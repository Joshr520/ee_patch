#using scripts\codescripts\struct;
#using scripts\shared\ai\zombie_utility;
#using scripts\shared\ai_shared;
#using scripts\shared\array_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\exploder_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\gameobjects_shared;
#using scripts\shared\math_shared;
#using scripts\shared\spawner_shared;
#using scripts\shared\util_shared;
#using scripts\zm\_zm_attackables;
#using scripts\zm\_zm_audio;
#using scripts\zm\_zm_laststand;
#using scripts\zm\_zm_magicbox;
#using scripts\zm\_zm_pack_a_punch;
#using scripts\zm\_zm_perk_random;
#using scripts\zm\_zm_perks;
#using scripts\zm\_zm_powerups;
#using scripts\zm\_zm_score;
#using scripts\zm\_zm_spawner;
#using scripts\zm\_zm_stats;
#using scripts\zm\_zm_unitrigger;
#using scripts\zm\_zm_utility;
#using scripts\zm\_zm_zonemgr;
#using scripts\zm\craftables\_zm_craftables;
#using scripts\zm\zm_challenges_tomb;
//#using scripts\zm\zm_tomb_amb;
#using scripts\zm\zm_tomb_capture_zones_ffotd;
#using scripts\zm\zm_tomb_magicbox;
#using scripts\zm\zm_tomb_utility;
//#using scripts\zm\zm_tomb_vo;

#insert scripts\shared\shared.gsh;

#using_animtree( "generic" );

#namespace zm_tomb_capture_zones;

/*
	Name: init_capture_zones
	Namespace: zm_tomb_capture_zones
	Checksum: 0x2D63CBD3
	Offset: 0x1328
	Size: 0x31B
	Parameters: 0
	Flags: None
*/
function init_capture_zones()
{
	zm_tomb_capture_zones_ffotd::capture_zone_init_start();
	level.initial_quick_revive_power_off = 1;
	precache_everything();
	level flag::init("zone_capture_in_progress");
	level flag::init("recapture_event_in_progress");
	level flag::init("capture_zones_init_done");
	level flag::init("recapture_zombies_cleared");
	level flag::init("generator_under_attack");
	level flag::init("all_zones_captured");
	level flag::init("generator_lost_to_recapture_zombies");
	level flag::init("power_on1");
	level flag::init("power_on2");
	level flag::init("power_on3");
	level flag::init("power_on4");
	level flag::init("power_on5");
	level flag::init("power_on6");
	root = %root;
	i = %p7_fxanim_zm_ori_pack_pc1_anim;
	i = %p7_fxanim_zm_ori_pack_pc2_anim;
	i = %p7_fxanim_zm_ori_pack_pc3_anim;
	i = %p7_fxanim_zm_ori_pack_pc4_anim;
	i = %p7_fxanim_zm_ori_pack_pc5_anim;
	i = %p7_fxanim_zm_ori_pack_pc6_anim;
	i = %p7_fxanim_zm_ori_pack_return_pc1_anim;
	i = %p7_fxanim_zm_ori_pack_return_pc2_anim;
	i = %p7_fxanim_zm_ori_pack_return_pc3_anim;
	i = %p7_fxanim_zm_ori_pack_return_pc4_anim;
	i = %p7_fxanim_zm_ori_pack_return_pc5_anim;
	i = %p7_fxanim_zm_ori_pack_return_pc6_anim;
	i = %p7_fxanim_zm_ori_monolith_inductor_pull_anim;
	i = %p7_fxanim_zm_ori_monolith_inductor_pull_idle_anim;
	i = %p7_fxanim_zm_ori_monolith_inductor_release_anim;
	i = %p7_fxanim_zm_ori_monolith_inductor_shake_anim;
	i = %p7_fxanim_zm_ori_monolith_inductor_idle_anim;
	level thread setup_capture_zones();
}

/*
	Name: precache_everything
	Namespace: zm_tomb_capture_zones
	Checksum: 0x99EC1590
	Offset: 0x1650
	Size: 0x3
	Parameters: 0
	Flags: None
*/
function precache_everything()
{
}

/*
	Name: setup_capture_zones
	Namespace: zm_tomb_capture_zones
	Checksum: 0xE07CA93A
	Offset: 0x1660
	Size: 0x88B
	Parameters: 0
	Flags: None
*/
function setup_capture_zones()
{
	spawner_capture_zombie = GetEnt("capture_zombie_spawner", "targetname");
	spawner_capture_zombie spawner::add_spawn_function(&zm_tomb_utility::capture_zombie_spawn_init);
	a_s_generator = struct::get_array("s_generator", "targetname");
	var_2dc6026c = struct::get_array("generator_attackable", "targetname");
	clientfield::register("world", "packapunch_anim", 21000, 3, "int");
	clientfield::register("actor", "zone_capture_zombie", 21000, 1, "int");
	clientfield::register("scriptmover", "zone_capture_emergence_hole", 21000, 1, "int");
	clientfield::register("world", "zc_change_progress_bar_color", 21000, 1, "int");
	clientfield::register("world", "zone_capture_hud_all_generators_captured", 21000, 1, "int");
	clientfield::register("world", "zone_capture_perk_machine_smoke_fx_always_on", 21000, 1, "int");
	clientfield::register("world", "pap_monolith_ring_shake", 21000, 1, "counter");
	clientfield::register("zbarrier", "pap_emissive_fx", 21000, 1, "int");
	clientfield::register("clientuimodel", "zmInventory.capture_generator_wheel_widget", 21000, 1, "int");
	foreach(struct in a_s_generator)
	{
		clientfield::register("world", struct.script_noteworthy, 21000, 7, "float");
		clientfield::register("world", "state_" + struct.script_noteworthy, 21000, 3, "int");
		clientfield::register("world", "zone_capture_hud_generator_" + struct.script_int, 21000, 2, "int");
		clientfield::register("world", "zone_capture_monolith_crystal_" + struct.script_int, 21000, 1, "int");
		clientfield::register("world", "zone_capture_perk_machine_smoke_fx_" + struct.script_int, 21000, 1, "int");
	}
	while(!level flag::exists("start_zombie_round_logic"))
	{
		wait(0.5);
	}
	level flag::wait_till("start_zombie_round_logic");
	objective_add(0, "invisible", (0, 0, 0), istring("zm_dlc5_capture_generator1"));
	objective_add(1, "invisible", (0, 0, 0), istring("zm_dlc5_capture_generator1"));
	objective_add(2, "invisible", (0, 0, 0), istring("zm_dlc5_capture_generator1"));
	objective_add(3, "invisible", (0, 0, 0), istring("zm_dlc5_capture_generator1"));
	level.magic_box_zbarrier_state_func = &set_magic_box_zbarrier_state;
	level.custom_perk_validation = &check_perk_machine_valid;
	level thread track_max_player_zombie_points();
	foreach(s_generator in a_s_generator)
	{
		if(!isdefined(s_generator.var_b454101b))
		{
			foreach(var_b454101b in var_2dc6026c)
			{
				if(var_b454101b.script_noteworthy == s_generator.script_noteworthy)
				{
					s_generator.var_b454101b = var_b454101b;
					break;
				}
			}
		}
		s_generator thread init_capture_zone();
	}
	register_elements_powered_by_zone_capture_generators();
	setup_perk_machines_not_controlled_by_zone_capture();
	pack_a_punch_init();
	level thread recapture_round_tracker();
	level.zone_capture.recapture_zombies = [];
	level.zone_capture.last_zone_captured = undefined;
	level.zone_capture.spawn_func_capture_zombie = &init_capture_zombie;
	level.zone_capture.spawn_func_recapture_zombie = &init_recapture_zombie;
	/#
		level thread watch_for_open_sesame();
		level thread debug_watch_for_zone_capture();
		level thread debug_watch_for_zone_recapture();
	#/
	zm_spawner::register_zombie_death_event_callback(&recapture_zombie_death_func);
	level.custom_derive_damage_refs = &zone_capture_gib_think;
	setup_inaccessible_zombie_attack_points();
	level thread quick_revive_game_type_watcher();
	level thread quick_revive_solo_leave_watcher();
	level thread all_zones_captured_vo();
	level flag::set("capture_zones_init_done");
	level clientfield::set("zone_capture_perk_machine_smoke_fx_always_on", 1);
	zm_tomb_capture_zones_ffotd::capture_zone_init_end();
}

/*
	Name: all_zones_captured_vo
	Namespace: zm_tomb_capture_zones
	Checksum: 0x7D0D6145
	Offset: 0x1EF8
	Size: 0x1A3
	Parameters: 0
	Flags: None
*/
function all_zones_captured_vo()
{
	level flag::wait_till("all_zones_captured");
	level flag::wait_till_clear("story_vo_playing");
	//zm_tomb_vo::set_players_dontspeak(1);
	level flag::set("story_vo_playing");
	e_speaker = get_closest_player_to_richtofen();
	if(isdefined(e_speaker))
	{
		//e_speaker zm_tomb_vo::set_player_dontspeak(0);
		e_speaker zm_audio::create_and_play_dialog("zone_capture", "all_generators_captured");
		e_speaker function_a98fbefd();
	}
	e_richtofen = get_player_named("Richtofen");
	if(isdefined(e_richtofen))
	{
		//e_richtofen zm_tomb_vo::set_player_dontspeak(0);
		e_richtofen zm_audio::create_and_play_dialog("zone_capture", "all_generators_captured");
	}
	//zm_tomb_vo::set_players_dontspeak(0);
	level flag::clear("story_vo_playing");
}

/*
	Name: function_a98fbefd
	Namespace: zm_tomb_capture_zones
	Checksum: 0x26EA7FC6
	Offset: 0x20A8
	Size: 0x65
	Parameters: 0
	Flags: None
*/
function function_a98fbefd()
{
	self endon("disconnect");
	self thread function_7b7c0a4e();
	self thread function_859f7d9c();
	self waittill("hash_a227b4c7", str_msg);
	self notify("hash_40238b64");
	return str_msg;
}

/*
	Name: function_859f7d9c
	Namespace: zm_tomb_capture_zones
	Checksum: 0x2F6FCC24
	Offset: 0x2118
	Size: 0x49
	Parameters: 0
	Flags: None
*/
function function_859f7d9c()
{
	self endon("hash_40238b64");
	while(isdefined(self.isSpeaking) && self.isSpeaking)
	{
		wait(0.05);
	}
	self notify("hash_a227b4c7", "sound_played");
}

/*
	Name: function_7b7c0a4e
	Namespace: zm_tomb_capture_zones
	Checksum: 0xDA4C8006
	Offset: 0x2170
	Size: 0x45
	Parameters: 1
	Flags: None
*/
function function_7b7c0a4e(n_timeout)
{
	if(!isdefined(n_timeout))
	{
		n_timeout = 5;
	}
	self endon("hash_40238b64");
	wait(n_timeout);
	self notify("hash_a227b4c7", "timeout");
}

/*
	Name: get_closest_player_to_richtofen
	Namespace: zm_tomb_capture_zones
	Checksum: 0xA5027A69
	Offset: 0x21C0
	Size: 0xE3
	Parameters: 0
	Flags: None
*/
function get_closest_player_to_richtofen()
{
	a_players = GetPlayers();
	e_speaker = undefined;
	e_richtofen = get_player_named("Richtofen");
	if(isdefined(e_richtofen))
	{
		if(a_players.size > 1)
		{
			ArrayRemoveValue(a_players, e_richtofen, 0);
			e_speaker = ArraySort(a_players, e_richtofen.origin, 1)[0];
		}
		else
		{
			e_speaker = undefined;
		}
	}
	else
	{
		e_speaker = get_random_speaker();
	}
	return e_speaker;
}

/*
	Name: get_player_named
	Namespace: zm_tomb_capture_zones
	Checksum: 0x307794CD
	Offset: 0x22B0
	Size: 0xCB
	Parameters: 1
	Flags: None
*/
function get_player_named(str_character_name)
{
	e_character = undefined;
	foreach(player in GetPlayers())
	{
		if(isdefined(player.character_name) && player.character_name == str_character_name)
		{
			e_character = player;
		}
	}
	return e_character;
}

/*
	Name: quick_revive_game_type_watcher
	Namespace: zm_tomb_capture_zones
	Checksum: 0x5EB8146
	Offset: 0x2388
	Size: 0x107
	Parameters: 0
	Flags: None
*/
function quick_revive_game_type_watcher()
{
	while(1)
	{
		level waittill("revive_hide");
		wait(1);
		t_revive_machine = level.zone_capture.zones["generator_start_bunker"].perk_machines["revive"];
		if(level.zone_capture.zones["generator_start_bunker"] flag::get("player_controlled"))
		{
			level notify("revive_on");
			t_revive_machine.is_locked = 0;
			t_revive_machine zm_perks::reset_vending_hint_string();
		}
		else
		{
			level notify("revive_off");
			t_revive_machine.is_locked = 1;
			t_revive_machine setHintString(&"ZM_TOMB_ZC");
		}
	}
}

/*
	Name: quick_revive_solo_leave_watcher
	Namespace: zm_tomb_capture_zones
	Checksum: 0xB8F9AC8D
	Offset: 0x2498
	Size: 0x63
	Parameters: 0
	Flags: None
*/
function quick_revive_solo_leave_watcher()
{
	if(level flag::exists("solo_revive"))
	{
		level flag::wait_till("solo_revive");
		level clientfield::set("zone_capture_perk_machine_smoke_fx_1", 0);
	}
}

/*
	Name: revive_perk_fx_think
	Namespace: zm_tomb_capture_zones
	Checksum: 0xEE0974A7
	Offset: 0x2508
	Size: 0x43
	Parameters: 0
	Flags: None
*/
function revive_perk_fx_think()
{
	return !level flag::exists("solo_revive") || !level flag::get("solo_revive");
}

/*
	Name: setup_inaccessible_zombie_attack_points
	Namespace: zm_tomb_capture_zones
	Checksum: 0x7BBE56AC
	Offset: 0x2558
	Size: 0xA3
	Parameters: 0
	Flags: None
*/
function setup_inaccessible_zombie_attack_points()
{
	set_attack_point_as_inaccessible("generator_start_bunker", 5);
	set_attack_point_as_inaccessible("generator_start_bunker", 11);
	set_attack_point_as_inaccessible("generator_tank_trench", 4);
	set_attack_point_as_inaccessible("generator_tank_trench", 5);
	set_attack_point_as_inaccessible("generator_tank_trench", 6);
}

/*
	Name: set_attack_point_as_inaccessible
	Namespace: zm_tomb_capture_zones
	Checksum: 0x9912E281
	Offset: 0x2608
	Size: 0x10F
	Parameters: 2
	Flags: None
*/
function set_attack_point_as_inaccessible(str_zone, n_index)
{
	/#
		Assert(isdefined(level.zone_capture.zones[str_zone]), "Dev Block strings are not supported" + str_zone + "Dev Block strings are not supported");
	#/
	level.zone_capture.zones[str_zone] flag::wait_till("zone_initialized");
	/#
		Assert(isdefined(level.zone_capture.zones[str_zone].zombie_attack_points[n_index]), "Dev Block strings are not supported" + n_index + "Dev Block strings are not supported" + str_zone);
	#/
	level.zone_capture.zones[str_zone].zombie_attack_points[n_index].inaccessible = 1;
}

/*
	Name: setup_perk_machines_not_controlled_by_zone_capture
	Namespace: zm_tomb_capture_zones
	Checksum: 0x9F5A83CB
	Offset: 0x2720
	Size: 0x2B
	Parameters: 0
	Flags: None
*/
function setup_perk_machines_not_controlled_by_zone_capture()
{
	level.zone_capture.perk_machines_always_on = Array("specialty_additionalprimaryweapon");
}

/*
	Name: track_max_player_zombie_points
	Namespace: zm_tomb_capture_zones
	Checksum: 0xF84F451B
	Offset: 0x2758
	Size: 0xB7
	Parameters: 0
	Flags: None
*/
function track_max_player_zombie_points()
{
	while(1)
	{
		a_players = GetPlayers();
		foreach(player in a_players)
		{
			player.n_capture_zombie_points = 0;
		}
		level waittill("between_round_over");
	}
}

/*
	Name: pack_a_punch_dummy_init
	Namespace: zm_tomb_capture_zones
	Checksum: 0x99EC1590
	Offset: 0x2818
	Size: 0x3
	Parameters: 0
	Flags: None
*/
function pack_a_punch_dummy_init()
{
}

/*
	Name: pack_a_punch_init
	Namespace: zm_tomb_capture_zones
	Checksum: 0xA304BA2D
	Offset: 0x2828
	Size: 0x33
	Parameters: 0
	Flags: None
*/
function pack_a_punch_init()
{
	level function_a2bcb201(0);
	level thread pack_a_punch_think();
}

/*
	Name: function_a2bcb201
	Namespace: zm_tomb_capture_zones
	Checksum: 0xAE9DAAEA
	Offset: 0x2868
	Size: 0x1D9
	Parameters: 1
	Flags: None
*/
function function_a2bcb201(b_show)
{
	var_1f4b1fcf = self.pack_a_punch.triggers;
	if(b_show)
	{
		wait(2.5);
		foreach(t_trigger in var_1f4b1fcf)
		{
			t_trigger.pap_machine SetVisibleToAll();
			t_trigger.pap_machine _zm_pack_a_punch::set_state_power_on();
			t_trigger.pap_machine clientfield::set("pap_emissive_fx", 1);
		}
		break;
	}
	foreach(t_trigger in var_1f4b1fcf)
	{
		t_trigger.pap_machine SetInvisibleToAll();
		t_trigger.pap_machine _zm_pack_a_punch::set_state_hidden();
		t_trigger.pap_machine clientfield::set("pap_emissive_fx", 0);
	}
}

/*
	Name: pack_a_punch_think
	Namespace: zm_tomb_capture_zones
	Checksum: 0x9F387C91
	Offset: 0x2A50
	Size: 0xDF
	Parameters: 0
	Flags: None
*/
function pack_a_punch_think()
{
	while(1)
	{
		level flag::wait_till("all_zones_captured");
		level notify("Pack_A_Punch_on");
		pack_a_punch_enable();
		level thread function_a2bcb201(1);
		exploder::exploder("lgtexp_exc_poweron");
		level flag::wait_till_clear("all_zones_captured");
		pack_a_punch_disable();
		level thread function_a2bcb201(0);
		exploder::kill_exploder("lgtexp_exc_poweron");
	}
}

/*
	Name: pack_a_punch_enable
	Namespace: zm_tomb_capture_zones
	Checksum: 0x42C94DF3
	Offset: 0x2B38
	Size: 0x71
	Parameters: 0
	Flags: None
*/
function pack_a_punch_enable()
{
	level flag::set("power_on");
	level clientfield::set("zone_capture_hud_all_generators_captured", 1);
	if(!level flag::get("generator_lost_to_recapture_zombies"))
	{
		level notify("all_zones_captured_none_lost");
	}
}

/*
	Name: pack_a_punch_disable
	Namespace: zm_tomb_capture_zones
	Checksum: 0x336A3603
	Offset: 0x2BB8
	Size: 0x63
	Parameters: 0
	Flags: None
*/
function pack_a_punch_disable()
{
	level flag::wait_till_clear("pack_machine_in_use");
	level clientfield::set("zone_capture_hud_all_generators_captured", 0);
	level flag::clear("power_on");
}

/*
	Name: register_elements_powered_by_zone_capture_generators
	Namespace: zm_tomb_capture_zones
	Checksum: 0xEED215C
	Offset: 0x2C28
	Size: 0x233
	Parameters: 0
	Flags: None
*/
function register_elements_powered_by_zone_capture_generators()
{
	register_random_perk_machine_for_zone("generator_start_bunker", "starting_bunker");
	register_perk_machine_for_zone("generator_start_bunker", "revive", "specialty_quickrevive", &revive_perk_fx_think);
	register_mystery_box_for_zone("generator_start_bunker", "bunker_start_chest");
	register_random_perk_machine_for_zone("generator_tank_trench", "trenches_right");
	register_mystery_box_for_zone("generator_tank_trench", "bunker_tank_chest");
	register_random_perk_machine_for_zone("generator_mid_trench", "trenches_left");
	register_perk_machine_for_zone("generator_mid_trench", "sleight", "specialty_fastreload");
	register_mystery_box_for_zone("generator_mid_trench", "bunker_cp_chest");
	register_random_perk_machine_for_zone("generator_nml_right", "nml");
	register_perk_machine_for_zone("generator_nml_right", "juggernog", "specialty_armorvest");
	register_mystery_box_for_zone("generator_nml_right", "nml_open_chest");
	register_random_perk_machine_for_zone("generator_nml_left", "farmhouse");
	register_perk_machine_for_zone("generator_nml_left", "marathon", "specialty_staminup");
	register_mystery_box_for_zone("generator_nml_left", "nml_farm_chest");
	register_random_perk_machine_for_zone("generator_church", "church");
	register_mystery_box_for_zone("generator_church", "village_church_chest");
}

/*
	Name: register_perk_machine_for_zone
	Namespace: zm_tomb_capture_zones
	Checksum: 0x5739B881
	Offset: 0x2E68
	Size: 0x15B
	Parameters: 4
	Flags: None
*/
function register_perk_machine_for_zone(str_zone_name, str_perk_name, str_machine_targetname, func_perk_fx_think)
{
	/#
		Assert(isdefined(level.zone_capture.zones[str_zone_name]), "Dev Block strings are not supported" + str_zone_name + "Dev Block strings are not supported");
	#/
	if(!isdefined(level.zone_capture.zones[str_zone_name].perk_machines))
	{
		level.zone_capture.zones[str_zone_name].perk_machines = [];
	}
	if(!isdefined(level.zone_capture.zones[str_zone_name].perk_machines[str_perk_name]))
	{
		e_perk_machine_trigger = get_perk_machine_trigger_from_vending_entity(str_machine_targetname);
		e_perk_machine_trigger.str_zone_name = str_zone_name;
		level.zone_capture.zones[str_zone_name].perk_machines[str_perk_name] = e_perk_machine_trigger;
	}
	level.zone_capture.zones[str_zone_name].perk_fx_func = func_perk_fx_think;
}

/*
	Name: register_random_perk_machine_for_zone
	Namespace: zm_tomb_capture_zones
	Checksum: 0x9E5DD352
	Offset: 0x2FD0
	Size: 0x277
	Parameters: 2
	Flags: None
*/
function register_random_perk_machine_for_zone(str_zone_name, str_identifier)
{
	/#
		Assert(isdefined(level.zone_capture.zones[str_zone_name]), "Dev Block strings are not supported" + str_zone_name + "Dev Block strings are not supported");
	#/
	if(!isdefined(level.zone_capture.zones[str_zone_name].perk_machines_random))
	{
		level.zone_capture.zones[str_zone_name].perk_machines_random = [];
	}
	a_random_perk_machines = GetEntArray("perk_random_machine", "targetname");
	foreach(random_perk_machine in a_random_perk_machines)
	{
		if(isdefined(random_perk_machine.script_string) && random_perk_machine.script_string == str_identifier)
		{
			if(!isdefined(level.zone_capture.zones[str_zone_name].perk_machines_random))
			{
				level.zone_capture.zones[str_zone_name].perk_machines_random = [];
			}
			else if(!IsArray(level.zone_capture.zones[str_zone_name].perk_machines_random))
			{
				level.zone_capture.zones[str_zone_name].perk_machines_random = Array(level.zone_capture.zones[str_zone_name].perk_machines_random);
			}
			level.zone_capture.zones[str_zone_name].perk_machines_random[level.zone_capture.zones[str_zone_name].perk_machines_random.size] = random_perk_machine;
		}
	}
}

/*
	Name: register_mystery_box_for_zone
	Namespace: zm_tomb_capture_zones
	Checksum: 0xB8FF6A95
	Offset: 0x3250
	Size: 0x241
	Parameters: 2
	Flags: None
*/
function register_mystery_box_for_zone(str_zone_name, str_identifier)
{
	/#
		Assert(isdefined(level.zone_capture.zones[str_zone_name]), "Dev Block strings are not supported" + str_zone_name + "Dev Block strings are not supported");
	#/
	if(!isdefined(level.zone_capture.zones[str_zone_name].mystery_boxes))
	{
		level.zone_capture.zones[str_zone_name].mystery_boxes = [];
	}
	s_mystery_box = get_mystery_box_from_script_noteworthy(str_identifier);
	s_mystery_box.unitrigger_stub.prompt_and_visibility_func = &magic_box_trigger_update_prompt;
	s_mystery_box.unitrigger_stub.zone = str_zone_name;
	s_mystery_box.zone_capture_area = str_zone_name;
	s_mystery_box.zbarrier.zone_capture_area = str_zone_name;
	if(!isdefined(level.zone_capture.zones[str_zone_name].mystery_boxes))
	{
		level.zone_capture.zones[str_zone_name].mystery_boxes = [];
	}
	else if(!IsArray(level.zone_capture.zones[str_zone_name].mystery_boxes))
	{
		level.zone_capture.zones[str_zone_name].mystery_boxes = Array(level.zone_capture.zones[str_zone_name].mystery_boxes);
	}
	level.zone_capture.zones[str_zone_name].mystery_boxes[level.zone_capture.zones[str_zone_name].mystery_boxes.size] = s_mystery_box;
}

/*
	Name: get_mystery_box_from_script_noteworthy
	Namespace: zm_tomb_capture_zones
	Checksum: 0x4B570044
	Offset: 0x34A0
	Size: 0xEF
	Parameters: 1
	Flags: None
*/
function get_mystery_box_from_script_noteworthy(str_script_noteworthy)
{
	s_box = undefined;
	foreach(s_mystery_box in level.chests)
	{
		if(isdefined(s_mystery_box.script_noteworthy) && s_mystery_box.script_noteworthy == str_script_noteworthy)
		{
			s_box = s_mystery_box;
		}
	}
	/#
		Assert(isdefined(s_mystery_box), "Dev Block strings are not supported" + str_script_noteworthy);
	#/
	return s_box;
}

/*
	Name: enable_perk_machines_in_zone
	Namespace: zm_tomb_capture_zones
	Checksum: 0xBDC9B631
	Offset: 0x3598
	Size: 0xFD
	Parameters: 0
	Flags: None
*/
function enable_perk_machines_in_zone()
{
	if(isdefined(self.perk_machines) && IsArray(self.perk_machines))
	{
		a_keys = getArrayKeys(self.perk_machines);
		for(i = 0; i < a_keys.size; i++)
		{
			level notify(a_keys[i] + "_on");
		}
		for(i = 0; i < a_keys.size; i++)
		{
			e_perk_trigger = self.perk_machines[a_keys[i]];
			e_perk_trigger.is_locked = 0;
			e_perk_trigger zm_perks::reset_vending_hint_string();
		}
	}
}

/*
	Name: disable_perk_machines_in_zone
	Namespace: zm_tomb_capture_zones
	Checksum: 0x3E5A289C
	Offset: 0x36A0
	Size: 0x105
	Parameters: 0
	Flags: None
*/
function disable_perk_machines_in_zone()
{
	if(isdefined(self.perk_machines) && IsArray(self.perk_machines))
	{
		a_keys = getArrayKeys(self.perk_machines);
		for(i = 0; i < a_keys.size; i++)
		{
			level notify(a_keys[i] + "_off");
		}
		for(i = 0; i < a_keys.size; i++)
		{
			e_perk_trigger = self.perk_machines[a_keys[i]];
			e_perk_trigger.is_locked = 1;
			e_perk_trigger setHintString(&"ZM_TOMB_ZC");
		}
	}
}

/*
	Name: enable_random_perk_machines_in_zone
	Namespace: zm_tomb_capture_zones
	Checksum: 0x86D66BF4
	Offset: 0x37B0
	Size: 0x111
	Parameters: 0
	Flags: None
*/
function enable_random_perk_machines_in_zone()
{
	if(isdefined(self.perk_machines_random) && IsArray(self.perk_machines_random))
	{
		foreach(random_perk_machine in self.perk_machines_random)
		{
			random_perk_machine.is_locked = 0;
			if(isdefined(random_perk_machine.current_perk_random_machine) && random_perk_machine.current_perk_random_machine)
			{
				random_perk_machine zm_perk_random::set_perk_random_machine_state("idle");
				continue;
			}
			random_perk_machine zm_perk_random::set_perk_random_machine_state("away");
		}
	}
}

/*
	Name: disable_random_perk_machines_in_zone
	Namespace: zm_tomb_capture_zones
	Checksum: 0xF1E16206
	Offset: 0x38D0
	Size: 0x111
	Parameters: 0
	Flags: None
*/
function disable_random_perk_machines_in_zone()
{
	if(isdefined(self.perk_machines_random) && IsArray(self.perk_machines_random))
	{
		foreach(random_perk_machine in self.perk_machines_random)
		{
			random_perk_machine.is_locked = 1;
			if(isdefined(random_perk_machine.current_perk_random_machine) && random_perk_machine.current_perk_random_machine)
			{
				random_perk_machine zm_perk_random::set_perk_random_machine_state("initial");
				continue;
			}
			random_perk_machine zm_perk_random::set_perk_random_machine_state("power_off");
		}
	}
}

/*
	Name: enable_mystery_boxes_in_zone
	Namespace: zm_tomb_capture_zones
	Checksum: 0x416E2277
	Offset: 0x39F0
	Size: 0xD1
	Parameters: 0
	Flags: None
*/
function enable_mystery_boxes_in_zone()
{
	foreach(mystery_box in self.mystery_boxes)
	{
		mystery_box.is_locked = 0;
		mystery_box.zbarrier set_magic_box_zbarrier_state("player_controlled");
		mystery_box.zbarrier clientfield::set("magicbox_runes", 1);
	}
}

/*
	Name: disable_mystery_boxes_in_zone
	Namespace: zm_tomb_capture_zones
	Checksum: 0x76806A19
	Offset: 0x3AD0
	Size: 0xD1
	Parameters: 0
	Flags: None
*/
function disable_mystery_boxes_in_zone()
{
	foreach(mystery_box in self.mystery_boxes)
	{
		mystery_box.is_locked = 1;
		mystery_box.zbarrier set_magic_box_zbarrier_state("zombie_controlled");
		mystery_box.zbarrier clientfield::set("magicbox_runes", 0);
	}
}

/*
	Name: get_perk_machine_trigger_from_vending_entity
	Namespace: zm_tomb_capture_zones
	Checksum: 0xD40E2525
	Offset: 0x3BB0
	Size: 0x67
	Parameters: 1
	Flags: None
*/
function get_perk_machine_trigger_from_vending_entity(str_vending_machine_targetname)
{
	e_trigger = GetEnt(str_vending_machine_targetname, "script_noteworthy");
	/#
		Assert(isdefined(e_trigger), "Dev Block strings are not supported" + str_vending_machine_targetname);
	#/
	return e_trigger;
}

/*
	Name: check_perk_machine_valid
	Namespace: zm_tomb_capture_zones
	Checksum: 0x19694C2B
	Offset: 0x3C20
	Size: 0xEF
	Parameters: 1
	Flags: None
*/
function check_perk_machine_valid(player)
{
	if(isdefined(self.script_noteworthy) && IsInArray(level.zone_capture.perk_machines_always_on, self.script_noteworthy))
	{
		b_machine_valid = 1;
	}
	else
	{
		Assert(isdefined(self.str_zone_name), "Dev Block strings are not supported");
		b_machine_valid = level.zone_capture.zones[self.str_zone_name] flag::get("player_controlled");
	}
	/#
	#/
	if(!b_machine_valid)
	{
		player zm_audio::create_and_play_dialog("lockdown", "power_off");
	}
	return b_machine_valid;
}

/*
	Name: init_capture_zone
	Namespace: zm_tomb_capture_zones
	Checksum: 0x60E0D60A
	Offset: 0x3D18
	Size: 0x2AB
	Parameters: 0
	Flags: None
*/
function init_capture_zone()
{
	/#
		Assert(isdefined(self.script_noteworthy), "Dev Block strings are not supported");
	#/
	if(!isdefined(level.zone_capture))
	{
		level.zone_capture = spawnstruct();
	}
	if(!isdefined(level.zone_capture.zones))
	{
		level.zone_capture.zones = [];
	}
	/#
		Assert(!isdefined(level.zone_capture.zones[self.script_noteworthy]), "Dev Block strings are not supported" + self.script_noteworthy + "Dev Block strings are not supported");
	#/
	self.n_current_progress = 0;
	self.n_last_progress = 0;
	self setup_generator_unitrigger();
	self.str_zone = zm_zonemgr::get_zone_from_position(self.origin, 1);
	self.sndent = spawn("script_origin", self.origin);
	/#
		Assert(isdefined(self.script_int), "Dev Block strings are not supported" + self.script_noteworthy + "Dev Block strings are not supported");
	#/
	self flag::init("attacked_by_recapture_zombies");
	self flag::init("current_recapture_target_zone");
	self flag::init("player_controlled");
	self flag::init("zone_contested");
	self flag::init("zone_initialized");
	level.zone_capture.zones[self.script_noteworthy] = self;
	self set_zombie_controlled_area(1);
	self setup_zombie_attack_points();
	self flag::set("zone_initialized");
	self thread wait_for_capture_trigger();
}

/*
	Name: setup_generator_unitrigger
	Namespace: zm_tomb_capture_zones
	Checksum: 0x146ABA4D
	Offset: 0x3FD0
	Size: 0x173
	Parameters: 0
	Flags: None
*/
function setup_generator_unitrigger()
{
	s_unitrigger_stub = spawnstruct();
	s_unitrigger_stub.origin = self.origin;
	s_unitrigger_stub.angles = self.angles;
	s_unitrigger_stub.radius = 32;
	s_unitrigger_stub.script_length = 128;
	s_unitrigger_stub.script_width = 128;
	s_unitrigger_stub.script_height = 128;
	s_unitrigger_stub.cursor_hint = "HINT_NOICON";
	s_unitrigger_stub.hint_string = &"ZM_TOMB_CAP";
	s_unitrigger_stub.hint_parm1 = [[&get_generator_capture_start_cost]]();
	s_unitrigger_stub.script_unitrigger_type = "unitrigger_box_use";
	s_unitrigger_stub.require_look_at = 1;
	s_unitrigger_stub.prompt_and_visibility_func = &generator_trigger_prompt_and_visibility;
	s_unitrigger_stub.generator_struct = self;
	zm_unitrigger::unitrigger_force_per_player_triggers(s_unitrigger_stub, 1);
	zm_unitrigger::register_static_unitrigger(s_unitrigger_stub, &generator_unitrigger_think);
}

/*
	Name: generator_trigger_prompt_and_visibility
	Namespace: zm_tomb_capture_zones
	Checksum: 0xE18CE658
	Offset: 0x4150
	Size: 0x117
	Parameters: 1
	Flags: None
*/
function generator_trigger_prompt_and_visibility(e_player)
{
	b_can_see_hint = 1;
	s_zone = self.stub.generator_struct;
	if(s_zone flag::get("zone_contested") || s_zone flag::get("player_controlled"))
	{
		b_can_see_hint = 0;
	}
	if(level flag::get("zone_capture_in_progress"))
	{
		self setHintString(&"ZM_TOMB_ZCIP");
	}
	else
	{
		self setHintString(&"ZM_TOMB_CAP", get_generator_capture_start_cost());
	}
	self SetInvisibleToPlayer(e_player, !b_can_see_hint);
	return b_can_see_hint;
}

/*
	Name: generator_unitrigger_think
	Namespace: zm_tomb_capture_zones
	Checksum: 0x9507E6E3
	Offset: 0x4270
	Size: 0x1D7
	Parameters: 0
	Flags: None
*/
function generator_unitrigger_think()
{
	self endon("kill_trigger");
	while(1)
	{
		self waittill("trigger", e_player);
		if(!zombie_utility::is_player_valid(e_player) || e_player zm_laststand::is_reviving_any() || e_player != self.parent_player)
		{
			continue;
		}
		if(level flag::get("zone_capture_in_progress"))
		{
			continue;
		}
		if(zombie_utility::is_player_valid(e_player))
		{
			self.stub.generator_struct.generator_cost = get_generator_capture_start_cost();
			if(e_player zm_score::can_player_purchase(self.stub.generator_struct.generator_cost))
			{
				e_player zm_score::minus_to_player_score(self.stub.generator_struct.generator_cost);
				self.purchaser = e_player;
			}
			else
			{
				zm_utility::play_sound_at_pos("no_purchase", self.origin);
				e_player zm_audio::create_and_play_dialog("general", "no_money_capture");
				continue;
			}
		}
		self SetInvisibleToAll();
		self.stub.generator_struct notify("start_generator_capture", e_player);
	}
}

/*
	Name: setup_zombie_attack_points
	Namespace: zm_tomb_capture_zones
	Checksum: 0x3383D158
	Offset: 0x4450
	Size: 0xC3
	Parameters: 0
	Flags: None
*/
function setup_zombie_attack_points()
{
	self.zombie_attack_points = [];
	v_right = AnglesToRight(self.angles);
	self add_attack_points_from_anchor_origin(self.origin, 0, 52);
	self add_attack_points_from_anchor_origin(self.origin + v_right * 170, 4, 32);
	self add_attack_points_from_anchor_origin(self.origin + v_right * -1 * 170, 8, 32);
}

/*
	Name: add_attack_points_from_anchor_origin
	Namespace: zm_tomb_capture_zones
	Checksum: 0x98329D49
	Offset: 0x4520
	Size: 0x155
	Parameters: 3
	Flags: None
*/
function add_attack_points_from_anchor_origin(v_origin, n_start_index, n_scale)
{
	v_forward = AnglesToForward(self.angles);
	v_right = AnglesToRight(self.angles);
	self.zombie_attack_points[n_start_index] = init_attack_point(v_origin + v_forward * n_scale, v_origin);
	self.zombie_attack_points[n_start_index + 1] = init_attack_point(v_origin + v_right * n_scale, v_origin);
	self.zombie_attack_points[n_start_index + 2] = init_attack_point(v_origin + v_forward * -1 * n_scale, v_origin);
	self.zombie_attack_points[n_start_index + 3] = init_attack_point(v_origin + v_right * -1 * n_scale, v_origin);
}

/*
	Name: init_attack_point
	Namespace: zm_tomb_capture_zones
	Checksum: 0xA5BE3570
	Offset: 0x4680
	Size: 0x87
	Parameters: 2
	Flags: None
*/
function init_attack_point(v_origin, v_center_pillar)
{
	s_temp = spawnstruct();
	s_temp.is_claimed = 0;
	s_temp.claimed_by = undefined;
	s_temp.origin = v_origin;
	s_temp.inaccessible = 0;
	s_temp.v_center_pillar = v_center_pillar;
	return s_temp;
}

/*
	Name: wait_for_capture_trigger
	Namespace: zm_tomb_capture_zones
	Checksum: 0xADD64A8C
	Offset: 0x4710
	Size: 0x1FF
	Parameters: 0
	Flags: None
*/
function wait_for_capture_trigger()
{
	while(1)
	{
		self waittill("start_generator_capture", e_player);
		if(!level flag::get("zone_capture_in_progress"))
		{
			level flag::set("zone_capture_in_progress");
			self.var_ea997a3c = e_player;
			e_player util::delay(2.5, undefined, &zm_audio::create_and_play_dialog, "zone_capture", "capture_started");
			self zm_tomb_capture_zones_ffotd::capture_event_start();
			self thread monitor_capture_zombies();
			self thread activate_capture_zone();
			self flag::wait_till("zone_contested");
			capture_event_handle_ai_limit();
			self flag::wait_till_clear("zone_contested");
			self zm_tomb_capture_zones_ffotd::capture_event_end();
			wait(1);
			self.var_ea997a3c = undefined;
		}
		else
		{
			level flag::wait_till("zone_capture_in_progress");
			level flag::wait_till_clear("zone_capture_in_progress");
		}
		capture_event_handle_ai_limit();
		if(self flag::get("player_controlled"))
		{
			self flag::wait_till_clear("player_controlled");
		}
	}
}

/*
	Name: refund_generator_cost_if_player_captured_it
	Namespace: zm_tomb_capture_zones
	Checksum: 0x5E7CDF67
	Offset: 0x4918
	Size: 0xCB
	Parameters: 1
	Flags: None
*/
function refund_generator_cost_if_player_captured_it(e_player)
{
	if(IsInArray(self get_players_in_capture_zone(), e_player))
	{
		n_refund_amount = self.generator_cost;
		b_double_points_active = level.zombie_vars["allies"]["zombie_point_scalar"] == 2;
		n_multiplier = 1;
		if(b_double_points_active)
		{
			n_multiplier = 0.5;
		}
		e_player zm_score::add_to_player_score(Int(n_refund_amount * n_multiplier));
	}
}

/*
	Name: get_generator_capture_start_cost
	Namespace: zm_tomb_capture_zones
	Checksum: 0xC88C662B
	Offset: 0x49F0
	Size: 0x1D
	Parameters: 0
	Flags: None
*/
function get_generator_capture_start_cost()
{
	return 200 * GetPlayers().size;
}

/*
	Name: capture_event_handle_ai_limit
	Namespace: zm_tomb_capture_zones
	Checksum: 0x82988A26
	Offset: 0x4A18
	Size: 0xA7
	Parameters: 0
	Flags: None
*/
function capture_event_handle_ai_limit()
{
	n_capture_zombies_needed = calculate_capture_event_zombies_needed();
	level.zombie_ai_limit = 24 - n_capture_zombies_needed;
	while(zombie_utility::get_current_zombie_count() > level.zombie_ai_limit)
	{
		ai_zombie = get_zombie_to_delete();
		if(isdefined(ai_zombie))
		{
			ai_zombie thread delete_zombie_for_capture_event();
		}
		util::wait_network_frame();
	}
}

/*
	Name: get_zombie_to_delete
	Namespace: zm_tomb_capture_zones
	Checksum: 0xC7F0CEAA
	Offset: 0x4AC8
	Size: 0x5B
	Parameters: 0
	Flags: None
*/
function get_zombie_to_delete()
{
	ai_zombie = undefined;
	a_zombies = zombie_utility::get_round_enemy_array();
	if(a_zombies.size > 0)
	{
		ai_zombie = Array::random(a_zombies);
	}
	return ai_zombie;
}

/*
	Name: delete_zombie_for_capture_event
	Namespace: zm_tomb_capture_zones
	Checksum: 0x7DD8B7DD
	Offset: 0x4B30
	Size: 0x83
	Parameters: 0
	Flags: None
*/
function delete_zombie_for_capture_event()
{
	if(isdefined(self))
	{
		playFX(level._effect["tesla_elec_kill"], self.origin);
		self ghost();
	}
	util::wait_network_frame();
	if(isdefined(self))
	{
		self delete();
	}
}

/*
	Name: calculate_capture_event_zombies_needed
	Namespace: zm_tomb_capture_zones
	Checksum: 0x10FE6AA3
	Offset: 0x4BC0
	Size: 0x71
	Parameters: 0
	Flags: None
*/
function calculate_capture_event_zombies_needed()
{
	n_capture_zombies_needed = get_capture_zombies_needed();
	n_recapture_zombies_needed = 0;
	if(level flag::get("recapture_event_in_progress"))
	{
		n_recapture_zombies_needed = get_recapture_zombies_needed();
	}
	return n_capture_zombies_needed + n_recapture_zombies_needed;
}

/*
	Name: get_capture_zombies_needed
	Namespace: zm_tomb_capture_zones
	Checksum: 0x6E59842D
	Offset: 0x4C40
	Size: 0x167
	Parameters: 1
	Flags: None
*/
function get_capture_zombies_needed(b_per_zone)
{
	if(!isdefined(b_per_zone))
	{
		b_per_zone = 0;
	}
	a_contested_zones = get_contested_zones();
	switch(a_contested_zones.size)
	{
		case 0:
		{
			n_capture_zombies_needed = 0;
			n_capture_zombies_needed_per_zone = 0;
			break;
		}
		case 1:
		{
			n_capture_zombies_needed = 4;
			n_capture_zombies_needed_per_zone = 4;
			break;
		}
		case 2:
		{
			n_capture_zombies_needed = 6;
			n_capture_zombies_needed_per_zone = 3;
			break;
		}
		case 3:
		{
			n_capture_zombies_needed = 6;
			n_capture_zombies_needed_per_zone = 2;
			break;
		}
		case 4:
		{
			n_capture_zombies_needed = 8;
			n_capture_zombies_needed_per_zone = 2;
			break;
		}
		default:
		{
			/#
				IPrintLnBold("Dev Block strings are not supported" + a_contested_zones.size);
			#/
			n_capture_zombies_needed = 2 * a_contested_zones.size;
			n_capture_zombies_needed_per_zone = 2;
			break;
		}
	}
	if(b_per_zone)
	{
		b_capture_zombies_needed = n_capture_zombies_needed_per_zone;
	}
	return n_capture_zombies_needed;
}

/*
	Name: set_capture_zombies_needed_per_zone
	Namespace: zm_tomb_capture_zones
	Checksum: 0x9755CEA7
	Offset: 0x4DB0
	Size: 0xE5
	Parameters: 0
	Flags: None
*/
function set_capture_zombies_needed_per_zone()
{
	a_contested_zones = get_contested_zones();
	n_zombies_needed_per_zone = get_capture_zombies_needed(1);
	foreach(zone in a_contested_zones)
	{
		if(zone flag::get("current_recapture_target_zone"))
		{
			continue;
		}
		zone.capture_zombie_limit = n_zombies_needed_per_zone;
	}
	return n_zombies_needed_per_zone;
}

/*
	Name: get_recapture_zombies_needed
	Namespace: zm_tomb_capture_zones
	Checksum: 0xE0BA9B46
	Offset: 0x4EA0
	Size: 0x39
	Parameters: 0
	Flags: None
*/
function get_recapture_zombies_needed()
{
	if(level.players.size == 1)
	{
		n_recapture_zombies_needed = 4;
	}
	else
	{
		n_recapture_zombies_needed = 6;
	}
	return n_recapture_zombies_needed;
}

/*
	Name: activate_capture_zone
	Namespace: zm_tomb_capture_zones
	Checksum: 0x818FA93A
	Offset: 0x4EE8
	Size: 0x183
	Parameters: 1
	Flags: None
*/
function activate_capture_zone(b_show_emergence_holes)
{
	if(!isdefined(b_show_emergence_holes))
	{
		b_show_emergence_holes = 1;
	}
	if(!level flag::get("recapture_event_in_progress"))
	{
		self thread generator_initiated_vo();
	}
	self.a_emergence_hole_structs = struct::get_array(self.target, "targetname");
	self show_emergence_holes(b_show_emergence_holes);
	if(level flag::get("recapture_event_in_progress") && self flag::get("current_recapture_target_zone"))
	{
		self thread function_38a0fa7f();
		self thread function_de6d807b();
		level flag::wait_till_any(Array("generator_under_attack", "recapture_zombies_cleared"));
		if(level flag::get("recapture_zombies_cleared"))
		{
			return;
		}
	}
	self capture_progress_think();
	self destroy_emergence_holes();
}

/*
	Name: function_38a0fa7f
	Namespace: zm_tomb_capture_zones
	Checksum: 0x2FE65C29
	Offset: 0x5078
	Size: 0x5B
	Parameters: 0
	Flags: None
*/
function function_38a0fa7f()
{
	level endon("recapture_zombies_cleared");
	self.var_b454101b waittill("attackable_damaged");
	level flag::set("generator_under_attack");
	self flag::set("attacked_by_recapture_zombies");
}

/*
	Name: function_de6d807b
	Namespace: zm_tomb_capture_zones
	Checksum: 0xA60915DE
	Offset: 0x50E0
	Size: 0x5B
	Parameters: 0
	Flags: None
*/
function function_de6d807b()
{
	level endon("recapture_zombies_cleared");
	self.var_b454101b waittill("attackable_deactivated");
	level flag::clear("generator_under_attack");
	self flag::clear("attacked_by_recapture_zombies");
}

/*
	Name: show_emergence_holes
	Namespace: zm_tomb_capture_zones
	Checksum: 0x33AFFC1B
	Offset: 0x5148
	Size: 0x133
	Parameters: 1
	Flags: None
*/
function show_emergence_holes(b_show_emergence_holes)
{
	self destroy_emergence_holes();
	if(b_show_emergence_holes)
	{
		self.a_spawner_holes = [];
		self.a_emergence_holes = [];
		foreach(s_spawner_hole in self.a_emergence_hole_structs)
		{
			if(!isdefined(self.a_emergence_holes))
			{
				self.a_emergence_holes = [];
			}
			else if(!IsArray(self.a_emergence_holes))
			{
				self.a_emergence_holes = Array(self.a_emergence_holes);
			}
			self.a_emergence_holes[self.a_emergence_holes.size] = s_spawner_hole emergence_hole_spawn();
		}
	}
}

/*
	Name: destroy_emergence_holes
	Namespace: zm_tomb_capture_zones
	Checksum: 0x6211924E
	Offset: 0x5288
	Size: 0x111
	Parameters: 0
	Flags: None
*/
function destroy_emergence_holes()
{
	if(isdefined(self.a_emergence_holes) && self.a_emergence_holes.size > 0)
	{
		foreach(m_emergence_hole in self.a_emergence_holes)
		{
			if(isdefined(m_emergence_hole))
			{
				m_emergence_hole clientfield::set("zone_capture_emergence_hole", 0);
				m_emergence_hole ghost();
				m_emergence_hole thread delete_self_after_time(RandomFloatRange(0.5, 2));
			}
			util::wait_network_frame();
		}
	}
}

/*
	Name: delete_self_after_time
	Namespace: zm_tomb_capture_zones
	Checksum: 0x73B3DE01
	Offset: 0x53A8
	Size: 0x2B
	Parameters: 1
	Flags: None
*/
function delete_self_after_time(n_time)
{
	wait(n_time);
	if(isdefined(self))
	{
		self delete();
	}
}

/*
	Name: monitor_capture_zombies
	Namespace: zm_tomb_capture_zones
	Checksum: 0xA035D37B
	Offset: 0x53E0
	Size: 0x1A7
	Parameters: 0
	Flags: None
*/
function monitor_capture_zombies()
{
	self flag::wait_till("zone_contested");
	e_spawner_capture_zombie = GetEnt("capture_zombie_spawner", "targetname");
	self.capture_zombies = [];
	self.capture_zombie_limit = self set_capture_zombies_needed_per_zone();
	while(self flag::get("zone_contested"))
	{
		self.capture_zombies = Array::remove_dead(self.capture_zombies);
		if(self.capture_zombies.size < self.capture_zombie_limit)
		{
			ai = zombie_utility::spawn_zombie(e_spawner_capture_zombie);
			s_spawn_point = self get_emergence_hole_spawn_point();
			ai thread [[level.zone_capture.spawn_func_capture_zombie]](self, s_spawn_point);
			if(!isdefined(self.capture_zombies))
			{
				self.capture_zombies = [];
			}
			else if(!IsArray(self.capture_zombies))
			{
				self.capture_zombies = Array(self.capture_zombies);
			}
			self.capture_zombies[self.capture_zombies.size] = ai;
		}
		wait(0.5);
	}
}

/*
	Name: monitor_recapture_zombies
	Namespace: zm_tomb_capture_zones
	Checksum: 0x47ADE90A
	Offset: 0x5590
	Size: 0x213
	Parameters: 0
	Flags: None
*/
function monitor_recapture_zombies()
{
	e_spawner_capture_zombie = GetEnt("capture_zombie_spawner", "targetname");
	self.capture_zombie_limit = get_recapture_zombies_needed();
	n_capture_zombie_spawns = 0;
	self thread play_vo_when_generator_is_attacked();
	while(level flag::get("recapture_event_in_progress") && n_capture_zombie_spawns < self.capture_zombie_limit)
	{
		level.zone_capture.recapture_zombies = Array::remove_dead(level.zone_capture.recapture_zombies);
		ai = zombie_utility::spawn_zombie(e_spawner_capture_zombie);
		if(isdefined(ai))
		{
			n_capture_zombie_spawns++;
			s_spawn_point = self get_emergence_hole_spawn_point();
			ai thread [[level.zone_capture.spawn_func_recapture_zombie]](self, s_spawn_point);
			if(!isdefined(level.zone_capture.recapture_zombies))
			{
				level.zone_capture.recapture_zombies = [];
			}
			else if(!IsArray(level.zone_capture.recapture_zombies))
			{
				level.zone_capture.recapture_zombies = Array(level.zone_capture.recapture_zombies);
			}
			level.zone_capture.recapture_zombies[level.zone_capture.recapture_zombies.size] = ai;
		}
		wait(0.5);
	}
	level monitor_recapture_zombie_count();
}

/*
	Name: play_vo_when_generator_is_attacked
	Namespace: zm_tomb_capture_zones
	Checksum: 0xE67B01B4
	Offset: 0x57B0
	Size: 0x4B
	Parameters: 0
	Flags: None
*/
function play_vo_when_generator_is_attacked()
{
	self endon("zone_contested");
	level endon("recapture_event_in_progress");
	self waittill("zombies_attacking_generator");
	broadcast_vo_category_to_team("recapture_generator_attacked", 3.5);
}

/*
	Name: get_emergence_hole_spawn_point
	Namespace: zm_tomb_capture_zones
	Checksum: 0x5F9CD1AC
	Offset: 0x5808
	Size: 0x97
	Parameters: 0
	Flags: None
*/
function get_emergence_hole_spawn_point()
{
	while(1)
	{
		if(isdefined(self.a_emergence_hole_structs) && self.a_emergence_hole_structs.size > 0)
		{
			s_spawn_point = self get_unused_emergence_hole_spawn_point();
			s_spawn_point.spawned_zombie = 1;
			return s_spawn_point;
		}
		else
		{
			self.a_emergence_hole_structs = struct::get_array(self.target, "targetname");
		}
		wait(0.05);
	}
}

/*
	Name: get_unused_emergence_hole_spawn_point
	Namespace: zm_tomb_capture_zones
	Checksum: 0x511C2939
	Offset: 0x58A8
	Size: 0x173
	Parameters: 0
	Flags: None
*/
function get_unused_emergence_hole_spawn_point()
{
	a_valid_spawn_points = [];
	b_all_points_used = 0;
	while(!a_valid_spawn_points.size)
	{
		foreach(s_emergence_hole in self.a_emergence_hole_structs)
		{
			if(!isdefined(s_emergence_hole.spawned_zombie) || b_all_points_used)
			{
				s_emergence_hole.spawned_zombie = 0;
			}
			if(!s_emergence_hole.spawned_zombie)
			{
				if(!isdefined(a_valid_spawn_points))
				{
					a_valid_spawn_points = [];
				}
				else if(!IsArray(a_valid_spawn_points))
				{
					a_valid_spawn_points = Array(a_valid_spawn_points);
				}
				a_valid_spawn_points[a_valid_spawn_points.size] = s_emergence_hole;
			}
		}
		if(!a_valid_spawn_points.size)
		{
			b_all_points_used = 1;
		}
	}
	s_spawn_point = Array::random(a_valid_spawn_points);
	return s_spawn_point;
}

/*
	Name: emergence_hole_spawn
	Namespace: zm_tomb_capture_zones
	Checksum: 0xC6AF090F
	Offset: 0x5A28
	Size: 0x97
	Parameters: 0
	Flags: None
*/
function emergence_hole_spawn()
{
	m_emergence_hole = spawn("script_model", self.origin);
	m_emergence_hole.angles = self.angles;
	m_emergence_hole SetModel("p7_zm_ori_dig_mound_hole");
	util::wait_network_frame();
	m_emergence_hole clientfield::set("zone_capture_emergence_hole", 1);
	return m_emergence_hole;
}

/*
	Name: init_zone_capture_zombie_common
	Namespace: zm_tomb_capture_zones
	Checksum: 0x9E1C015C
	Offset: 0x5AC8
	Size: 0xB3
	Parameters: 1
	Flags: None
*/
function init_zone_capture_zombie_common(s_spawn_point)
{
	self setPhysParams(15, 0, 72);
	self.ignore_enemy_count = 1;
	self.b_ignore_cleanup = 1;
	self zm_tomb_utility::dug_zombie_rise(s_spawn_point);
	self playsound("zmb_vocals_capzomb_spawn");
	self clientfield::set("zone_capture_zombie", 1);
	self init_anim_rate();
}

/*
	Name: init_anim_rate
	Namespace: zm_tomb_capture_zones
	Checksum: 0x7F1A1E0E
	Offset: 0x5B88
	Size: 0x8B
	Parameters: 0
	Flags: None
*/
function init_anim_rate()
{
	self ASMSetAnimationRate(1);
	self clientfield::set("anim_rate", 1);
	n_rate = self clientfield::get("anim_rate");
	self setentityanimrate(n_rate);
}

/*
	Name: zone_capture_gib_think
	Namespace: zm_tomb_capture_zones
	Checksum: 0x4AF1A241
	Offset: 0x5C20
	Size: 0x97
	Parameters: 3
	Flags: None
*/
function zone_capture_gib_think(refs, point, weaponName)
{
	if(isdefined(self.is_recapture_zombie) && self.is_recapture_zombie)
	{
		ArrayRemoveValue(refs, "right_leg", 0);
		ArrayRemoveValue(refs, "left_leg", 0);
		ArrayRemoveValue(refs, "no_legs", 0);
	}
	return refs;
}

/*
	Name: init_capture_zombie
	Namespace: zm_tomb_capture_zones
	Checksum: 0xC92EF01D
	Offset: 0x5CC0
	Size: 0xC3
	Parameters: 2
	Flags: None
*/
function init_capture_zombie(zone_struct, s_spawn_point)
{
	self endon("death");
	self init_zone_capture_zombie_common(s_spawn_point);
	if(isdefined(self.zombie_move_speed) && self.zombie_move_speed == "walk")
	{
		self.zombie_move_speed = "run";
		self zombie_utility::set_zombie_run_cycle("run");
	}
	find_flesh_struct_string = "find_flesh";
	self notify("zombie_custom_think_done", find_flesh_struct_string);
	self thread capture_zombies_only_attack_nearby_players(zone_struct);
}

/*
	Name: init_recapture_zombie
	Namespace: zm_tomb_capture_zones
	Checksum: 0xDF87F9C4
	Offset: 0x5D90
	Size: 0xC7
	Parameters: 2
	Flags: None
*/
function init_recapture_zombie(zone_struct, s_spawn_point)
{
	self endon("death");
	self.is_recapture_zombie = 1;
	self.ignoreMelee = 1;
	self ai::set_behavior_attribute("use_attackable", 1);
	self init_zone_capture_zombie_common(s_spawn_point);
	self.goalRadius = 30;
	self zombie_utility::set_zombie_run_cycle("sprint");
	self.var_dfb19f30 = 1;
	set_recapture_zombie_attack_target(zone_struct);
	self.is_attacking_zone = 1;
}

/*
	Name: capture_zombie_rise_fx
	Namespace: zm_tomb_capture_zones
	Checksum: 0xAC500107
	Offset: 0x5E60
	Size: 0x63
	Parameters: 1
	Flags: None
*/
function capture_zombie_rise_fx(ai_zombie)
{
	playFX(level._effect["zone_capture_zombie_spawn"], self.origin, AnglesToForward(self.angles), anglesToUp(self.angles));
}

/*
	Name: get_unclaimed_attack_point
	Namespace: zm_tomb_capture_zones
	Checksum: 0x1B226273
	Offset: 0x5ED0
	Size: 0x24F
	Parameters: 1
	Flags: None
*/
function get_unclaimed_attack_point(s_zone)
{
	s_zone clean_up_unused_attack_points();
	n_claimed_center = s_zone get_claimed_attack_points_between_indicies(0, 3);
	n_claimed_left = s_zone get_claimed_attack_points_between_indicies(4, 7);
	n_claimed_right = s_zone get_claimed_attack_points_between_indicies(8, 11);
	b_use_center_pillar = n_claimed_center < 3;
	b_use_left_pillar = n_claimed_left < 1;
	b_use_right_pillar = n_claimed_right < 1;
	if(b_use_center_pillar)
	{
		a_valid_attack_points = s_zone get_unclaimed_attack_points_between_indicies(0, 3);
	}
	else if(b_use_left_pillar)
	{
		a_valid_attack_points = s_zone get_unclaimed_attack_points_between_indicies(4, 7);
	}
	else if(b_use_right_pillar)
	{
		a_valid_attack_points = s_zone get_unclaimed_attack_points_between_indicies(8, 11);
	}
	else
	{
		a_valid_attack_points = s_zone get_unclaimed_attack_points_between_indicies(0, 11);
	}
	if(a_valid_attack_points.size == 0)
	{
		a_valid_attack_points = s_zone get_unclaimed_attack_points_between_indicies(0, 11);
	}
	/#
		Assert(a_valid_attack_points.size > 0, "Dev Block strings are not supported" + s_zone.script_noteworthy);
	#/
	s_attack_point = Array::random(a_valid_attack_points);
	s_attack_point.is_claimed = 1;
	s_attack_point.claimed_by = self;
	return s_attack_point;
}

/*
	Name: clean_up_unused_attack_points
	Namespace: zm_tomb_capture_zones
	Checksum: 0x48A59D4F
	Offset: 0x6128
	Size: 0xB7
	Parameters: 0
	Flags: None
*/
function clean_up_unused_attack_points()
{
	foreach(s_attack_point in self.zombie_attack_points)
	{
		if(s_attack_point.is_claimed && !isdefined(s_attack_point.claimed_by))
		{
			s_attack_point.is_claimed = 0;
			s_attack_point.claimed_by = undefined;
		}
	}
}

/*
	Name: get_unclaimed_attack_points_between_indicies
	Namespace: zm_tomb_capture_zones
	Checksum: 0xF05F4FF4
	Offset: 0x61E8
	Size: 0xEF
	Parameters: 2
	Flags: None
*/
function get_unclaimed_attack_points_between_indicies(n_start, n_end)
{
	a_valid_attack_points = [];
	for(i = n_start; i < n_end; i++)
	{
		if(!self.zombie_attack_points[i].is_claimed && !self.zombie_attack_points[i].inaccessible)
		{
			if(!isdefined(a_valid_attack_points))
			{
				a_valid_attack_points = [];
			}
			else if(!IsArray(a_valid_attack_points))
			{
				a_valid_attack_points = Array(a_valid_attack_points);
			}
			a_valid_attack_points[a_valid_attack_points.size] = self.zombie_attack_points[i];
		}
	}
	return a_valid_attack_points;
}

/*
	Name: get_claimed_attack_points_between_indicies
	Namespace: zm_tomb_capture_zones
	Checksum: 0xFBA87A8B
	Offset: 0x62E0
	Size: 0xD1
	Parameters: 2
	Flags: None
*/
function get_claimed_attack_points_between_indicies(n_start, n_end)
{
	a_valid_points = [];
	for(i = n_start; i < n_end; i++)
	{
		if(self.zombie_attack_points[i].is_claimed)
		{
			if(!isdefined(a_valid_points))
			{
				a_valid_points = [];
			}
			else if(!IsArray(a_valid_points))
			{
				a_valid_points = Array(a_valid_points);
			}
			a_valid_points[a_valid_points.size] = self.zombie_attack_points[i];
		}
	}
	return a_valid_points.size;
}

/*
	Name: unclaim_attacking_point
	Namespace: zm_tomb_capture_zones
	Checksum: 0x75FC2FB9
	Offset: 0x63C0
	Size: 0x19
	Parameters: 0
	Flags: None
*/
function unclaim_attacking_point()
{
	self.is_claimed = 0;
	self.claimed_by = undefined;
}

/*
	Name: clear_all_zombie_attack_points_in_zone
	Namespace: zm_tomb_capture_zones
	Checksum: 0x38E98146
	Offset: 0x63E8
	Size: 0x89
	Parameters: 0
	Flags: None
*/
function clear_all_zombie_attack_points_in_zone()
{
	foreach(s_attack_point in self.zombie_attack_points)
	{
		s_attack_point unclaim_attacking_point();
	}
}

/*
	Name: capture_zombies_only_attack_nearby_players
	Namespace: zm_tomb_capture_zones
	Checksum: 0xEC85CF0B
	Offset: 0x6480
	Size: 0x18B
	Parameters: 1
	Flags: None
*/
function capture_zombies_only_attack_nearby_players(s_zone)
{
	self endon("death");
	n_goal_radius = self.goalRadius;
	while(1)
	{
		self.goalRadius = n_goal_radius;
		if(self should_capture_zombie_attack_generator(s_zone))
		{
			self notify("stop_find_flesh");
			self notify("zombie_acquire_enemy");
			self.ignore_find_flesh = 1;
			self.goalRadius = 30;
			if(!isdefined(self.attacking_point))
			{
				self.attacking_point = self get_unclaimed_attack_point(s_zone);
			}
			self setgoalpos(self.attacking_point.origin);
			self thread cancel_generator_attack_if_player_gets_close_to_generator(s_zone);
			str_notify = self util::waittill_any_return("goal", "stop_attacking_generator", "death");
			if(str_notify === "stop_attacking_generator")
			{
				self.attacking_point unclaim_attacking_point();
			}
			else
			{
				self play_melee_attack_animation();
				continue;
			}
		}
		wait(0.5);
	}
}

/*
	Name: cancel_generator_attack_if_player_gets_close_to_generator
	Namespace: zm_tomb_capture_zones
	Checksum: 0xDE132778
	Offset: 0x6618
	Size: 0x97
	Parameters: 1
	Flags: None
*/
function cancel_generator_attack_if_player_gets_close_to_generator(s_zone)
{
	self notify("generator_attack_cancel_think");
	self endon("generator_attack_cancel_think");
	self endon("death");
	while(1)
	{
		if(!self should_capture_zombie_attack_generator(s_zone))
		{
			self notify("stop_attacking_generator");
			self.ignore_find_flesh = 0;
			break;
		}
		wait(RandomFloatRange(0.2, 1.5));
	}
}

/*
	Name: should_capture_zombie_attack_generator
	Namespace: zm_tomb_capture_zones
	Checksum: 0xC5E9F065
	Offset: 0x66B8
	Size: 0x23D
	Parameters: 1
	Flags: None
*/
function should_capture_zombie_attack_generator(s_zone)
{
	a_players = GetPlayers();
	a_valid_targets = ArraySort(a_players, s_zone.origin, 1, undefined, 700);
	foreach(player in a_players)
	{
		if(!isdefined(self.ignore_player))
		{
			self.ignore_player = [];
		}
		b_is_valid_target = IsInArray(a_valid_targets, player) && zombie_utility::is_player_valid(player);
		b_is_currently_ignored = IsInArray(self.ignore_player, player);
		if(b_is_valid_target && b_is_currently_ignored)
		{
			ArrayRemoveValue(self.ignore_player, player, 0);
			continue;
		}
		if(!b_is_valid_target && !b_is_currently_ignored)
		{
			if(!isdefined(self.ignore_player))
			{
				self.ignore_player = [];
			}
			else if(!IsArray(self.ignore_player))
			{
				self.ignore_player = Array(self.ignore_player);
			}
			self.ignore_player[self.ignore_player.size] = player;
		}
	}
	b_should_attack_generator = isdefined(self.enemy) && (a_valid_targets.size == 0 || self.ignore_player.size == a_players.size);
	return b_should_attack_generator;
}

/*
	Name: play_melee_attack_animation
	Namespace: zm_tomb_capture_zones
	Checksum: 0x1E6C1C1C
	Offset: 0x6900
	Size: 0x15D
	Parameters: 0
	Flags: None
*/
function play_melee_attack_animation()
{
	self endon("death");
	self endon("poi_state_changed");
	v_angles = self.angles;
	if(isdefined(self.attacking_point))
	{
		v_angles = self.attacking_point.v_center_pillar - self.origin;
		v_angles = VectorToAngles((v_angles[0], v_angles[1], 0));
	}
	var_ae686a3e = [];
	var_ae686a3e[var_ae686a3e.size] = "ai_zombie_base_ad_attack_v1";
	var_ae686a3e[var_ae686a3e.size] = "ai_zombie_base_ad_attack_v2";
	var_ae686a3e[var_ae686a3e.size] = "ai_zombie_base_ad_attack_v3";
	var_ae686a3e[var_ae686a3e.size] = "ai_zombie_base_ad_attack_v4";
	var_ae686a3e = Array::randomize(var_ae686a3e);
	self AnimScripted("attack_anim", self.origin, v_angles, var_ae686a3e[0]);
	time = getanimlength(var_ae686a3e[0]);
	wait(time);
}

/*
	Name: recapture_zombie_poi_think
	Namespace: zm_tomb_capture_zones
	Checksum: 0x3D1E9C46
	Offset: 0x6A68
	Size: 0x17D
	Parameters: 0
	Flags: None
*/
function recapture_zombie_poi_think()
{
	self endon("death");
	self.zombie_has_point_of_interest = 0;
	while(isdefined(self) && isalive(self))
	{
		if(isdefined(level._poi_override))
		{
			zombie_poi = self [[level._poi_override]]();
		}
		if(!isdefined(zombie_poi))
		{
			zombie_poi = self zm_utility::get_zombie_point_of_interest(self.origin);
		}
		self.using_poi_last_check = self.zombie_has_point_of_interest;
		if(isdefined(zombie_poi) && IsArray(zombie_poi) && isdefined(zombie_poi[1]))
		{
			self.goalRadius = 16;
			self.zombie_has_point_of_interest = 1;
			self.is_attacking_zone = 0;
			self.point_of_interest = zombie_poi[0];
		}
		else
		{
			self.goalRadius = 30;
			self.zombie_has_point_of_interest = 0;
			self.point_of_interest = undefined;
			zombie_poi = undefined;
		}
		if(self.using_poi_last_check != self.zombie_has_point_of_interest)
		{
			self notify("poi_state_changed");
			self StopAnimScripted(0.2);
		}
		wait(1);
	}
}

/*
	Name: kill_all_capture_zombies
	Namespace: zm_tomb_capture_zones
	Checksum: 0xF714A23F
	Offset: 0x6BF0
	Size: 0x163
	Parameters: 0
	Flags: None
*/
function kill_all_capture_zombies()
{
	while(isdefined(self.capture_zombies) && self.capture_zombies.size > 0)
	{
		foreach(zombie in self.capture_zombies)
		{
			if(isdefined(zombie) && isalive(zombie))
			{
				playFX(level._effect["tesla_elec_kill"], zombie.origin);
				zombie DoDamage(zombie.health + 100, zombie.origin);
			}
			util::wait_network_frame();
		}
		self.capture_zombies = Array::remove_dead(self.capture_zombies);
	}
	self.capture_zombies = [];
}

/*
	Name: kill_all_recapture_zombies
	Namespace: zm_tomb_capture_zones
	Checksum: 0x74AFDC67
	Offset: 0x6D60
	Size: 0x193
	Parameters: 0
	Flags: None
*/
function kill_all_recapture_zombies()
{
	while(isdefined(level.zone_capture.recapture_zombies) && level.zone_capture.recapture_zombies.size > 0)
	{
		foreach(zombie in level.zone_capture.recapture_zombies)
		{
			if(isdefined(zombie) && IsAlive(zombie))
			{
				playFX(level._effect["tesla_elec_kill"], zombie.origin);
				zombie DoDamage(zombie.health + 100, zombie.origin);
			}
			util::wait_network_frame();
		}
		level.zone_capture.recapture_zombies = Array::remove_dead(level.zone_capture.recapture_zombies);
	}
	level.zone_capture.recapture_zombies = [];
}

/*
	Name: is_capture_area_occupied
	Namespace: zm_tomb_capture_zones
	Checksum: 0x3F757CB
	Offset: 0x6F00
	Size: 0xB3
	Parameters: 1
	Flags: None
*/
function is_capture_area_occupied(parent_zone)
{
	if(parent_zone.is_occupied)
	{
		return 1;
	}
	foreach(s_child_zone in parent_zone.child_capture_zones)
	{
		if(s_child_zone.is_occupied)
		{
			return 1;
		}
	}
	return 0;
}

/*
	Name: set_player_controlled_area
	Namespace: zm_tomb_capture_zones
	Checksum: 0x943D4CF7
	Offset: 0x6FC0
	Size: 0x43
	Parameters: 0
	Flags: None
*/
function set_player_controlled_area()
{
	level.zone_capture.last_zone_captured = self;
	self set_player_controlled_zone();
	self play_pap_anim(1);
}

/*
	Name: update_captured_zone_count
	Namespace: zm_tomb_capture_zones
	Checksum: 0x601AF2BB
	Offset: 0x7010
	Size: 0x6B
	Parameters: 0
	Flags: None
*/
function update_captured_zone_count()
{
	level.total_capture_zones = get_captured_zone_count();
	if(level.total_capture_zones == 6)
	{
		level flag::set("all_zones_captured");
	}
	else
	{
		level flag::clear("all_zones_captured");
	}
}

/*
	Name: get_captured_zone_count
	Namespace: zm_tomb_capture_zones
	Checksum: 0x597BC2F6
	Offset: 0x7088
	Size: 0xB5
	Parameters: 0
	Flags: None
*/
function get_captured_zone_count()
{
	n_player_controlled_zones = 0;
	foreach(generator in level.zone_capture.zones)
	{
		if(generator flag::get("player_controlled"))
		{
			n_player_controlled_zones++;
		}
	}
	return n_player_controlled_zones;
}

/*
	Name: get_contested_zone_count
	Namespace: zm_tomb_capture_zones
	Checksum: 0x116EEF8A
	Offset: 0x7148
	Size: 0x13
	Parameters: 0
	Flags: None
*/
function get_contested_zone_count()
{
	return get_contested_zones().size;
}

/*
	Name: get_contested_zones
	Namespace: zm_tomb_capture_zones
	Checksum: 0xE0956FA3
	Offset: 0x7168
	Size: 0x10B
	Parameters: 0
	Flags: None
*/
function get_contested_zones()
{
	a_contested_zones = [];
	foreach(generator in level.zone_capture.zones)
	{
		if(generator flag::get("zone_contested"))
		{
			if(!isdefined(a_contested_zones))
			{
				a_contested_zones = [];
			}
			else if(!IsArray(a_contested_zones))
			{
				a_contested_zones = Array(a_contested_zones);
			}
			a_contested_zones[a_contested_zones.size] = generator;
		}
	}
	return a_contested_zones;
}

/*
	Name: set_player_controlled_zone
	Namespace: zm_tomb_capture_zones
	Checksum: 0x9CD09D61
	Offset: 0x7280
	Size: 0x231
	Parameters: 0
	Flags: None
*/
function set_player_controlled_zone()
{
	if(!self flag::get("player_controlled"))
	{
		foreach(e_player in level.players)
		{
			e_player thread zm_craftables::player_show_craftable_parts_ui(undefined, "zmInventory.capture_generator_wheel_widget", 0);
		}
	}
	self flag::set("player_controlled");
	self flag::clear("attacked_by_recapture_zombies");
	level clientfield::set("zone_capture_hud_generator_" + self.script_int, 1);
	level clientfield::set("zone_capture_monolith_crystal_" + self.script_int, 0);
	if(!isdefined(self.perk_fx_func) || [[self.perk_fx_func]]())
	{
		level clientfield::set("zone_capture_perk_machine_smoke_fx_" + self.script_int, 1);
	}
	self flag::set("player_controlled");
	update_captured_zone_count();
	self enable_perk_machines_in_zone();
	self enable_random_perk_machines_in_zone();
	self enable_mystery_boxes_in_zone();
	self function_c3b54f6d();
	level notify("zone_captured_by_player", self.str_zone);
}

/*
	Name: set_zombie_controlled_area
	Namespace: zm_tomb_capture_zones
	Checksum: 0xF551827B
	Offset: 0x74C0
	Size: 0x10B
	Parameters: 1
	Flags: None
*/
function set_zombie_controlled_area(b_is_level_initializing)
{
	if(!isdefined(b_is_level_initializing))
	{
		b_is_level_initializing = 0;
	}
	update_captured_zone_count();
	if(b_is_level_initializing)
	{
		level clientfield::set("state_" + self.script_noteworthy, 3);
		util::wait_network_frame();
		level clientfield::set("state_" + self.script_noteworthy, 0);
	}
	if(self flag::get("player_controlled"))
	{
		level flag::set("generator_lost_to_recapture_zombies");
	}
	self set_zombie_controlled_zone(b_is_level_initializing);
	self play_pap_anim(0);
}

/*
	Name: function_b0debead
	Namespace: zm_tomb_capture_zones
	Checksum: 0xAAB66034
	Offset: 0x75D8
	Size: 0xC3
	Parameters: 0
	Flags: None
*/
function function_b0debead()
{
	level flag::wait_till("start_zombie_round_logic");
	var_5102e5a = get_captured_zone_count();
	if(var_5102e5a > 0)
	{
		level clientfield::set("packapunch_anim", 0);
	}
	else if(var_5102e5a == 0)
	{
		level clientfield::set("packapunch_anim", 6);
		wait(5);
		level clientfield::set("packapunch_anim", 0);
	}
}

/*
	Name: play_pap_anim
	Namespace: zm_tomb_capture_zones
	Checksum: 0x2775089C
	Offset: 0x76A8
	Size: 0x3B
	Parameters: 1
	Flags: None
*/
function play_pap_anim(b_assemble)
{
	level clientfield::set("packapunch_anim", get_captured_zone_count());
}

/*
	Name: set_zombie_controlled_zone
	Namespace: zm_tomb_capture_zones
	Checksum: 0x7EE2ADDD
	Offset: 0x76F0
	Size: 0x203
	Parameters: 1
	Flags: None
*/
function set_zombie_controlled_zone(b_is_level_initializing)
{
	if(!isdefined(b_is_level_initializing))
	{
		b_is_level_initializing = 0;
	}
	n_hud_state = 2;
	if(b_is_level_initializing)
	{
		n_hud_state = 0;
	}
	if(!b_is_level_initializing && self flag::get("player_controlled"))
	{
		foreach(e_player in level.players)
		{
			e_player thread zm_craftables::player_show_craftable_parts_ui(undefined, "zmInventory.capture_generator_wheel_widget", 0);
		}
	}
	self flag::clear("player_controlled");
	level clientfield::set("zone_capture_hud_generator_" + self.script_int, n_hud_state);
	level clientfield::set("zone_capture_monolith_crystal_" + self.script_int, 1);
	level clientfield::set("zone_capture_perk_machine_smoke_fx_" + self.script_int, 0);
	update_captured_zone_count();
	self disable_perk_machines_in_zone();
	self disable_random_perk_machines_in_zone();
	self disable_mystery_boxes_in_zone();
	if(!b_is_level_initializing)
	{
		self function_1138b343();
	}
}

/*
	Name: function_c3b54f6d
	Namespace: zm_tomb_capture_zones
	Checksum: 0x16A71F90
	Offset: 0x7900
	Size: 0x3B
	Parameters: 0
	Flags: None
*/
function function_c3b54f6d()
{
	var_43157bc9 = "power_on" + self.script_int;
	level flag::set(var_43157bc9);
}

/*
	Name: function_1138b343
	Namespace: zm_tomb_capture_zones
	Checksum: 0xA3B371
	Offset: 0x7948
	Size: 0x3B
	Parameters: 0
	Flags: None
*/
function function_1138b343()
{
	var_43157bc9 = "power_on" + self.script_int;
	level flag::clear(var_43157bc9);
}

/*
	Name: capture_progress_think
	Namespace: zm_tomb_capture_zones
	Checksum: 0x8E64EC44
	Offset: 0x7990
	Size: 0x483
	Parameters: 0
	Flags: None
*/
function capture_progress_think()
{
	self init_capture_progress();
	self clear_zone_objective_index();
	self show_zone_capture_objective(1);
	self get_zone_objective_index();
	while(self flag::get("zone_contested"))
	{
		a_players = GetPlayers();
		a_players_in_capture_zone = self get_players_in_capture_zone();
		foreach(player in a_players)
		{
			if(IsInArray(a_players_in_capture_zone, player))
			{
				if(!level flag::get("recapture_event_in_progress") || !self flag::get("current_recapture_target_zone"))
				{
					Objective_SetPlayerUsing(self.n_objective_index, player);
				}
				continue;
			}
			if(zombie_utility::is_player_valid(player))
			{
				Objective_ClearPlayerUsing(self.n_objective_index, player);
			}
		}
		self.n_last_progress = self.n_current_progress;
		self.n_current_progress = self.n_current_progress + self get_progress_rate(a_players_in_capture_zone.size, a_players.size);
		if(self.n_last_progress != self.n_current_progress)
		{
			self.n_current_progress = math::clamp(self.n_current_progress, 0, 100);
			Objective_SetProgress(self.n_objective_index, self.n_current_progress / 100);
			self zone_capture_sound_state_think();
			level clientfield::set(self.script_noteworthy, self.n_current_progress / 100);
			self generator_set_state();
			if(!level flag::get("recapture_event_in_progress") || !self flag::get("attacked_by_recapture_zombies"))
			{
				b_set_color_to_white = a_players_in_capture_zone.size > 0;
				if(!level flag::get("recapture_event_in_progress") && self flag::get("current_recapture_target_zone"))
				{
					b_set_color_to_white = 1;
				}
				level clientfield::set("zc_change_progress_bar_color", b_set_color_to_white);
			}
			update_objective_on_momentum_change();
			if(self.n_current_progress == 0 || (self.n_current_progress == 100 && !self flag::get("attacked_by_recapture_zombies")))
			{
				self flag::clear("zone_contested");
			}
		}
		show_zone_capture_debug_info();
		wait(0.1);
	}
	self flag::clear("attacked_by_recapture_zombies");
	self handle_generator_capture();
	self clear_all_zombie_attack_points_in_zone();
}

/*
	Name: update_objective_on_momentum_change
	Namespace: zm_tomb_capture_zones
	Checksum: 0x852ABACC
	Offset: 0x7E20
	Size: 0xBB
	Parameters: 0
	Flags: None
*/
function update_objective_on_momentum_change()
{
	if(self flag::get("current_recapture_target_zone") && !level flag::get("recapture_event_in_progress") && self.n_objective_index == 1 && self.n_current_progress > self.n_last_progress)
	{
		self clear_zone_objective_index();
		self show_zone_capture_objective(1);
		level clientfield::set("zc_change_progress_bar_color", 1);
	}
}

/*
	Name: get_zone_objective_index
	Namespace: zm_tomb_capture_zones
	Checksum: 0x18A5413B
	Offset: 0x7EE8
	Size: 0x8D
	Parameters: 0
	Flags: None
*/
function get_zone_objective_index()
{
	if(!isdefined(self.n_objective_index))
	{
		if(self flag::get("current_recapture_target_zone"))
		{
			if(level flag::get("recapture_event_in_progress"))
			{
				n_objective = 1;
			}
			else
			{
				n_objective = 2;
			}
		}
		else
		{
			n_objective = 0;
		}
		self.n_objective_index = n_objective;
	}
	return self.n_objective_index;
}

/*
	Name: get_zones_using_objective_index
	Namespace: zm_tomb_capture_zones
	Checksum: 0x43D85FCD
	Offset: 0x7F80
	Size: 0xC7
	Parameters: 1
	Flags: None
*/
function get_zones_using_objective_index(n_index)
{
	n_zones_using_objective_index = 0;
	foreach(zone in level.zone_capture.zones)
	{
		if(isdefined(zone.n_objective_index) && zone.n_objective_index == n_index)
		{
			n_zones_using_objective_index++;
		}
	}
	return n_zones_using_objective_index;
}

/*
	Name: zone_capture_sound_state_think
	Namespace: zm_tomb_capture_zones
	Checksum: 0xF90BF41A
	Offset: 0x8050
	Size: 0xBF
	Parameters: 0
	Flags: None
*/
function zone_capture_sound_state_think()
{
	if(!isdefined(self.is_playing_audio))
	{
		self.is_playing_audio = 0;
	}
	if(self.n_current_progress > self.n_last_progress)
	{
		if(self.is_playing_audio)
		{
			self.sndent StopLoopSound();
			self.is_playing_audio = 0;
		}
	}
	else if(!self.is_playing_audio && level flag::get("generator_under_attack"))
	{
		self.sndent PlayLoopSound("zmb_capturezone_generator_alarm", 0.25);
		self.is_playing_audio = 1;
	}
}

/*
	Name: function_d545328
	Namespace: zm_tomb_capture_zones
	Checksum: 0x2B243EA1
	Offset: 0x8118
	Size: 0x4B
	Parameters: 0
	Flags: None
*/
function function_d545328()
{
	self show_zone_capture_objective(0);
	util::wait_network_frame();
	level clientfield::set("zc_change_progress_bar_color", 0);
}

/*
	Name: handle_generator_capture
	Namespace: zm_tomb_capture_zones
	Checksum: 0x7152E599
	Offset: 0x8170
	Size: 0x193
	Parameters: 0
	Flags: None
*/
function handle_generator_capture()
{
	self thread function_d545328();
	if(self.n_current_progress == 100)
	{
		self players_capture_zone();
		self kill_all_capture_zombies();
		level clientfield::set("state_" + self.script_noteworthy, 6);
	}
	else if(self.n_current_progress == 0)
	{
		if(self flag::get("player_controlled"))
		{
			self.sndent StopLoopSound(0.25);
			self thread generator_deactivated_vo();
			self.is_playing_audio = 0;
		}
		self set_zombie_controlled_area();
		if(level flag::get("recapture_event_in_progress") && get_captured_zone_count() > 0)
		{
		}
		else
		{
			self kill_all_capture_zombies();
		}
	}
	if(get_contested_zone_count() == 0)
	{
		level flag::clear("zone_capture_in_progress");
	}
}

/*
	Name: init_capture_progress
	Namespace: zm_tomb_capture_zones
	Checksum: 0x657E2FBE
	Offset: 0x8310
	Size: 0x193
	Parameters: 0
	Flags: None
*/
function init_capture_progress()
{
	if(!isdefined(level.zone_capture.rate_capture))
	{
		level.zone_capture.rate_capture = get_update_rate(10);
	}
	if(!isdefined(level.zone_capture.rate_capture_solo))
	{
		level.zone_capture.rate_capture_solo = get_update_rate(12);
	}
	if(!isdefined(level.zone_capture.rate_decay))
	{
		level.zone_capture.rate_decay = get_update_rate(20) * -1;
	}
	if(!isdefined(level.zone_capture.rate_recapture))
	{
		level.zone_capture.rate_recapture = get_update_rate(40) * -1;
	}
	if(!isdefined(level.zone_capture.rate_recapture_players))
	{
		level.zone_capture.rate_recapture_players = get_update_rate(10);
	}
	if(!self flag::get("player_controlled"))
	{
		self.n_current_progress = 0;
		self flag::clear("attacked_by_recapture_zombies");
	}
	self flag::set("zone_contested");
}

/*
	Name: get_progress_rate
	Namespace: zm_tomb_capture_zones
	Checksum: 0x4A2978EE
	Offset: 0x84B0
	Size: 0x18B
	Parameters: 2
	Flags: None
*/
function get_progress_rate(n_players_in_zone, n_players_total)
{
	if(level flag::get("recapture_event_in_progress") && self flag::get("current_recapture_target_zone"))
	{
		if(self get_recapture_attacker_count() > 0)
		{
			n_rate = level.zone_capture.rate_recapture;
		}
		else if(!self flag::get("attacked_by_recapture_zombies"))
		{
			n_rate = 0;
		}
		else
		{
			n_rate = level.zone_capture.rate_recapture_players;
		}
	}
	else if(self flag::get("current_recapture_target_zone"))
	{
		n_rate = level.zone_capture.rate_recapture_players;
	}
	else if(n_players_in_zone > 0)
	{
		if(level.players.size == 1)
		{
			n_rate = level.zone_capture.rate_capture_solo;
		}
		else
		{
			n_rate = level.zone_capture.rate_capture * n_players_in_zone / n_players_total;
		}
	}
	else
	{
		n_rate = level.zone_capture.rate_decay;
	}
	return n_rate;
}

/*
	Name: show_zone_capture_objective
	Namespace: zm_tomb_capture_zones
	Checksum: 0x5D440EBA
	Offset: 0x8648
	Size: 0xAB
	Parameters: 1
	Flags: None
*/
function show_zone_capture_objective(b_show_objective)
{
	self get_zone_objective_index();
	if(b_show_objective)
	{
		objective_add(self.n_objective_index, "active", self.origin, istring("zm_dlc5_capture_generator" + self.script_int));
		Objective_SetVisibleToAll(self.n_objective_index);
	}
	else
	{
		self clear_zone_objective_index();
	}
}

/*
	Name: clear_zone_objective_index
	Namespace: zm_tomb_capture_zones
	Checksum: 0xFF16D838
	Offset: 0x8700
	Size: 0x101
	Parameters: 0
	Flags: None
*/
function clear_zone_objective_index()
{
	if(isdefined(self.n_objective_index) && get_zones_using_objective_index(self.n_objective_index) < 2)
	{
		objective_state(self.n_objective_index, "invisible");
		a_players = GetPlayers();
		foreach(player in a_players)
		{
			Objective_ClearPlayerUsing(self.n_objective_index, player);
		}
	}
	self.n_objective_index = undefined;
}

/*
	Name: hide_zone_objective_while_recapture_group_runs_to_next_generator
	Namespace: zm_tomb_capture_zones
	Checksum: 0xAC4DDA9D
	Offset: 0x8810
	Size: 0xCB
	Parameters: 1
	Flags: None
*/
function hide_zone_objective_while_recapture_group_runs_to_next_generator(b_hide_icon)
{
	self clear_zone_objective_index();
	level flag::clear("generator_under_attack");
	if(!b_hide_icon)
	{
		recapture_zombie_group_icon_show();
	}
	do
	{
		wait(1);
	}
	while(!(!level flag::get("recapture_zombies_cleared") && self get_recapture_attacker_count() == 0));
	if(!level flag::get("recapture_zombies_cleared"))
	{
		self thread generator_compromised_vo();
	}
}

/*
	Name: recapture_zombie_group_icon_show
	Namespace: zm_tomb_capture_zones
	Checksum: 0x2501B18F
	Offset: 0x88E8
	Size: 0x153
	Parameters: 0
	Flags: None
*/
function recapture_zombie_group_icon_show()
{
	level endon("recapture_zombies_cleared");
	if(isdefined(level.zone_capture.recapture_zombies) && level flag::get("recapture_event_in_progress"))
	{
		while(!level.zone_capture.recapture_zombies.size)
		{
			util::wait_network_frame();
			level.zone_capture.recapture_zombies = Array::remove_dead(level.zone_capture.recapture_zombies);
		}
		level flag::wait_till_clear("generator_under_attack");
		if(level.zone_capture.recapture_zombies.size > 0)
		{
			ai_zombie = Array::random(level.zone_capture.recapture_zombies);
			objective_add(3, "active", ai_zombie, istring("zm_dlc5_recapture_zombie"));
			ai_zombie thread recapture_zombie_icon_think();
		}
	}
}

/*
	Name: recapture_zombie_icon_think
	Namespace: zm_tomb_capture_zones
	Checksum: 0xE3E2901F
	Offset: 0x8A48
	Size: 0xCB
	Parameters: 0
	Flags: None
*/
function recapture_zombie_icon_think()
{
	while(isalive(self) && !level flag::get("generator_under_attack"))
	{
		/#
			debugstar(self.origin, 20, (1, 0, 0));
		#/
		wait(1);
	}
	recapture_zombie_group_icon_hide();
	util::wait_network_frame();
	if(!level flag::get("recapture_zombies_cleared"))
	{
		recapture_zombie_group_icon_show();
	}
}

/*
	Name: recapture_zombie_group_icon_hide
	Namespace: zm_tomb_capture_zones
	Checksum: 0x5BFBBA3E
	Offset: 0x8B20
	Size: 0x53
	Parameters: 0
	Flags: None
*/
function recapture_zombie_group_icon_hide()
{
	objective_state(3, "invisible");
	if(isalive(self))
	{
		objective_clearentity(3);
	}
}

/*
	Name: players_capture_zone
	Namespace: zm_tomb_capture_zones
	Checksum: 0xEF99D03A
	Offset: 0x8B80
	Size: 0x153
	Parameters: 0
	Flags: None
*/
function players_capture_zone()
{
	self.sndent playsound("zmb_capturezone_success");
	self.sndent StopLoopSound(0.25);
	util::wait_network_frame();
	if(!level flag::get("recapture_event_in_progress") && !self flag::get("player_controlled"))
	{
		self thread zone_capture_complete_vo();
	}
	reward_players_in_capture_zone();
	self set_player_controlled_area();
	if(isdefined(self.var_ea997a3c))
	{
		self refund_generator_cost_if_player_captured_it(self.var_ea997a3c);
	}
	util::wait_network_frame();
	playFX(level._effect["capture_complete"], self.origin);
	level thread sndplaygeneratormusicstinger();
}

/*
	Name: reward_players_in_capture_zone
	Namespace: zm_tomb_capture_zones
	Checksum: 0xCA233CE8
	Offset: 0x8CE0
	Size: 0x119
	Parameters: 0
	Flags: None
*/
function reward_players_in_capture_zone()
{
	b_challenge_exists = namespace_a528e918::challenge_exists("zc_zone_captures");
	if(!self flag::get("player_controlled"))
	{
		foreach(player in get_players_in_capture_zone())
		{
			player notify("completed_zone_capture");
			player zm_score::player_add_points("bonus_points_powerup", 100);
			if(b_challenge_exists)
			{
				player namespace_a528e918::increment_stat("zc_zone_captures");
			}
		}
	}
}

/*
	Name: show_zone_capture_debug_info
	Namespace: zm_tomb_capture_zones
	Checksum: 0xF15341A1
	Offset: 0x8E08
	Size: 0x1D1
	Parameters: 0
	Flags: None
*/
function show_zone_capture_debug_info()
{
	/#
		if(GetDvarInt("Dev Block strings are not supported") > 0)
		{
			print3d(self.origin, "Dev Block strings are not supported" + self.n_current_progress, (0, 1, 0));
			circle(GroundTrace(self.origin, self.origin - VectorScale((0, 0, 1), 1000), 0, undefined)["Dev Block strings are not supported"], 220, (0, 1, 0), 0, 4);
			foreach(n_index, attack_point in self.zombie_attack_points)
			{
				if(attack_point.inaccessible)
				{
					v_color = (1, 1, 1);
				}
				else if(attack_point.is_claimed)
				{
					v_color = (1, 0, 0);
				}
				else
				{
					v_color = (0, 1, 0);
				}
				debugstar(attack_point.origin, 4, v_color);
				print3d(attack_point.origin + VectorScale((0, 0, 1), 10), n_index, v_color, 1, 1, 4);
			}
		}
	#/
}

/*
	Name: get_players_in_capture_zone
	Namespace: zm_tomb_capture_zones
	Checksum: 0xF57DE2B9
	Offset: 0x8FE8
	Size: 0x163
	Parameters: 0
	Flags: None
*/
function get_players_in_capture_zone()
{
	a_players_in_capture_zone = [];
	foreach(player in GetPlayers())
	{
		if(zombie_utility::is_player_valid(player) && Distance2DSquared(player.origin, self.origin) < 48400 && player.origin[2] > self.origin[2] + -20)
		{
			if(!isdefined(a_players_in_capture_zone))
			{
				a_players_in_capture_zone = [];
			}
			else if(!IsArray(a_players_in_capture_zone))
			{
				a_players_in_capture_zone = Array(a_players_in_capture_zone);
			}
			a_players_in_capture_zone[a_players_in_capture_zone.size] = player;
		}
	}
	return a_players_in_capture_zone;
}

/*
	Name: get_update_rate
	Namespace: zm_tomb_capture_zones
	Checksum: 0xF0BE75A3
	Offset: 0x9158
	Size: 0x31
	Parameters: 1
	Flags: None
*/
function get_update_rate(n_duration)
{
	n_change_per_update = 100 / n_duration * 0.1;
	return n_change_per_update;
}

/*
	Name: generator_set_state
	Namespace: zm_tomb_capture_zones
	Checksum: 0x1B205DB3
	Offset: 0x9198
	Size: 0x133
	Parameters: 0
	Flags: None
*/
function generator_set_state()
{
	n_generator_state = level clientfield::get("state_" + self.script_noteworthy);
	if(self.n_current_progress == 0)
	{
		self generator_state_turn_off();
	}
	else if(n_generator_state == 0 && self.n_current_progress > 0)
	{
		self generator_state_turn_on();
	}
	else if(self can_start_generator_power_up_anim())
	{
		self generator_state_power_up();
	}
	else if(n_generator_state == 2 && self.n_current_progress < self.n_last_progress)
	{
		self generator_state_power_down();
		if(!level flag::get("recapture_event_in_progress"))
		{
			self thread generator_interrupted_vo();
		}
	}
}

/*
	Name: generator_state_turn_on
	Namespace: zm_tomb_capture_zones
	Checksum: 0x48311ED8
	Offset: 0x92D8
	Size: 0x37
	Parameters: 0
	Flags: None
*/
function generator_state_turn_on()
{
	level clientfield::set("state_" + self.script_noteworthy, 1);
	self.n_time_started_generator = GetTime();
}

/*
	Name: generator_state_power_up
	Namespace: zm_tomb_capture_zones
	Checksum: 0xB8A59107
	Offset: 0x9318
	Size: 0x2B
	Parameters: 0
	Flags: None
*/
function generator_state_power_up()
{
	level clientfield::set("state_" + self.script_noteworthy, 2);
}

/*
	Name: generator_state_power_down
	Namespace: zm_tomb_capture_zones
	Checksum: 0xE8E65740
	Offset: 0x9350
	Size: 0x6B
	Parameters: 0
	Flags: None
*/
function generator_state_power_down()
{
	if(self flag::get("attacked_by_recapture_zombies"))
	{
		n_state = 5;
	}
	else
	{
		n_state = 3;
	}
	level clientfield::set("state_" + self.script_noteworthy, n_state);
}

/*
	Name: generator_state_turn_off
	Namespace: zm_tomb_capture_zones
	Checksum: 0xB1D41DCA
	Offset: 0x93C8
	Size: 0x43
	Parameters: 0
	Flags: None
*/
function generator_state_turn_off()
{
	level clientfield::set("state_" + self.script_noteworthy, 4);
	self thread generator_turns_off_after_anim();
}

/*
	Name: generator_turns_off_after_anim
	Namespace: zm_tomb_capture_zones
	Checksum: 0x5A4C83CB
	Offset: 0x9418
	Size: 0x3B
	Parameters: 0
	Flags: None
*/
function generator_turns_off_after_anim()
{
	wait(getanimlength(%p7_fxanim_zm_ori_generator_end_anim));
	self generator_state_off();
}

/*
	Name: generator_state_off
	Namespace: zm_tomb_capture_zones
	Checksum: 0xAC867058
	Offset: 0x9460
	Size: 0x2B
	Parameters: 0
	Flags: None
*/
function generator_state_off()
{
	level clientfield::set("state_" + self.script_noteworthy, 0);
}

/*
	Name: can_start_generator_power_up_anim
	Namespace: zm_tomb_capture_zones
	Checksum: 0x67C4C6B4
	Offset: 0x9498
	Size: 0x83
	Parameters: 0
	Flags: None
*/
function can_start_generator_power_up_anim()
{
	if(!isdefined(self.n_time_started_generator))
	{
		self.n_time_started_generator = 0;
	}
	if(!isdefined(self.n_time_start_anim))
	{
		self.n_time_start_anim = getanimlength(%p7_fxanim_zm_ori_generator_start_anim);
	}
	return self.n_current_progress > self.n_last_progress && GetTime() - self.n_time_started_generator * 0.001 > self.n_time_start_anim;
}

/*
	Name: get_recapture_attacker_count
	Namespace: zm_tomb_capture_zones
	Checksum: 0xD5BFE571
	Offset: 0x9528
	Size: 0xEF
	Parameters: 0
	Flags: None
*/
function get_recapture_attacker_count()
{
	n_zone_attacker_count = 0;
	foreach(zombie in level.zone_capture.recapture_zombies)
	{
		if(isalive(zombie) && (IS_TRUE(zombie.is_attacking_zone)) && self.script_noteworthy === level.zone_capture.recapture_target)
		{
			n_zone_attacker_count++;
		}
	}
	return n_zone_attacker_count;
}

/*
	Name: watch_for_open_sesame
	Namespace: zm_tomb_capture_zones
	Checksum: 0xCFC60A01
	Offset: 0x9620
	Size: 0x111
	Parameters: 0
	Flags: None
*/
function watch_for_open_sesame()
{
	/#
		level waittill("open_sesame");
		level.b_open_sesame = 1;
		a_generators = struct::get_array("Dev Block strings are not supported", "Dev Block strings are not supported");
		foreach(s_generator in a_generators)
		{
			s_temp = level.zone_capture.zones[s_generator.script_noteworthy];
			s_temp debug_set_generator_active();
			util::wait_network_frame();
		}
	#/
}

/*
	Name: debug_watch_for_zone_capture
	Namespace: zm_tomb_capture_zones
	Checksum: 0x64E5EF23
	Offset: 0x9740
	Size: 0xED
	Parameters: 0
	Flags: None
*/
function debug_watch_for_zone_capture()
{
	/#
		while(1)
		{
			level waittill("force_zone_capture", n_zone);
			foreach(zone in level.zone_capture.zones)
			{
				if(zone.script_int == n_zone && !zone flag::get("Dev Block strings are not supported"))
				{
					zone debug_set_generator_active();
				}
			}
		}
	#/
}

/*
	Name: debug_watch_for_zone_recapture
	Namespace: zm_tomb_capture_zones
	Checksum: 0xD0ECF56C
	Offset: 0x9838
	Size: 0xED
	Parameters: 0
	Flags: None
*/
function debug_watch_for_zone_recapture()
{
	/#
		while(1)
		{
			level waittill("force_zone_recapture", n_zone);
			foreach(zone in level.zone_capture.zones)
			{
				if(zone.script_int == n_zone && zone flag::get("Dev Block strings are not supported"))
				{
					zone debug_set_generator_inactive();
				}
			}
		}
	#/
}

/*
	Name: debug_set_generator_active
	Namespace: zm_tomb_capture_zones
	Checksum: 0x859094B3
	Offset: 0x9930
	Size: 0x63
	Parameters: 0
	Flags: None
*/
function debug_set_generator_active()
{
	/#
		self set_player_controlled_area();
		self.n_current_progress = 100;
		self generator_state_power_up();
		level clientfield::set(self.script_noteworthy, self.n_current_progress / 100);
	#/
}

/*
	Name: debug_set_generator_inactive
	Namespace: zm_tomb_capture_zones
	Checksum: 0xD4494BFB
	Offset: 0x99A0
	Size: 0x63
	Parameters: 0
	Flags: None
*/
function debug_set_generator_inactive()
{
	/#
		self set_zombie_controlled_area();
		self.n_current_progress = 0;
		self generator_state_turn_off();
		level clientfield::set(self.script_noteworthy, self.n_current_progress / 100);
	#/
}

/*
	Name: set_magic_box_zbarrier_state
	Namespace: zm_tomb_capture_zones
	Checksum: 0x7C75D9A0
	Offset: 0x9A10
	Size: 0x509
	Parameters: 1
	Flags: None
*/
function set_magic_box_zbarrier_state(State)
{
	for(i = 0; i < self GetNumZBarrierPieces(); i++)
	{
		self HideZBarrierPiece(i);
	}
	self notify("zbarrier_state_change");
	switch(State)
	{
		case "away":
		{
			self ShowZBarrierPiece(0);
			self.State = "away";
			self.owner.is_locked = 0;
			break;
		}
		case "arriving":
		{
			self ShowZBarrierPiece(1);
			self thread namespace_bafc277e::magic_box_arrives();
			self.State = "arriving";
			break;
		}
		case "initial":
		{
			self ShowZBarrierPiece(1);
			self thread zm_magicbox::magic_box_initial();
			thread zm_unitrigger::register_static_unitrigger(self.owner.unitrigger_stub, &zm_magicbox::magicbox_unitrigger_think);
			self.State = "close";
			break;
		}
		case "open":
		{
			self ShowZBarrierPiece(2);
			self thread namespace_bafc277e::magic_box_opens();
			self.State = "open";
			break;
		}
		case "close":
		{
			self ShowZBarrierPiece(2);
			self thread namespace_bafc277e::magic_box_closes();
			self.State = "close";
			break;
		}
		case "leaving":
		{
			self ShowZBarrierPiece(1);
			self thread namespace_bafc277e::magic_box_leaves();
			self.State = "leaving";
			self.owner.is_locked = 0;
			break;
		}
		case "zombie_controlled":
		{
			if(IS_TRUE(level.zombie_vars["zombie_powerup_fire_sale_on"]))
			{
				self ShowZBarrierPiece(2);
				self clientfield::set("magicbox_amb_fx", 0);
			}
			if(self.State == "initial" || self.State == "close")
			{
				self ShowZBarrierPiece(1);
				self clientfield::set("magicbox_amb_fx", 1);
			}
			else if(self.State == "away")
			{
				self ShowZBarrierPiece(0);
				self clientfield::set("magicbox_amb_fx", 0);
			}
			else if(self.State == "open" || self.State == "leaving")
			{
				self ShowZBarrierPiece(2);
				self clientfield::set("magicbox_amb_fx", 0);
			}
			break;
		}
		case "player_controlled":
		{
			if(self.State == "arriving" || self.State == "close")
			{
				self ShowZBarrierPiece(2);
				self clientfield::set("magicbox_amb_fx", 2);
				break;
			}
			if(self.State == "away")
			{
				self ShowZBarrierPiece(0);
				self clientfield::set("magicbox_amb_fx", 3);
			}
			break;
		}
		default:
		{
			if(isdefined(level.custom_magicbox_state_handler))
			{
				self [[level.custom_magicbox_state_handler]](State);
			}
			break;
		}
	}
}

/*
	Name: magic_box_trigger_update_prompt
	Namespace: zm_tomb_capture_zones
	Checksum: 0x59719C2B
	Offset: 0x9F28
	Size: 0x8F
	Parameters: 1
	Flags: None
*/
function magic_box_trigger_update_prompt(player)
{
	can_use = self magic_box_stub_update_prompt(player);
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

/*
	Name: magic_box_stub_update_prompt
	Namespace: zm_tomb_capture_zones
	Checksum: 0x8ED0D6E
	Offset: 0x9FC0
	Size: 0x1CF
	Parameters: 1
	Flags: None
*/
function magic_box_stub_update_prompt(player)
{
	if(!self zm_magicbox::trigger_visible_to_player(player))
	{
		return 0;
	}
	self.hint_parm1 = undefined;
	if(IS_TRUE(self.stub.trigger_target.grab_weapon_hint))
	{
		cursor_hint = "HINT_WEAPON";
		cursor_hint_weapon = self.stub.trigger_target.grab_weapon;
		self setcursorhint(cursor_hint, cursor_hint_weapon);
		if(isdefined(level.magic_box_check_equipment) && [[level.magic_box_check_equipment]](cursor_hint_weapon))
		{
			self.hint_string = &"ZOMBIE_TRADE_EQUIP_FILL";
		}
		else
		{
			self.hint_string = &"ZOMBIE_TRADE_WEAPON_FILL";
		}
	}
	else
	{
		self setcursorhint("HINT_NOICON");
		if(!level.zone_capture.zones[self.stub.zone] flag::get("player_controlled"))
		{
			self.hint_string = &"ZM_TOMB_ZC";
			return 0;
		}
		else
		{
			self.hint_parm1 = self.stub.trigger_target.zombie_cost;
			self.hint_string = zm_utility::get_hint_string(self, "default_treasure_chest");
		}
	}
	return 1;
}

/*
	Name: recapture_round_tracker
	Namespace: zm_tomb_capture_zones
	Checksum: 0x49CAC944
	Offset: 0xA198
	Size: 0x137
	Parameters: 0
	Flags: None
*/
function recapture_round_tracker()
{
	n_next_recapture_round = 10;
	while(1)
	{
		/#
			iprintln("Dev Block strings are not supported" + n_next_recapture_round);
		#/
		level util::waittill_any("between_round_over", "force_recapture_start");
		/#
			if(GetDvarInt("Dev Block strings are not supported") > 0)
			{
				n_next_recapture_round = level.round_number;
			}
		#/
		if(level.round_number >= n_next_recapture_round && !level flag::get("zone_capture_in_progress") && get_captured_zone_count() >= get_player_controlled_zone_count_for_recapture())
		{
			if(n_next_recapture_round == 10) n_next_recapture_round = 15;
			else if(n_next_recapture_round == 15) n_next_recapture_round = 19;
			else n_next_recapture_round = level.round_number + randomIntRange(3, 6);
			level thread recapture_round_start();
		}
	}
}

/*
	Name: get_player_controlled_zone_count_for_recapture
	Namespace: zm_tomb_capture_zones
	Checksum: 0x938AD78D
	Offset: 0xA2D8
	Size: 0x47
	Parameters: 0
	Flags: None
*/
function get_player_controlled_zone_count_for_recapture()
{
	n_zones_required = 4;
	/#
		if(GetDvarInt("Dev Block strings are not supported") > 0)
		{
			n_zones_required = 1;
		}
	#/
	return n_zones_required;
}

/*
	Name: get_recapture_zone
	Namespace: zm_tomb_capture_zones
	Checksum: 0xE355CD67
	Offset: 0xA328
	Size: 0x2E5
	Parameters: 1
	Flags: None
*/
function get_recapture_zone(s_last_recapture_zone)
{
	a_s_player_zones = [];
	foreach(str_key, s_zone in level.zone_capture.zones)
	{
		if(s_zone flag::get("player_controlled"))
		{
			a_s_player_zones[str_key] = s_zone;
		}
	}
	s_recapture_zone = undefined;
	if(a_s_player_zones.size)
	{
		if(isdefined(s_last_recapture_zone))
		{
			n_distance_closest = undefined;
			foreach(s_zone in a_s_player_zones)
			{
				n_distance = DistanceSquared(s_zone.origin, s_last_recapture_zone.origin);
				if(!isdefined(n_distance_closest) || n_distance < n_distance_closest)
				{
					s_recapture_zone = s_zone;
					n_distance_closest = n_distance;
				}
			}
			break;
		}
		s_recapture_zone = Array::random(a_s_player_zones);
		/#
			if(GetDvarInt("Dev Block strings are not supported") > 0)
			{
				n_zone = GetDvarInt("Dev Block strings are not supported");
				foreach(zone in level.zone_capture.zones)
				{
					if(n_zone == zone.script_int && zone flag::get("Dev Block strings are not supported"))
					{
						s_recapture_zone = zone;
						break;
					}
				}
			}
		#/
	}
	return s_recapture_zone;
}

/*
	Name: recapture_round_start
	Namespace: zm_tomb_capture_zones
	Checksum: 0x9CBA1971
	Offset: 0xA618
	Size: 0x553
	Parameters: 0
	Flags: None
*/
function recapture_round_start()
{
	level flag::set("recapture_event_in_progress");
	level flag::clear("recapture_zombies_cleared");
	level flag::clear("generator_under_attack");
	level.recapture_zombies_killed = 0;
	b_is_first_generator_attack = 1;
	s_recapture_target_zone = undefined;
	capture_event_handle_ai_limit();
	recapture_round_audio_starts();
	var_c746b61a = struct::get_array("generator_attackable", "targetname");
	foreach(var_b454101b in var_c746b61a)
	{
		var_b454101b zm_attackables::deactivate();
		var_b454101b.health = 1000000;
		var_b454101b.max_health = var_b454101b.health;
		var_b454101b.aggro_distance = 1024;
	}
	while(!level flag::get("recapture_zombies_cleared") && get_captured_zone_count() > 0)
	{
		s_recapture_target_zone = get_recapture_zone(s_recapture_target_zone);
		var_28e07566 = s_recapture_target_zone.var_b454101b;
		level.zone_capture.recapture_target = s_recapture_target_zone.script_noteworthy;
		level.zone_capture.var_186a84eb = var_28e07566;
		s_recapture_target_zone zm_tomb_capture_zones_ffotd::recapture_event_start();
		var_28e07566 zm_attackables::activate();
		if(b_is_first_generator_attack)
		{
			s_recapture_target_zone thread monitor_recapture_zombies();
			util::delay(10, undefined, &broadcast_vo_category_to_team, "recapture_generator_attacked");
		}
		s_recapture_target_zone thread generator_under_attack_warnings();
		s_recapture_target_zone flag::set("current_recapture_target_zone");
		s_recapture_target_zone thread hide_zone_objective_while_recapture_group_runs_to_next_generator(b_is_first_generator_attack);
		s_recapture_target_zone activate_capture_zone(b_is_first_generator_attack);
		s_recapture_target_zone flag::clear("attacked_by_recapture_zombies");
		s_recapture_target_zone flag::clear("current_recapture_target_zone");
		var_28e07566 zm_attackables::deactivate();
		if(!s_recapture_target_zone flag::get("player_controlled"))
		{
			util::delay(3, undefined, &broadcast_vo_category_to_team, "recapture_started");
		}
		b_is_first_generator_attack = 0;
		s_recapture_target_zone zm_tomb_capture_zones_ffotd::recapture_event_end();
		wait(0.05);
	}
	if(s_recapture_target_zone.n_current_progress == 0 || s_recapture_target_zone.n_current_progress == 100)
	{
		s_recapture_target_zone handle_generator_capture();
	}
	capture_event_handle_ai_limit();
	kill_all_recapture_zombies();
	recapture_round_audio_ends();
	var_c746b61a = struct::get_array("generator_attackable", "targetname");
	foreach(var_b454101b in var_c746b61a)
	{
		var_b454101b zm_attackables::deactivate();
	}
	level flag::clear("recapture_event_in_progress");
	level flag::clear("generator_under_attack");
}

/*
	Name: broadcast_vo_category_to_team
	Namespace: zm_tomb_capture_zones
	Checksum: 0x77C5B782
	Offset: 0xAB78
	Size: 0x17D
	Parameters: 2
	Flags: None
*/
function broadcast_vo_category_to_team(str_category, n_delay)
{
	if(!isdefined(n_delay))
	{
		n_delay = 1;
	}
	a_players = GetPlayers();
	a_speakers = [];
	do
	{
		e_speaker = get_random_speaker(a_players);
		if(!isdefined(a_speakers))
		{
			a_speakers = [];
		}
		else if(!IsArray(a_speakers))
		{
			a_speakers = Array(a_speakers);
		}
		a_speakers[a_speakers.size] = e_speaker;
		ArrayRemoveValue(a_players, e_speaker);
		a_players = e_speaker get_players_too_far_to_hear(a_players);
	}
	while(!a_players.size > 0);
	for(i = 0; i < a_speakers.size; i++)
	{
		a_speakers[i] util::delay(n_delay, undefined, &zm_audio::create_and_play_dialog, "zone_capture", str_category);
	}
}

/*
	Name: get_players_too_far_to_hear
	Namespace: zm_tomb_capture_zones
	Checksum: 0xCEDA071
	Offset: 0xAD00
	Size: 0x14B
	Parameters: 1
	Flags: None
*/
function get_players_too_far_to_hear(a_players)
{
	a_distant = [];
	foreach(player in a_players)
	{
		if(DistanceSquared(player.origin, self.origin) > 640000 && zombie_utility::is_player_valid(player) && !player IsPlayerOnSameMachine(self))
		{
			if(!isdefined(a_distant))
			{
				a_distant = [];
			}
			else if(!IsArray(a_distant))
			{
				a_distant = Array(a_distant);
			}
			a_distant[a_distant.size] = player;
		}
	}
	return a_distant;
}

/*
	Name: get_random_speaker
	Namespace: zm_tomb_capture_zones
	Checksum: 0x9A61AF39
	Offset: 0xAE58
	Size: 0x131
	Parameters: 1
	Flags: None
*/
function get_random_speaker(a_players)
{
	if(!isdefined(a_players))
	{
		a_players = GetPlayers();
	}
	a_valid_players = [];
	foreach(player in a_players)
	{
		if(zombie_utility::is_player_valid(player))
		{
			if(!isdefined(a_valid_players))
			{
				a_valid_players = [];
			}
			else if(!IsArray(a_valid_players))
			{
				a_valid_players = Array(a_valid_players);
			}
			a_valid_players[a_valid_players.size] = player;
		}
	}
	return Array::random(a_valid_players);
}

/*
	Name: set_recapture_zombie_attack_target
	Namespace: zm_tomb_capture_zones
	Checksum: 0x783897AD
	Offset: 0xAF98
	Size: 0x4B
	Parameters: 1
	Flags: None
*/
function set_recapture_zombie_attack_target(s_recapture_target_zone)
{
	level flag::clear("generator_under_attack");
	s_recapture_target_zone flag::clear("attacked_by_recapture_zombies");
}

/*
	Name: sndrecaptureroundloop
	Namespace: zm_tomb_capture_zones
	Checksum: 0xF4A77D50
	Offset: 0xAFF0
	Size: 0x7B
	Parameters: 0
	Flags: None
*/
function sndrecaptureroundloop()
{
	level endon("sndEndRoundLoop");
	wait(5);
	ent = spawn("script_origin", (0, 0, 0));
	ent PlayLoopSound("mus_recapture_round_loop", 5);
	ent thread sndrecaptureroundloop_stop();
}

/*
	Name: sndrecaptureroundloop_stop
	Namespace: zm_tomb_capture_zones
	Checksum: 0xFC0A618B
	Offset: 0xB078
	Size: 0x53
	Parameters: 0
	Flags: None
*/
function sndrecaptureroundloop_stop()
{
	level flag::wait_till("recapture_zombies_cleared");
	self StopLoopSound(2);
	wait(2);
	self delete();
}

/*
	Name: monitor_recapture_zombie_count
	Namespace: zm_tomb_capture_zones
	Checksum: 0x461F3D55
	Offset: 0xB0D8
	Size: 0x11F
	Parameters: 0
	Flags: None
*/
function monitor_recapture_zombie_count()
{
	while(1)
	{
		level.zone_capture.recapture_zombies = Array::remove_dead(level.zone_capture.recapture_zombies);
		if(level.zone_capture.recapture_zombies.size == 0)
		{
			level flag::set("recapture_zombies_cleared");
			level flag::clear("recapture_event_in_progress");
			level flag::clear("generator_under_attack");
			if(isdefined(level.zone_capture.recapture_target))
			{
				level.zone_capture.zones[level.zone_capture.recapture_target] flag::clear("attacked_by_recapture_zombies");
				level.zone_capture.recapture_target = undefined;
			}
			break;
		}
		wait(1);
	}
}

/*
	Name: recapture_zombie_death_func
	Namespace: zm_tomb_capture_zones
	Checksum: 0x7F1AB80D
	Offset: 0xB200
	Size: 0x173
	Parameters: 0
	Flags: None
*/
function recapture_zombie_death_func()
{
	if(IS_TRUE(self.is_recapture_zombie))
	{
		level.recapture_zombies_killed++;
		if(isdefined(self.attacker) && IsPlayer(self.attacker) && level.recapture_zombies_killed == get_recapture_zombies_needed())
		{
			self.attacker thread util::delay(2, undefined, &zm_audio::create_and_play_dialog, "zone_capture", "recapture_prevented");
			foreach(player in GetPlayers())
			{
			}
		}
		else if(level.recapture_zombies_killed == get_recapture_zombies_needed() && level flag::get("generator_under_attack"))
		{
			self drop_max_ammo_at_death_location();
		}
	}
}

/*
	Name: drop_max_ammo_at_death_location
	Namespace: zm_tomb_capture_zones
	Checksum: 0xE7B28FE
	Offset: 0xB380
	Size: 0x93
	Parameters: 0
	Flags: None
*/
function drop_max_ammo_at_death_location()
{
	if(isdefined(self))
	{
		v_powerup_origin = GroundTrace(self.origin + VectorScale((0, 0, 1), 10), self.origin + VectorScale((0, 0, -1), 150), 0, undefined, 1)["position"];
	}
	if(isdefined(v_powerup_origin))
	{
		level thread zm_powerups::specific_powerup_drop("full_ammo", v_powerup_origin);
	}
}

/*
	Name: generator_under_attack_warnings
	Namespace: zm_tomb_capture_zones
	Checksum: 0x53D82B6
	Offset: 0xB420
	Size: 0x11B
	Parameters: 0
	Flags: None
*/
function generator_under_attack_warnings()
{
	level flag::wait_till_any(Array("generator_under_attack", "recapture_zombies_cleared"));
	if(!level flag::get("recapture_zombies_cleared"))
	{
		e_alarm_sound = spawn("script_origin", self.origin);
		e_alarm_sound PlayLoopSound("zmb_capturezone_losing");
		e_alarm_sound thread play_flare_effect();
		wait(0.5);
		level flag::wait_till_clear("generator_under_attack");
		e_alarm_sound StopLoopSound(0.2);
		wait(0.5);
		e_alarm_sound delete();
	}
}

/*
	Name: play_flare_effect
	Namespace: zm_tomb_capture_zones
	Checksum: 0x6892A84B
	Offset: 0xB548
	Size: 0x7D
	Parameters: 0
	Flags: None
*/
function play_flare_effect()
{
	self endon("death");
	n_end_time = GetTime() + 5000;
	while(level flag::get("generator_under_attack"))
	{
		playFX(level._effect["lght_marker_flare"], self.origin);
		wait(4);
	}
}

/*
	Name: recapture_round_audio_starts
	Namespace: zm_tomb_capture_zones
	Checksum: 0x4749ABDF
	Offset: 0xB5D0
	Size: 0x2B
	Parameters: 0
	Flags: None
*/
function recapture_round_audio_starts()
{
	level.sndMusicSpecialRound = 1;
	level thread zm_audio::sndMusicSystem_PlayState("round_start_recap");
}

/*
	Name: recapture_round_audio_ends
	Namespace: zm_tomb_capture_zones
	Checksum: 0x2305C45
	Offset: 0xB608
	Size: 0x3D
	Parameters: 0
	Flags: None
*/
function recapture_round_audio_ends()
{
	level thread zm_audio::sndMusicSystem_PlayState("round_end_recap");
	level.sndMusicSpecialRound = 0;
	level notify("sndEndRoundLoop");
}

/*
	Name: custom_vending_power_on
	Namespace: zm_tomb_capture_zones
	Checksum: 0x99EC1590
	Offset: 0xB650
	Size: 0x3
	Parameters: 0
	Flags: None
*/
function custom_vending_power_on()
{
}

/*
	Name: custom_vending_power_off
	Namespace: zm_tomb_capture_zones
	Checksum: 0x99EC1590
	Offset: 0xB660
	Size: 0x3
	Parameters: 0
	Flags: None
*/
function custom_vending_power_off()
{
}

/*
	Name: generator_initiated_vo
	Namespace: zm_tomb_capture_zones
	Checksum: 0x52B12B29
	Offset: 0xB670
	Size: 0x93
	Parameters: 0
	Flags: None
*/
function generator_initiated_vo()
{
	e_vo_origin = spawn("script_origin", self.origin);
	level.maxis_generator_vo = 1;
	e_vo_origin PlaySoundWithNotify("vox_maxi_generator_initiate_0", "vox_maxi_generator_initiate_0_done");
	e_vo_origin waittill("vox_maxi_generator_initiate_0_done");
	level.maxis_generator_vo = 0;
	e_vo_origin delete();
}

/*
	Name: zone_capture_complete_vo
	Namespace: zm_tomb_capture_zones
	Checksum: 0xC9D431C4
	Offset: 0xB710
	Size: 0xE3
	Parameters: 0
	Flags: None
*/
function zone_capture_complete_vo()
{
	e_vo_origin = spawn("script_origin", self.origin);
	e_vo_origin PlaySoundWithNotify("vox_maxi_generator_process_complete_0", "vox_maxi_generator_process_complete_0_done");
	e_vo_origin waittill("vox_maxi_generator_process_complete_0_done");
	e_vo_origin PlaySoundWithNotify("vox_maxi_generator_" + self.script_int + "_activated_0", "vox_maxi_generator_" + self.script_int + "_activated_0_done");
	e_vo_origin waittill("vox_maxi_generator_" + self.script_int + "_activated_0_done");
	e_vo_origin delete();
}

/*
	Name: generator_interrupted_vo
	Namespace: zm_tomb_capture_zones
	Checksum: 0xE8F91551
	Offset: 0xB800
	Size: 0x7B
	Parameters: 0
	Flags: None
*/
function generator_interrupted_vo()
{
	e_vo_origin = spawn("script_origin", self.origin);
	e_vo_origin PlaySoundWithNotify("vox_maxi_generator_interrupted_0", "vox_maxi_generator_interrupted_0_done");
	e_vo_origin waittill("vox_maxi_generator_interrupted_0_done");
	e_vo_origin delete();
}

/*
	Name: generator_compromised_vo
	Namespace: zm_tomb_capture_zones
	Checksum: 0xA0D3673A
	Offset: 0xB888
	Size: 0xB3
	Parameters: 0
	Flags: None
*/
function generator_compromised_vo()
{
	e_vo_origin = spawn("script_origin", self.origin);
	e_vo_origin PlaySoundWithNotify("vox_maxi_generator_" + self.script_int + "_compromised_0", "vox_maxi_generator_" + self.script_int + "_compromised_0_done");
	e_vo_origin waittill("vox_maxi_generator_" + self.script_int + "_compromised_0_done");
	e_vo_origin delete();
}

/*
	Name: generator_deactivated_vo
	Namespace: zm_tomb_capture_zones
	Checksum: 0x870DA3AE
	Offset: 0xB948
	Size: 0xB3
	Parameters: 0
	Flags: None
*/
function generator_deactivated_vo()
{
	e_vo_origin = spawn("script_origin", self.origin);
	e_vo_origin PlaySoundWithNotify("vox_maxi_generator_" + self.script_int + "_deactivated_0", "vox_maxi_generator_" + self.script_int + "_deactivated_0_done");
	e_vo_origin waittill("vox_maxi_generator_" + self.script_int + "_deactivated_0_done");
	e_vo_origin delete();
}

/*
	Name: sndplaygeneratormusicstinger
	Namespace: zm_tomb_capture_zones
	Checksum: 0xBFDF4B54
	Offset: 0xBA08
	Size: 0x43
	Parameters: 0
	Flags: None
*/
function sndplaygeneratormusicstinger()
{
	num = get_captured_zone_count();
	//level thread zm_tomb_amb::sndplaystinger("generator_" + num);
}

