#using scripts\codescripts\struct;
#using scripts\shared\ai\zombie_utility;
#using scripts\shared\array_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\exploder_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\scene_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;
#using scripts\zm\_util;
#using scripts\zm\_zm;
#using scripts\zm\_zm_blockers;
#using scripts\zm\_zm_devgui;
#using scripts\zm\_zm_equipment;
#using scripts\zm\_zm_pack_a_punch;
#using scripts\zm\_zm_pack_a_punch_util;
#using scripts\zm\_zm_perks;
#using scripts\zm\_zm_power;
#using scripts\zm\_zm_unitrigger;
#using scripts\zm\_zm_utility;
#using scripts\zm\_zm_weap_keeper_skull;
#using scripts\zm\_zm_weapons;
#using scripts\zm\_zm_zonemgr;

#namespace namespace_8aed53c9;

/*
	Name: function_d095318
	Namespace: namespace_8aed53c9
	Checksum: 0xEDFDAB31
	Offset: 0x3D0
	Size: 0x59
	Parameters: 4
	Flags: None
*/
function function_d095318(origin, radius, use_trigger, func_per_player_msg)
{
	if(!isdefined(use_trigger))
	{
		use_trigger = 0;
	}
	return function_a40fee2f(origin, undefined, radius, use_trigger, func_per_player_msg);
}

/*
	Name: function_a40fee2f
	Namespace: namespace_8aed53c9
	Checksum: 0xB27FE2A0
	Offset: 0x438
	Size: 0x1F7
	Parameters: 5
	Flags: Private
*/
function private function_a40fee2f(origin, angles, var_3b9cee11, use_trigger, func_per_player_msg)
{
	if(!isdefined(use_trigger))
	{
		use_trigger = 0;
	}
	trigger_stub = spawnstruct();
	trigger_stub.origin = origin;
	str_type = "unitrigger_radius";
	if(IsVec(var_3b9cee11))
	{
		trigger_stub.script_length = var_3b9cee11[0];
		trigger_stub.script_width = var_3b9cee11[1];
		trigger_stub.script_height = var_3b9cee11[2];
		str_type = "unitrigger_box";
		if(!isdefined(angles))
		{
			angles = (0, 0, 0);
		}
		trigger_stub.angles = angles;
	}
	else
	{
		trigger_stub.radius = var_3b9cee11;
	}
	if(use_trigger)
	{
		trigger_stub.cursor_hint = "HINT_NOICON";
		trigger_stub.script_unitrigger_type = str_type + "_use";
	}
	else
	{
		trigger_stub.script_unitrigger_type = str_type;
	}
	if(isdefined(func_per_player_msg))
	{
		trigger_stub.var_af0b9c6c = func_per_player_msg;
		zm_unitrigger::unitrigger_force_per_player_triggers(trigger_stub, 1);
	}
	trigger_stub.prompt_and_visibility_func = &function_5ea427bf;
	zm_unitrigger::register_unitrigger(trigger_stub, &unitrigger_think);
	return trigger_stub;
}

/*
	Name: function_5ea427bf
	Namespace: namespace_8aed53c9
	Checksum: 0xCEA5676
	Offset: 0x638
	Size: 0x16F
	Parameters: 1
	Flags: None
*/
function function_5ea427bf(player)
{
	b_visible = 1;
	if(isdefined(player.beastmode) && player.beastmode && (!isdefined(self.var_8842df9d) && self.var_8842df9d))
	{
		b_visible = 0;
	}
	else if(isdefined(self.stub.var_98775f3))
	{
		b_visible = self [[self.stub.var_98775f3]](player);
	}
	str_msg = &"";
	param1 = undefined;
	if(b_visible)
	{
		if(isdefined(self.stub.var_af0b9c6c))
		{
			str_msg = self [[self.stub.var_af0b9c6c]](player);
		}
		else
		{
			str_msg = self.stub.hint_string;
			param1 = self.stub.hint_parm1;
		}
	}
	if(isdefined(param1))
	{
		self setHintString(str_msg, param1);
	}
	else
	{
		self setHintString(str_msg);
	}
	return b_visible;
}

/*
	Name: unitrigger_think
	Namespace: namespace_8aed53c9
	Checksum: 0xCEB4F4F2
	Offset: 0x7B0
	Size: 0x5F
	Parameters: 0
	Flags: Private
*/
function private unitrigger_think()
{
	self endon("kill_trigger");
	self.stub thread function_c1947ff7();
	while(1)
	{
		self waittill("trigger", player);
		self.stub notify("trigger", player);
	}
}

/*
	Name: function_c1947ff7
	Namespace: namespace_8aed53c9
	Checksum: 0x68689137
	Offset: 0x818
	Size: 0x1B
	Parameters: 0
	Flags: None
*/
function function_c1947ff7()
{
	self zm_unitrigger::run_visibility_function_for_all_triggers();
}

/*
	Name: function_acd04dc9
	Namespace: namespace_8aed53c9
	Checksum: 0x4CFD57A9
	Offset: 0x840
	Size: 0x27
	Parameters: 0
	Flags: None
*/
function function_acd04dc9()
{
	self endon("death");
	self waittill("completed_emerging_into_playable_area");
	self.no_powerups = 1;
}

/*
	Name: function_7448e472
	Namespace: namespace_8aed53c9
	Checksum: 0x623A4F3D
	Offset: 0x870
	Size: 0x323
	Parameters: 1
	Flags: None
*/
function function_7448e472(e_target)
{
	self endon("death");
	if(isdefined(e_target.targetname))
	{
		var_241c185a = "someone_revealed_" + e_target.targetname;
		self endon(var_241c185a);
	}
	var_c2b47c7a = 0;
	self.var_abd1c759 = e_target;
	while(isdefined(e_target) && (!isdefined(var_c2b47c7a) && var_c2b47c7a))
	{
		if(self HasWeapon(level.var_c003f5b))
		{
			if(self util::ads_button_held())
			{
				if(self GetCurrentWeapon() !== level.var_c003f5b)
				{
					while(self AdsButtonPressed())
					{
						wait(0.05);
					}
				}
				else if(self getammocount(level.var_c003f5b))
				{
					if(self namespace_f55b6585::function_3f3f64e9(e_target) && self namespace_f55b6585::function_5fa274c1(e_target))
					{
						self PlayRumbleOnEntity("zm_island_skull_reveal");
						n_count = 0;
						while(self util::ads_button_held())
						{
							wait(1);
							n_count++;
							if(n_count >= 2)
							{
								break;
							}
						}
						if(n_count >= 2)
						{
							e_target.var_f0b65c0a = self;
							var_c2b47c7a = 1;
							playsoundatposition("zmb_wpn_skullgun_discover", e_target.origin);
							self notify("hash_b2ddad7");
							self thread function_4aedb20b();
							foreach(player in level.players)
							{
								if(e_target === player.var_abd1c759)
								{
									player.var_abd1c759 = undefined;
									if(isdefined(var_241c185a) && player != self)
									{
										player notify(var_241c185a);
									}
								}
							}
							break;
						}
						else
						{
							self StopRumble("zm_island_skull_reveal");
						}
					}
				}
			}
		}
		wait(0.05);
	}
	return var_c2b47c7a;
}

/*
	Name: function_4aedb20b
	Namespace: namespace_8aed53c9
	Checksum: 0xB69E2633
	Offset: 0xBA0
	Size: 0x63
	Parameters: 0
	Flags: None
*/
function function_4aedb20b()
{
	if(self.var_118ab24e >= 33)
	{
		self GadgetPowerSet(0, self.var_118ab24e - 33);
	}
	else
	{
		self GadgetPowerSet(0, 0);
	}
}

/*
	Name: function_925aa63a
	Namespace: namespace_8aed53c9
	Checksum: 0xC2793D9B
	Offset: 0xC10
	Size: 0x181
	Parameters: 4
	Flags: None
*/
function function_925aa63a(var_fedda046, n_delay, n_value, b_delete)
{
	if(!isdefined(n_delay))
	{
		n_delay = 0.1;
	}
	if(!isdefined(b_delete))
	{
		b_delete = 1;
	}
	foreach(var_1c7231df in var_fedda046)
	{
		if(isdefined(var_1c7231df))
		{
			var_1c7231df clientfield::set("do_fade_material", n_value);
			wait(n_delay);
		}
	}
	wait(1);
	if(isdefined(b_delete) && b_delete)
	{
		foreach(var_1c7231df in var_fedda046)
		{
			var_1c7231df delete();
		}
	}
}

/*
	Name: function_f2a55b5f
	Namespace: namespace_8aed53c9
	Checksum: 0xE2EE335F
	Offset: 0xDA0
	Size: 0x61
	Parameters: 1
	Flags: None
*/
function function_f2a55b5f(a_str_zones)
{
	if(!zm_utility::is_player_valid(self))
	{
		return 0;
	}
	str_player_zone = self zm_zonemgr::get_player_zone();
	return IsInArray(a_str_zones, str_player_zone);
}

/*
	Name: is_facing
	Namespace: namespace_8aed53c9
	Checksum: 0x1C271C0A
	Offset: 0xE10
	Size: 0x141
	Parameters: 2
	Flags: None
*/
function is_facing(target, n_tolerance)
{
	if(!isdefined(n_tolerance))
	{
		n_tolerance = 0.707;
	}
	if(IsEntity(target))
	{
		v_target = target.origin;
	}
	else if(IsVec(target))
	{
		v_target = target;
	}
	var_7ef98cb2 = v_target - self.origin;
	var_7ec36342 = VectorNormalize(var_7ef98cb2);
	var_bedf3d47 = AnglesToForward(self.angles);
	var_c67c7281 = VectorNormalize(var_bedf3d47);
	n_dot = VectorDot(var_7ec36342, var_c67c7281);
	return n_dot >= n_tolerance;
}

/*
	Name: function_1867f3e8
	Namespace: namespace_8aed53c9
	Checksum: 0x5BBDA886
	Offset: 0xF60
	Size: 0x15B
	Parameters: 1
	Flags: None
*/
function function_1867f3e8(n_distance)
{
	n_dist_sq = n_distance * n_distance;
	str_player_zone = self zm_zonemgr::get_player_zone();
	a_enemies = GetAITeamArray("axis");
	var_9efb74d5 = 0;
	foreach(enemy in a_enemies)
	{
		if(isalive(enemy) && enemy zm_zonemgr::entity_in_zone(str_player_zone) && DistanceSquared(self.origin, enemy.origin) < n_dist_sq)
		{
			var_9efb74d5++;
		}
	}
	return var_9efb74d5;
}

/*
	Name: function_4bf4ac40
	Namespace: namespace_8aed53c9
	Checksum: 0xF03D770
	Offset: 0x10C8
	Size: 0xD1
	Parameters: 1
	Flags: None
*/
function function_4bf4ac40(v_loc)
{
	a_players = ArrayCopy(level.activePlayers);
	e_player = undefined;
	if(isdefined(v_loc))
	{
		e_player = ArrayGetClosest(v_loc, a_players);
	}
	do
	{
		else
		{
			e_player = Array::random(a_players);
		}
		ArrayRemoveValue(a_players, e_player);
	}
	while(!(!zm_utility::is_player_valid(e_player) && a_players.size > 0));
	return e_player;
}

/*
	Name: function_8c6350db
	Namespace: namespace_8aed53c9
	Checksum: 0x2C12842F
	Offset: 0x11A8
	Size: 0xDB
	Parameters: 4
	Flags: None
*/
function function_8c6350db(v_org, n_dot, b_do_trace, e_ignore)
{
	foreach(player in level.players)
	{
		if(zm_utility::is_player_valid(player) && player util::is_player_looking_at(v_org, n_dot, b_do_trace, e_ignore))
		{
			return 1;
		}
	}
	return 0;
}

/*
	Name: swap_weapon
	Namespace: namespace_8aed53c9
	Checksum: 0x83F1C76A
	Offset: 0x1290
	Size: 0x241
	Parameters: 1
	Flags: None
*/
function swap_weapon(var_9f85aad5)
{
	var_913ae498 = self GetCurrentWeapon();
	if(!zm_utility::is_player_valid(self))
	{
		return;
	}
	if(self.IS_DRINKING > 0)
	{
		return;
	}
	if(zm_utility::is_placeable_mine(var_913ae498) || zm_equipment::is_equipment(var_913ae498) || var_913ae498 == level.weaponNone)
	{
		return;
	}
	if(!self zm_weapons::has_weapon_or_upgrade(var_9f85aad5))
	{
		if(var_9f85aad5.type === "melee")
		{
			self function_3420bc2f(var_9f85aad5);
		}
		else if(var_9f85aad5.type === "grenade")
		{
			self zm_weapons::weapon_give(var_9f85aad5);
		}
		else
		{
			self take_old_weapon_and_give_new(var_913ae498, var_9f85aad5);
		}
		break;
	}
	var_c259e5ce = self zm_weapons::get_player_weapon_with_same_base(var_9f85aad5);
	var_6c6831af = self GetWeaponsList(1);
	foreach(weapon in var_6c6831af)
	{
		if(self zm_weapons::get_player_weapon_with_same_base(weapon) === var_c259e5ce)
		{
			self giveMaxAmmo(weapon);
		}
	}
}

/*
	Name: take_old_weapon_and_give_new
	Namespace: namespace_8aed53c9
	Checksum: 0xBB6AB070
	Offset: 0x14E0
	Size: 0x9F
	Parameters: 2
	Flags: None
*/
function take_old_weapon_and_give_new(current_weapon, weapon)
{
	a_weapons = self GetWeaponsListPrimaries();
	if(isdefined(a_weapons) && a_weapons.size >= zm_utility::get_player_weapon_limit(self))
	{
		self TakeWeapon(current_weapon);
	}
	var_7b9ca68 = self zm_weapons::give_build_kit_weapon(weapon);
}

/*
	Name: function_3420bc2f
	Namespace: namespace_8aed53c9
	Checksum: 0x23F61BBF
	Offset: 0x1588
	Size: 0x13F
	Parameters: 1
	Flags: None
*/
function function_3420bc2f(var_9f85aad5)
{
	var_c5716cdc = self GetWeaponsList(1);
	foreach(weapon in var_c5716cdc)
	{
		if(weapon.type === "melee")
		{
			self TakeWeapon(weapon);
			break;
		}
	}
	if(self hasPerk("specialty_widowswine"))
	{
		var_7b9ca68 = self zm_weapons::give_build_kit_weapon(level.w_widows_wine_bowie_knife);
	}
	else
	{
		var_7b9ca68 = self zm_weapons::give_build_kit_weapon(var_9f85aad5);
	}
}

/*
	Name: function_8faf1d24
	Namespace: namespace_8aed53c9
	Checksum: 0xAFA07A94
	Offset: 0x16D0
	Size: 0x107
	Parameters: 4
	Flags: None
*/
function function_8faf1d24(v_color, var_8882142e, n_scale, str_endon)
{
	/#
		if(!isdefined(v_color))
		{
			v_color = VectorScale((0, 0, 1), 255);
		}
		if(!isdefined(var_8882142e))
		{
			var_8882142e = "Dev Block strings are not supported";
		}
		if(!isdefined(n_scale))
		{
			n_scale = 0.25;
		}
		if(!isdefined(str_endon))
		{
			str_endon = "Dev Block strings are not supported";
		}
		if(GetDvarInt("Dev Block strings are not supported") == 0)
		{
			return;
		}
		if(isdefined(str_endon))
		{
			self endon(str_endon);
		}
		origin = self.origin;
		while(1)
		{
			print3d(origin, var_8882142e, v_color, n_scale);
			wait(0.1);
		}
	#/
}

