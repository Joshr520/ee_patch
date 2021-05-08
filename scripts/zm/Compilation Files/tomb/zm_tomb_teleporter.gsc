#using scripts\codescripts\struct;
#using scripts\shared\ai\zombie_utility;
#using scripts\shared\array_shared;
#using scripts\shared\audio_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\exploder_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\hud_shared;
#using scripts\shared\math_shared;
#using scripts\shared\scene_shared;
#using scripts\shared\util_shared;
#using scripts\shared\visionset_mgr_shared;
#using scripts\zm\_zm_score;
#using scripts\zm\_zm_utility;
#using scripts\zm\zm_tomb_utility;
#using scripts\zm\zm_tomb_vo;

#namespace zm_tomb_teleporter;

/*
	Name: teleporter_init
	Namespace: zm_tomb_teleporter
	Checksum: 0xD465D605
	Offset: 0x760
	Size: 0x4EB
	Parameters: 0
	Flags: None
*/
function teleporter_init()
{
	clientfield::register("scriptmover", "teleporter_fx", 21000, 1, "int");
	clientfield::register("allplayers", "teleport_arrival_departure_fx", 21000, 1, "counter");
	clientfield::register("vehicle", "teleport_arrival_departure_fx", 21000, 1, "counter");
	visionset_mgr::register_info("overlay", "zm_factory_teleport", 21000, 61, 1, 1);
	level.teleport = [];
	level.n_active_links = 0;
	level.n_countdown = 0;
	level.teleport_cost = 0;
	level.is_cooldown = 0;
	level.n_active_timer = -1;
	level.n_teleport_time = 0;
	level.a_teleport_models = [];
	a_entrance_models = GetEntArray("teleport_model", "targetname");
	foreach(e_model in a_entrance_models)
	{
		e_model useanimtree(-1);
		level.a_teleport_models[e_model.script_int] = e_model;
		e_model SetIgnorePauseWorld(1);
	}
	Array::thread_all(a_entrance_models, &teleporter_samantha_chamber_line);
	a_portal_frames = GetEntArray("portal_exit_frame", "script_noteworthy");
	level.a_portal_exit_frames = [];
	foreach(e_frame in a_portal_frames)
	{
		e_frame useanimtree(-1);
		e_frame ghost();
		level.a_portal_exit_frames[e_frame.script_int] = e_frame;
		e_frame thread scene::Play("p7_fxanim_zm_ori_portal_collapse_bundle", e_frame);
	}
	level.a_teleport_exits = [];
	a_exits = struct::get_array("portal_exit", "script_noteworthy");
	foreach(s_portal in a_exits)
	{
		level.a_teleport_exits[s_portal.script_int] = s_portal;
	}
	level.a_teleport_exit_triggers = [];
	a_trigs = struct::get_array("chamber_exit_trigger", "script_noteworthy");
	foreach(s_trig in a_trigs)
	{
		level.a_teleport_exit_triggers[s_trig.script_int] = s_trig;
	}
	spawn_stargate_fx_origins();
}

/*
	Name: main
	Namespace: zm_tomb_teleporter
	Checksum: 0x7B094424
	Offset: 0xC58
	Size: 0x53
	Parameters: 0
	Flags: None
*/
function main()
{
	a_s_teleporters = struct::get_array("trigger_teleport_pad", "targetname");
	Array::thread_all(a_s_teleporters, &run_chamber_entrance_teleporter);
}

/*
	Name: teleporter_samantha_chamber_line
	Namespace: zm_tomb_teleporter
	Checksum: 0xDBC81494
	Offset: 0xCB8
	Size: 0x1BF
	Parameters: 0
	Flags: None
*/
function teleporter_samantha_chamber_line()
{
	max_dist_sq = 640000;
	level.sam_chamber_line_played = 0;
	level flag::wait_till("samantha_intro_done");
	while(!level.sam_chamber_line_played)
	{
		a_players = GetPlayers();
		foreach(e_player in a_players)
		{
			dist_sq = Distance2DSquared(self.origin, e_player.origin);
			height_diff = Abs(self.origin[2] - e_player.origin[2]);
			if(dist_sq < max_dist_sq && height_diff < 150 && (!isdefined(e_player.isSpeaking) && e_player.isSpeaking))
			{
				level thread play_teleporter_samantha_chamber_line(e_player);
				return;
			}
		}
		wait(0.1);
	}
}

/*
	Name: play_teleporter_samantha_chamber_line
	Namespace: zm_tomb_teleporter
	Checksum: 0x9255FF40
	Offset: 0xE80
	Size: 0xF3
	Parameters: 1
	Flags: None
*/
function play_teleporter_samantha_chamber_line(e_player)
{
	if(level.sam_chamber_line_played)
	{
		return;
	}
	level.sam_chamber_line_played = 1;
	level flag::wait_till_clear("story_vo_playing");
	level flag::set("story_vo_playing");
	zm_tomb_vo::set_players_dontspeak(1);
	zm_tomb_vo::samanthasay("vox_sam_enter_chamber_1_0", e_player, 1);
	zm_tomb_vo::samanthasay("vox_sam_enter_chamber_2_0", e_player);
	zm_tomb_vo::set_players_dontspeak(0);
	level flag::clear("story_vo_playing");
}

/*
	Name: run_chamber_exit
	Namespace: zm_tomb_teleporter
	Checksum: 0x9569B4A7
	Offset: 0xF80
	Size: 0x617
	Parameters: 1
	Flags: None
*/
function run_chamber_exit(n_enum)
{
	s_portal = level.a_teleport_exits[n_enum];
	s_activate_pos = level.a_teleport_exit_triggers[n_enum];
	e_portal_frame = level.a_portal_exit_frames[n_enum];
	e_portal_frame show();
	str_building_flag = e_portal_frame.targetname + "_building";
	level flag::init(str_building_flag);
	s_activate_pos.trigger_stub = zm_tomb_utility::tomb_spawn_trigger_radius(s_activate_pos.origin, 50, 1);
	s_activate_pos.trigger_stub zm_tomb_utility::set_unitrigger_hint_string(&"ZM_TOMB_TELE");
	s_portal.target = s_activate_pos.target;
	s_portal.origin = e_portal_frame GetTagOrigin("fx_portal_jnt");
	s_portal.angles = e_portal_frame GetTagAngles("fx_portal_jnt");
	str_fx = zm_tomb_utility::get_teleport_fx_from_enum(n_enum);
	collapse_time = getanimlength(%p7_fxanim_zm_ori_portal_collapse_anim);
	open_time = getanimlength(%p7_fxanim_zm_ori_portal_open_anim);
	var_ff7119bc = undefined;
	switch(s_portal.targetname)
	{
		case "portal_exit_fire":
		{
			var_ff7119bc = "p7_fxanim_zm_ori_portal_open_fire_bundle";
			break;
		}
		case "portal_exit_air":
		{
			var_ff7119bc = "p7_fxanim_zm_ori_portal_open_air_bundle";
			break;
		}
		case "portal_exit_ice":
		{
			var_ff7119bc = "p7_fxanim_zm_ori_portal_open_ice_bundle";
			break;
		}
		case "portal_exit_electric":
		{
			var_ff7119bc = "p7_fxanim_zm_ori_portal_open_elec_bundle";
			break;
		}
		case default:
		{
			break;
		}
	}
	level flag::wait_till("start_zombie_round_logic");
	while(1)
	{
		s_activate_pos.trigger_stub waittill("trigger", e_player);
		if(!zombie_utility::is_player_valid(e_player))
		{
			continue;
		}
		if(e_player.score < level.teleport_cost)
		{
			continue;
		}
		s_activate_pos.trigger_stub zm_tomb_utility::set_unitrigger_hint_string("");
		if(level.teleport_cost > 0)
		{
			e_player zm_score::minus_to_player_score(level.teleport_cost);
		}
		e_portal_frame PlayLoopSound("zmb_teleporter_loop_pre", 1);
		e_portal_frame thread scene::Play(var_ff7119bc, e_portal_frame);
		level flag::set(str_building_flag);
		e_portal_frame thread zm_tomb_utility::whirlwind_rumble_nearby_players(str_building_flag);
		wait(open_time);
		e_portal_frame thread scene::Play("p7_fxanim_zm_ori_portal_open_1frame_bundle", e_portal_frame);
		util::wait_network_frame();
		level flag::clear(str_building_flag);
		e_fx = spawn("script_model", s_portal.origin);
		e_fx.angles = s_portal.angles + VectorScale((0, 1, 0), 180);
		e_fx SetModel("tag_origin");
		e_fx clientfield::set("element_glow_fx", n_enum + 4);
		zm_tomb_utility::rumble_nearby_players(e_fx.origin, 1000, 2);
		e_portal_frame PlayLoopSound("zmb_teleporter_loop_post", 1);
		s_portal thread teleporter_radius_think();
		wait(20);
		e_portal_frame thread scene::Play("p7_fxanim_zm_ori_portal_collapse_bundle", e_portal_frame);
		e_portal_frame StopLoopSound(0.5);
		e_portal_frame playsound("zmb_teleporter_anim_collapse_pew");
		s_portal notify("teleporter_radius_stop");
		e_fx clientfield::set("element_glow_fx", 0);
		wait(collapse_time);
		e_fx delete();
		s_activate_pos.trigger_stub zm_tomb_utility::set_unitrigger_hint_string(&"ZM_TOMB_TELE");
	}
}

/*
	Name: run_chamber_entrance_teleporter
	Namespace: zm_tomb_teleporter
	Checksum: 0x4DACA049
	Offset: 0x15A0
	Size: 0x61F
	Parameters: 0
	Flags: None
*/
function run_chamber_entrance_teleporter()
{
	self endon("death");
	fx_glow = zm_tomb_utility::get_teleport_fx_from_enum(self.script_int);
	e_model = level.a_teleport_models[self.script_int];
	self.origin = e_model GetTagOrigin("fx_portal_jnt");
	self.angles = e_model GetTagAngles("fx_portal_jnt");
	self.angles = (self.angles[0], self.angles[1] + 180, self.angles[2]);
	self.trigger_stub = zm_tomb_utility::tomb_spawn_trigger_radius(self.origin - VectorScale((0, 0, 1), 30), 50);
	level flag::init("enable_teleporter_" + self.script_int);
	str_building_flag = "teleporter_building_" + self.script_int;
	level flag::init(str_building_flag);
	collapse_time = getanimlength(%p7_fxanim_zm_ori_portal_collapse_anim);
	open_time = getanimlength(%p7_fxanim_zm_ori_portal_open_anim);
	level flag::wait_till("start_zombie_round_logic");
	e_model thread scene::Play("p7_fxanim_zm_ori_portal_collapse_bundle", e_model);
	wait(collapse_time);
	while(1)
	{
		level flag::wait_till("enable_teleporter_" + self.script_int);
		level flag::set(str_building_flag);
		var_babde23d = undefined;
		var_ff7119bc = undefined;
		switch(self.target)
		{
			case "fire_teleport_player":
			{
				var_babde23d = "lgtexp_fireCave_fade";
				var_ff7119bc = "p7_fxanim_zm_ori_portal_open_fire_bundle";
				break;
			}
			case "air_teleport_player":
			{
				var_babde23d = "lgtexp_airCave_fade";
				var_ff7119bc = "p7_fxanim_zm_ori_portal_open_air_bundle";
				break;
			}
			case "water_teleport_player":
			{
				var_babde23d = "lgtexp_iceCave_fade";
				var_ff7119bc = "p7_fxanim_zm_ori_portal_open_ice_bundle";
				break;
			}
			case "electric_teleport_player":
			{
				var_babde23d = "lgtexp_elecCave_fade";
				var_ff7119bc = "p7_fxanim_zm_ori_portal_open_elec_bundle";
				break;
			}
			case default:
			{
				break;
			}
		}
		e_model thread zm_tomb_utility::whirlwind_rumble_nearby_players(str_building_flag);
		if(isdefined(var_ff7119bc))
		{
			e_model thread scene::Play(var_ff7119bc, e_model);
		}
		e_model PlayLoopSound("zmb_teleporter_loop_pre", 1);
		wait(open_time);
		e_model thread scene::Play("p7_fxanim_zm_ori_portal_open_1frame_bundle", e_model);
		util::wait_network_frame();
		e_fx = spawn("script_model", self.origin);
		e_fx.angles = self.angles;
		e_fx SetModel("tag_origin");
		e_fx clientfield::set("element_glow_fx", self.script_int + 4);
		zm_tomb_utility::rumble_nearby_players(e_fx.origin, 1000, 2);
		e_model PlayLoopSound("zmb_teleporter_loop_post", 1);
		if(isdefined(var_babde23d))
		{
			exploder::exploder(var_babde23d);
		}
		if(!(isdefined(self.exit_enabled) && self.exit_enabled))
		{
			self.exit_enabled = 1;
			level thread run_chamber_exit(self.script_int);
		}
		self thread stargate_teleport_think();
		level flag::clear(str_building_flag);
		level flag::wait_till_clear("enable_teleporter_" + self.script_int);
		level notify("disable_teleporter_" + self.script_int);
		e_fx clientfield::set("element_glow_fx", 0);
		e_model StopLoopSound(0.5);
		e_model playsound("zmb_teleporter_anim_collapse_pew");
		e_model thread scene::Play("p7_fxanim_zm_ori_portal_collapse_bundle", e_model);
		if(isdefined(var_babde23d))
		{
			exploder::kill_exploder(var_babde23d);
		}
		wait(collapse_time);
		e_fx delete();
	}
}

/*
	Name: teleporter_radius_think
	Namespace: zm_tomb_teleporter
	Checksum: 0xBEAD5EB0
	Offset: 0x1BC8
	Size: 0x1F7
	Parameters: 1
	Flags: None
*/
function teleporter_radius_think(radius)
{
	if(!isdefined(radius))
	{
		radius = 120;
	}
	self endon("teleporter_radius_stop");
	radius_sq = radius * radius;
	while(1)
	{
		a_players = GetPlayers();
		foreach(e_player in a_players)
		{
			dist_sq = DistanceSquared(e_player.origin, self.origin);
			if(dist_sq < radius_sq && e_player GetStance() != "prone" && (!isdefined(e_player.teleporting) && e_player.teleporting))
			{
				playFX(level._effect["teleport_3p"], self.origin, (1, 0, 0), (0, 0, 1));
				playsoundatposition("zmb_teleporter_tele_3d", self.origin);
				level thread stargate_teleport_player(self.target, e_player, 5);
			}
		}
		util::wait_network_frame();
	}
}

/*
	Name: stargate_teleport_think
	Namespace: zm_tomb_teleporter
	Checksum: 0x246970BA
	Offset: 0x1DC8
	Size: 0x147
	Parameters: 0
	Flags: None
*/
function stargate_teleport_think()
{
	self endon("death");
	level endon("disable_teleporter_" + self.script_int);
	e_potal = level.a_teleport_models[self.script_int];
	while(1)
	{
		self.trigger_stub waittill("trigger", e_player);
		if(e_player GetStance() != "prone" && (!isdefined(e_player.teleporting) && e_player.teleporting))
		{
			playFX(level._effect["teleport_3p"], self.origin, (1, 0, 0), (0, 0, 1));
			playsoundatposition("zmb_teleporter_tele_3d", self.origin);
			level notify("player_teleported", e_player, self.script_int);
			level thread stargate_teleport_player(self.target, e_player);
		}
	}
}

/*
	Name: stargate_teleport_enable
	Namespace: zm_tomb_teleporter
	Checksum: 0xFF792546
	Offset: 0x1F18
	Size: 0x2B
	Parameters: 1
	Flags: None
*/
function stargate_teleport_enable(n_index)
{
	level flag::set("enable_teleporter_" + n_index);
}

/*
	Name: stargate_teleport_disable
	Namespace: zm_tomb_teleporter
	Checksum: 0x7247448C
	Offset: 0x1F50
	Size: 0x2B
	Parameters: 1
	Flags: None
*/
function stargate_teleport_disable(n_index)
{
	level flag::clear("enable_teleporter_" + n_index);
}

/*
	Name: stargate_play_fx
	Namespace: zm_tomb_teleporter
	Checksum: 0x3DAC4BB3
	Offset: 0x1F88
	Size: 0x5B
	Parameters: 0
	Flags: None
*/
function stargate_play_fx()
{
	self.e_fx clientfield::set("teleporter_fx", 1);
	self waittill("stop_teleport_fx");
	self.e_fx clientfield::set("teleporter_fx", 0);
}

/*
	Name: spawn_stargate_fx_origins
	Namespace: zm_tomb_teleporter
	Checksum: 0x21494F7E
	Offset: 0x1FF0
	Size: 0x17D
	Parameters: 0
	Flags: None
*/
function spawn_stargate_fx_origins()
{
	a_teleport_positions = struct::get_array("teleport_room", "script_noteworthy");
	foreach(s_teleport in a_teleport_positions)
	{
		v_fx_pos = s_teleport.origin + (0, 0, 64) + AnglesToForward(s_teleport.angles) * 120;
		s_teleport.e_fx = spawn("script_model", v_fx_pos);
		s_teleport.e_fx SetModel("tag_origin");
		s_teleport.e_fx.angles = s_teleport.angles + VectorScale((0, 1, 0), 180);
	}
}

/*
	Name: stargate_teleport_player
	Namespace: zm_tomb_teleporter
	Checksum: 0x3E21FBA1
	Offset: 0x2178
	Size: 0x6EB
	Parameters: 4
	Flags: None
*/
function stargate_teleport_player(str_teleport_to, player, n_teleport_time_sec, show_fx)
{
	if(!isdefined(n_teleport_time_sec))
	{
		n_teleport_time_sec = 2;
	}
	if(!isdefined(show_fx))
	{
		show_fx = 1;
	}
	player.teleporting = 1;
	player clientfield::increment("teleport_arrival_departure_fx");
	if(show_fx)
	{
		player thread hud::fade_to_black_for_x_sec(0, 0.3, 0, 0.5, "white");
		util::wait_network_frame();
	}
	n_pos = player.characterindex;
	prone_offset = VectorScale((0, 0, 1), 49);
	crouch_offset = VectorScale((0, 0, 1), 20);
	stand_offset = (0, 0, 0);
	image_room = struct::get("teleport_room_" + n_pos, "targetname");
	player disableOffhandWeapons();
	player DisableWeapons();
	player FreezeControls(1);
	util::wait_network_frame();
	var_64103691 = struct::get_array(str_teleport_to, "targetname");
	n_total_time = n_teleport_time_sec + 4;
	player zm_utility::create_streamer_hint(struct::get_array(str_teleport_to, "targetname")[0].origin, struct::get_array(str_teleport_to, "targetname")[0].angles, 1, n_total_time);
	if(player GetStance() == "prone")
	{
		desired_origin = image_room.origin + prone_offset;
	}
	else if(player GetStance() == "crouch")
	{
		desired_origin = image_room.origin + crouch_offset;
	}
	else
	{
		desired_origin = image_room.origin + stand_offset;
	}
	player.teleport_origin = spawn("script_model", player.origin);
	player.teleport_origin SetModel("tag_origin");
	player.teleport_origin.angles = player.angles;
	player PlayerLinkToAbsolute(player.teleport_origin, "tag_origin");
	player.teleport_origin.origin = desired_origin;
	player.teleport_origin.angles = image_room.angles;
	if(show_fx)
	{
		player playsoundtoplayer("zmb_teleporter_plr_start", player);
	}
	util::wait_network_frame();
	player.teleport_origin.angles = image_room.angles;
	if(show_fx)
	{
		image_room thread stargate_play_fx();
		visionset_mgr::activate("overlay", "zm_factory_teleport", player);
	}
	var_c5af343b = 0.5;
	wait(n_teleport_time_sec - var_c5af343b);
	if(show_fx)
	{
		player thread hud::fade_to_black_for_x_sec(0, var_c5af343b + 0.3, 0, 0.5, "white");
		util::wait_network_frame();
	}
	image_room notify("stop_teleport_fx");
	a_pos = struct::get_array(str_teleport_to, "targetname");
	s_pos = get_free_teleport_pos(player, a_pos);
	player Unlink();
	if(isdefined(player.teleport_origin))
	{
		player.teleport_origin delete();
		player.teleport_origin = undefined;
	}
	player SetOrigin(s_pos.origin);
	player SetPlayerAngles(s_pos.angles);
	player enableWeapons();
	player EnableOffhandWeapons();
	player FreezeControls(0);
	visionset_mgr::deactivate("overlay", "zm_factory_teleport", player);
	if(show_fx)
	{
		player playsoundtoplayer("zmb_teleporter_plr_end", player);
	}
	player.teleporting = 0;
	player clientfield::increment("teleport_arrival_departure_fx");
	player notify("hash_327f029");
}

/*
	Name: is_teleport_landing_valid
	Namespace: zm_tomb_teleporter
	Checksum: 0xBC98AC65
	Offset: 0x2870
	Size: 0xF1
	Parameters: 2
	Flags: None
*/
function is_teleport_landing_valid(s_pos, n_radius)
{
	n_radius_sq = n_radius * n_radius;
	a_players = GetPlayers();
	foreach(e_player in a_players)
	{
		if(Distance2DSquared(s_pos.origin, e_player.origin) < n_radius_sq)
		{
			return 0;
		}
	}
	return 1;
}

/*
	Name: get_free_teleport_pos
	Namespace: zm_tomb_teleporter
	Checksum: 0x36C867A9
	Offset: 0x2970
	Size: 0xEF
	Parameters: 2
	Flags: None
*/
function get_free_teleport_pos(player, a_structs)
{
	n_player_radius = 64;
	while(1)
	{
		a_players = GetPlayers();
		foreach(s_pos in a_structs)
		{
			if(is_teleport_landing_valid(s_pos, n_player_radius))
			{
				return s_pos;
			}
		}
		wait(0.05);
	}
}

