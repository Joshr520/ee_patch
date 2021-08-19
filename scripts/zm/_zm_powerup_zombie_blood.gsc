#using scripts\shared\array_shared;
#using scripts\shared\callbacks_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;
#using scripts\shared\visionset_mgr_shared;
#using scripts\zm\_zm_bgb;
#using scripts\zm\_zm_powerups;
#using scripts\zm\_zm_utility;

#namespace namespace_43a18dd5;

/*
	Name: __init__sytem__
	Namespace: namespace_43a18dd5
	Checksum: 0xA6F82ACA
	Offset: 0x398
	Size: 0x33
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("zm_powerup_zombie_blood", &__init__, undefined, undefined);
}

/*
	Name: __init__
	Namespace: namespace_43a18dd5
	Checksum: 0x2D0A0913
	Offset: 0x3D8
	Size: 0x2CB
	Parameters: 0
	Flags: None
*/
function __init__()
{
	if(!isdefined(level.str_zombie_blood_model))
	{
		level.str_zombie_blood_model = "c_zom_der_zombie1";
	}
	clientfield::register("allplayers", "player_zombie_blood_fx", 21000, 1, "int");
	level._effect["zombie_blood"] = "dlc5/tomb/fx_pwr_up_blood";
	level._effect["zombie_blood_1st"] = "dlc5/tomb/fx_pwr_up_blood_overlay";
	zm_powerups::register_powerup("zombie_blood", &function_73234659);
	zm_powerups::add_zombie_powerup("zombie_blood", "p7_zm_ori_power_up_blood", &"ZOMBIE_POWERUP_MAX_AMMO", &zm_powerups::func_should_always_drop, 1, 0, 0, undefined, "powerup_zombie_blood", "zombie_powerup_zombie_blood_time", "zombie_powerup_zombie_blood_on", 1, 0);
	zm_powerups::powerup_set_can_pick_up_in_last_stand("zombie_blood", 0);
	zm_powerups::powerup_set_statless_powerup("zombie_blood");
	callback::on_connect(&init_player_zombie_blood_vars);
	level.a_zombie_blood_entities = GetEntArray("zombie_blood_visible", "targetname");
	if(isdefined(level.a_zombie_blood_entities))
	{
		foreach(var_e81648f0 in level.a_zombie_blood_entities)
		{
			var_e81648f0 thread make_zombie_blood_entity();
		}
	}
	else if(!isdefined(level.var_198f35d))
	{
		level.var_198f35d = 120;
	}
	visionset_mgr::register_info("visionset", "zm_tomb_in_plain_sight", 21000, level.var_198f35d, 31, 1, &visionset_mgr::ramp_in_out_thread_per_player, 0);
	if(!isdefined(level.var_e8b932c5))
	{
		level.var_e8b932c5 = 120;
	}
	visionset_mgr::register_info("overlay", "zm_tomb_in_plain_sight", 21000, level.var_e8b932c5, 1, 1);
}

/*
	Name: init_player_zombie_blood_vars
	Namespace: namespace_43a18dd5
	Checksum: 0x14B80CAF
	Offset: 0x6B0
	Size: 0x31
	Parameters: 0
	Flags: None
*/
function init_player_zombie_blood_vars()
{
	self.zombie_vars["zombie_powerup_zombie_blood_on"] = 0;
	self.zombie_vars["zombie_powerup_zombie_blood_time"] = 30;
}

/*
	Name: function_73234659
	Namespace: namespace_43a18dd5
	Checksum: 0xD36BBA9F
	Offset: 0x6F0
	Size: 0x23
	Parameters: 1
	Flags: None
*/
function function_73234659(player)
{
	level thread zombie_blood_powerup(self, player);
}

/*
	Name: zombie_blood_powerup
	Namespace: namespace_43a18dd5
	Checksum: 0xF9671EA9
	Offset: 0x720
	Size: 0x6B9
	Parameters: 2
	Flags: None
*/
function zombie_blood_powerup(var_bae0d10b, e_player)
{
	e_player notify("zombie_blood");
	e_player endon("zombie_blood");
	e_player endon("disconnect");
	e_player thread zm_powerups::powerup_vo("zombie_blood");
	e_player._show_solo_hud = 1;
	if(bgb::is_team_enabled("zm_bgb_temporal_gift"))
	{
		var_bf0a128b = 60;
	}
	else
	{
		var_bf0a128b = 30;
	}
	if(!e_player.zombie_vars["zombie_powerup_zombie_blood_on"])
	{
		e_player zm_utility::increment_ignoreme();
	}
	e_player.zombie_vars["zombie_powerup_zombie_blood_time"] = var_bf0a128b;
	e_player.zombie_vars["zombie_powerup_zombie_blood_on"] = 1;
	e_player SetCharacterBodyStyle(1);
	level notify("player_zombie_blood", e_player);
	visionset_mgr::activate("visionset", "zm_tomb_in_plain_sight", e_player, 0.5, var_bf0a128b, 0.5);
	visionset_mgr::activate("overlay", "zm_tomb_in_plain_sight", e_player);
	e_player clientfield::set("player_zombie_blood_fx", 1);
	level.a_zombie_blood_entities = Array::remove_undefined(level.a_zombie_blood_entities);
	foreach(e_zombie_blood in level.a_zombie_blood_entities)
	{
		if(isdefined(e_zombie_blood.e_unique_player))
		{
			if(e_zombie_blood.e_unique_player == e_player)
			{
				e_zombie_blood SetVisibleToPlayer(e_player);
			}
			continue;
		}
		e_zombie_blood SetVisibleToPlayer(e_player);
	}
	if(!isdefined(e_player.m_fx))
	{
		v_origin = e_player GetTagOrigin("j_eyeball_le");
		v_angles = e_player GetTagAngles("j_eyeball_le");
		m_fx = spawn("script_model", v_origin);
		m_fx SetModel("tag_origin");
		m_fx.angles = v_angles;
		m_fx LinkTo(e_player, "j_eyeball_le", (0, 0, 0), (0, 0, 0));
		m_fx thread fx_disconnect_watch(e_player);
		PlayFXOnTag(level._effect["zombie_blood"], m_fx, "tag_origin");
		e_player.m_fx = m_fx;
		e_player.m_fx PlayLoopSound("zmb_zombieblood_3rd_loop", 1);
	}
	e_player thread watch_zombie_blood_early_exit();
	while(e_player.zombie_vars["zombie_powerup_zombie_blood_time"] >= 0)
	{
		wait(0.05);
		e_player.zombie_vars["zombie_powerup_zombie_blood_time"] = e_player.zombie_vars["zombie_powerup_zombie_blood_time"] - 0.05;
	}
	e_player SetCharacterBodyStyle(0);
	e_player notify("zombie_blood_over");
	if(isdefined(e_player.characterindex))
	{
		e_player playsound("vox_plr_" + e_player.characterindex + "_exert_grunt_" + randomIntRange(0, 3));
	}
	e_player.m_fx delete();
	visionset_mgr::deactivate("visionset", "zm_tomb_in_plain_sight", e_player);
	visionset_mgr::deactivate("overlay", "zm_tomb_in_plain_sight", e_player);
	e_player.zombie_vars["zombie_powerup_zombie_blood_on"] = 0;
	e_player.zombie_vars["zombie_powerup_zombie_blood_time"] = 30;
	e_player._show_solo_hud = 0;
	e_player clientfield::set("player_zombie_blood_fx", 0);
	e_player zm_utility::decrement_ignoreme();
	level.a_zombie_blood_entities = Array::remove_undefined(level.a_zombie_blood_entities);
	foreach(e_zombie_blood in level.a_zombie_blood_entities)
	{
		e_zombie_blood SetInvisibleToPlayer(e_player);
	}
}

/*
	Name: fx_disconnect_watch
	Namespace: namespace_43a18dd5
	Checksum: 0xFD05D0BF
	Offset: 0xDE8
	Size: 0x3B
	Parameters: 1
	Flags: None
*/
function fx_disconnect_watch(e_player)
{
	self endon("death");
	e_player waittill("disconnect");
	self delete();
}

/*
	Name: watch_zombie_blood_early_exit
	Namespace: namespace_43a18dd5
	Checksum: 0x1F6115D5
	Offset: 0xE30
	Size: 0x83
	Parameters: 0
	Flags: None
*/
function watch_zombie_blood_early_exit()
{
	self notify("early_exit_watch");
	self endon("early_exit_watch");
	self endon("zombie_blood_over");
	self endon("disconnect");
	util::waittill_any_ents_two(self, "player_downed", level, "end_game");
	self.zombie_vars["zombie_powerup_zombie_blood_time"] = -0.05;
	self.early_exit = 1;
}

/*
	Name: make_zombie_blood_entity
	Namespace: namespace_43a18dd5
	Checksum: 0x407F8505
	Offset: 0xEC0
	Size: 0x191
	Parameters: 0
	Flags: None
*/
function make_zombie_blood_entity()
{
	/#
		Assert(isdefined(level.a_zombie_blood_entities), "Dev Block strings are not supported");
	#/
	if(!isdefined(level.a_zombie_blood_entities))
	{
		level.a_zombie_blood_entities = [];
	}
	else if(!IsArray(level.a_zombie_blood_entities))
	{
		level.a_zombie_blood_entities = Array(level.a_zombie_blood_entities);
	}
	level.a_zombie_blood_entities[level.a_zombie_blood_entities.size] = self;
	self SetInvisibleToAll();
	foreach(e_player in GetPlayers())
	{
		if(e_player.zombie_vars["zombie_powerup_zombie_blood_on"])
		{
			if(isdefined(self.e_unique_player))
			{
				if(self.e_unique_player == e_player)
				{
					self SetVisibleToPlayer(e_player);
				}
				continue;
			}
			self SetVisibleToPlayer(e_player);
		}
	}
}

