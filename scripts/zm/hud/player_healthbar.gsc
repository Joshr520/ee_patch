#using scripts\shared\hud_util_shared;
#using scripts\shared\flag_shared;
#using scripts\zm\_zm;

#namespace player_healthbar;

function init()
{
	level.player_health_array = array(100,100,100,100);

	level flag::wait_till("initial_blackscreen_passed");
	players = GetPlayers();
	max_health = players[0].maxhealth;

	for(i = 0; i < players.size; i++)
	{
		players[i] thread track_health();
	}
}

function track_health()
{
	self.healthbar = self create_healthbar();
	self.healthbar_text = self create_healthbar_text();

	self thread update_health();
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

function update_health()
{
	while(1)
	{
		foreach(index, player in GetPlayers())
		{
			if(self == player && level.player_health_array[index] != (Int((self.health / self.maxhealth) * 100)))
			{
				level.player_health_array[index] = Int((self.health / self.maxhealth) * 100);
				self.healthbar SetShader("progress_bar_fill", Int(self.healthbar.width * (self.health / self.maxhealth)), self.healthbar.height);
				self.healthbar_text SetText("" + Int((self.health / self.maxhealth) * 100));

				if(self.health / self.maxhealth == 1) self.healthbar_text.x = -10;
				else if(self.health / self.maxhealth >= 0.1) self.healthbar_text.x = -9;
				else self.healthbar_text.x = -8;
			}
			wait 0.05;
		}
		wait 0.1;
	}
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