#using scripts\shared\math_shared;
#using scripts\zm\_zm_magicbox;

#insert scripts\shared\shared.gsh;

#namespace bgb_machine_override;

function init()
{
	while(!isdefined(level.var_5081bd63)) wait 0.1;
	for(i = 0; i < level.var_5081bd63.size; i++)
	{
		level.var_5081bd63[i].unitrigger_stub.prompt_and_visibility_func = &can_player_use;
	}
}

function can_player_use(player)
{
	can_use = self check_bgb_state(player);
	if(isdefined(self.hint_string))
	{
		if(isdefined(self.hint_parm1))
		{
			self setHintString(self.hint_string, self.hint_parm1);
		}
		else
		{
			self setHintString(self.hint_string);
		}
	}
	return can_use;
}

function check_bgb_state(player)
{
	b_result = 0;
	if(!self trigger_visible_to_player(player))
	{
		return b_result;
	}
	self.hint_parm1 = undefined;
	if(IS_TRUE(self.stub.trigger_target.var_a2b01d1d))
	{
		/*if(!(IS_TRUE(self.stub.trigger_target.var_16d95df4) && self.stub.trigger_target.var_16d95df4))
		{
			str_hint = &"ZOMBIE_BGB_MACHINE_OUT_OF";
			b_result = 0;
		}
		else
		{
			str_hint = &"ZOMBIE_BGB_MACHINE_OFFERING";
			b_result = 1;
		}*/
		str_hint = &"ZOMBIE_BGB_MACHINE_OFFERING";
		b_result = 1;
		cursor_hint = "HINT_BGB";
		cursor_hint_weapon = level.bgb[self.stub.trigger_target.var_b287be].var_e25ca181;
		self SetCursorHint(cursor_hint, cursor_hint_weapon);
		self.hint_string = str_hint;
	}
	else
	{
		self SetCursorHint("HINT_NOICON");
		if(player.var_85da8a33 < level.var_6cb6a683)
		{
			if(IS_TRUE(level.var_42792b8b))
			{
				self.hint_string = &"ZOMBIE_BGB_MACHINE_AVAILABLE_CFILL";
			}
			else
			{
				self.hint_string = &"ZOMBIE_BGB_MACHINE_AVAILABLE";
				self.hint_parm1 = bgb_cost(player, self.stub.trigger_target.base_cost);
			}
			b_result = 1;
		}
		else
		{
			self.hint_string = &"ZOMBIE_BGB_MACHINE_COMEBACK";
			b_result = 0;
		}
	}
	return b_result;
}

function trigger_visible_to_player(player)
{
	self SetInvisibleToPlayer(player);
	visible = 1;
	if(!player zm_magicbox::can_buy_weapon())
	{
		visible = 0;
	}
	if(!visible)
	{
		return 0;
	}
	if(isdefined(self.stub.trigger_target.var_492b876) && player !== self.stub.trigger_target.var_492b876)
	{
		return 0;
	}
	self SetVisibleToPlayer(player);
	return 1;
}

function bgb_cost(player, base_cost)
{
	if(player.var_85da8a33 < 1 && GetDvarInt("scr_firstGumFree") === 1)
	{
		return 0;
	}
	if(!isdefined(level.var_f02c5598))
	{
		level.var_f02c5598 = 1000;
	}
	if(!isdefined(level.var_e1dee7ba))
	{
		level.var_e1dee7ba = 10;
	}
	if(!isdefined(level.var_1485dcdc))
	{
		level.var_1485dcdc = 2;
	}
	cost = 500;
	if(player.var_85da8a33 >= 1)
	{
		var_33ea806b = floor(level.round_number / level.var_e1dee7ba);
		var_33ea806b = math::clamp(var_33ea806b, 0, level.var_8ef45dc2);
		var_39a90c5a = pow(level.var_a3e3127d, var_33ea806b);
		cost = cost + level.var_f02c5598 * var_39a90c5a;
	}
	if(player.var_85da8a33 >= 2)
	{
		cost = cost * level.var_1485dcdc;
	}
	cost = Int(cost);
	if(500 != base_cost)
	{
		cost = cost - 500 - base_cost;
	}
	return cost;
}