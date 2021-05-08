#using scripts\codescripts\struct;
#using scripts\shared\ai\zombie_utility;
#using scripts\shared\ai_shared;
#using scripts\shared\array_shared;
#using scripts\shared\callbacks_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\exploder_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\fx_shared;
#using scripts\shared\laststand_shared;
#using scripts\shared\lui_shared;
#using scripts\shared\scene_shared;
#using scripts\shared\scoreevents_shared;
#using scripts\shared\spawner_shared;
#using scripts\shared\system_shared;
#using scripts\shared\trigger_shared;
#using scripts\shared\util_shared;
#using scripts\shared\vehicle_ai_shared;
#using scripts\shared\vehicle_shared;
#using scripts\zm\_zm;
#using scripts\zm\_zm_ai_spiders;
#using scripts\zm\_zm_devgui;
#using scripts\zm\_zm_laststand;
#using scripts\zm\_zm_pack_a_punch;
#using scripts\zm\_zm_pack_a_punch_util;
#using scripts\zm\_zm_perks;
#using scripts\zm\_zm_spawner;
#using scripts\zm\_zm_stats;
#using scripts\zm\_zm_unitrigger;
#using scripts\zm\_zm_utility;
#using scripts\zm\_zm_weap_keeper_skull;
#using scripts\zm\_zm_zonemgr;
#using scripts\zm\bgbs\_zm_bgb_anywhere_but_here;
#using scripts\zm\bgbs\_zm_bgb_pop_shocks;
#using scripts\zm\zm_island_bgb;
#using scripts\zm\zm_island_perks;
#using scripts\zm\zm_island_util;
#using scripts\zm\zm_island_vo;

#insert scripts\shared\shared.gsh;

#namespace namespace_b3c23ec9;

/*
	Name: main
	Namespace: namespace_b3c23ec9
	Checksum: 0x88F53E29
	Offset: 0x16C8
	Size: 0x123
	Parameters: 0
	Flags: None
*/
function main()
{
	var_e66037d6 = GetEnt("main_ee_elevator_wall_metal", "targetname");
	var_ed315f0 = GetEnt("main_ee_elevator_wall_decal", "targetname");
	var_e66037d6 clientfield::set("do_fade_material", 1);
	var_ed315f0 clientfield::set("do_fade_material", 0.5);
	level thread function_6e38e085();
	level thread function_8221532d();
	level thread function_9f26e724();
	level thread function_dcc18c22();
	level thread function_7910f0c2();
}

/*
	Name: function_30d4f164
	Namespace: namespace_b3c23ec9
	Checksum: 0x696ACCB0
	Offset: 0x17F8
	Size: 0x3C3
	Parameters: 0
	Flags: None
*/
function function_30d4f164()
{
	register_clientfields();
	level flag::init("player_has_aa_gun_ammo");
	level flag::init("aa_gun_ammo_loaded");
	level flag::init("aa_gun_ee_complete");
	level flag::init("flag_play_outro_cutscene");
	level flag::init("elevator_part_gear1_found");
	level flag::init("elevator_part_gear2_found");
	level flag::init("elevator_part_gear3_found");
	level flag::init("elevator_part_gear1_placed");
	level flag::init("elevator_part_gear2_placed");
	level flag::init("elevator_part_gear3_placed");
	level flag::init("elevator_in_use");
	level flag::init("elevator_at_bottom");
	level flag::init("elevator_cooldown");
	level flag::init("flag_hide_outro_water");
	level flag::init("flag_show_outro_water");
	level flag::init("elevator_door_closed");
	level flag::set("elevator_door_closed");
	level flag::init("prison_vines_cleared");
	if(GetDvarInt("splitscreen_playerCount") < 3)
	{
		callback::on_spawned(&function_85773a07);
	}
	callback::on_spawned(&function_aeef1178);
	callback::on_spawned(&function_df4d1d4);
	level thread function_75e5527f();
	function_8099bad0();
	function_5d0980ef();
	function_62dfc4c7();
	function_af46160f();
	level thread function_f818f5b5();
	level thread aa_gun_think();
	level thread function_19cfd507();
	level thread function_e509082();
	/#
		if(GetDvarInt("Dev Block strings are not supported") > 0)
		{
			function_12d043ed();
		}
	#/
}

/*
	Name: register_clientfields
	Namespace: namespace_b3c23ec9
	Checksum: 0x4D6E9FAD
	Offset: 0x1BC8
	Size: 0x193
	Parameters: 0
	Flags: None
*/
function register_clientfields()
{
	clientfield::register("scriptmover", "zipline_lightning_fx", 9000, 1, "int");
	clientfield::register("vehicle", "plane_hit_by_aa_gun", 9000, 1, "int");
	clientfield::register("allplayers", "lightning_shield_fx", 9000, 1, "int");
	clientfield::register("scriptmover", "smoke_trail_fx", 9000, 1, "int");
	clientfield::register("scriptmover", "smoke_smolder_fx", 9000, 1, "int");
	clientfield::register("scriptmover", "perk_lightning_fx", 9000, GetMinBitCountForNum(6), "int");
	clientfield::register("zbarrier", "bgb_lightning_fx", 9000, 1, "int");
	clientfield::register("world", "umbra_tome_outro_igc", 9000, 1, "int");
}

/*
	Name: function_85773a07
	Namespace: namespace_b3c23ec9
	Checksum: 0xEB281450
	Offset: 0x1D68
	Size: 0x6B
	Parameters: 0
	Flags: None
*/
function function_85773a07()
{
	self endon("death");
	var_af4d7f99 = GetEnt("mdl_main_ee_map", "targetname");
	self namespace_8aed53c9::function_7448e472(var_af4d7f99);
	level thread function_85b23415();
}

/*
	Name: function_85b23415
	Namespace: namespace_b3c23ec9
	Checksum: 0xA854E6E8
	Offset: 0x1DE0
	Size: 0x8B
	Parameters: 0
	Flags: None
*/
function function_85b23415()
{
	var_af4d7f99 = GetEnt("mdl_main_ee_map", "targetname");
	var_af4d7f99 clientfield::set("do_fade_material", 1);
	level flag::set("trilogy_released");
	exploder::exploder("lgt_elevator");
}

/*
	Name: function_7910f0c2
	Namespace: namespace_b3c23ec9
	Checksum: 0xC4BFBF8C
	Offset: 0x1E78
	Size: 0xB5
	Parameters: 0
	Flags: None
*/
function function_7910f0c2()
{
	level flag::wait_till("trilogy_released");
	level.var_6f17d9e9 = 0;
	for(i = 1; i < 4; i++)
	{
		var_f34dc519 = GetEnt("takeo_arm_gate" + i, "targetname");
		var_f34dc519 thread function_d9de7eb6(i);
		level.var_6f17d9e9++;
	}
}

/*
	Name: function_d9de7eb6
	Namespace: namespace_b3c23ec9
	Checksum: 0xA94BF1FB
	Offset: 0x1F38
	Size: 0x467
	Parameters: 1
	Flags: None
*/
function function_d9de7eb6(var_a3612ddd)
{
	e_clip = GetEnt(self.target, "targetname");
	e_clip SetCanDamage(1);
	e_clip.health = 10000;
	var_75f5a225 = GetEnt("clip_player_" + var_a3612ddd, "targetname");
	self thread scene::Play("p7_fxanim_zm_island_takeo_arm_gate" + var_a3612ddd + "_bundle", self);
	var_2b128827 = 1;
	var_b538c87 = 0;
	while(IS_TRUE(var_2b128827))
	{
		e_clip waittill("damage", n_damage, e_attacker, v_direction, v_point, str_mod, str_tag_name, str_model_name, str_part_name, w_weapon);
		if(w_weapon === level.var_5e75629a)
		{
			self PlayRumbleOnEntity("tank_damage_heavy_mp");
			self scene::Play("p7_fxanim_zm_island_takeo_arm_gate" + var_a3612ddd + "_close_bundle", self);
			self thread scene::Play("p7_fxanim_zm_island_takeo_arm_gate" + var_a3612ddd + "_bundle", self);
			if(var_a3612ddd == 1 && !var_b538c87)
			{
				var_b538c87 = 1;
				str_vo = "vox_plr_" + e_attacker.characterindex + "_mq_ee_3_1_0";
				e_attacker thread namespace_f333593c::function_7b697614(str_vo, 0, 1);
			}
		}
		else if(w_weapon === level.var_a4052592)
		{
			self PlayRumbleOnEntity("zm_island_rumble_takeo_hall_vine_hit");
			Earthquake(0.35, 0.5, self.origin, 325);
			self playsound("zmb_takeo_vox_roar_amrgate");
			self HidePart("eye1_side_jnt");
			wait(1.5);
			self scene::Play("p7_fxanim_zm_island_takeo_arm_gate" + var_a3612ddd + "_retract_bundle", self);
			e_clip delete();
			var_75f5a225 delete();
			level.var_6f17d9e9--;
			if(level.var_6f17d9e9 == 0)
			{
				level notify("hash_add73e69");
				level util::delay(2, undefined, &flag::set, "prison_vines_cleared");
				level.var_6f17d9e9 = undefined;
			}
			wait(5);
			struct::delete_script_bundle("scene", "p7_fxanim_zm_island_takeo_arm_gate" + var_a3612ddd + "_bundle");
			struct::delete_script_bundle("scene", "p7_fxanim_zm_island_takeo_arm_gate" + var_a3612ddd + "_close_bundle");
			struct::delete_script_bundle("scene", "p7_fxanim_zm_island_takeo_arm_gate" + var_a3612ddd + "_retract_bundle");
			var_2b128827 = 0;
		}
	}
}

/*
	Name: function_df4d1d4
	Namespace: namespace_b3c23ec9
	Checksum: 0xCE38367A
	Offset: 0x23A8
	Size: 0xD7
	Parameters: 0
	Flags: None
*/
function function_df4d1d4()
{
	self endon("death");
	level endon("hash_1f9f4017");
	level flag::wait_till("trilogy_released");
	var_af8f5b69 = GetEnt("trigger_gas_hurt", "targetname");
	while(1)
	{
		trigger::wait_till("trigger_gas_hurt", "targetname", self);
		if(!self.var_df4182b1 && zm_utility::is_player_valid(self))
		{
			self DoDamage(5, self.origin);
		}
		wait(0.5);
	}
}

/*
	Name: function_75e5527f
	Namespace: namespace_b3c23ec9
	Checksum: 0xBD8BD71
	Offset: 0x2488
	Size: 0x1BD
	Parameters: 0
	Flags: None
*/
function function_75e5527f()
{
	level endon("hash_5790f552");
	var_af8f5b69 = GetEnt("trigger_gas_chamber", "targetname");
	while(1)
	{
		var_af8f5b69 waittill("trigger");
		a_talkers = [];
		foreach(player in level.players)
		{
			if(player istouching(var_af8f5b69) && !player.var_df4182b1 && zm_utility::is_player_valid(player))
			{
				Array::add(a_talkers, player);
			}
		}
		e_talker = Array::random(a_talkers);
		if(isdefined(e_talker))
		{
			str_vo = "vox_plr_" + e_talker.characterindex + "_mq_ee_3_0_0";
			e_talker thread namespace_f333593c::function_7b697614(str_vo, 0, 1);
			level notify("hash_5790f552");
		}
	}
}

/*
	Name: function_19cfd507
	Namespace: namespace_b3c23ec9
	Checksum: 0x19396796
	Offset: 0x2650
	Size: 0x8B
	Parameters: 0
	Flags: None
*/
function function_19cfd507()
{
	level flag::wait_till("trilogy_released");
	level thread function_d6bb2a6c();
	level.var_2c12d9a6 = &function_2fae2796;
	level flag::wait_till("elevator_part_gear1_found");
	level.var_2c12d9a6 = &namespace_f694d9ca::function_fa778ca4;
}

/*
	Name: function_d6bb2a6c
	Namespace: namespace_b3c23ec9
	Checksum: 0xABEBB493
	Offset: 0x26E8
	Size: 0xC3
	Parameters: 0
	Flags: None
*/
function function_d6bb2a6c()
{
	var_a2365998 = struct::get("elevator_part_gear1");
	var_71e3d70a = util::spawn_model("p7_zm_bgb_gear_01", var_a2365998.origin, var_a2365998.angles);
	var_71e3d70a.trigger = namespace_8aed53c9::function_d095318(var_71e3d70a.origin, 50, 1, &function_9bd3096f);
	var_71e3d70a thread function_d81e5824("elevator_part_gear1_found");
}

/*
	Name: function_2fae2796
	Namespace: namespace_b3c23ec9
	Checksum: 0x67EA036
	Offset: 0x27B8
	Size: 0xD7
	Parameters: 0
	Flags: None
*/
function function_2fae2796()
{
	var_664f35bb = struct::get_array("ee_gear_teleport_spot", "targetname");
	while(1)
	{
		foreach(s_spot in var_664f35bb)
		{
			if(!positionWouldTelefrag(s_spot.origin))
			{
				return s_spot;
			}
		}
		wait(0.05);
	}
}

/*
	Name: function_8099bad0
	Namespace: namespace_b3c23ec9
	Checksum: 0xC2C4F503
	Offset: 0x2898
	Size: 0x5B
	Parameters: 0
	Flags: None
*/
function function_8099bad0()
{
	Array::thread_all(GetEntArray("clip_zipline_zap", "targetname"), &function_5b0b2b3d);
	level thread function_53246bea();
}

/*
	Name: function_5b0b2b3d
	Namespace: namespace_b3c23ec9
	Checksum: 0xB9B611E
	Offset: 0x2900
	Size: 0x42F
	Parameters: 0
	Flags: None
*/
function function_5b0b2b3d()
{
	level flag::wait_till("all_challenges_completed");
	self SetCanDamage(1);
	self.health = 100000;
	var_fae0d733 = struct::get_array("transport_zip_line", "targetname");
	while(1)
	{
		self waittill("damage", n_damage, e_attacker, v_direction, v_point, str_mod, str_tag_name, str_model_name, str_part_name, w_weapon);
		if(w_weapon.name === "island_riotshield" && (IS_TRUE(e_attacker.var_36c3d64a)))
		{
			level flag::set("zipline_lightning_charge");
			e_attacker notify("hash_6bef9736");
			self playsound("zmb_lightning_shield_activate");
			foreach(s_loc in var_fae0d733)
			{
				s_loc.var_1cdf0f7a clientfield::set("zipline_lightning_fx", 1);
			}
			exploder::exploder("fxexp_504");
			level util::delay(5, undefined, &exploder::exploder_stop, "fxexp_504");
			if(level flag::get("flag_zipline_in_use"))
			{
				foreach(player in level.players)
				{
					if(IS_TRUE(player.is_ziplining))
					{
						player.var_53539670 notify("reached_end_node");
						break;
					}
				}
			}
			else if(level.players.size == 1)
			{
				level.players[0] thread function_426caba9();
			}
			foreach(s_loc in var_fae0d733)
			{
				s_loc.var_1cdf0f7a util::delay(5, undefined, &clientfield::set, "zipline_lightning_fx", 0);
			}
			wait(5);
			level flag::clear("zipline_lightning_charge");
		}
	}
}

/*
	Name: function_62dfc4c7
	Namespace: namespace_b3c23ec9
	Checksum: 0x70F6A3CA
	Offset: 0x2D38
	Size: 0x43
	Parameters: 0
	Flags: None
*/
function function_62dfc4c7()
{
	Array::thread_all(GetEntArray("clip_sewer_panel_zap", "targetname"), &function_e9ec0fdf);
}

/*
	Name: function_e9ec0fdf
	Namespace: namespace_b3c23ec9
	Checksum: 0xD08F8357
	Offset: 0x2D88
	Size: 0x227
	Parameters: 0
	Flags: None
*/
function function_e9ec0fdf()
{
	self endon("death");
	level flag::wait_till("all_challenges_completed");
	self SetCanDamage(1);
	self.health = 100000;
	s_loc = struct::get("transport_sewer_" + self.script_noteworthy);
	while(1)
	{
		self waittill("damage", n_damage, e_attacker, v_direction, v_point, str_mod, str_tag_name, str_model_name, str_part_name, w_weapon);
		if(IS_TRUE(w_weapon.isRiotShield) && IS_TRUE(e_attacker.var_36c3d64a))
		{
			level flag::set("sewer_lightning_charge_" + self.script_noteworthy);
			e_attacker notify("hash_6bef9736");
			self playsound("zmb_lightning_shield_activate");
			s_loc.var_1cdf0f7a clientfield::set("zipline_lightning_fx", 1);
			wait(5);
			s_loc.var_1cdf0f7a clientfield::set("zipline_lightning_fx", 0);
			level flag::clear("sewer_lightning_charge_" + self.script_noteworthy);
		}
	}
}

/*
	Name: function_af46160f
	Namespace: namespace_b3c23ec9
	Checksum: 0xBECCF1D1
	Offset: 0x2FB8
	Size: 0x8B
	Parameters: 0
	Flags: None
*/
function function_af46160f()
{
	var_f7d59b95 = GetEnt("clip_cage_control", "targetname");
	var_a398a1e1 = struct::get(var_f7d59b95.target, "targetname");
	var_f7d59b95 thread function_4d23baa6(var_a398a1e1.origin, var_a398a1e1.angles);
}

/*
	Name: function_4d23baa6
	Namespace: namespace_b3c23ec9
	Checksum: 0xB714BB70
	Offset: 0x3050
	Size: 0x237
	Parameters: 4
	Flags: None
*/
function function_4d23baa6(v_origin, v_angles, var_b6c00097, var_5588387b)
{
	if(!isdefined(var_b6c00097))
	{
		var_b6c00097 = 5;
	}
	self endon("death");
	self SetCanDamage(1);
	self.health = 100000;
	while(1)
	{
		self waittill("damage", n_damage, e_attacker, v_direction, v_point, str_mod, str_tag_name, str_model_name, str_part_name, w_weapon);
		if(IS_TRUE(w_weapon.isRiotShield) && (IS_TRUE(e_attacker.var_36c3d64a)))
		{
			self notify("charged");
			e_attacker notify("hash_6bef9736");
			self playsound("zmb_lightning_shield_activate");
			var_752908f7 = util::spawn_model("tag_origin", v_origin, v_angles);
			var_752908f7 clientfield::set("zipline_lightning_fx", 1);
			if(isdefined(var_5588387b))
			{
				var_752908f7 thread [[var_5588387b]]();
			}
			wait(var_b6c00097);
			var_752908f7 notify("hash_48ec464");
			var_752908f7 clientfield::set("zipline_lightning_fx", 0);
			util::wait_network_frame();
			var_752908f7 delete();
		}
	}
}

/*
	Name: function_426caba9
	Namespace: namespace_b3c23ec9
	Checksum: 0xFB410D88
	Offset: 0x3290
	Size: 0xDB
	Parameters: 0
	Flags: None
*/
function function_426caba9()
{
	self endon("disconnect");
	if(isdefined(5))
	{
		__s = spawnstruct();
		__s endon("timeout");
		__s util::delay_notify(5, "timeout");
	}
	level flag::wait_till("flag_zipline_in_use");
	self waittill("hash_912d72b1");
	while(!self meleeButtonPressed())
	{
		wait(0.05);
	}
	if(isdefined(self.var_53539670))
	{
		self.var_53539670 notify("reached_end_node");
	}
}

/*
	Name: function_6e38e085
	Namespace: namespace_b3c23ec9
	Checksum: 0xE17ECEDA
	Offset: 0x3378
	Size: 0x127
	Parameters: 0
	Flags: None
*/
function function_6e38e085()
{
	var_d93f9cb8 = GetEnt("boat_death", "targetname");
	while(1)
	{
		var_d93f9cb8 waittill("trigger", e_who);
		if(isPlayer(e_who) && (!IS_TRUE(e_who.var_a98632dd)))
		{
			e_who.var_a98632dd = 1;
			e_who thread function_1bbe32e1();
			if(!level flag::get("solo_game"))
			{
				e_who.no_revive_trigger = 1;
			}
			e_who DoDamage(e_who.health + 1000, e_who.origin);
		}
	}
}

/*
	Name: function_1bbe32e1
	Namespace: namespace_b3c23ec9
	Checksum: 0xFA1808EC
	Offset: 0x34A8
	Size: 0xA5
	Parameters: 0
	Flags: None
*/
function function_1bbe32e1()
{
	self endon("disconnect");
	if(self hasPerk("specialty_quickrevive") && level flag::get("solo_game"))
	{
		self SetOrigin(self.var_5eb06498);
	}
	self util::waittill_any("player_revived", "spawned");
	self.no_revive_trigger = undefined;
	self.var_a98632dd = undefined;
}

/*
	Name: function_53246bea
	Namespace: namespace_b3c23ec9
	Checksum: 0xAF0EA04B
	Offset: 0x3558
	Size: 0xE3
	Parameters: 0
	Flags: None
*/
function function_53246bea()
{
	level flag::wait_till("trilogy_released");
	var_a2365998 = struct::get("elevator_part_gear2");
	var_71e3d70a = util::spawn_model("p7_zm_bgb_gear_01", var_a2365998.origin, var_a2365998.angles);
	var_71e3d70a.trigger = namespace_8aed53c9::function_d095318(var_71e3d70a.origin, 50, 1, &function_9bd3096f);
	var_71e3d70a thread function_d81e5824("elevator_part_gear2_found");
}

/*
	Name: function_1f4e6abd
	Namespace: namespace_b3c23ec9
	Checksum: 0xE9CC0DCF
	Offset: 0x3648
	Size: 0x1C3
	Parameters: 0
	Flags: None
*/
function function_1f4e6abd()
{
	var_ff4420b1 = util::spawn_model("p7_zm_ctl_ammo_flak_bullet_01", self.origin + VectorScale((0, 0, 1), 36), self.angles);
	var_ff4420b1 SetScale(5);
	var_4f2d91b3 = spawnstruct();
	var_4f2d91b3.origin = var_ff4420b1.origin;
	var_4f2d91b3.angles = var_ff4420b1.angles;
	var_4f2d91b3.e_parent = var_ff4420b1;
	var_4f2d91b3.script_unitrigger_type = "unitrigger_box_use";
	var_4f2d91b3.cursor_hint = "HINT_NOICON";
	var_4f2d91b3.require_look_at = 1;
	var_4f2d91b3.script_width = 128;
	var_4f2d91b3.script_length = 130;
	var_4f2d91b3.script_height = 100;
	var_4f2d91b3.prompt_and_visibility_func = &function_ca475941;
	zm_unitrigger::register_static_unitrigger(var_4f2d91b3, &function_545006a5);
	var_ff4420b1 waittill("hash_639abf38");
	var_ff4420b1 delete();
	zm_unitrigger::unregister_unitrigger(var_4f2d91b3);
}

/*
	Name: function_ca475941
	Namespace: namespace_b3c23ec9
	Checksum: 0xD32E6B17
	Offset: 0x3818
	Size: 0x2F
	Parameters: 1
	Flags: None
*/
function function_ca475941(player)
{
	self setHintString("");
	return 1;
}

/*
	Name: function_545006a5
	Namespace: namespace_b3c23ec9
	Checksum: 0x62875409
	Offset: 0x3850
	Size: 0xB9
	Parameters: 0
	Flags: None
*/
function function_545006a5()
{
	while(1)
	{
		self waittill("trigger", e_who);
		if(e_who zm_utility::in_revive_trigger())
		{
			continue;
		}
		if(e_who.IS_DRINKING > 0)
		{
			continue;
		}
		if(!zm_utility::is_player_valid(e_who))
		{
			continue;
		}
		self.stub.e_parent notify("hash_639abf38");
		level flag::set("player_has_aa_gun_ammo");
		return;
	}
}

/*
	Name: aa_gun_think
	Namespace: namespace_b3c23ec9
	Checksum: 0x1370DFBA
	Offset: 0x3918
	Size: 0x1C5
	Parameters: 0
	Flags: None
*/
function aa_gun_think()
{
	level flag::wait_till("trilogy_released");
	level thread function_35340bf6();
	level flag::wait_till("player_has_aa_gun_ammo");
	var_16bdbe0a = struct::get("aa_gun_trigger", "targetname");
	var_16bdbe0a.script_unitrigger_type = "unitrigger_box_use";
	var_16bdbe0a.radius = 64;
	var_16bdbe0a.cursor_hint = "HINT_NOICON";
	var_16bdbe0a.require_look_at = 1;
	while(!level flag::get("aa_gun_ee_complete"))
	{
		var_16bdbe0a.prompt_and_visibility_func = &function_9c02ad1;
		zm_unitrigger::register_static_unitrigger(var_16bdbe0a, &function_408069b5);
		level waittill("hash_e7ebaf47");
		zm_unitrigger::unregister_unitrigger(var_16bdbe0a);
		wait(1);
		var_16bdbe0a.prompt_and_visibility_func = &function_97bdb2f5;
		zm_unitrigger::register_static_unitrigger(var_16bdbe0a, &function_c0946f91);
		level waittill("hash_248f6385");
		zm_unitrigger::unregister_unitrigger(var_16bdbe0a);
		wait(1);
	}
}

/*
	Name: function_9c02ad1
	Namespace: namespace_b3c23ec9
	Checksum: 0x5BA135DB
	Offset: 0x3AE8
	Size: 0x97
	Parameters: 1
	Flags: None
*/
function function_9c02ad1(player)
{
	if(!player zm_utility::is_player_looking_at(self.origin, 0.5, 0) || !level flag::get("player_has_aa_gun_ammo"))
	{
		self setHintString("");
		return 0;
	}
	self setHintString("");
	return 1;
}

/*
	Name: function_408069b5
	Namespace: namespace_b3c23ec9
	Checksum: 0xCA37C739
	Offset: 0x3B88
	Size: 0x113
	Parameters: 0
	Flags: None
*/
function function_408069b5()
{
	while(!level flag::get("aa_gun_ammo_loaded"))
	{
		self waittill("trigger", e_who);
		if(e_who zm_utility::in_revive_trigger())
		{
			continue;
		}
		if(e_who.IS_DRINKING > 0)
		{
			continue;
		}
		if(!zm_utility::is_player_valid(e_who))
		{
			continue;
		}
		if(level flag::get("player_has_aa_gun_ammo"))
		{
			level flag::set("aa_gun_ammo_loaded");
			level flag::clear("player_has_aa_gun_ammo");
			playsoundatposition("zmb_aa_gun_load", self.origin);
			break;
		}
	}
}

/*
	Name: function_c0946f91
	Namespace: namespace_b3c23ec9
	Checksum: 0x7AC2C835
	Offset: 0x3CA8
	Size: 0xCB
	Parameters: 0
	Flags: None
*/
function function_c0946f91()
{
	while(level flag::get("aa_gun_ammo_loaded"))
	{
		self waittill("trigger", e_who);
		if(e_who zm_utility::in_revive_trigger())
		{
			continue;
		}
		if(e_who.IS_DRINKING > 0)
		{
			continue;
		}
		if(!zm_utility::is_player_valid(e_who))
		{
			continue;
		}
		level thread function_248f6385();
		playsoundatposition("wpn_aa_fire", self.origin);
		break;
	}
}

/*
	Name: function_97bdb2f5
	Namespace: namespace_b3c23ec9
	Checksum: 0x5CE16F0B
	Offset: 0x3D80
	Size: 0x77
	Parameters: 1
	Flags: None
*/
function function_97bdb2f5(player)
{
	if(!player zm_utility::is_player_looking_at(self.origin, 0.5, 0))
	{
		self setHintString("");
		return 0;
	}
	self setHintString("");
	return 1;
}

/*
	Name: function_248f6385
	Namespace: namespace_b3c23ec9
	Checksum: 0xAC4B36A3
	Offset: 0x3E00
	Size: 0x123
	Parameters: 0
	Flags: None
*/
function function_248f6385()
{
	level notify("hash_248f6385");
	level flag::clear("aa_gun_ammo_loaded");
	var_8cad0c4d = GetEnt("aa_gun", "targetname");
	var_8cad0c4d thread scene::Play("p7_fxanim_zm_island_flak_88_bundle", var_8cad0c4d);
	exploder::exploder("fxexp_810");
	var_16bdbe0a = struct::get("aa_gun_trigger", "targetname");
	PlayRumbleOnPosition("zm_island_aa_gun_fired", var_16bdbe0a.origin);
	if(level flag::get("ee_gun_plane_in_range"))
	{
		level flag::set("aa_gun_ee_complete");
	}
}

/*
	Name: function_35340bf6
	Namespace: namespace_b3c23ec9
	Checksum: 0xDFAEEAD8
	Offset: 0x3F30
	Size: 0xD7
	Parameters: 0
	Flags: None
*/
function function_35340bf6()
{
	while(!flag::get("aa_gun_ee_complete"))
	{
		e_vehicle = vehicle::simple_spawn_single("main_ee_aa_gun_plane");
		e_vehicle SetForceNoCull();
		e_vehicle thread function_45e9f465();
		e_vehicle thread namespace_c8222934::function_235019b6("main_ee_aa_gun_plane_path");
		e_vehicle waittill("reached_end_node");
		e_vehicle clientfield::set("plane_hit_by_aa_gun", 0);
		wait(60);
		//wait(randomIntRange(60, 120));
	}
}

/*
	Name: function_45e9f465
	Namespace: namespace_b3c23ec9
	Checksum: 0x330273C9
	Offset: 0x4010
	Size: 0x493
	Parameters: 0
	Flags: None
*/
function function_45e9f465()
{
	self endon("reached_end_node");
	level flag::wait_till("aa_gun_ee_complete");
	wait(0.3);
	self clientfield::set("plane_hit_by_aa_gun", 1);
	self playsound("evt_b17_explode");
	var_f7fded02 = struct::get_array("aa_gun_elevator_part_landing", "targetname");
	s_end = Array::random(var_f7fded02);
	s_explosion = spawnstruct();
	s_explosion.origin = self.origin;
	s_explosion.angles = self.angles;
	s_explosion thread scene::Play("p7_fxanim_zm_island_b17_explode_bundle");
	self.delete_on_death = 1;
	self notify("death");
	if(!isalive(self))
	{
		self delete();
	}
	wait(0.05);
	if(s_end.script_noteworthy == "gear_meteor")
	{
		nd_path_start = GetVehicleNode("meteor_start", "targetname");
	}
	else if(s_end.script_noteworthy == "gear_bunker")
	{
		nd_path_start = GetVehicleNode("bunker_start", "targetname");
	}
	else
	{
		nd_path_start = GetVehicleNode("lab_start", "targetname");
	}
	var_6549ae27 = spawner::simple_spawn_single("gear_vehicle");
	var_71e3d70a = util::spawn_model("p7_zm_bgb_gear_01", var_6549ae27.origin, s_end.angles);
	var_71e3d70a LinkTo(var_6549ae27);
	var_71e3d70a PlayLoopSound("evt_b17_piece_lp");
	util::wait_network_frame();
	var_71e3d70a clientfield::set("smoke_trail_fx", 1);
	var_6549ae27 vehicle::get_on_and_go_path(nd_path_start);
	var_6549ae27 waittill("reached_end_node");
	var_6549ae27.delete_on_death = 1;
	var_6549ae27 notify("death");
	if(!isalive(var_6549ae27))
	{
		var_6549ae27 delete();
	}
	var_71e3d70a moveto(s_end.origin, 0.1);
	var_71e3d70a waittill("movedone");
	var_71e3d70a clientfield::set("smoke_trail_fx", 0);
	var_71e3d70a clientfield::set("smoke_smolder_fx", 1);
	var_71e3d70a playsound("evt_b17_piece_impact");
	var_71e3d70a StopLoopSound(0.25);
	var_71e3d70a.trigger = namespace_8aed53c9::function_d095318(var_71e3d70a.origin, 50, 1, &function_9bd3096f);
	var_71e3d70a thread function_d81e5824("elevator_part_gear3_found");
	s_explosion = undefined;
}

/*
	Name: function_4280e890
	Namespace: namespace_b3c23ec9
	Checksum: 0xA4E25F63
	Offset: 0x44B0
	Size: 0x53
	Parameters: 0
	Flags: None
*/
function function_4280e890()
{
	level flag::wait_till("ee_gun_plane_in_range");
	wait(0.1);
	level flag::wait_till_clear("ee_gun_plane_in_range");
	wait(0.1);
}

/*
	Name: function_d81e5824
	Namespace: namespace_b3c23ec9
	Checksum: 0xA03FBDE9
	Offset: 0x4510
	Size: 0xC3
	Parameters: 1
	Flags: None
*/
function function_d81e5824(str_flag)
{
	while(1)
	{
		self.trigger waittill("trigger", player);
		if(zm_utility::is_player_valid(player))
		{
			zm_unitrigger::unregister_unitrigger(self.trigger);
			level flag::set(str_flag);
			self.trigger = undefined;
			player playsound("zmb_item_pickup");
			self delete();
			break;
		}
	}
}

/*
	Name: function_9bd3096f
	Namespace: namespace_b3c23ec9
	Checksum: 0x9B77B392
	Offset: 0x45E0
	Size: 0x11
	Parameters: 1
	Flags: Private
*/
function private function_9bd3096f(player)
{
	return "";
}

/*
	Name: function_5d0980ef
	Namespace: namespace_b3c23ec9
	Checksum: 0x1EA23172
	Offset: 0x4600
	Size: 0xA3
	Parameters: 0
	Flags: None
*/
function function_5d0980ef()
{
	var_66bf6df = GetEnt("elevator_gears", "targetname");
	var_66bf6df HidePart("wheel_01_jnt");
	var_66bf6df HidePart("wheel_02_jnt");
	var_66bf6df HidePart("wheel_03_jnt");
	level thread function_a06630fc();
}

/*
	Name: function_aeef1178
	Namespace: namespace_b3c23ec9
	Checksum: 0x92C725FB
	Offset: 0x46B0
	Size: 0x1D9
	Parameters: 0
	Flags: None
*/
function function_aeef1178()
{
	self endon("disconnect");
	self endon("hash_51d9edd8");
	level endon("hash_b165a75b");
	level flag::wait_till("trilogy_released");
	var_e66037d6 = GetEnt("main_ee_elevator_wall_metal", "targetname");
	var_ed315f0 = GetEnt("main_ee_elevator_wall_decal", "targetname");
	self namespace_8aed53c9::function_7448e472(var_e66037d6);
	callback::remove_on_spawned(&function_aeef1178);
	foreach(player in level.players)
	{
		if(player !== self)
		{
			player notify("hash_51d9edd8");
		}
	}
	exploder::exploder("fxexp_509");
	level thread namespace_8aed53c9::function_925aa63a(Array(var_e66037d6, var_ed315f0), 0.25, 0, 1);
	level thread function_6cc2e374();
	level notify("hash_b165a75b");
}

/*
	Name: function_a06630fc
	Namespace: namespace_b3c23ec9
	Checksum: 0x89A60A85
	Offset: 0x4898
	Size: 0x43
	Parameters: 0
	Flags: None
*/
function function_a06630fc()
{
	trigger::wait_till("trigger_see_gears");
	Array::thread_all(level.players, &function_77f4b1ca);
}

/*
	Name: function_77f4b1ca
	Namespace: namespace_b3c23ec9
	Checksum: 0xA23B9E19
	Offset: 0x48E8
	Size: 0x12B
	Parameters: 0
	Flags: None
*/
function function_77f4b1ca()
{
	self endon("disconnect");
	self endon("hash_87b9e813");
	var_66bf6df = GetEnt("elevator_gears", "targetname");
	self util::waittill_player_looking_at(var_66bf6df.origin);
	foreach(player in level.players)
	{
		if(player != self)
		{
			player notify("hash_87b9e813");
		}
	}
	if(zm_utility::is_player_valid(self))
	{
		self thread namespace_f333593c::function_d258c672("2");
	}
}

/*
	Name: function_6cc2e374
	Namespace: namespace_b3c23ec9
	Checksum: 0x4BCDBB2A
	Offset: 0x4A20
	Size: 0x483
	Parameters: 0
	Flags: None
*/
function function_6cc2e374()
{
	var_f022cb65 = GetEnt("trigger_elevator_gears", "targetname");
	var_f022cb65 setcursorhint("HINT_NOICON");
	var_f022cb65 setHintString("");
	var_66bf6df = GetEnt("elevator_gears", "targetname");
	var_66bf6df thread function_46d7f262();
	while(1)
	{
		var_f022cb65 waittill("trigger", e_who);
		if(level flag::get("elevator_part_gear1_found") && !level flag::get("elevator_part_gear1_placed"))
		{
			level flag::set("elevator_part_gear1_placed");
			var_f022cb65 playsound("zmb_item_pickup");
			var_66bf6df.var_df281e84 = util::spawn_model("p7_zm_isl_elevator_gears_wheel", var_66bf6df GetTagOrigin("wheel_01_jnt") + (1, 2, 0), var_66bf6df GetTagAngles("wheel_01_jnt"));
		}
		if(level flag::get("elevator_part_gear2_found") && !level flag::get("elevator_part_gear2_placed"))
		{
			level flag::set("elevator_part_gear2_placed");
			var_f022cb65 playsound("zmb_item_pickup");
			var_66bf6df.var_e882d83c = util::spawn_model("p7_zm_isl_elevator_gears_wheel_small", var_66bf6df GetTagOrigin("wheel_02_jnt") + (0.525, 2, -0.075), var_66bf6df GetTagAngles("wheel_02_jnt"));
		}
		if(level flag::get("elevator_part_gear3_found") && !level flag::get("elevator_part_gear3_placed"))
		{
			level flag::set("elevator_part_gear3_placed");
			var_f022cb65 playsound("zmb_item_pickup");
			var_66bf6df.var_aab7a6d1 = util::spawn_model("p7_zm_isl_elevator_gears_wheel_small", var_66bf6df GetTagOrigin("wheel_03_jnt") + VectorScale((0, 1, 0), 2), var_66bf6df GetTagAngles("wheel_03_jnt"));
		}
		if(level flag::get("elevator_part_gear1_found") && level flag::get("elevator_part_gear2_found") && level flag::get("elevator_part_gear3_found"))
		{
			var_f022cb65 playsound("zmb_elevator_fix");
			level thread namespace_f333593c::function_3bf2d62a("elevator", 0, 1, 0);
			if(zm_utility::is_player_valid(e_who))
			{
				e_who thread namespace_f333593c::function_d258c672("elevator");
			}
			level thread function_e2cd4ac4();
			break;
		}
	}
}

/*
	Name: function_46d7f262
	Namespace: namespace_b3c23ec9
	Checksum: 0xB5292584
	Offset: 0x4EB0
	Size: 0x1D7
	Parameters: 0
	Flags: None
*/
function function_46d7f262()
{
	var_17b2dca3 = GetEntArray("easter_egg_elevator_cage", "targetname");
	while(1)
	{
		level flag::wait_till("elevator_in_use");
		wait(0.1);
		while(!isdefined(var_17b2dca3[0].is_moving))
		{
			wait(0.05);
		}
		while(var_17b2dca3[0].is_moving)
		{
			if(level flag::get("elevator_at_bottom"))
			{
				var_b126107b = -90;
			}
			else
			{
				var_b126107b = 90;
			}
			self.var_df281e84 RotateRoll(var_b126107b, 1);
			self.var_e882d83c RotateRoll(var_b126107b, 1);
			self.var_aab7a6d1 RotateRoll(var_b126107b * -1, 1);
			wait(0.9);
		}
		self.var_df281e84 RotateRoll(var_b126107b * 0.01, 0.1);
		self.var_e882d83c RotateRoll(var_b126107b * 0.01, 0.1);
		self.var_aab7a6d1 RotateRoll(var_b126107b * -1 * 0.01, 0.1);
	}
}

/*
	Name: function_e2cd4ac4
	Namespace: namespace_b3c23ec9
	Checksum: 0x6667EF91
	Offset: 0x5090
	Size: 0x49B
	Parameters: 0
	Flags: None
*/
function function_e2cd4ac4()
{
	n_width = 64;
	n_height = 128;
	n_length = 64;
	var_37f7b157 = struct::get_array("s_elevator_trigger", "targetname");
	foreach(s_org in var_37f7b157)
	{
		s_org.script_unitrigger_type = "unitrigger_box_use";
		s_org.cursor_hint = "HINT_NOICON";
		s_org.script_width = n_width;
		s_org.script_height = n_height;
		s_org.script_length = n_length;
		s_org.require_look_at = 1;
		s_org.prompt_and_visibility_func = &function_d93c8e95;
		zm_unitrigger::register_static_unitrigger(s_org, &function_8f599d4f);
	}
	var_37f7b157 = struct::get_array("s_elevator_call_trigger", "targetname");
	foreach(s_org in var_37f7b157)
	{
		s_org.script_unitrigger_type = "unitrigger_box_use";
		s_org.cursor_hint = "HINT_NOICON";
		s_org.script_width = n_width;
		s_org.script_height = n_height;
		s_org.script_length = n_length;
		s_org.require_look_at = 1;
		if(s_org.script_noteworthy == "bottom")
		{
			s_org.var_db67c127 = 1;
		}
		else
		{
			s_org.var_db67c127 = 0;
		}
		s_org.prompt_and_visibility_func = &function_ee748266;
		zm_unitrigger::register_static_unitrigger(s_org, &function_66070c12);
	}
	e_elevator = GetEnt("easter_egg_elevator_cage", "targetname");
	e_elevator SetMovingPlatformEnabled(1);
	var_dd1bd705 = GetEntArray("elevator_panel_lights", "script_noteworthy");
	foreach(e_light in var_dd1bd705)
	{
		e_light LinkTo(e_elevator);
	}
	exploder::exploder("ex_elevator_panel_green");
	exploder::exploder("ex_elevator_switch_top_red");
	exploder::exploder("ex_elevator_switch_bottom_green");
	exploder::exploder("ex_elevator_overlight");
	exploder::exploder("ex_elevator_repaired");
	function_574812fe();
}

/*
	Name: function_d93c8e95
	Namespace: namespace_b3c23ec9
	Checksum: 0x7863A7DE
	Offset: 0x5538
	Size: 0xC1
	Parameters: 1
	Flags: None
*/
function function_d93c8e95(player)
{
	if(level flag::get("elevator_in_use"))
	{
		self setHintString("");
		return 0;
	}
	else if(level flag::get("elevator_cooldown"))
	{
		self setHintString(&"ZM_ISLAND_ELEVATOR_RECHARGING");
		return 1;
	}
	else
	{
		self setHintString(&"ZM_ISLAND_USE_ELEVATOR");
		return 1;
	}
}

/*
	Name: function_8f599d4f
	Namespace: namespace_b3c23ec9
	Checksum: 0xBDBF59B5
	Offset: 0x5608
	Size: 0xD7
	Parameters: 0
	Flags: None
*/
function function_8f599d4f()
{
	while(1)
	{
		self waittill("trigger", player);
		if(player zm_utility::in_revive_trigger())
		{
			continue;
		}
		if(player.IS_DRINKING > 0)
		{
			continue;
		}
		if(!zm_utility::is_player_valid(player))
		{
			continue;
		}
		if(level flag::get("elevator_in_use") || level flag::get("elevator_cooldown"))
		{
			continue;
		}
		level thread function_46201613(self, player);
	}
}

/*
	Name: function_ee748266
	Namespace: namespace_b3c23ec9
	Checksum: 0x9045DA8D
	Offset: 0x56E8
	Size: 0x117
	Parameters: 1
	Flags: None
*/
function function_ee748266(player)
{
	if(level flag::get("elevator_in_use"))
	{
		self setHintString(&"ZM_ISLAND_ELEVATOR_IN_USE");
		return 0;
	}
	else if(level flag::get("elevator_cooldown"))
	{
		self setHintString(&"ZM_ISLAND_ELEVATOR_RECHARGING");
		return 1;
	}
	else if(self.stub.var_db67c127 != level flag::get("elevator_at_bottom"))
	{
		self setHintString(&"ZM_ISLAND_CALL_ELEVATOR");
		return 1;
	}
	else
	{
		self setHintString("");
		return 0;
	}
}

/*
	Name: function_66070c12
	Namespace: namespace_b3c23ec9
	Checksum: 0x9272236E
	Offset: 0x5808
	Size: 0x107
	Parameters: 0
	Flags: None
*/
function function_66070c12()
{
	while(1)
	{
		self waittill("trigger", player);
		if(player zm_utility::in_revive_trigger())
		{
			continue;
		}
		if(player.IS_DRINKING > 0)
		{
			continue;
		}
		if(!zm_utility::is_player_valid(player))
		{
			continue;
		}
		if(level flag::get("elevator_in_use") || level flag::get("elevator_cooldown"))
		{
			continue;
		}
		if(self.stub.var_db67c127 != level flag::get("elevator_at_bottom"))
		{
			level thread function_46201613(self, player);
		}
	}
}

/*
	Name: function_46201613
	Namespace: namespace_b3c23ec9
	Checksum: 0xC49275FA
	Offset: 0x5918
	Size: 0x21B
	Parameters: 2
	Flags: None
*/
function function_46201613(trig_stub, player)
{
	level flag::set("elevator_in_use");
	exploder::exploder_stop("ex_elevator_panel_green");
	exploder::exploder_stop("ex_elevator_switch_top_green");
	exploder::exploder_stop("ex_elevator_switch_bottom_green");
	exploder::exploder("ex_elevator_panel_red");
	exploder::exploder("ex_elevator_switch_top_red");
	exploder::exploder("ex_elevator_switch_bottom_red");
	function_574812fe(0);
	elevator_move();
	function_574812fe();
	level flag::clear("elevator_in_use");
	level flag::set("elevator_cooldown");
	wait(5);
	level flag::clear("elevator_cooldown");
	exploder::exploder_stop("ex_elevator_panel_red");
	exploder::exploder("ex_elevator_panel_green");
	if(level flag::get("elevator_at_bottom"))
	{
		exploder::exploder_stop("ex_elevator_switch_top_red");
		exploder::exploder("ex_elevator_switch_top_green");
	}
	else
	{
		exploder::exploder_stop("ex_elevator_switch_bottom_red");
		exploder::exploder("ex_elevator_switch_bottom_green");
	}
}

/*
	Name: function_574812fe
	Namespace: namespace_b3c23ec9
	Checksum: 0xAAED1450
	Offset: 0x5B40
	Size: 0x619
	Parameters: 1
	Flags: None
*/
function function_574812fe(b_open)
{
	if(!isdefined(b_open))
	{
		b_open = 1;
	}
	if(level flag::get("elevator_at_bottom"))
	{
		e_door_left = GetEnt("easter_egg_elevator_door_bottom_left", "targetname");
		e_door_right = GetEnt("easter_egg_elevator_door_bottom_right", "targetname");
		var_28bca224 = GetEnt("easter_egg_elevator_door_inner_bottom_left", "targetname");
		var_70426c1b = GetEnt("easter_egg_elevator_door_inner_bottom_right", "targetname");
		var_2e25ac99 = GetNodeArray("elevator_bottom_begin_node", "targetname");
	}
	else
	{
		e_door_left = GetEnt("easter_egg_elevator_door_top_left", "targetname");
		e_door_right = GetEnt("easter_egg_elevator_door_top_right", "targetname");
		var_28bca224 = GetEnt("easter_egg_elevator_door_inner_top_left", "targetname");
		var_70426c1b = GetEnt("easter_egg_elevator_door_inner_top_right", "targetname");
		var_2e25ac99 = GetNodeArray("elevator_top_begin_node", "targetname");
	}
	if(IS_TRUE(b_open))
	{
		e_door_left notsolid();
		e_door_right notsolid();
		var_28bca224 notsolid();
		var_70426c1b notsolid();
		e_door_left connectpaths();
		e_door_right connectpaths();
		var_28bca224 connectpaths();
		var_70426c1b connectpaths();
		foreach(var_49686839 in var_2e25ac99)
		{
			LinkTraversal(var_49686839);
		}
		e_door_left MoveY(-40, 1);
		e_door_right MoveY(40, 1);
		var_28bca224 MoveY(-40, 1);
		var_70426c1b MoveY(40, 1);
		var_28bca224 playsound("zmb_elevator_door_open");
		level flag::clear("elevator_door_closed");
	}
	else
	{
		foreach(var_49686839 in var_2e25ac99)
		{
			UnlinkTraversal(var_49686839);
		}
		e_door_left solid();
		e_door_right solid();
		var_28bca224 solid();
		var_70426c1b solid();
		e_door_left disconnectpaths();
		e_door_right disconnectpaths();
		var_28bca224 disconnectpaths();
		var_70426c1b disconnectpaths();
		e_door_left MoveY(40, 1);
		e_door_right MoveY(-40, 1);
		var_28bca224 MoveY(40, 1);
		var_70426c1b MoveY(-40, 1);
		var_28bca224 playsound("zmb_elevator_door_close");
		level flag::set("elevator_door_closed");
	}
	e_door_left waittill("movedone");
}

/*
	Name: elevator_move
	Namespace: namespace_b3c23ec9
	Checksum: 0x65A4B9C0
	Offset: 0x6168
	Size: 0x4C3
	Parameters: 0
	Flags: None
*/
function elevator_move()
{
	var_17b2dca3 = GetEntArray("easter_egg_elevator_cage", "targetname");
	var_1fac16fe = GetEnt("easter_egg_elevator_door_inner_top_left", "targetname");
	var_1fac16fe LinkTo(var_17b2dca3[0]);
	var_adbea363 = GetEnt("easter_egg_elevator_door_inner_top_right", "targetname");
	var_adbea363 LinkTo(var_17b2dca3[0]);
	var_46ebdf14 = GetEnt("easter_egg_elevator_door_inner_bottom_left", "targetname");
	var_46ebdf14 LinkTo(var_17b2dca3[0]);
	var_ddc6ba27 = GetEnt("easter_egg_elevator_door_inner_bottom_right", "targetname");
	var_ddc6ba27 LinkTo(var_17b2dca3[0]);
	if(level flag::get("elevator_at_bottom"))
	{
		foreach(e_elevator in var_17b2dca3)
		{
			e_elevator MoveZ(1280, 20);
		}
		break;
	}
	foreach(e_elevator in var_17b2dca3)
	{
		e_elevator MoveZ(-1280, 20);
	}
	var_17b2dca3[0].is_moving = 1;
	var_17b2dca3[0] playsound("zmb_elevator_start");
	var_17b2dca3[0] PlayLoopSound("zmb_elevator_loop");
	var_17b2dca3[0] thread function_7b8e6e93();
	var_17b2dca3[0] waittill("movedone");
	var_17b2dca3[0] thread function_e35db912();
	var_17b2dca3[0].is_moving = 0;
	var_17b2dca3[0] playsound("zmb_elevator_stop");
	var_17b2dca3[0] StopLoopSound(0.5);
	var_1fac16fe = GetEnt("easter_egg_elevator_door_inner_top_left", "targetname");
	var_1fac16fe Unlink();
	var_adbea363 = GetEnt("easter_egg_elevator_door_inner_top_right", "targetname");
	var_adbea363 Unlink();
	var_46ebdf14 = GetEnt("easter_egg_elevator_door_inner_bottom_left", "targetname");
	var_46ebdf14 Unlink();
	var_ddc6ba27 = GetEnt("easter_egg_elevator_door_inner_bottom_right", "targetname");
	var_ddc6ba27 Unlink();
	if(level flag::get("elevator_at_bottom"))
	{
		level flag::clear("elevator_at_bottom");
	}
	else
	{
		level flag::set("elevator_at_bottom");
	}
}

/*
	Name: function_7b8e6e93
	Namespace: namespace_b3c23ec9
	Checksum: 0x54252AC6
	Offset: 0x6638
	Size: 0x1C5
	Parameters: 0
	Flags: None
*/
function function_7b8e6e93()
{
	self endon("movedone");
	while(1)
	{
		foreach(player in level.players)
		{
			if(player istouching(self))
			{
				player.in_elevator = 1;
			}
		}
		wait(0.05);
		foreach(player in level.players)
		{
			if(player.in_elevator === 1 && (player.origin[2] > self.origin[2] + 60 || player.origin[2] < self.origin[2] - 20))
			{
				player SetOrigin(self.origin + VectorScale((0, 0, 1), 20));
			}
		}
	}
}

/*
	Name: function_e35db912
	Namespace: namespace_b3c23ec9
	Checksum: 0xE83F25F5
	Offset: 0x6808
	Size: 0x8D
	Parameters: 0
	Flags: None
*/
function function_e35db912()
{
	wait(0.1);
	foreach(player in level.players)
	{
		player.in_elevator = 0;
	}
}

/*
	Name: function_f818f5b5
	Namespace: namespace_b3c23ec9
	Checksum: 0x91097DAA
	Offset: 0x68A0
	Size: 0x297
	Parameters: 0
	Flags: None
*/
function function_f818f5b5()
{
	level flag::wait_till("all_challenges_completed");
	zm::register_actor_damage_callback(&function_16155679);
	zm::register_vehicle_damage_callback(&function_a7a11020);
	var_8d943e64 = GetEnt("ruins_lightning_trigger", "targetname");
	while(1)
	{
		wait(60);
		//wait(RandomFloatRange(60, 90));
		exploder::exploder("fxexp_510");
		exploder::exploder("fxexp_511");
		exploder::exploder("fxexp_512");
		exploder::exploder("fxexp_513");
		exploder::exploder("fxexp_514");
		exploder::exploder("fxexp_820");
		exploder::exploder("fxexp_821");
		exploder::exploder("fxexp_822");
		exploder::exploder("fxexp_823");
		level thread function_51f6829f(var_8d943e64);
		wait(5);
		level notify("hash_6d764fa3");
		exploder::exploder_stop("fxexp_510");
		exploder::exploder_stop("fxexp_511");
		exploder::exploder_stop("fxexp_512");
		exploder::exploder_stop("fxexp_513");
		exploder::exploder_stop("fxexp_514");
		exploder::exploder_stop("fxexp_820");
		exploder::exploder_stop("fxexp_821");
		exploder::exploder_stop("fxexp_822");
		exploder::exploder_stop("fxexp_823");
	}
}

/*
	Name: function_51f6829f
	Namespace: namespace_b3c23ec9
	Checksum: 0x8D94ECE9
	Offset: 0x6B40
	Size: 0x227
	Parameters: 1
	Flags: None
*/
function function_51f6829f(var_8d943e64)
{
	level endon("hash_6d764fa3");
	wait(1);
	while(1)
	{
		foreach(player in level.players)
		{
			if(player istouching(var_8d943e64))
			{
				w_current = player GetCurrentWeapon();
				if(w_current.isRiotShield === 1 && (!IS_TRUE(player zm_laststand::is_reviving_any())) && (IS_TRUE(zm_utility::is_player_valid(player))))
				{
					if(!(IS_TRUE(player.var_36c3d64a)))
					{
						player thread function_8f34e78f();
						player notify("hash_df77d4a");
					}
					continue;
				}
				if(!(IS_TRUE(player.var_bd2718b6)))
				{
					player DoDamage(player.maxhealth * 0.5, player.origin);
					player thread function_69b5fce9();
				}
			}
		}
		wait(0.1);
	}
}

/*
	Name: function_69b5fce9
	Namespace: namespace_b3c23ec9
	Checksum: 0xC8A8E2F8
	Offset: 0x6D70
	Size: 0x2F
	Parameters: 0
	Flags: None
*/
function function_69b5fce9()
{
	self endon("disconnect");
	self.var_bd2718b6 = 1;
	wait(3);
	self.var_bd2718b6 = 0;
}

/*
	Name: function_8f34e78f
	Namespace: namespace_b3c23ec9
	Checksum: 0x1F19BC0E
	Offset: 0x6DA8
	Size: 0x5B
	Parameters: 0
	Flags: None
*/
function function_8f34e78f()
{
	self.var_36c3d64a = 1;
	self.riotshield_damage_absorb_callback = &function_d68f2492;
	self thread function_e7cf715();
	self clientfield::set("lightning_shield_fx", 1);
}

/*
	Name: function_e7cf715
	Namespace: namespace_b3c23ec9
	Checksum: 0xCF85B17C
	Offset: 0x6E10
	Size: 0x73
	Parameters: 0
	Flags: None
*/
function function_e7cf715()
{
	self endon("disconnect");
	self util::waittill_any("destroy_riotshield", "riotshield_lost_lightning", "bled_out");
	self.var_36c3d64a = 0;
	self.riotshield_damage_absorb_callback = undefined;
	self clientfield::set("lightning_shield_fx", 0);
}

/*
	Name: function_9f26e724
	Namespace: namespace_b3c23ec9
	Checksum: 0x22C0C230
	Offset: 0x6E90
	Size: 0xD1
	Parameters: 0
	Flags: None
*/
function function_9f26e724()
{
	foreach(var_c9340b8 in level.var_961b3545)
	{
		if(var_c9340b8.script_string != "revive_perk" || (level.activePlayers.size > 1 && var_c9340b8.script_string == "revive_perk"))
		{
			var_c9340b8 thread function_f295a467();
		}
	}
}

/*
	Name: function_f295a467
	Namespace: namespace_b3c23ec9
	Checksum: 0x1BB1B2B6
	Offset: 0x6F70
	Size: 0x297
	Parameters: 0
	Flags: None
*/
function function_f295a467()
{
	self endon("death");
	self.var_bf47c5ef = 0;
	self.machine SetCanDamage(1);
	while(1)
	{
		self.machine waittill("damage", n_damage, e_attacker, v_direction, v_point, str_mod, str_tag_name, str_model_name, str_part_name, w_weapon);
		n_damage = 0;
		if(IS_TRUE(w_weapon.isRiotShield) && IS_TRUE(e_attacker.var_36c3d64a) && !self.var_bf47c5ef)
		{
			e_attacker notify("hash_6bef9736");
			self.var_bf47c5ef = 1;
			self.var_a62a0fde = self.cost;
			self playsound("zmb_lightning_shield_activate");
			str_perk = self.script_noteworthy;
			if(isdefined(level._custom_perks) && isdefined(level._custom_perks[str_perk]))
			{
				self.cost = Int(self.cost * 0.5);
				level._custom_perks[str_perk].cost = self.cost;
				self.machine thread function_b83e4b61(str_perk, 1);
				self zm_perks::reset_vending_hint_string();
				wait(30);
				self.machine thread function_b83e4b61(str_perk, 0);
				self.var_bf47c5ef = 0;
				self.cost = self.var_a62a0fde;
				level._custom_perks[str_perk].cost = self.cost;
				self zm_perks::reset_vending_hint_string();
			}
		}
	}
}

/*
	Name: function_b83e4b61
	Namespace: namespace_b3c23ec9
	Checksum: 0x46765314
	Offset: 0x7210
	Size: 0x19B
	Parameters: 2
	Flags: None
*/
function function_b83e4b61(str_perk, b_on)
{
	if(b_on)
	{
		switch(str_perk)
		{
			case "specialty_doubletap2":
			{
				self clientfield::set("perk_lightning_fx", 1);
				break;
			}
			case "specialty_armorvest":
			{
				self clientfield::set("perk_lightning_fx", 2);
				break;
			}
			case "specialty_quickrevive":
			{
				self clientfield::set("perk_lightning_fx", 3);
				break;
			}
			case "specialty_fastreload":
			{
				self clientfield::set("perk_lightning_fx", 4);
				break;
			}
			case "specialty_staminup":
			{
				self clientfield::set("perk_lightning_fx", 5);
				break;
			}
			case "specialty_additionalprimaryweapon":
			{
				self clientfield::set("perk_lightning_fx", 6);
				break;
			}
			default:
			{
				self clientfield::set("perk_lightning_fx", 1);
				break;
			}
		}
	}
	else
	{
		self clientfield::set("perk_lightning_fx", 0);
	}
}

/*
	Name: function_8221532d
	Namespace: namespace_b3c23ec9
	Checksum: 0x22EF690C
	Offset: 0x73B8
	Size: 0x153
	Parameters: 0
	Flags: None
*/
function function_8221532d()
{
	var_d3ed310f = GetEntArray("bgb_damage_clip", "script_noteworthy");
	foreach(var_a27ff52f in var_d3ed310f)
	{
		foreach(var_4770ddb4 in level.var_5081bd63)
		{
			if(var_4770ddb4 istouching(var_a27ff52f))
			{
				var_4770ddb4.var_9e209773 = var_a27ff52f;
				var_4770ddb4 thread function_e20ecfa4();
				break;
			}
		}
	}
}

/*
	Name: function_e20ecfa4
	Namespace: namespace_b3c23ec9
	Checksum: 0x529B2646
	Offset: 0x7518
	Size: 0x283
	Parameters: 0
	Flags: None
*/
function function_e20ecfa4()
{
	self endon("death");
	self.var_bf47c5ef = 0;
	self.var_9e209773 SetCanDamage(1);
	self.var_9e209773.health = 99999;
	while(1)
	{
		self.var_9e209773 waittill("damage", n_damage, e_attacker, v_direction, v_point, str_mod, str_tag_name, str_model_name, str_part_name, w_weapon);
		n_damage = 0;
		if(IS_TRUE(w_weapon.isRiotShield) && IS_TRUE(e_attacker.var_36c3d64a) && !self.var_bf47c5ef)
		{
			if(isdefined(level.zombie_vars["zombie_powerup_fire_sale_on"]) && level.zombie_vars["zombie_powerup_fire_sale_on"])
			{
				continue;
			}
			self.var_9e209773 playsound("zmb_lightning_shield_activate");
			e_attacker notify("hash_6bef9736");
			self.var_bf47c5ef = 1;
			self.var_a62a0fde = self.base_cost;
			self.base_cost = Int(self.base_cost * 0.5);
			self clientfield::set("bgb_lightning_fx", 1);
			wait(30);
			if(IS_TRUE(level.zombie_vars["zombie_powerup_fire_sale_on"]))
			{
				level waittill("fire_sale_off");
				wait(0.5);
			}
			self clientfield::set("bgb_lightning_fx", 0);
			self.var_bf47c5ef = 0;
			self.base_cost = self.var_a62a0fde;
		}
	}
}

/*
	Name: function_16155679
	Namespace: namespace_b3c23ec9
	Checksum: 0x287F4863
	Offset: 0x77A8
	Size: 0x11F
	Parameters: 12
	Flags: None
*/
function function_16155679(inflictor, attacker, damage, flags, meansOfDeath, weapon, vPoint, vDir, sHitLoc, psOffsetTime, boneIndex, surfaceType)
{
	if(IS_TRUE(weapon.isRiotShield) && IS_TRUE(attacker.var_36c3d64a) && !isPlayer(self))
	{
		attacker namespace_112fb534::function_20654ca0(self);
		attacker notify("hash_aacf862e");
		attacker namespace_f333593c::function_1881817("kill", "shield_electric");
	}
	return -1;
}

/*
	Name: function_a7a11020
	Namespace: namespace_b3c23ec9
	Checksum: 0xA692D776
	Offset: 0x78D0
	Size: 0x157
	Parameters: 15
	Flags: None
*/
function function_a7a11020(eInflictor, eAttacker, iDamage, iDFlags, sMeansOfDeath, weapon, vPoint, vDir, sHitLoc, vDamageOrigin, psOffsetTime, damageFromUnderneath, modelIndex, partName, vSurfaceNormal)
{
	if(IS_TRUE(weapon.isRiotShield) && IS_TRUE(eAttacker.var_36c3d64a) && !isPlayer(self))
	{
		if(level.var_335f95e4 === self && level flag::get("spider_from_mars_trapped_in_raised_cage"))
		{
			return 0;
		}
		eAttacker namespace_112fb534::function_20654ca0(self);
		eAttacker namespace_f333593c::function_1881817("kill", "shield_electric");
	}
	return iDamage;
}

/*
	Name: function_d68f2492
	Namespace: namespace_b3c23ec9
	Checksum: 0x125B4FF4
	Offset: 0x7A30
	Size: 0x73
	Parameters: 4
	Flags: None
*/
function function_d68f2492(eAttacker, iDamage, sHitLoc, sMeansOfDeath)
{
	if(IS_TRUE(self.var_36c3d64a) && !isPlayer(eAttacker))
	{
		self namespace_112fb534::function_20654ca0(eAttacker);
	}
}

/*
	Name: function_e509082
	Namespace: namespace_b3c23ec9
	Checksum: 0xEAA57092
	Offset: 0x7AB0
	Size: 0x31B
	Parameters: 0
	Flags: None
*/
function function_e509082()
{
	level flag::wait_till("flag_play_outro_cutscene");
	foreach(player in level.activePlayers)
	{
		player thread namespace_f333593c::function_cf763858();
	}
	level LUI::screen_fade_out(0, "black");
	level util::player_lock_control();
	scene::add_scene_func("cin_isl_outro_3rd_sh140", &function_c93cd104, "play");
	scene::add_scene_func("cin_isl_outro_3rd_sh240", &function_c5001569, "play");
	scene::add_scene_func("cin_isl_outro_3rd_sh240", &function_dad4e4f3, "done");
	scene::add_scene_func("cin_isl_outro_3rd_sh250", &function_1f3b8e3c, "play");
	scene::add_scene_func("cin_isl_outro_3rd_sh250", &function_da7a6f36, "done");
	wait(0.25);
	GetEnt("mdl_alttakeo", "targetname") Hide();
	level thread function_dcf88974();
	level flag::set("flag_show_outro_water");
	wait(0.25);
	level LUI::screen_fade_in(0, "black");
	level scene::Play("cin_isl_outro_3rd_sh010");
	Array::thread_all(level.activePlayers, &zm_utility::give_player_all_perks);
	Array::thread_all(level.players, &function_d875b253);
	Array::thread_all(level.players, &function_d2e1a913);
	level flag::set("flag_outro_cutscene_done");
}

/*
	Name: function_d2e1a913
	Namespace: namespace_b3c23ec9
	Checksum: 0x8F0D33B2
	Offset: 0x7DD8
	Size: 0x63
	Parameters: 0
	Flags: None
*/
function function_d2e1a913()
{
	level scoreevents::processScoreEvent("main_EE_quest_island", self);
	self zm_stats::increment_global_stat("DARKOPS_ISLAND_EE");
	self zm_stats::increment_global_stat("DARKOPS_ISLAND_SUPER_EE");
}

/*
	Name: function_d875b253
	Namespace: namespace_b3c23ec9
	Checksum: 0x7E215C50
	Offset: 0x7E48
	Size: 0x4B
	Parameters: 0
	Flags: None
*/
function function_d875b253()
{
	if(isalive(self) && self.characterindex != 2)
	{
		self SetCharacterBodyStyle(1);
	}
}

/*
	Name: function_c93cd104
	Namespace: namespace_b3c23ec9
	Checksum: 0xF2EA75C2
	Offset: 0x7EA0
	Size: 0x93
	Parameters: 1
	Flags: None
*/
function function_c93cd104(a_ents)
{
	var_722023b5 = a_ents["old_takeo"];
	var_722023b5 waittill("hash_a00e5555");
	if(level.var_7ccadaab === 11)
	{
		var_722023b5 PlaySoundOnTag("vox_tak1_outro_igc_japalt_13", "J_Head");
	}
	else
	{
		var_722023b5 PlaySoundOnTag("vox_tak1_outro_igc_13", "J_Head");
	}
}

/*
	Name: function_c5001569
	Namespace: namespace_b3c23ec9
	Checksum: 0x72DBFD27
	Offset: 0x7F40
	Size: 0x33
	Parameters: 1
	Flags: None
*/
function function_c5001569(a_ents)
{
	level waittill("hash_83582d4d");
	level LUI::screen_fade_out(0, "black");
}

/*
	Name: function_dad4e4f3
	Namespace: namespace_b3c23ec9
	Checksum: 0x37F0A551
	Offset: 0x7F80
	Size: 0x2B
	Parameters: 1
	Flags: None
*/
function function_dad4e4f3(a_ents)
{
	level LUI::screen_fade_in(0, "black");
}

/*
	Name: function_1f3b8e3c
	Namespace: namespace_b3c23ec9
	Checksum: 0x14ADA020
	Offset: 0x7FB8
	Size: 0x1A3
	Parameters: 1
	Flags: None
*/
function function_1f3b8e3c(a_ents)
{
	if(!isdefined(a_ents))
	{
		a_ents = undefined;
	}
	var_f852acf0 = a_ents["summoning_key"];
	s_org = struct::get("tag_align_end_cinematic");
	e_org = spawn("script_model", s_org.origin);
	if(isdefined(a_ents))
	{
		level waittill("hash_f2d5d1f");
	}
	level LUI::screen_fade_out(0, "white");
	level waittill("hash_71fdf829");
	e_org PlaySoundWithNotify("vox_plr_0_outro_igc_28");
	var_f852acf0 Hide();
	level waittill("hash_4bfb7dc0");
	e_org PlaySoundWithNotify("vox_plr_2_outro_igc_29");
	level waittill("portal_effect");
	Array::thread_all(level.players, &function_449f0778);
	level LUI::screen_fade_in(0.5, "white");
	e_org delete();
}

/*
	Name: function_da7a6f36
	Namespace: namespace_b3c23ec9
	Checksum: 0x2BD30701
	Offset: 0x8168
	Size: 0x63
	Parameters: 1
	Flags: None
*/
function function_da7a6f36(a_ents)
{
	level thread function_f714fcfa();
	level thread scene::Play("cin_isl_outro_1st_old_takeo_corpse");
	level flag::set("flag_hide_outro_water");
}

/*
	Name: function_f714fcfa
	Namespace: namespace_b3c23ec9
	Checksum: 0x15440B97
	Offset: 0x81D8
	Size: 0x36B
	Parameters: 0
	Flags: None
*/
function function_f714fcfa()
{
	wait(5);
	struct::delete_script_bundle("scene", "cin_isl_outro_3rd_sh010");
	struct::delete_script_bundle("scene", "cin_isl_outro_3rd_sh020");
	struct::delete_script_bundle("scene", "cin_isl_outro_3rd_sh030");
	struct::delete_script_bundle("scene", "cin_isl_outro_3rd_sh040");
	struct::delete_script_bundle("scene", "cin_isl_outro_3rd_sh060");
	struct::delete_script_bundle("scene", "cin_isl_outro_3rd_sh070");
	struct::delete_script_bundle("scene", "cin_isl_outro_3rd_sh080");
	struct::delete_script_bundle("scene", "cin_isl_outro_3rd_sh090");
	struct::delete_script_bundle("scene", "cin_isl_outro_3rd_sh100");
	struct::delete_script_bundle("scene", "cin_isl_outro_3rd_sh120");
	struct::delete_script_bundle("scene", "cin_isl_outro_3rd_sh130");
	struct::delete_script_bundle("scene", "cin_isl_outro_3rd_sh140");
	struct::delete_script_bundle("scene", "cin_isl_outro_3rd_sh150");
	struct::delete_script_bundle("scene", "cin_isl_outro_3rd_sh160");
	struct::delete_script_bundle("scene", "cin_isl_outro_3rd_sh170");
	struct::delete_script_bundle("scene", "cin_isl_outro_3rd_sh175");
	struct::delete_script_bundle("scene", "cin_isl_outro_3rd_sh180");
	struct::delete_script_bundle("scene", "cin_isl_outro_3rd_sh190");
	struct::delete_script_bundle("scene", "cin_isl_outro_3rd_sh190");
	struct::delete_script_bundle("scene", "cin_isl_outro_3rd_sh195");
	struct::delete_script_bundle("scene", "cin_isl_outro_3rd_sh196");
	struct::delete_script_bundle("scene", "cin_isl_outro_3rd_sh200");
	struct::delete_script_bundle("scene", "cin_isl_outro_3rd_sh210");
	struct::delete_script_bundle("scene", "cin_isl_outro_3rd_sh220");
	struct::delete_script_bundle("scene", "cin_isl_outro_3rd_sh230");
	struct::delete_script_bundle("scene", "cin_isl_outro_3rd_sh240");
	struct::delete_script_bundle("scene", "cin_isl_outro_3rd_sh250");
}

/*
	Name: function_dcf88974
	Namespace: namespace_b3c23ec9
	Checksum: 0xBE992078
	Offset: 0x8550
	Size: 0x219
	Parameters: 0
	Flags: None
*/
function function_dcf88974()
{
	foreach(player in level.players)
	{
		n_player_index = player.characterindex;
		s_org = struct::get("ending_igc_exit_" + n_player_index);
		player SetOrigin(s_org.origin);
		player SetPlayerAngles(s_org.angles);
		player FreezeControlsAllowLook(1);
		player AllowSprint(0);
		player AllowJump(0);
		player EnableInvulnerability();
		player setClientUIVisibilityFlag("hud_visible", 0);
		player setClientUIVisibilityFlag("weapon_hud_visible", 0);
		player DisableWeapons();
		player.var_d07c64b6 = 0;
		player notify("hash_dd8e5266");
		player clientfield::set("spore_trail_player_fx", 0);
		player clientfield::set_to_player("spore_camera_fx", 0);
	}
}

/*
	Name: function_449f0778
	Namespace: namespace_b3c23ec9
	Checksum: 0x61A9A606
	Offset: 0x8778
	Size: 0x20F
	Parameters: 0
	Flags: None
*/
function function_449f0778()
{
	self endon("disconnect");
	self clientfield::set_to_player("player_stargate_fx", 1);
	n_player_index = self.characterindex;
	level clientfield::set("portal_state_ending_" + n_player_index, 1);
	s_org = struct::get("ending_igc_exit_" + n_player_index);
	self playsound("zmb_outro_teleport");
	wait(3);
	self clientfield::set_to_player("player_stargate_fx", 0);
	wait(1.5);
	level util::player_unlock_control();
	self enableWeapons();
	self FreezeControlsAllowLook(0);
	self AllowSprint(1);
	self AllowJump(1);
	self DisableInvulnerability();
	self setClientUIVisibilityFlag("hud_visible", 1);
	self setClientUIVisibilityFlag("weapon_hud_visible", 1);
	level clientfield::set("portal_state_ending_" + n_player_index, 0);
	level thread namespace_f333593c::function_b83e53a5();
	level flag::set("spawn_zombies");
	level.disable_nuke_delay_spawning = 0;
}

/*
	Name: function_dcc18c22
	Namespace: namespace_b3c23ec9
	Checksum: 0x5FB9D8AA
	Offset: 0x8990
	Size: 0xB3
	Parameters: 0
	Flags: None
*/
function function_dcc18c22()
{
	var_f96832b6 = GetEnt("main_ee_outro_water", "targetname");
	var_f96832b6 Hide();
	level flag::wait_till("flag_show_outro_water");
	var_f96832b6 show();
	level flag::wait_till("flag_hide_outro_water");
	var_f96832b6 Hide();
}

/*
	Name: function_12d043ed
	Namespace: namespace_b3c23ec9
	Checksum: 0x4941F329
	Offset: 0x8A50
	Size: 0xEB
	Parameters: 0
	Flags: None
*/
function function_12d043ed()
{
	/#
		level flag::set("Dev Block strings are not supported");
		zm_devgui::function_4acecab5(&function_efbc0e1);
		AddDebugCommand("Dev Block strings are not supported");
		AddDebugCommand("Dev Block strings are not supported");
		AddDebugCommand("Dev Block strings are not supported");
		AddDebugCommand("Dev Block strings are not supported");
		AddDebugCommand("Dev Block strings are not supported");
		AddDebugCommand("Dev Block strings are not supported");
		AddDebugCommand("Dev Block strings are not supported");
	#/
}

/*
	Name: function_efbc0e1
	Namespace: namespace_b3c23ec9
	Checksum: 0xE3BD4288
	Offset: 0x8B48
	Size: 0x2FD
	Parameters: 1
	Flags: None
*/
function function_efbc0e1(cmd)
{
	/#
		switch(cmd)
		{
			case "Dev Block strings are not supported":
			{
				level flag::set("Dev Block strings are not supported");
				return 1;
			}
			case "Dev Block strings are not supported":
			{
				level thread function_85b23415();
				level flag::set("Dev Block strings are not supported");
				level flag::set("Dev Block strings are not supported");
				level flag::set("Dev Block strings are not supported");
				level flag::set("Dev Block strings are not supported");
				return 1;
			}
			case "Dev Block strings are not supported":
			{
				foreach(player in level.players)
				{
					w_current = player GetCurrentWeapon();
					if(w_current.isRiotShield === 1)
					{
						player thread function_8f34e78f();
					}
				}
				return 1;
			}
			case "Dev Block strings are not supported":
			{
				function_e2cd4ac4();
				return 1;
			}
			case "Dev Block strings are not supported":
			{
				level flag::set("Dev Block strings are not supported");
				level flag::set("Dev Block strings are not supported");
				level flag::set("Dev Block strings are not supported");
				return 1;
			}
			case "Dev Block strings are not supported":
			{
				clientfield::set("Dev Block strings are not supported", 1);
				level scene::init("Dev Block strings are not supported");
				while(!level scene::is_ready("Dev Block strings are not supported"))
				{
					wait(0.05);
				}
				wait(5);
				level flag::set("Dev Block strings are not supported");
				return 1;
			}
			case "Dev Block strings are not supported":
			{
				level thread function_1f3b8e3c();
				return 1;
			}
		}
		return 0;
	#/
}

