#using scripts\shared\hud_util_shared;
#using scripts\shared\flag_shared;
#using scripts\zm\_zm;

#namespace player_healthbar;

function init()
{
	level flag::wait_till("initial_blackscreen_passed");
	players = GetPlayers();
	max_health = players[0].maxhealth;

	for(i = 0; i < players.size; i++)
	{
		players[i] thread track_health(i);
		players[i] regen_tracker();
	}
}

function track_health(player, num)
{
	self.healthbar = self create_healthbar();
	self.healthbar_text = self create_healthbar_text();

	self thread update_health();
	self thread update_health_text();
}

function update_health()
{
	while(1)
	{
		level waittill("player_damaged");
		self.healthbar SetShader(self.shader, Int(self.healthbar.width * (self.health / self.maxhealth)), self.height);
		self update_health_regen();
	}
}

function update_health_text()
{
	while(1)
	{
		level waittill("player_damaged");
		self.healthbar_text SetText("" + Int((self.health / self.maxhealth) * 100));
		self update_health__regen_text();
	}
}

function create_healthbar()
{
	bar = healthbar_init((0.625, 0, 0), 60, 20);
	return bar;
}

function create_healthbar_text()
{
	bar = healthbar_text_init("objective", 1.5);
	return bar;
}

function update_health_regen()
{
	while(self.health != self.maxhealth)
	{
		//IPrintLnBold(Int(self.healthbar.width * (self.health / self.maxhealth)));
		self.healthbar SetShader(self.healthbar_shader, Int(self.healthbar.width * (self.health / self.maxhealth)), self.height);
		wait 0.05;
	}
	self.healthbar SetShader(self.healthbar_shader, Int(self.width * (self.health / self.maxhealth)), self.height);
}

function update_health__regen_text()
{
	while(self.health != self.maxhealth)
	{
		wait 0.05;
	}
	IPrintLnBold("Update Health" + self.health);
	self.healthbar_text SetText("" + Int((self.health / self.maxhealth) * 100));
}

function healthbar_init(color, width, height)
{
	barElem = NewClientHudElem(self);
	barElem.x = 75;
	barElem.y = -35;
	barElem.alignX = "left";
	barElem.alignY = "bottom";
	barElem.horzAlign = "user_left";
	barElem.vertAlign = "user_bottom";
	barElem.width = width;
	barElem.height = height;
	barElem.color = color;
	barElem.sort = -2;
	barElem.hidewheninmenu = 0;
	barElem.shader = "progress_bar_fill";
	barElem SetShader("progress_bar_fill", width, height);
	barElem.hidden = false;
	
	barElemBG = NewClientHudElem(self);
	barElemBG.x = 73;
	barElemBG.y = -33;
	barElemBG.alignX = "left";
	barElemBG.alignY = "bottom";
	barElemBG.horzAlign = "user_left";
	barElemBG.vertAlign = "user_bottom";
	barElemBG.color = (0,0,0);
	barElemBG.sort = -3;
	barElemBG.alpha = 0.5;
	barElemBG.hidewheninmenu = 0;
	barElemBG SetShader("progress_bar_bg", width + 4, height + 4);
	barElemBG.hidden = false;
	
	return barElem;
}

function healthbar_text_init(font, fontScale)
{
	fontElem = NewClientHudElem(self);
	fontElem.elemType = "font";
	fontElem.font = font;
	fontElem.fontscale = fontScale;
	fontElem.x = -10;
	fontElem.y = 426;
	fontElem.alignX = "left";
	fontElem.alignY = "top";
	barElemText.horzAlign = "user_left";
	fontElem.sort = -1;
	fontElem.width = 0;
	fontElem.height = Int(level.fontHeight * fontScale);
	fontElem.xOffset = 0;
	fontElem.yOffset = 0;
	fontElem.hidden = false;
	fontElem SetText("" + Int((self.health / self.maxhealth) * 100));
	return fontElem;
}

function player_damage(num)
{
	while(1)
	{
		self waittill("damage", amount, attacker, dir, point, mod);
		if(isdefined(attacker) && attacker.team == self.team)
		{
			continue;
		}
		//self.hurtAgain = 1;
		//self.damagePoint = point;
		//self.damageAttacker = attacker;
		level notify("player_damaged");
		IPrintLnBold("Player Damaged");
	}
}

function regen_tracker()
{
	oldratio = 1;
	health_add = 0;
	regenRate = 0.1;
	veryHurt = 0;
	playerJustGotRedFlashing = 0;
	invulTime = 0;
	hurtTime = 0;
	newHealth = 0;
	lastinvulratio = 1;
	self thread player_damage();
	if(!isdefined(self.veryHurt))
	{
		self.veryHurt = 0;
	}

	playerInvulTimeScale = GetDvarFloat("scr_playerInvulTimeScale");
	while(1)
	{
		wait(0.05);
		waittillframeend;
		if(self.health == self.maxhealth)
		{
			lastinvulratio = 1;
			playerJustGotRedFlashing = 0;
			veryHurt = 0;
			continue;
		}
		if(self.health <= 0)
		{
			return;
		}
		wasVeryHurt = veryHurt;
		health_ratio = self.health / self.maxhealth;
		if(health_ratio <= level.healthOverlayCutoff)
		{
			veryHurt = 1;
			if(!wasVeryHurt)
			{
				hurtTime = GetTime();
				playerJustGotRedFlashing = 1;
			}
		}
		if(self.hurtAgain)
		{
			hurtTime = GetTime();
			self.hurtAgain = 0;
		}
		if(health_ratio >= oldratio)
		{
			if(GetTime() - hurtTime < level.playerHealth_RegularRegenDelay)
			{
				continue;
			}
			if(veryHurt)
			{
				self.veryHurt = 1;
				newHealth = health_ratio;
				if(GetTime() > hurtTime + level.longRegenTime)
				{
					newHealth = newHealth + regenRate;
					IPrintLnBold("New Health" + newHealth);
				}
			}
			else
			{
				newHealth = 1;
				self.veryHurt = 0;
			}
			if(newHealth > 1)
			{
				newHealth = 1;
			}
			if(newHealth <= 0)
			{
				return;
			}
			self SetNormalHealth(newHealth);
			oldratio = self.health / self.maxhealth;
			continue;
		}
		invulWorthyHealthDrop = lastinvulratio - health_ratio > level.worthyDamageRatio;
		if(self.health <= 1)
		{
			self SetNormalHealth(2 / self.maxhealth);
			invulWorthyHealthDrop = 1;
		}
		oldratio = self.health / self.maxhealth;
		health_add = 0;
		hurtTime = GetTime();
		if(!invulWorthyHealthDrop || playerInvulTimeScale <= 0)
		{
			continue;
		}
		if(self flag::get("player_is_invulnerable"))
		{
			continue;
		}
		if(playerJustGotRedFlashing)
		{
			invulTime = level.invulTime_onShield;
			playerJustGotRedFlashing = 0;
		}
		else if(veryHurt)
		{
			invulTime = level.invulTime_postShield;
		}
		else
		{
			invulTime = level.invulTime_preShield;
		}
		invulTime = invulTime * playerInvulTimeScale;
		lastinvulratio = self.health / self.maxhealth;
	}
}