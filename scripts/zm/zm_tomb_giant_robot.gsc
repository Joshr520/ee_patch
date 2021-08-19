#using scripts\codescripts\struct;
#using scripts\shared\ai\zombie_utility;
#using scripts\shared\array_shared;
#using scripts\shared\audio_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\exploder_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\hud_shared;
#using scripts\shared\laststand_shared;
#using scripts\shared\math_shared;
#using scripts\shared\scene_shared;
#using scripts\shared\util_shared;
#using scripts\zm\_zm;
#using scripts\zm\_zm_audio;
#using scripts\zm\_zm_bgb;
#using scripts\zm\_zm_clone;
#using scripts\zm\_zm_laststand;
#using scripts\zm\_zm_stats;
#using scripts\zm\_zm_unitrigger;
#using scripts\zm\_zm_utility;
//#using scripts\zm\_zm_weap_one_inch_punch;
#using scripts\zm\_zm_zonemgr;
//#using scripts\zm\zm_tomb_amb;
//#using scripts\zm\zm_tomb_mech;
//#using scripts\zm\zm_tomb_teleporter;
//#using scripts\zm\zm_tomb_vo;

#using scripts\shared\ai\zombie_shared;
#using scripts\shared\visionset_mgr_shared;

#insert scripts\shared\shared.gsh;

#using_animtree( "generic" );

#namespace zm_tomb_giant_robot;

function init_giant_robot_glows()
{
	level flag::init("foot_shot");
	level flag::init("three_robot_round");
	level flag::init("fire_link_enabled");
	level flag::init("timeout_vo_robot_0");
	level flag::init("timeout_vo_robot_1");
	level flag::init("timeout_vo_robot_2");
	level flag::init("all_robot_hatch");
	level.gr_foot_hatch_closed = [];
	level.gr_foot_hatch_closed[0] = 1;
	level.gr_foot_hatch_closed[1] = 1;
	level.gr_foot_hatch_closed[2] = 1;
	a_gr_head_triggers = struct::get_array("giant_robot_head_exit_trigger", "script_noteworthy");
	foreach(struct in a_gr_head_triggers)
	{
		gr_head_exit_trigger_start(struct);
	}
	level thread handle_wind_tunnel_bunker_collision();
	level thread handle_tank_bunker_collision();
}

function init_giant_robot()
{
	clientfield::register("scriptmover", "register_giant_robot", 21000, 1, "int");
	clientfield::register("world", "start_anim_robot_0", 21000, 1, "int");
	clientfield::register("world", "start_anim_robot_1", 21000, 1, "int");
	clientfield::register("world", "start_anim_robot_2", 21000, 1, "int");
	clientfield::register("world", "play_foot_stomp_fx_robot_0", 21000, 2, "int");
	clientfield::register("world", "play_foot_stomp_fx_robot_1", 21000, 2, "int");
	clientfield::register("world", "play_foot_stomp_fx_robot_2", 21000, 2, "int");
	clientfield::register("world", "play_foot_open_fx_robot_0", 21000, 2, "int");
	clientfield::register("world", "play_foot_open_fx_robot_1", 21000, 2, "int");
	clientfield::register("world", "play_foot_open_fx_robot_2", 21000, 2, "int");
	clientfield::register("world", "eject_warning_fx_robot_0", 21000, 1, "int");
	clientfield::register("world", "eject_warning_fx_robot_1", 21000, 1, "int");
	clientfield::register("world", "eject_warning_fx_robot_2", 21000, 1, "int");
	clientfield::register("scriptmover", "light_foot_fx_robot", 21000, 2, "int");
	clientfield::register("allplayers", "eject_steam_fx", 21000, 1, "int");
	clientfield::register("allplayers", "all_tubes_play_eject_steam_fx", 21000, 1, "int");
	clientfield::register("allplayers", "gr_eject_player_impact_fx", 21000, 1, "int");
	clientfield::register("toplayer", "giant_robot_rumble_and_shake", 21000, 2, "int");
	clientfield::register("world", "church_ceiling_fxanim", 21000, 1, "int");
	level thread giant_robot_initial_spawns();
	level thread setup_giant_robots_intermission();
	init_footstep_safe_spots();
}

function init_footstep_safe_spots()
{
	level.giant_robot_footstep_safe_spots = [];
	make_safe_spot_trigger_box_at_point((-493, -198, 389), (0, 0, 0), 80, 64, 150);
}

function make_safe_spot_trigger_box_at_point(v_origin, v_angles, n_length, n_width, n_height)
{
	trig = spawn("trigger_box", v_origin, 0, n_length, n_width, n_height);
	trig.angles = v_angles;
	MAKE_ARRAY(level.giant_robot_footstep_safe_spots)
	level.giant_robot_footstep_safe_spots[level.giant_robot_footstep_safe_spots.size] = trig;
}

function tomb_can_revive_override(player_down)
{
	if(IS_TRUE(player_down.is_stomped))
	{
		return 0;
	}
	return 1;
}

function giant_robot_initial_spawns()
{
	while(!level flag::exists("start_zombie_round_logic"))
	{
		wait(0.5);
	}
	level flag::wait_till("start_zombie_round_logic");
	level.a_giant_robots = [];
	for(i = 0; i < 3; i++)
	{
		level.gr_foot_hatch_closed[i] = 1;
		trig_stomp_kill_right = GetEnt("trig_stomp_kill_right_" + i, "targetname");
		trig_stomp_kill_left = GetEnt("trig_stomp_kill_left_" + i, "targetname");
		trig_stomp_kill_right EnableLinkTo();
		trig_stomp_kill_left EnableLinkTo();
		clip_foot_right = GetEnt("clip_foot_right_" + i, "targetname");
		clip_foot_left = GetEnt("clip_foot_left_" + i, "targetname");
		ai = GetEnt("giant_robot_" + i, "targetname");
		ai SetIgnorePauseWorld(1);
		ai.v_start_origin = ai.origin;
		ai.is_giant_robot = 1;
		ai.giant_robot_id = i;
		ai.ignore_enemy_count = 1;
		tag_right_foot = ai GetTagOrigin("TAG_ATTACH_HATCH_RI");
		tag_left_foot = ai GetTagOrigin("TAG_ATTACH_HATCH_LE");
		if(ai.targetname == "giant_robot_1")
		{
			n_offset = 80;
		}
		else
		{
			n_offset = 72;
		}
		trig_stomp_kill_right.origin = tag_right_foot + (0, 0, n_offset);
		trig_stomp_kill_right.angles = ai GetTagAngles("TAG_ATTACH_HATCH_RI");
		trig_stomp_kill_left.origin = tag_left_foot + (0, 0, n_offset);
		trig_stomp_kill_left.angles = ai GetTagAngles("TAG_ATTACH_HATCH_LE");
		wait(0.1);
		trig_stomp_kill_right LinkTo(ai, "tag_attach_hatch_ri", (0, 0, n_offset));
		util::wait_network_frame();
		trig_stomp_kill_left LinkTo(ai, "tag_attach_hatch_le", (0, 0, n_offset));
		util::wait_network_frame();
		ai.trig_stomp_kill_right = trig_stomp_kill_right;
		ai.trig_stomp_kill_left = trig_stomp_kill_left;
		clip_foot_right.origin = tag_right_foot + (0, 0, 0);
		clip_foot_left.origin = tag_left_foot + (0, 0, 0);
		clip_foot_right.angles = ai GetTagAngles("TAG_ATTACH_HATCH_RI");
		clip_foot_left.angles = ai GetTagAngles("TAG_ATTACH_HATCH_LE");
		wait(0.1);
		clip_foot_right LinkTo(ai, "tag_attach_hatch_ri", (0, 0, 0));
		util::wait_network_frame();
		clip_foot_left LinkTo(ai, "tag_attach_hatch_le", (0, 0, 0));
		util::wait_network_frame();
		ai.clip_foot_right = clip_foot_right;
		ai.clip_foot_left = clip_foot_left;
		ai.is_zombie = 0;
		ai.animName = "giant_robot_walker";
		ai.script_noteworthy = "giant_robot";
		ai.audio_type = "giant_robot";
		ai.ignoreall = 1;
		ai.ignoreme = 1;
		ai.ignore_game_over_death = 1;
		ai SetCanDamage(0);
		ai SetPlayerCollision(1);
		ai SetForceNoCull();
		ai clientfield::set("register_giant_robot", 1);
		ai Ghost();
		ai flag::init("robot_head_entered");
		ai flag::init("kill_trigger_active");
		level.a_giant_robots[i] = ai;
		util::wait_network_frame();
	}
	level thread robot_cycling();
}

function robot_cycling() //Want to improve so its less hardcode and more dependent on how the game is being played out
{

	three_robot_round = 0;
	last_robot = -1;
	level thread giant_robot_intro_walk( 1 );

	orderIndex = 0;
	order = [];

	//Perfect wind
	order[0] = 1; //  0:40   thor
	order[1] = 2; //  2:40   freya
	order[2] = 0; //  4:40   odin
	order[3] = 1; //  6:40   thor

	//Random cycling since wind parts should be collected
	order[4] = 0;  //  8:40    
	order[5] = 2;  //  10:40   
	order[6] = 1;  //  12:40   
	order[7] = 2;  //  14:40   
	order[8] = 1;  //  16:40   
	order[9] = 2;  //  18:40   
	order[10] = 1; //  20:40   
	order[11] = 2; //  22:40   

	//AFD cycles. These are now replaced by logic later in this function.
	order[12] = 1; //  24:40   thor
	order[13] = 2; //  26:40   freya
	order[14] = 0; //  28:40   odin
	order[15] = 1; //  30:40   thor
	order[16] = 2; //  32:40   freya

	//Alternate between freya and thor so boxes don't get stepped on
	order[17] = 2; //  34:40   
	order[18] = 1; //  36:40   
	order[19] = 2; //  38:40   
	order[20] = 1; //  40:40   
	order[21] = 2; //  42:40   
	order[22] = 1; //  44:40   
	order[23] = 2; //  46:40   
	order[24] = 1; //  48:40   
	order[25] = 2; //  50:40   
	order[26] = 1; //  52:40   
	order[27] = 2; //  54:40   
	order[28] = 1; //  56:40   
	order[29] = 2; //  58:40   

	level waittill( "giant_robot_intro_complete" );
	while(1)
	{
		if(level.round_number % 4 == 0 && three_robot_round != level.round_number)
		{
			//IPrintLnBold("Three robot round. Set flag to three_robot_round");
			level flag::set("three_robot_round");
		}
		if(level flag::get("ee_all_staffs_placed") && !level flag::get("ee_mech_zombie_hole_opened"))
		{
			level flag::set("three_robot_round");
		}
		/#
			if(isdefined(level.devgui_force_three_robot_round) && level.devgui_force_three_robot_round)
			{
				level flag::set( "three_robot_round" );
			}
		#/

		//If its a three robot round, dont send another round of trios
		if(level flag::get("three_robot_round"))
		{
			level.zombie_ai_limit = 22;
			//random_number = RandomInt(3);

			//If user is doing gstrike 2 on 16, then we want Thor to be the trios robot. Otherwise, spawn Odin
			if (level.round_number == 12) {
				random_number = 2;
			} else if (level.round_number == 4) {
				random_number = 2;
			} else if (level.n_ee_robot_staffs_planted == 3) {
				random_number = 1;
			} else {
				random_number = 0;
			}

			//Replace order[orderIndex] with trios
			orderIndex++;
			

			if(random_number == 2 || level flag::get("all_robot_hatch"))
			{
				level thread giant_robot_start_walk(2);
			}
			else
			{
				level thread giant_robot_start_walk(2, 0);
			}
			wait(5);
			if(random_number == 0 || level flag::get("all_robot_hatch"))
			{
				level thread giant_robot_start_walk(0);
			}
			else
			{
				level thread giant_robot_start_walk(0, 0);
			}
			wait(5);
			if(random_number == 1 || level flag::get("all_robot_hatch"))
			{
				level thread giant_robot_start_walk(1);
			}
			else
			{
				level thread giant_robot_start_walk(1, 0);
			}
			level waittill("giant_robot_walk_cycle_complete");
			level waittill("giant_robot_walk_cycle_complete");
			level waittill("giant_robot_walk_cycle_complete");
			wait(5);

			random_number = order[orderIndex];
			level.zombie_ai_limit = 24;
			three_robot_round = level.round_number;
			last_robot = -1;
			level flag::clear("three_robot_round");
		}

		//If the staffs aren't upgraded, do cycling according to the hardcoded values on order[]
		else if (!flag::get("ee_all_staffs_upgraded") && !flag::get("ee_mech_zombie_hole_opened")) 
		{
			random_number = order[orderIndex];
			orderIndex++;
			last_robot = random_number;
			level thread giant_robot_start_walk(random_number);
			level waittill("giant_robot_walk_cycle_complete");
			wait(5);
		}

		//If the staffs are upgraded, we want to place ice first (will be first, so no staffs planted prior to). 
		else if(flag::get("ee_all_staffs_upgraded") && level.n_ee_robot_staffs_planted == 0 ) {
			//Spawn box foot Freya
			random_number = 2;
			orderIndex++;
			last_robot = random_number;
			level thread giant_robot_start_walk(random_number);
			level waittill("giant_robot_walk_cycle_complete");
			wait(5);
		} 

		//Check if staffs are upgraded and user has placed either just ice or if user has placed ice and/or fire If so, spawn odin.
		else if (flag::get("ee_all_staffs_upgraded") && (level.n_ee_robot_staffs_planted == 1 || level.n_ee_robot_staffs_planted == 2)) {
			//Spawn wind tunnel Odin
			random_number = 0;
			orderIndex++;
			last_robot = random_number;
			level thread giant_robot_start_walk(random_number);
			level waittill("giant_robot_walk_cycle_complete");
			wait(5);
		} 

		//Check if staffs are upgraded and user has placed all staffs but lightning. If so, check round and spawn thor
		else if (flag::get("ee_all_staffs_upgraded") && level.n_ee_robot_staffs_planted == 3) {
			//Spawn Gen 2 Thor
			random_number = 1;
			orderIndex++;
			last_robot = random_number;
			level thread giant_robot_start_walk(random_number);
			level waittill("giant_robot_walk_cycle_complete");
			wait(5);
		}

		//When rain fire is completed, the panzer hole will be opened. After this happens, we want the cycling to return to a repetition of thor and freya.
		else if (flag::get("ee_mech_zombie_hole_opened")) {
			random_number = order[orderIndex];
			orderIndex++;
			last_robot = random_number;
			level thread giant_robot_start_walk(random_number);
			level waittill("giant_robot_walk_cycle_complete");
			wait(5);
		}
	}
}

function giant_robot_intro_walk(n_robot_id)
{
	ai = GetEnt("giant_robot_" + n_robot_id, "targetname");
	ai Attach("veh_t7_zhd_robot_foot_hatch", "TAG_ATTACH_HATCH_LE");
	ai Attach("veh_t7_zhd_robot_foot_hatch", "TAG_ATTACH_HATCH_RI");
	ai thread giant_robot_think(ai.trig_stomp_kill_right, ai.trig_stomp_kill_left, ai.clip_foot_right, ai.clip_foot_left, undefined, 3);
	PlaySoundAtPosition("evt_footfall_robot_intro", (0, 0, 0));
	wait(0.5);
	exploder::exploder("fxexp_420");
	a_players = GetPlayers();
	foreach(player in a_players)
	{
		player clientfield::set_to_player("giant_robot_rumble_and_shake", 3);
		player thread turn_clientside_rumble_off();
	}
	level waittill("giant_robot_walk_cycle_complete");
	level notify("giant_robot_intro_complete");
}

function giant_robot_start_walk(n_robot_id, b_has_hatch)
{
	if(!isdefined(b_has_hatch))
	{
		b_has_hatch = 1;
	}
	ai = GetEnt("giant_robot_" + n_robot_id, "targetname");
	level.gr_foot_hatch_closed[n_robot_id] = 1;
	ai.b_has_hatch = b_has_hatch;
	ai flag::clear("kill_trigger_active");
	ai flag::clear("robot_head_entered");
	if(isdefined(ai.b_has_hatch) && ai.b_has_hatch)
	{
		m_sole = GetEnt("target_sole_" + n_robot_id, "targetname");
	}
	if(isdefined(m_sole) && (isdefined(ai.b_has_hatch) && ai.b_has_hatch))
	{
		m_sole SetCanDamage(1);
		m_sole.health = 99999;
		m_sole UseAnimTree(-1);
		m_sole Unlink();
	}
	wait(10);
	if(isdefined(m_sole))
	{
		//Want gen 6 freya (right foot) for the second cycle and left foot for everything else during the run
		if (n_robot_id == 2 && level.round_number < 10) {
			ai.hatch_foot = "right";
		} 
		else {
			ai.hatch_foot = "left";
		}
	
		/#
			if(isdefined(level.devgui_force_giant_robot_foot) && (isdefined(ai.b_has_hatch) && ai.b_has_hatch))
			{
				ai.hatch_foot = level.devgui_force_giant_robot_foot;
			}
		#/
		if(ai.hatch_foot == "left")
		{
			n_sole_origin = ai GetTagOrigin("TAG_ATTACH_HATCH_LE");
			v_sole_angles = ai GetTagAngles("TAG_ATTACH_HATCH_LE");
			ai.hatch_foot = "left";
			str_sole_tag = "tag_attach_hatch_le";
			ai Attach("veh_t7_zhd_robot_foot_hatch", "TAG_ATTACH_HATCH_RI");
		}
		else if(ai.hatch_foot == "right")
		{
			n_sole_origin = ai GetTagOrigin("TAG_ATTACH_HATCH_RI");
			v_sole_angles = ai GetTagAngles("TAG_ATTACH_HATCH_RI");
			ai.hatch_foot = "right";
			str_sole_tag = "tag_attach_hatch_ri";
			ai Attach("veh_t7_zhd_robot_foot_hatch", "TAG_ATTACH_HATCH_LE");
		}
		m_sole.origin = n_sole_origin;
		m_sole.angles = v_sole_angles;
		wait(0.1);
		m_sole LinkTo(ai, str_sole_tag, (0, 0, 0));
		m_sole show();
	}
	if(!(isdefined(ai.b_has_hatch) && ai.b_has_hatch))
	{
		ai Attach("veh_t7_zhd_robot_foot_hatch", "TAG_ATTACH_HATCH_RI");
		ai Attach("veh_t7_zhd_robot_foot_hatch", "TAG_ATTACH_HATCH_LE");
	}
	wait(0.05);
	ai thread giant_robot_think(ai.trig_stomp_kill_right, ai.trig_stomp_kill_left, ai.clip_foot_right, ai.clip_foot_left, m_sole, n_robot_id);
}

function giant_robot_think(trig_stomp_kill_right, trig_stomp_kill_left, clip_foot_right, clip_foot_left, m_sole, n_robot_id)
{
	self thread robot_walk_animation(n_robot_id);
	if(isdefined(self.hatch_foot) && IS_TRUE(self.b_has_hatch))
	{
		switch(self.hatch_foot)
		{
			case "left":
			{
				self clientfield::set("light_foot_fx_robot", 1);
				break;
			}
			case "right":
			{
				self clientfield::set("light_foot_fx_robot", 2);
				break;
			}
			default:
			{
				self clientfield::set("light_foot_fx_robot", 0);
				break;
			}
		}
	}
	else
	{
		self clientfield::set("light_foot_fx_robot", 0);
	}
	self Show();
	if(isdefined(m_sole))
	{
		self thread sole_cleanup(m_sole);
	}
	self.is_walking = 1;
	self thread monitor_footsteps(trig_stomp_kill_right, "right");
	self thread monitor_footsteps(trig_stomp_kill_left, "left");
	self thread monitor_footsteps_fx(trig_stomp_kill_right, "right");
	self thread monitor_footsteps_fx(trig_stomp_kill_left, "left");
	self thread monitor_shadow_notetracks("right");
	self thread monitor_shadow_notetracks("left");
	self thread sndgrthreads("left");
	self thread sndgrthreads("right");
	if(isdefined(m_sole) && level.gr_foot_hatch_closed[n_robot_id] && IS_TRUE(self.b_has_hatch))
	{
		self thread giant_robot_foot_waittill_sole_shot(m_sole);
	}
	a_players = GetPlayers();
	
	if(n_robot_id != 3 && !IS_TRUE(level.giant_robot_discovered))
	{
		foreach(player in a_players)
		{
			player thread giant_robot_discovered_vo(self);
		}
	}
	if(level flag::get("three_robot_round") && !IS_TRUE(level.three_robot_round_vo))
	{
		foreach(player in a_players)
		{
			player thread three_robot_round_vo(self);
		}
	}
	else if(n_robot_id != 3 && !IS_TRUE(level.shoot_robot_vo))
	{
		foreach(player in a_players)
		{
			player thread shoot_at_giant_robot_vo(self);
		}
	}
	self waittill("giant_robot_stop");
	self.is_walking = 0;
	self StopAnimScripted();
	self.origin = self.v_start_origin;
	level clientfield::set("play_foot_open_fx_robot_" + self.giant_robot_id, 0);
	self clientfield::set("light_foot_fx_robot", 0);
	self Ghost();
	self DetachAll();
	level notify("giant_robot_walk_cycle_complete");
}

function sole_cleanup(m_sole)
{
	self endon("death");
	self endon("giant_robot_stop");
	util::wait_network_frame();
	m_sole ClearAnim(%root, 0);
	util::wait_network_frame();
	m_sole AnimScripted("hatch_anim", m_sole.origin, m_sole.angles, "ai_zm_dlc5_zombie_giant_robot_hatch_close");
}

function giant_robot_foot_waittill_sole_shot(m_sole)
{
	self endon("death");
	self endon("giant_robot_stop");
	if(isdefined(self.hatch_foot) && self.hatch_foot == "left")
	{
		str_tag = "TAG_ATTACH_HATCH_LE";
		n_foot = 2;
	}
	else if(isdefined(self.hatch_foot) && self.hatch_foot == "right")
	{
		str_tag = "TAG_ATTACH_HATCH_RI";
		n_foot = 1;
	}
	//self waittill("hash_5ebbf30b");
	wait(1);
	m_sole waittill("damage", amount, inflictor, direction, point, type, tagName, modelName, partName, weaponName, iDFlags);
	m_sole.health = 99999;
	level.gr_foot_hatch_closed[self.giant_robot_id] = 0;
	level clientfield::set("play_foot_open_fx_robot_" + self.giant_robot_id, n_foot);
	m_sole AnimScripted("hatch_anim", m_sole.origin, m_sole.angles, "ai_zm_dlc5_zombie_giant_robot_hatch_open");
	n_time = GetAnimLength(%ai_zm_dlc5_zombie_giant_robot_hatch_open);
	wait(n_time);
	m_sole AnimScripted("hatch_anim", m_sole.origin, m_sole.angles, "ai_zm_dlc5_zombie_giant_robot_hatch_open_idle");
}

function giant_robot_close_head_entrance(foot_side)
{
	level endon("intermission");
	wait(5);
	level.gr_foot_hatch_closed[self.giant_robot_id] = 1;
	level clientfield::set("play_foot_open_fx_robot_" + self.giant_robot_id, 0);
	m_sole = GetEnt("target_sole_" + self.giant_robot_id, "targetname");
	if(isdefined(m_sole))
	{
		m_sole AnimScripted("hatch_anim", m_sole.origin, m_sole.angles, "ai_zm_dlc5_zombie_giant_robot_hatch_close");
		self clientfield::set("light_foot_fx_robot", 0);
	}
}

function robot_walk_animation(n_robot_id)
{
	if(n_robot_id != 3)
	{
		level clientfield::set("start_anim_robot_" + n_robot_id, 1);
		self thread start_footprint_warning_vo(n_robot_id);
	}
	if(n_robot_id == 0)
	{
		level scene::Play("cin_tomb_giant_robot_walk_nml_intro", self);
		level scene::Play("cin_tomb_giant_robot_walk_nml", self);
		level scene::Play("cin_tomb_giant_robot_walk_nml_outtro", self);
		self notify("giant_robot_stop");
	}
	else if(n_robot_id == 1)
	{
		level scene::Play("cin_tomb_giant_robot_walk_trenches_intro", self);
		level scene::Play("cin_tomb_giant_robot_walk_trenches", self);
		level scene::Play("cin_tomb_giant_robot_walk_trenches_outtro", self);
		self notify("giant_robot_stop");
	}
	else if(n_robot_id == 2)
	{
		level scene::Play("cin_tomb_giant_robot_walk_village_intro", self);
		level scene::Play("cin_tomb_giant_robot_walk_village", self);
		level scene::Play("cin_tomb_giant_robot_walk_village_outtro", self);
		self notify("giant_robot_stop");
	}
	else if(n_robot_id == 3)
	{
		level scene::Play("cin_tomb_giant_robot_bunker_intro", self);
		self notify("giant_robot_stop");
	}
	if(n_robot_id != 3)
	{
		level clientfield::set("start_anim_robot_" + n_robot_id, 0);
	}
}

function sndgrthreads(side)
{
	self thread sndrobot("soundfootstart_" + side, "zmb_robot_leg_move_" + side, side);
	self thread sndrobot("soundfootwarning_" + side, "zmb_robot_foot_alarm", side);
}

function sndrobot(Notetrack, alias, side)
{
	self endon("giant_robot_stop");
	if(side == "right")
	{
		str_tag = "TAG_ATTACH_HATCH_RI";
	}
	if(side == "left")
	{
		str_tag = "TAG_ATTACH_HATCH_LE";
	}
	while(1)
	{
		self waittill(Notetrack);
		if(Notetrack == "soundfootstart_left" || Notetrack == "soundfootstart_right")
		{
			self thread robotPlayFootSnd(1, str_tag, side);
		}
		else if(Notetrack == "soundfootwarning_left" || Notetrack == "soundfootwarning_right")
		{
			self thread robotPlayFootSnd(0, str_tag, side);
		}
		wait(0.1);
	}
}

function robotPlayFootSnd(startMove, str_tag, side)
{
	if(startMove)
	{
		self PlaySoundOnTag("zmb_robot_leg_move_" + side, str_tag);
		wait(1.1);
		self PlaySoundOnTag("zmb_robot_foot_alarm", str_tag);
		wait(0.7);
		self PlaySoundOnTag("zmb_robot_pre_stomp_a", str_tag);
		wait(0.6);
		self PlaySoundOnTag("zmb_robot_leg_whoosh", str_tag);
	}
	else
	{
		self PlaySoundOnTag("zmb_robot_foot_alarm", str_tag);
		wait(0.7);
		self PlaySoundOnTag("zmb_robot_pre_stomp_a", str_tag);
		wait(0.6);
		self PlaySoundOnTag("zmb_robot_leg_whoosh", str_tag);
	}
}

function monitor_footsteps(trig_stomp_kill, foot_side)
{
	self endon("death");
	self endon("giant_robot_stop");
	str_start_stomp = "kill_zombies_" + foot_side + "foot_1";
	str_end_stomp = "footstep_" + foot_side + "_large";
	while(1)
	{
		self waittillmatch(str_start_stomp);
		self thread toggle_kill_trigger_flag(trig_stomp_kill, 1, foot_side);
		self waittillmatch(str_end_stomp);
		if(self.giant_robot_id == 0 && foot_side == "left")
		{
			self thread toggle_wind_bunker_collision();
		}
		else if(self.giant_robot_id == 1 && foot_side == "left")
		{
			self thread toggle_tank_bunker_collision();
		}
		wait(0.5);
		self thread toggle_kill_trigger_flag(trig_stomp_kill, 0, foot_side);
	}
}

function monitor_footsteps_fx(trig_stomp_kill, foot_side)
{
	self endon("death");
	self endon("giant_robot_stop");
	str_end_stomp = "footstep_" + foot_side + "_large";
	while(1)
	{
		level clientfield::set("play_foot_stomp_fx_robot_" + self.giant_robot_id, 0);
		self waittillmatch(str_end_stomp);
		if(foot_side == "right")
		{
			level clientfield::set("play_foot_stomp_fx_robot_" + self.giant_robot_id, 1);
		}
		else
		{
			level clientfield::set("play_foot_stomp_fx_robot_" + self.giant_robot_id, 2);
		}
		trig_stomp_kill thread rumble_and_shake(self);
		if(self.giant_robot_id == 2)
		{
			self thread church_ceiling_fxanim(foot_side);
		}
		else if(self.giant_robot_id == 0)
		{
			self thread play_pap_shake_fxanim(foot_side);
		}
		util::wait_network_frame();
	}
}

function monitor_shadow_notetracks(foot_side)
{
	self endon("death");
	self endon("giant_robot_stop");
	while(1)
	{
		self waittillmatch("shadow_" + foot_side);
		start_robot_stomp_warning_vo(foot_side);
	}
}

function rumble_and_shake(robot)
{
	a_players = GetPlayers();
	wait(0.2);
	foreach(player in a_players)
	{
		if(zombie_utility::is_player_valid(player))
		{
			if(isdefined(player.in_giant_robot_head))
			{
				if(isdefined(player.giant_robot_transition) && player.giant_robot_transition)
				{
					continue;
				}
				if(player.in_giant_robot_head == robot.giant_robot_id)
				{
					player clientfield::set_to_player("giant_robot_rumble_and_shake", 2);
				}
				else
				{
					continue;
				}
			}
			else
			{
				dist = Distance(player.origin, self.origin);
				if(dist < 1500)
				{
					player clientfield::set_to_player("giant_robot_rumble_and_shake", 3);
					level notify("sam_clue_giant", player);
				}
				else if(dist < 3000)
				{
					player clientfield::set_to_player("giant_robot_rumble_and_shake", 2);
				}
				else if(dist < 6000)
				{
					player clientfield::set_to_player("giant_robot_rumble_and_shake", 1);
				}
				else
				{
					continue;
				}
			}
			player thread turn_clientside_rumble_off();
		}
	}
}

function toggle_kill_trigger_flag(trig_stomp, b_flag, foot_side)
{
	if(!isdefined(foot_side))
	{
		foot_side = undefined;
	}
	if(b_flag)
	{
		self flag::set("kill_trigger_active");
		trig_stomp thread activate_kill_trigger(self, foot_side);
	}
	else
	{
		self flag::clear("kill_trigger_active");
		level notify("stop_kill_trig_think");
		if(self flag::get("robot_head_entered"))
		{
			self flag::clear("robot_head_entered");
			self thread giant_robot_close_head_entrance(foot_side);
			level thread giant_robot_head_teleport_timeout(self.giant_robot_id);
		}
	}
}

function activate_kill_trigger(robot, foot_side)
{
	level endon("stop_kill_trig_think");
	if(foot_side == "left")
	{
		str_foot_tag = "TAG_ATTACH_HATCH_LE";
	}
	if(foot_side == "right")
	{
		str_foot_tag = "TAG_ATTACH_HATCH_RI";
	}
	while(robot flag::get("kill_trigger_active"))
	{
		a_zombies = GetAISpeciesArray(level.zombie_team, "all");
		a_zombies_to_kill = [];
		foreach(zombie in a_zombies)
		{
			if(DistanceSquared(zombie.origin, self.origin) < 360000)
			{
				if(IS_TRUE(zombie.is_giant_robot))
				{
					continue;
				}
				if(IS_TRUE(zombie.marked_for_death))
				{
					continue;
				}
				if(IS_TRUE(zombie.robot_stomped))
				{
					continue;
				}
				if(zombie IsTouching(self))
				{
					if(IS_TRUE(zombie.is_mechz))
					{
						zombie thread mechz_robot_stomp_callback();
						continue;
					}
					zombie setgoalpos(zombie.origin);
					zombie.marked_for_death = 1;
					a_zombies_to_kill[a_zombies_to_kill.size] = zombie;
					continue;
				}
				if(!IS_TRUE(zombie.is_mechz) && !IS_TRUE(zombie.missingLegs) && IS_TRUE(zombie.completed_emerging_into_playable_area))
				{
					n_my_z = zombie.origin[2];
					v_giant_robot = robot GetTagOrigin(str_foot_tag);
					n_giant_robot_z = v_giant_robot[2];
					z_diff = Abs(n_my_z - n_giant_robot_z);
					if(z_diff <= 100)
					{
						zombie.v_punched_from = self.origin;
						//zombie animcustom(&_zm_weap_one_inch_punch::knockdown_zombie_animate);
						zombie animcustom(&knockdown_zombie_animate);
					}
				}
			}
		}
		if(a_zombies_to_kill.size > 0)
		{
			level thread zombie_stomp_death(robot, a_zombies_to_kill);
			robot thread zombie_stomped_by_gr_vo(foot_side);
		}
		if(isdefined(level.maxis_quadrotor))
		{
			if(level.maxis_quadrotor IsTouching(self))
			{
				level.maxis_quadrotor thread quadrotor_stomp_death();
			}
		}
		a_boxes = GetEntArray("foot_box", "script_noteworthy");
		foreach(m_box in a_boxes)
		{
			if(m_box IsTouching(self))
			{
				m_box notify("robot_foot_stomp");
			}
		}
		players = GetPlayers();
		for(i = 0; i < players.size; i++)
		{
			if(zombie_utility::is_player_valid(players[i], 0, 1))
			{
				if(!players[i] IsTouching(self))
				{
					continue;
				}
				if(players[i] is_in_giant_robot_footstep_safe_spot())
				{
					continue;
				}
				if(isdefined(players[i].in_giant_robot_head))
				{
					continue;
				}
				if(IS_TRUE(players[i].is_stomped))
				{
					continue;
				}
				if(!level.gr_foot_hatch_closed[robot.giant_robot_id] && isdefined(robot.hatch_foot) && IS_TRUE(robot.b_has_hatch) && IsSubStr(self.targetname, robot.hatch_foot) && !self laststand::player_is_in_laststand())
				{
					players[i].ignoreme = 1;
					players[i].teleport_initial_origin = self.origin;
					players[i].var_b605c6c3 = 0;
					if(robot.giant_robot_id == 0)
					{
						//level thread zm_tomb_teleporter::stargate_teleport_player("head_0_teleport_player", players[i], 2, 0);
						level thread stargate_teleport_player("head_0_teleport_player", players[i], 2, 0);
						players[i].in_giant_robot_head = 0;
					}
					else if(robot.giant_robot_id == 1)
					{
						level thread stargate_teleport_player("head_1_teleport_player", players[i], 2, 0);
						players[i].in_giant_robot_head = 1;
						if(players[i] zm_zonemgr::entity_in_zone("zone_bunker_4d") || players[i] zm_zonemgr::entity_in_zone("zone_bunker_4c"))
						{
							players[i].entered_foot_from_tank_bunker = 1;
						}
					}
					else
					{
						level thread stargate_teleport_player("head_2_teleport_player", players[i], 2, 0);
						players[i].in_giant_robot_head = 2;
					}
					robot flag::set("robot_head_entered");
					players[i] PlaySoundToPlayer("zmb_bot_elevator_ride_up", players[i]);
					start_wait = 0;
					black_screen_wait = 4;
					fade_in_time = 0.01;
					fade_out_time = 0.2;
					players[i] thread hud::fade_to_black_for_x_sec(start_wait, black_screen_wait, fade_in_time, fade_out_time, "white");
					N_TRANSITION_TIME = start_wait + black_screen_wait + fade_in_time + fade_out_time;
					n_start_time = start_wait + fade_in_time;
					players[i] thread player_transition_into_robot_head_start(n_start_time);
					players[i] thread player_transition_into_robot_head_finish(N_TRANSITION_TIME);
					players[i] thread player_death_watch_on_giant_robot();
					continue;
				}
				if(isdefined(players[i].dig_vars["has_helmet"]) && players[i].dig_vars["has_helmet"])
				{
					players[i] thread player_stomp_fake_death(robot);
				}
				else
				{
					players[i] thread player_stomp_death(robot);
				}
				start_wait = 0;
				black_screen_wait = 5;
				fade_in_time = 0.01;
				fade_out_time = 0.2;
				players[i] thread hud::fade_to_black_for_x_sec(start_wait, black_screen_wait, fade_in_time, fade_out_time, "black");
			}
		}
		wait(0.05);
	}
}

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
	player DisableOffhandWeapons();
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
	player.teleport_origin = Spawn("script_model", player.origin);
	player.teleport_origin SetModel("tag_origin");
	player.teleport_origin.angles = player.angles;
	player PlayerLinkToAbsolute(player.teleport_origin, "tag_origin");
	player.teleport_origin.origin = desired_origin;
	player.teleport_origin.angles = image_room.angles;
	if(show_fx)
	{
		player PlaySoundToPlayer("zmb_teleporter_plr_start", player);
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
		player.teleport_origin Delete();
		player.teleport_origin = undefined;
	}
	player SetOrigin(s_pos.origin);
	player SetPlayerAngles(s_pos.angles);
	player EnableWeapons();
	player EnableOffhandWeapons();
	player FreezeControls(0);
	visionset_mgr::deactivate("overlay", "zm_factory_teleport", player);
	if(show_fx)
	{
		player PlaySoundToPlayer("zmb_teleporter_plr_end", player);
	}
	player.teleporting = 0;
	player clientfield::increment("teleport_arrival_departure_fx");
	player notify("hash_327f029");
}

function stargate_play_fx()
{
	self.e_fx clientfield::set("teleporter_fx", 1);
	self waittill("stop_teleport_fx");
	self.e_fx clientfield::set("teleporter_fx", 0);
}

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

function knockdown_zombie_animate()
{
	self notify("end_play_punch_pain_anim");
	self endon("killanimscript");
	self endon("death");
	self endon("end_play_punch_pain_anim");
	if(isdefined(self.marked_for_death) && self.marked_for_death)
	{
		return;
	}
	self.allowPain = 0;
	animation_direction = undefined;
	animation_legs = "";
	animation_side = undefined;
	animation_duration = "_default";
	v_forward = VectorDot(AnglesToForward(self.angles), VectorNormalize(self.v_punched_from - self.origin));
	if(v_forward > 0.6)
	{
		animation_direction = "back";
		if(isdefined(self.missingLegs) && self.missingLegs)
		{
			animation_legs = "_crawl";
		}
		if(RandomInt(100) > 75)
		{
			animation_side = "belly";
		}
		else
		{
			animation_side = "back";
		}
	}
	else if(self.damageyaw > 75 && self.damageyaw < 135)
	{
		animation_direction = "left";
		animation_side = "belly";
	}
	else if(self.damageyaw > -135 && self.damageyaw < -75)
	{
		animation_direction = "right";
		animation_side = "belly";
	}
	else
	{
		animation_direction = "front";
		animation_side = "belly";
	}
	self thread knockdown_zombie_animate_state();
	self SetAnimStateFromASD("zm_punch_fall_" + animation_direction + animation_legs);
	self zombie_shared::DoNoteTracks("punch_fall_anim", self.punch_handle_pain_notetracks);
	if(IS_TRUE(self.missingLegs) || IS_TRUE(self.marked_for_death))
	{
		return;
	}
	if(isdefined(self.a.gib_ref))
	{
		if(self.a.gib_ref == "no_legs" || self.a.gib_ref == "no_arms" || (self.a.gib_ref == "left_leg" || self.a.gib_ref == "right_leg" && RandomInt(100) > 25) || (self.a.gib_ref == "left_arm" || self.a.gib_ref == "right_arm" && RandomInt(100) > 75))
		{
			animation_duration = "_late";
		}
		else if(RandomInt(100) > 75)
		{
			animation_duration = "_early";
		}
	}
	else if(RandomInt(100) > 25)
	{
		animation_duration = "_early";
	}
	self zombie_shared::DoNoteTracks("punch_getup_anim");
	self.allowPain = 1;
	self notify("back_up");
}

function knockdown_zombie_animate_state()
{
	self endon("death");
	self.is_knocked_down = 1;
	self util::waittill_any("damage", "back_up");
	self.is_knocked_down = 0;
}

function mechz_robot_stomp_callback()
{
	self endon("death");
	if(IS_TRUE(self.robot_stomped))
	{
		return;
	}
	self.robot_stomped = 1;
}

function is_in_giant_robot_footstep_safe_spot()
{
	b_is_in_safe_spot = 0;
	if(isdefined(level.giant_robot_footstep_safe_spots))
	{
		foreach(e_volume in level.giant_robot_footstep_safe_spots)
		{
			if(self IsTouching(e_volume))
			{
				b_is_in_safe_spot = 1;
				break;
			}
		}
	}
	return b_is_in_safe_spot;
}

function player_stomp_death(robot)
{
	self endon("death");
	self endon("disconnect");
	self.is_stomped = 1;
	self PlaySound("zmb_zombie_arc");
	self FreezeControls(1);
	if(self laststand::player_is_in_laststand())
	{
		self ShellShock("explosion", 7);
	}
	else
	{
		self DoDamage(self.health, self.origin, robot);
	}
	wait(5);
	self.is_stomped = 0;
	if(!IS_TRUE(self.hostMigrationControlsFrozen))
	{
		self FreezeControls(0);
	}
	self thread play_robot_crush_player_vo();
}

function player_stomp_fake_death(robot)
{
	self endon("death");
	self endon("disconnect");
	self.is_stomped = 1;
	self notify("hash_e2be4752");
	self playsound("zmb_zombie_arc");
	self FreezeControls(1);
	self zm_utility::increment_ignoreme();
	self SetStance("prone");
	self ShellShock("explosion", 7);
	wait(5);
	self.is_stomped = 0;
	if(!IS_TRUE(self.hostMigrationControlsFrozen))
	{
		self FreezeControls(0);
	}
	if(!IS_TRUE(self.ee_stepped_on))
	{
		self zm_audio::create_and_play_dialog("general", "robot_crush_golden");
		self.ee_stepped_on = 1;
	}
	self zm_utility::decrement_ignoreme();
}

function zombie_stomp_death(robot, a_zombies_to_kill)
{
	n_interval = 0;
	for(i = 0; i < a_zombies_to_kill.size; i++)
	{
		zombie = a_zombies_to_kill[i];
		if(!isdefined(zombie) || !IsAlive(zombie))
		{
			continue;
		}
		if(!IS_TRUE(zombie.exclude_cleanup_adding_to_total))
		{
			level.zombie_total++;
			level.zombie_respawns++;
			if(zombie.health < zombie.maxhealth)
			{
				ARRAY_ADD(level.a_zombie_respawn_health[zombie.archetype],zombie.health)
			}
		}
		zombie zombie_utility::reset_attack_spot();
		zombie DoDamage(zombie.health, zombie.origin, robot);
		n_interval++;
		if(n_interval >= 4)
		{
			util::wait_network_frame();
			n_interval = 0;
		}
	}
}

function quadrotor_stomp_death()
{
	self endon("death");
	self Delete();
}

function toggle_wind_bunker_collision()
{
	s_org = struct::get("wind_tunnel_bunker", "script_noteworthy");
	v_foot = self GetTagOrigin("TAG_ATTACH_HATCH_LE");
	if(Distance2DSquared(s_org.origin, v_foot) < 57600)
	{
		level notify("wind_bunker_collision_on");
		wait(5);
		level notify("wind_bunker_collision_off");
	}
}

function toggle_tank_bunker_collision()
{
	s_org = struct::get("tank_bunker", "script_noteworthy");
	v_foot = self GetTagOrigin("TAG_ATTACH_HATCH_LE");
	if(Distance2DSquared(s_org.origin, v_foot) < 57600)
	{
		level notify("tank_bunker_collision_on");
		wait(5);
		level notify("tank_bunker_collision_off");
	}
}

function handle_wind_tunnel_bunker_collision()
{
	e_collision = GetEnt("clip_foot_bottom_wind", "targetname");
	e_collision NotSolid();
	e_collision ConnectPaths();
	while(1)
	{
		level waittill("wind_bunker_collision_on");
		wait(0.1);
		e_collision Solid();
		e_collision DisconnectPaths();
		level waittill("wind_bunker_collision_off");
		e_collision NotSolid();
		e_collision ConnectPaths();
	}
}

function handle_tank_bunker_collision()
{
	e_collision = GetEnt("clip_foot_bottom_tank", "targetname");
	e_collision NotSolid();
	e_collision ConnectPaths();
	while(1)
	{
		level waittill("tank_bunker_collision_on");
		wait(0.1);
		e_collision Solid();
		e_collision DisconnectPaths();
		level waittill("tank_bunker_collision_off");
		e_collision NotSolid();
		e_collision ConnectPaths();
	}
}

function church_ceiling_fxanim(foot_side)
{
	if(foot_side == "left")
	{
		tag_foot = self GetTagOrigin("TAG_ATTACH_HATCH_LE");
	}
	else
	{
		tag_foot = self GetTagOrigin("TAG_ATTACH_HATCH_RI");
	}
	s_church = struct::get("giant_robot_church_marker", "targetname");
	n_distance = Distance2DSquared(tag_foot, s_church.origin);
	if(n_distance < 1000000)
	{
		level clientfield::set("church_ceiling_fxanim", 1);
		util::wait_network_frame();
		level clientfield::set("church_ceiling_fxanim", 0);
	}
}

function play_pap_shake_fxanim(foot_side)
{
	if(foot_side == "left")
	{
		tag_foot = self GetTagOrigin("TAG_ATTACH_HATCH_LE");
	}
	else
	{
		tag_foot = self GetTagOrigin("TAG_ATTACH_HATCH_RI");
	}
	s_pap = struct::get("giant_robot_pap_marker", "targetname");
	wait(0.2);
	n_distance = Distance2DSquared(tag_foot, s_pap.origin);
	if(n_distance < 2250000)
	{
		level clientfield::increment("pap_monolith_ring_shake");
	}
}

function player_transition_into_robot_head_start(n_start_time)
{
	self endon("death");
	self endon("disconnect");
	self.giant_robot_transition = 1;
	self.dontspeak = 1;
	self clientfield::set_to_player("giant_robot_rumble_and_shake", 3);
	wait(1.5);
	self clientfield::set_to_player("player_rumble_and_shake", 4);
}

function player_transition_into_robot_head_finish(N_TRANSITION_TIME)
{
	self endon("death");
	self endon("disconnect");
	wait(N_TRANSITION_TIME);
	self clientfield::set_to_player("player_rumble_and_shake", 0);
	self clientfield::set_to_player("giant_robot_rumble_and_shake", 0);
	self.giant_robot_transition = 0;
	wait(2);
	if(!level flag::get("story_vo_playing"))
	{
		self.dontspeak = 0;
		self zm_audio::create_and_play_dialog("general", "enter_robot");
	}
	if(!isdefined(level.sndrobotheadcount) || level.sndrobotheadcount == 0)
	{
		level.sndrobotheadcount = 4;
		level thread sndplaystinger("zone_robot_head");
	}
	else
	{
		level.sndrobotheadcount--;
	}
}

function sndplaystinger(State)
{
	if(isdefined(level.musicSystem.currentPlaytype) && level.musicSystem.currentPlaytype >= 4 || IS_TRUE(level.musicSystemOverride))
	{
		return;
	}
	level thread zm_audio::sndMusicSystem_PlayState(State);
}

function gr_head_exit_trigger_start(s_origin)
{
	s_origin.unitrigger_stub = SpawnStruct();
	s_origin.unitrigger_stub.origin = s_origin.origin;
	s_origin.unitrigger_stub.radius = 36;
	s_origin.unitrigger_stub.height = 256;
	s_origin.unitrigger_stub.script_unitrigger_type = "unitrigger_radius_use";
	s_origin.unitrigger_stub.hint_string = &"ZM_TOMB_EHT";
	s_origin.unitrigger_stub.cursor_hint = "HINT_NOICON";
	s_origin.unitrigger_stub.require_look_at = 1;
	s_origin.unitrigger_stub.target = s_origin.target;
	s_origin.unitrigger_stub.script_int = s_origin.script_int;
	s_origin.unitrigger_stub.is_available = 1;
	s_origin.unitrigger_stub.prompt_and_visibility_func = &gr_head_eject_trigger_visibility;
	zm_unitrigger::unitrigger_force_per_player_triggers(s_origin.unitrigger_stub, 1);
	zm_unitrigger::register_static_unitrigger(s_origin.unitrigger_stub, &player_exits_giant_robot_head_trigger_think);
}

function gr_head_eject_trigger_visibility(player)
{
	b_is_invis = !IS_TRUE(self.stub.is_available);
	self SetInvisibleToPlayer(player, b_is_invis);
	self SetHintString(self.stub.hint_string);
	return !b_is_invis;
}

function reset_gr_head_unitriggers()
{
	zm_unitrigger::unregister_unitrigger(self.unitrigger_stub);
	zm_unitrigger::register_static_unitrigger(self.unitrigger_stub, &player_exits_giant_robot_head_trigger_think);
}

function player_exits_giant_robot_head_trigger_think()
{
	self endon("tube_used_for_timeout");
	while(1)
	{
		self waittill("trigger", player);
		if(!IS_TRUE(self.stub.is_available))
		{
			continue;
		}
		if(!IsPlayer(player) || !zombie_utility::is_player_valid(player))
		{
			continue;
		}
		level thread init_player_eject_logic(self.stub, player);
		self.stub.is_available = 0;
	}
}

function init_player_eject_logic(s_unitrigger, player, b_timeout)
{
	if(!isdefined(b_timeout))
	{
		b_timeout = 0;
	}
	s_unitrigger.is_available = 0;
	s_origin = struct::get(s_unitrigger.target, "targetname");
	v_origin = s_origin.origin;
	v_angles = s_origin.angles;
	m_linkpoint = spawn_model("tag_origin", v_origin, v_angles);
	if(isdefined(level.giant_robot_head_player_eject_thread_custom_func))
	{
		player thread [[level.giant_robot_head_player_eject_thread_custom_func]](m_linkpoint, s_origin.script_noteworthy, b_timeout);
	}
	else
	{
		player thread giant_robot_head_player_eject_thread(m_linkpoint, s_origin.script_noteworthy, b_timeout);
	}
	tube_clone = player zm_clone::spawn_player_clone(player, player.origin, undefined);
	player thread giant_robot_eject_disconnect_watcher(m_linkpoint, tube_clone);
	tube_clone LinkTo(m_linkpoint);
	tube_clone.ignoreme = 1;
	tube_clone Show();
	tube_clone DetachAll();
	tube_clone SetVisibleToAll();
	tube_clone SetInvisibleToPlayer(player);
	tube_clone thread tube_clone_falls_to_earth(m_linkpoint);
	m_linkpoint waittill("movedone");
	wait(6);
	s_unitrigger.is_available = 1;
}

function giant_robot_head_player_eject_thread(m_linkpoint, str_tube, b_timeout)
{
	if(!isdefined(b_timeout))
	{
		b_timeout = 0;
	}
	level endon("intermission");
	self endon("death_or_disconnect");
	currentWeap = self GetCurrentWeapon();
	self DisableWeapons();
	self DisableOffhandWeapons();
	self EnableInvulnerability();
	self SetStance("stand");
	self AllowStand(1);
	self AllowCrouch(0);
	self AllowProne(0);
	self PlayerLinkToDelta(m_linkpoint, "tag_origin", 1, 20, 20, 20, 20);
	self SetPlayerAngles(m_linkpoint.angles);
	self.dontspeak = 1;
	self clientfield::set_to_player("isspeaking", 1);
	self notify("teleport");
	self.giant_robot_transition = 1;
	self PlaySoundToPlayer("zmb_bot_timeout_alarm", self);
	self.old_angles = self.angles;
	if(!b_timeout)
	{
		self clientfield::set("eject_steam_fx", 1);
		self thread in_tube_manual_looping_rumble();
		wait(3);
	}
	self StopSounds();
	util::wait_network_frame();
	self PlaySoundToPlayer("zmb_giantrobot_exit", self);
	self notify("end_in_tube_rumble");
	self thread exit_gr_manual_looping_rumble();
	m_linkpoint MoveTo(m_linkpoint.origin + VectorScale((0, 0, 1), 2000), 2.5);
	self thread hud::fade_to_black_for_x_sec(0, 2, 0.5, 0, "white");
	wait(1);
	m_linkpoint MoveTo(self.teleport_initial_origin + VectorScale((0, 0, 1), 3000), 0.05);
	self thread scene::Play("cin_zm_gen_player_fall_loop", self);
	self SetInvisibleToAll();
	self SetVisibleToPlayer(self);
	wait(1);
	self PlaySoundToPlayer("zmb_giantrobot_fall", self);
	self PlayerLinkToDelta(m_linkpoint, "tag_origin", 1, 180, 180, 20, 20);
	m_linkpoint MoveTo(self.teleport_initial_origin, 3, 1);
	m_linkpoint thread play_gr_eject_impact_player_fx(self);
	m_linkpoint notify("start_gr_eject_fall_to_earth");
	self thread player_screams_while_falling();
	wait(2.85);
	self thread hud::fade_to_black_for_x_sec(0, 1, 0, 0.5, "black");
	self waittill("gr_eject_fall_complete");
	self SetVisibleToAll();
	self enableWeapons();
	if(isdefined(currentWeap) && currentWeap != level.weaponNone)
	{
		self SwitchToWeaponImmediate(currentWeap);
	}
	self EnableOffhandWeapons();
	self Unlink();
	m_linkpoint Delete();
	self teleport_player_to_gr_footprint_safe_spot();
	level scene::stop("cin_zm_gen_player_fall_loop");
	self Show();
	self SetPlayerAngles(self.old_angles);
	self DisableInvulnerability();
	self.dontspeak = 0;
	self AllowStand(1);
	self AllowCrouch(1);
	self AllowProne(1);
	self clientfield::set_to_player("isspeaking", 0);
	self.in_giant_robot_head = undefined;
	self.teleport_initial_origin = undefined;
	self.old_angles = undefined;
	self.var_b605c6c3 = 1;
	self thread gr_eject_landing_rumble();
	self thread gr_eject_landing_rumble_on_position();
	self clientfield::set("eject_steam_fx", 0);
	n_post_eject_time = 2.5;
	self SetStance("prone");
	self ShellShock("explosion", n_post_eject_time);
	self.giant_robot_transition = 0;
	self notify("gr_eject_sequence_complete");
	if(!level flag::get("story_vo_playing"))
	{
		self util::delay(3, undefined, &zm_audio::create_and_play_dialog, "general", "air_chute_landing");
	}
	wait(n_post_eject_time);
	self.ignoreme = 0;
}

function player_screams_while_falling()
{
	self endon("disconnect");
	self StopSounds();
	util::wait_network_frame();
	self PlaySoundToPlayer("vox_plr_" + self.characterindex + "_exit_robot_0", self);
}

function tube_clone_falls_to_earth(m_linkpoint)
{
	m_linkpoint waittill("start_gr_eject_fall_to_earth");
	self thread scene::Play("cin_zm_dlc1_jump_pad_air_loop", self);
	m_linkpoint waittill("movedone");
	self thread scene::stop("cin_zm_dlc1_jump_pad_air_loop");
	self Delete();
}

function in_tube_manual_looping_rumble()
{
	self endon("end_in_tube_rumble");
	self endon("death");
	self endon("disconnect");
	while(1)
	{
		self clientfield::set_to_player("giant_robot_rumble_and_shake", 1);
		util::wait_network_frame();
		self clientfield::set_to_player("giant_robot_rumble_and_shake", 0);
		util::wait_network_frame();
		wait(0.1);
	}
}

function exit_gr_manual_looping_rumble()
{
	self endon("end_exit_gr_rumble");
	self endon("death");
	self endon("disconnect");
	while(1)
	{
		self clientfield::set_to_player("giant_robot_rumble_and_shake", 1);
		util::wait_network_frame();
		self clientfield::set_to_player("giant_robot_rumble_and_shake", 0);
		util::wait_network_frame();
		wait(0.1);
	}
}

function gr_eject_landing_rumble()
{
	self endon("death");
	self endon("disconnect");
	self notify("end_exit_gr_rumble");
	util::wait_network_frame();
	self clientfield::set_to_player("giant_robot_rumble_and_shake", 0);
	util::wait_network_frame();
	self clientfield::set_to_player("giant_robot_rumble_and_shake", 3);
	util::wait_network_frame();
	self clientfield::set_to_player("giant_robot_rumble_and_shake", 0);
}

function gr_eject_landing_rumble_on_position()
{
	self endon("death");
	self endon("disconnect");
	a_players = GetPlayers();
	foreach(player in a_players)
	{
		if(player == self)
		{
			continue;
		}
		if(IS_TRUE(player.giant_robot_transition))
		{
			continue;
		}
		if(Distance2DSquared(player.origin, self.origin) < 250000)
		{
			player thread gr_eject_landing_rumble();
		}
	}
}

function teleport_player_to_gr_footprint_safe_spot()
{
	self endon("death");
	self endon("disconnect");
	if(IS_TRUE(self.entered_foot_from_tank_bunker))
	{
		a_s_orgs = struct::get_array("tank_platform_safe_spots", "targetname");
		foreach(struct in a_s_orgs)
		{
			if(!PositionWouldTelefrag(struct.origin))
			{
				self SetOrigin(struct.origin);
				break;
			}
		}
		self.entered_foot_from_tank_bunker = 0;
		return;
	}
	a_s_footprints = struct::get_array("giant_robot_footprint", "targetname");
	a_s_footprints = util::get_array_of_closest(self.teleport_initial_origin, a_s_footprints);
	s_footprint = a_s_footprints[0];
	a_v_offset = [];
	a_v_offset[0] = (0, 0, 0);
	a_v_offset[1] = VectorScale((1, 1, 0), 50);
	a_v_offset[2] = VectorScale((1, 0, 0), 50);
	a_v_offset[3] = VectorScale((1, -1, 0), 50);
	a_v_offset[4] = VectorScale((0, -1, 0), 50);
	a_v_offset[5] = VectorScale((-1, -1, 0), 50);
	a_v_offset[6] = VectorScale((-1, 0, 0), 50);
	a_v_offset[7] = VectorScale((-1, 1, 0), 50);
	a_v_offset[8] = VectorScale((0, 1, 0), 50);
	for(i = 0; i < a_v_offset.size; i++)
	{
		v_origin = s_footprint.origin + a_v_offset[i];
		v_trace_start = v_origin + VectorScale((0, 0, 1), 100);
		v_final = PlayerPhysicsTrace(v_trace_start, v_origin);
		if(!PositionWouldTelefrag(v_final))
		{
			self SetOrigin(v_final);
			break;
		}
	}
}

function giant_robot_head_teleport_timeout(n_robot_id)
{
	level endon("intermission");
	wait(15);
	n_players_in_robot = count_players_in_gr_head(n_robot_id);
	if(n_players_in_robot == 0)
	{
		return;
	}
	while(level flag::get("maxis_audiolog_gr" + n_robot_id + "_playing"))
	{
		wait(0.1);
	}
	n_players_in_robot = count_players_in_gr_head(n_robot_id);
	if(n_players_in_robot == 0)
	{
		return;
	}
	level thread play_timeout_warning_vo(n_robot_id);
	reset_maxis_audiolog_unitrigger(n_robot_id);
	level clientfield::set("eject_warning_fx_robot_" + n_robot_id, 1);
	a_players = GetPlayers();
	a_players[0] clientfield::set("all_tubes_play_eject_steam_fx", 1);
	level waittill("timeout_warning_vo_complete_" + n_robot_id);
	a_gr_head_triggers = struct::get_array("giant_robot_head_exit_trigger", "script_noteworthy");
	a_shutdown_triggers = [];
	foreach(trigger in a_gr_head_triggers)
	{
		if(trigger.script_int == n_robot_id)
		{
			if(isdefined(trigger.unitrigger_stub.is_available) && trigger.unitrigger_stub.is_available)
			{
				zm_unitrigger::unregister_unitrigger(trigger.unitrigger_stub);
				a_shutdown_triggers[a_shutdown_triggers.size] = trigger;
			}
		}
	}
	a_players = GetPlayers();
	a_m_linkspots = [];
	foreach(player in a_players)
	{
		if(isdefined(player.in_giant_robot_head) && player.in_giant_robot_head == n_robot_id)
		{
			if(!IS_TRUE(player.giant_robot_transition))
			{
				if(player laststand::player_is_in_laststand())
				{
					if(IS_TRUE(player.waiting_to_revive) && a_players.size <= 1)
					{
						level flag::set("instant_revive");
						player.stopFlashingBadlyTime = GetTime() + 1000;
						util::wait_network_frame();
						level flag::clear("instant_revive");
					}
					else if(player bgb::is_enabled("zm_bgb_self_medication"))
					{
						player bgb::take();
						player.var_df0decf1 = undefined;
						player.var_25b88da = 0;
						player thread zm_laststand::bleed_out();
						player notify("gr_head_forced_bleed_out");
						continue;
					}
					else
					{
						player thread zm_laststand::bleed_out();
						player notify("gr_head_forced_bleed_out");
						continue;
					}
				}
				if(isalive(player))
				{
					m_linkspot = spawn_model("tag_origin", player.origin, player.angles);
					a_m_linkspots[a_m_linkspots.size] = m_linkspot;
					player start_drag_player_to_eject_tube(n_robot_id, m_linkspot);
					wait(0.1);
				}
			}
		}
	}
	wait(10);
	restart_maxis_audiolog_unitrigger(n_robot_id);
	level clientfield::set("eject_warning_fx_robot_" + n_robot_id, 0);
	a_players = GetPlayers();
	a_players[0] clientfield::set("all_tubes_play_eject_steam_fx", 0);
	foreach(trigger in a_shutdown_triggers)
	{
		if(trigger.script_int == n_robot_id)
		{
			trigger thread reset_gr_head_unitriggers();
		}
	}
	if(a_m_linkspots.size > 0)
	{
		for(i = 0; i < a_m_linkspots.size; i++)
		{
			if(isdefined(a_m_linkspots[i]))
			{
				a_m_linkspots[i] Delete();
			}
		}
	}
}

function reset_maxis_audiolog_unitrigger(n_robot_id)
{
	if(n_robot_id == 0)
	{
		n_script_int = 4;
	}
	else if(n_robot_id == 1)
	{
		n_script_int = 5;
	}
	else if(n_robot_id == 2)
	{
		n_script_int = 6;
	}
	if(level flag::get("maxis_audio_log_" + n_script_int))
	{
		return;
	}
	a_s_radios = struct::get_array("maxis_audio_log", "targetname");
	foreach(s_origin in a_s_radios)
	{
		if(s_origin.script_int == n_script_int)
		{
			if(isdefined(s_origin.unitrigger_stub))
			{
				zm_unitrigger::unregister_unitrigger(s_origin.unitrigger_stub);
			}
		}
	}
}

function restart_maxis_audiolog_unitrigger(n_robot_id)
{
	if(n_robot_id == 0)
	{
		n_script_int = 4;
	}
	else if(n_robot_id == 1)
	{
		n_script_int = 5;
	}
	else if(n_robot_id == 2)
	{
		n_script_int = 6;
	}
	a_s_radios = struct::get_array("maxis_audio_log", "targetname");
	foreach(s_origin in a_s_radios)
	{
		if(s_origin.script_int == n_script_int)
		{
			if(isdefined(s_origin.unitrigger_stub))
			{
				zm_unitrigger::register_static_unitrigger(s_origin.unitrigger_stub, &maxis_audio_log_think);
			}
		}
	}
}

function maxis_audio_log_think()
{
	self waittill("trigger", player);
	if(!IsPlayer(player) || !zombie_utility::is_player_valid(player))
	{
		return;
	}
	level thread play_maxis_audio_log(self.stub.origin, self.stub.script_int);
}

function play_maxis_audio_log(v_trigger_origin, n_audiolog_id)
{
	a_audiolog = get_audiolog_vo();
	a_audiolog_to_play = a_audiolog[n_audiolog_id];
	if(n_audiolog_id == 4)
	{
		level flag::set("maxis_audiolog_gr0_playing");
	}
	else if(n_audiolog_id == 5)
	{
		level flag::set("maxis_audiolog_gr1_playing");
	}
	else if(n_audiolog_id == 6)
	{
		level flag::set("maxis_audiolog_gr2_playing");
	}
	e_vo_origin = Spawn("script_origin", v_trigger_origin);
	level flag::set("maxis_audio_log_" + n_audiolog_id);
	a_s_triggers = struct::get_array("maxis_audio_log", "targetname");
	foreach(s_trigger in a_s_triggers)
	{
		if(s_trigger.script_int == n_audiolog_id)
		{
			break;
		}
	}
	level thread zm_unitrigger::unregister_unitrigger(s_trigger.unitrigger_stub);
	for(i = 0; i < a_audiolog_to_play.size; i++)
	{
		e_vo_origin PlaySoundWithNotify(a_audiolog_to_play[i], a_audiolog_to_play[i] + "_done");
		e_vo_origin waittill(a_audiolog_to_play[i] + "_done");
	}
	e_vo_origin Delete();
	if(n_audiolog_id == 4)
	{
		level flag::clear("maxis_audiolog_gr0_playing");
	}
	else if(n_audiolog_id == 5)
	{
		level flag::clear("maxis_audiolog_gr1_playing");
	}
	else if(n_audiolog_id == 6)
	{
		level flag::clear("maxis_audiolog_gr2_playing");
	}
	level thread zm_unitrigger::register_static_unitrigger(s_trigger.unitrigger_stub, &maxis_audio_log_think);
}

function get_audiolog_vo()
{
	a_audiologs = [];
	a_audiologs[1] = [];
	a_audiologs[1][0] = "vox_maxi_audio_log_1_1_0";
	a_audiologs[1][1] = "vox_maxi_audio_log_1_2_0";
	a_audiologs[1][2] = "vox_maxi_audio_log_1_3_0";
	a_audiologs[2] = [];
	a_audiologs[2][0] = "vox_maxi_audio_log_2_1_0";
	a_audiologs[2][1] = "vox_maxi_audio_log_2_2_0";
	a_audiologs[3] = [];
	a_audiologs[3][0] = "vox_maxi_audio_log_3_1_0";
	a_audiologs[3][1] = "vox_maxi_audio_log_3_2_0";
	a_audiologs[3][2] = "vox_maxi_audio_log_3_3_0";
	a_audiologs[4] = [];
	a_audiologs[4][0] = "vox_maxi_audio_log_4_1_0";
	a_audiologs[4][1] = "vox_maxi_audio_log_4_2_0";
	a_audiologs[4][2] = "vox_maxi_audio_log_4_3_0";
	a_audiologs[5] = [];
	a_audiologs[5][0] = "vox_maxi_audio_log_5_1_0";
	a_audiologs[5][1] = "vox_maxi_audio_log_5_2_0";
	a_audiologs[5][2] = "vox_maxi_audio_log_5_3_0";
	a_audiologs[6] = [];
	a_audiologs[6][0] = "vox_maxi_audio_log_6_1_0";
	a_audiologs[6][1] = "vox_maxi_audio_log_6_2_0";
	return a_audiologs;
}

function start_drag_player_to_eject_tube(n_robot_id, m_linkspot)
{
	self endon("death");
	self endon("disconnect");
	a_gr_head_triggers = struct::get_array("giant_robot_head_exit_trigger", "script_noteworthy");
	a_gr_head_triggers = util::get_array_of_closest(self.origin, a_gr_head_triggers);
	foreach(trigger in a_gr_head_triggers)
	{
		if(trigger.unitrigger_stub.script_int == n_robot_id)
		{
			if(isdefined(trigger.unitrigger_stub.is_available) && trigger.unitrigger_stub.is_available)
			{
				self thread in_tube_manual_looping_rumble();
				trigger.unitrigger_stub.is_available = 0;
				s_tube = struct::get(trigger.target, "targetname");
				self PlayerLinkToDelta(m_linkspot, "tag_origin", 1, 20, 20, 20, 20);
				self thread move_player_to_eject_tube(m_linkspot, s_tube, trigger);
				break;
			}
		}
	}
}

function move_player_to_eject_tube(m_linkspot, s_tube, trigger)
{
	self endon("death");
	self endon("disconnect");
	self.giant_robot_transition = 1;
	n_speed = 500;
	n_dist = Distance(m_linkspot.origin, s_tube.origin);
	n_time = n_dist / n_speed;
	m_linkspot MoveTo(s_tube.origin, n_time);
	m_linkspot waittill("movedone");
	m_linkspot Delete();
	level thread init_player_eject_logic(trigger.unitrigger_stub, self, 1);
}

function sndalarmtimeout()
{
	self endon("teleport");
	self endon("disconnect");
	self PlaySoundToPlayer("zmb_bot_timeout_alarm", self);
	wait(2.5);
	self PlaySoundToPlayer("zmb_bot_timeout_alarm", self);
}

function play_gr_eject_impact_player_fx(player)
{
	player endon("death");
	player endon("disconnect");
	self waittill("movedone");
	player clientfield::set("gr_eject_player_impact_fx", 1);
	util::wait_network_frame();
	player notify("gr_eject_fall_complete");
	wait(1);
	player clientfield::set("gr_eject_player_impact_fx", 0);
}

function player_death_watch_on_giant_robot()
{
	self endon("disconnect");
	self endon("gr_eject_sequence_complete");
	self util::waittill_either("bled_out", "gr_head_forced_bleed_out");
	self.entered_foot_from_tank_bunker = undefined;
	self.giant_robot_transition = undefined;
	self.in_giant_robot_head = undefined;
	self.ignoreme = 0;
	self.dontspeak = 0;
}

function giant_robot_eject_disconnect_watcher(m_linkpoint, tube_clone)
{
	self endon("gr_eject_sequence_complete");
	self waittill("disconnect");
	if(isdefined(m_linkpoint))
	{
		m_linkpoint Delete();
	}
	if(isdefined(tube_clone))
	{
		tube_clone Delete();
	}
}

function turn_clientside_rumble_off()
{
	self endon("death");
	self endon("disconnect");
	util::wait_network_frame();
	self clientfield::set_to_player("giant_robot_rumble_and_shake", 0);
}

function spawn_model(model_name, origin, angles, n_spawnflags)
{
	if(!isdefined(n_spawnflags))
	{
		n_spawnflags = 0;
	}
	if(!isdefined(origin))
	{
		origin = (0, 0, 0);
	}
	model = Spawn("script_model", origin, n_spawnflags);
	model SetModel(model_name);
	if(isdefined(angles))
	{
		model.angles = angles;
	}
	return model;
}

function count_players_in_gr_head(n_robot_id)
{
	n_players_in_robot = 0;
	a_players = GetPlayers();
	foreach(player in a_players)
	{
		if(isdefined(player.in_giant_robot_head) && player.in_giant_robot_head == n_robot_id)
		{
			n_players_in_robot++;
		}
	}
	return n_players_in_robot;
}

function setup_giant_robots_intermission()
{
	level waittill("intermission");
	for(i = 0; i < 3; i++)
	{
		ai_giant_robot = GetEnt("giant_robot_" + i, "targetname");
		if(!isdefined(ai_giant_robot))
		{
			continue;
		}
		ai_giant_robot Ghost();
		ai_giant_robot StopAnimScripted(0.05);
		ai_giant_robot notify("giant_robot_stop");
		if(i == 2)
		{
			util::wait_network_frame();
			ai_giant_robot Show();
			level thread scene::Play("cin_tomb_giant_robot_walk_village", ai_giant_robot);
		}
	}
}

function giant_robot_discovered_vo(ai_giant_robot)
{
	ai_giant_robot endon("giant_robot_stop");
	self endon("disconnect");
	level endon("giant_robot_discovered");
	while(1)
	{
		if(Distance2DSquared(self.origin, ai_giant_robot.origin) < 16000000)
		{
			if(self zm_utility::is_player_looking_at(ai_giant_robot.origin + VectorScale((0, 0, 1), 2000), 0.85))
			{
				if(!IS_TRUE(self.dontspeak))
				{
					self zm_audio::create_and_play_dialog("general", "discover_robot");
					level.giant_robot_discovered = 1;
					level notify("giant_robot_discovered");
					break;
				}
			}
		}
		wait(0.1);
	}
}

function three_robot_round_vo(ai_giant_robot)
{
	ai_giant_robot endon("giant_robot_stop");
	self endon("disconnect");
	level endon("three_robot_round_vo");
	while(1)
	{
		if(Distance2DSquared(self.origin, ai_giant_robot.origin) < 16000000)
		{
			if(self zm_utility::is_player_looking_at(ai_giant_robot.origin + VectorScale((0, 0, 1), 2000), 0.85))
			{
				if(!(isdefined(self.dontspeak) && self.dontspeak))
				{
					self zm_audio::create_and_play_dialog("general", "see_robots");
					level.three_robot_round_vo = 1;
					level notify("three_robot_round_vo");
					break;
				}
			}
		}
		wait(0.1);
	}
}

function shoot_at_giant_robot_vo(ai_giant_robot)
{
	ai_giant_robot endon("giant_robot_stop");
	self endon("disconnect");
	level endon("shoot_robot_vo");
	while(1)
	{
		while(Distance2DSquared(self.origin, ai_giant_robot.origin) < 16000000 && self zm_utility::is_player_looking_at(ai_giant_robot.origin + VectorScale((0, 0, 1), 2000), 0.7))
		{
			self waittill("weapon_fired");
			if(Distance2DSquared(self.origin, ai_giant_robot.origin) < 16000000 && self zm_utility::is_player_looking_at(ai_giant_robot.origin + VectorScale((0, 0, 1), 2000), 0.7))
			{
				if(!IS_TRUE(self.dontspeak))
				{
					self zm_audio::create_and_play_dialog("general", "shoot_robot");
					level.shoot_robot_vo = 1;
					level notify("shoot_robot_vo");
					return;
				}
			}
		}
		wait(0.1);
	}
}

function start_robot_stomp_warning_vo(foot_side)
{
	if(foot_side == "right")
	{
		str_tag = "TAG_ATTACH_HATCH_RI";
	}
	else if(foot_side == "left")
	{
		str_tag = "TAG_ATTACH_HATCH_LE";
	}
	v_origin = self GetTagOrigin(str_tag);
	a_s_footprint_all = struct::get_array("giant_robot_footprint_center", "targetname");
	a_s_footprint = [];
	foreach(footprint in a_s_footprint_all)
	{
		if(footprint.script_int == self.giant_robot_id)
		{
			ARRAY_ADD(a_s_footprint,footprint)
		}
	}
	if(a_s_footprint.size == 0)
	{
		return;
	}
	else
	{
		a_s_footprint = util::get_array_of_closest(v_origin, a_s_footprint);
		s_footprint = a_s_footprint[0];
	}
	a_players = GetPlayers();
	foreach(player in a_players)
	{
		if(Distance2DSquared(player.origin, s_footprint.origin) < 160000)
		{
			player thread play_robot_stomp_warning_vo();
		}
	}
}

function play_robot_stomp_warning_vo()
{
	a_players = GetPlayers();
	foreach(player in a_players)
	{
		if(player == self)
		{
			continue;
		}
		if(Distance2DSquared(self.origin, player.origin) < 640000)
		{
			if(player zm_utility::is_player_looking_at(self.origin + VectorScale((0, 0, 1), 60)))
			{
				if(!IS_TRUE(player.dontspeak))
				{
					player zm_audio::create_and_play_dialog("general", "warn_robot_foot");
					break;
				}
			}
		}
	}
}

function zombie_stomped_by_gr_vo(foot_side)
{
	self endon("giant_robot_stop");
	if(foot_side == "right")
	{
		str_tag = "TAG_ATTACH_HATCH_RI";
	}
	else if(foot_side == "left")
	{
		str_tag = "TAG_ATTACH_HATCH_LE";
	}
	v_origin = self GetTagOrigin(str_tag);
	a_players = GetPlayers();
	foreach(player in a_players)
	{
		if(DistanceSquared(v_origin, player.origin) < 640000)
		{
			if(player zm_utility::is_player_looking_at(v_origin, 0.25))
			{
				if(!(isdefined(player.dontspeak) && player.dontspeak))
				{
					player zm_audio::create_and_play_dialog("general", "robot_crush_zombie");
					return;
				}
			}
		}
	}
}

function play_robot_crush_player_vo()
{
	self endon("disconnect");
	if(self laststand::player_is_in_laststand())
	{
		if(math::cointoss())
		{
			n_alt = 1;
		}
		else
		{
			n_alt = 0;
		}
		self PlaySoundWithNotify("vox_plr_" + self.characterindex + "_robot_crush_player_" + n_alt, "sound_done" + "vox_plr_" + self.characterindex + "_robot_crush_player_" + n_alt);
	}
}

function play_timeout_warning_vo(n_robot_id)
{
	level flag::set("timeout_vo_robot_" + n_robot_id);
	s_origin = struct::get("eject_warning_fx_robot_" + n_robot_id, "targetname");
	e_vo_origin = spawn_model("tag_origin", s_origin.origin);
	e_vo_origin PlaySoundWithNotify("vox_maxi_purge_robot_0", "vox_maxi_purge_robot_0_done");
	e_vo_origin waittill("vox_maxi_purge_robot_0_done");
	a_players = GetPlayers();
	foreach(player in a_players)
	{
		if(isdefined(player.in_giant_robot_head) && player.in_giant_robot_head == n_robot_id)
		{
			if(!IS_TRUE(player.giant_robot_transition))
			{
				if(!IS_TRUE(player.dontspeak))
				{
					player zm_audio::create_and_play_dialog("general", "purge_robot");
					break;
				}
			}
		}
	}
	while(isdefined(player) && IS_TRUE(player.isSpeaking))
	{
		wait(0.1);
	}
	wait(1);
	e_vo_origin PlaySoundWithNotify("vox_maxi_purge_countdown_0", "vox_maxi_purge_countdown_0_done");
	e_vo_origin waittill("vox_maxi_purge_countdown_0_done");
	wait(1);
	level notify("timeout_warning_vo_complete_" + n_robot_id);
	e_vo_origin PlaySoundWithNotify("vox_maxi_purge_now_0", "vox_maxi_purge_now_0_done");
	e_vo_origin waittill("vox_maxi_purge_now_0_done");
	e_vo_origin Delete();
	level flag::clear("timeout_vo_robot_" + n_robot_id);
}

function start_footprint_warning_vo(n_robot_id)
{
	wait(20);
	a_structs = struct::get_array("giant_robot_footprint_center", "targetname");
	foreach(struct in a_structs)
	{
		if(struct.script_int == n_robot_id)
		{
			struct thread footprint_check_for_nearby_players(self);
		}
	}
}

function footprint_check_for_nearby_players(ai_giant_robot)
{
	level endon("footprint_warning_vo");
	ai_giant_robot endon("giant_robot_stop");
	while(1)
	{
		a_players = GetPlayers();
		foreach(player in a_players)
		{
			if(Distance2DSquared(player.origin, self.origin) < 90000)
			{
				if(Distance2DSquared(player.origin, ai_giant_robot.origin) < 16000000)
				{
					if(player.origin[0] > ai_giant_robot.origin[0])
					{
						if(!(isdefined(player.dontspeak) && player.dontspeak))
						{
							player zm_utility::do_player_general_vox("general", "warn_robot");
							level.footprint_warning_vo = 1;
							level notify("footprint_warning_vo");
							return;
						}
					}
				}
			}
		}
		wait(1);
	}
}