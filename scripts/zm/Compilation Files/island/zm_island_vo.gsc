#using scripts\codescripts\struct;
#using scripts\shared\array_shared;
#using scripts\shared\callbacks_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\exploder_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\laststand_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;
#using scripts\shared\vehicle_ai_shared;
#using scripts\zm\_zm;
#using scripts\zm\_zm_audio;
#using scripts\zm\_zm_equipment;
#using scripts\zm\_zm_laststand;
#using scripts\zm\_zm_score;
#using scripts\zm\_zm_sidequests;
#using scripts\zm\_zm_spawner;
#using scripts\zm\_zm_timer;
#using scripts\zm\_zm_unitrigger;
#using scripts\zm\_zm_utility;
#using scripts\zm\_zm_weapons;
#using scripts\zm\_zm_zonemgr;
#using scripts\zm\craftables\_zm_craftables;
#using scripts\zm\zm_island_util;

#namespace namespace_f333593c;

/*
	Name: __init__sytem__
	Namespace: namespace_f333593c
	Checksum: 0x767AED28
	Offset: 0x1998
	Size: 0x33
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("zm_island_vo", &__init__, undefined, undefined);
}

/*
	Name: __init__
	Namespace: namespace_f333593c
	Checksum: 0x7F5FC30B
	Offset: 0x19D8
	Size: 0x1EB
	Parameters: 0
	Flags: None
*/
function __init__()
{
	callback::on_connect(&on_player_connect);
	callback::on_spawned(&on_player_spawned);
	level.a_e_speakers = [];
	level.audio_get_mod_type = &function_642e6aef;
	function_267933e4();
	level thread function_772aa229();
	level thread function_c426b455();
	level flag::init("thrasher_spotted");
	level flag::init("vo_lock_thrasher_appear_roar");
	level flag::init("takeofight_wave_spawning");
	level thread function_8eebdc4d();
	level thread function_5ca4424();
	level thread function_a5b6f9c0();
	level.var_bac3b790 = [];
	level.var_38d92be7 = [];
	level.var_c6455b5 = [];
	level.var_2c67f767 = [];
	level.var_4b332a77 = [];
	level.var_bc80de72 = [];
	level.var_9c6abc49 = [];
	level.var_caa91bc0 = [];
	level flag::init("skull_s_pickup_vo_locked");
	zm_spawner::register_zombie_death_event_callback(&function_b978ce37);
}

/*
	Name: on_player_spawned
	Namespace: namespace_f333593c
	Checksum: 0x1836A727
	Offset: 0x1BD0
	Size: 0x9C3
	Parameters: 0
	Flags: None
*/
function on_player_spawned()
{
	self.var_10f58653 = [];
	self.var_bac3b790 = [];
	self.var_38d92be7 = [];
	self.var_c6455b5 = [];
	self.var_2c67f767 = [];
	self.var_4b332a77 = [];
	self.var_bc80de72 = [];
	self.var_9c6abc49 = [];
	self.var_caa91bc0 = [];
	self.isSpeaking = 0;
	self.n_vo_priority = 0;
	self thread zm_audio::water_vox();
	self function_65f8953a("player_filled_bucket", "bucket", "fill", 10, 3);
	self function_65f8953a("player_watered_plant", "water", "plant", 5, 3);
	self function_65f8953a("player_opened_bunker", "access", "bunker", 10, 1);
	self function_65f8953a("island_riotshield_pickup_from_table", "pickup", "zombie_shield", 5);
	self function_65f8953a("player_has_gasmask", "pickup", "gas_mask", 5, 1);
	self function_65f8953a("player_lost_gasmask", "break", "gas_mask", 5, 3);
	self function_65f8953a("flag_player_completed_challenge_1", "response", "positive", 5);
	self function_65f8953a("flag_player_completed_challenge_2", "response", "positive", 5);
	self function_65f8953a("flag_player_completed_challenge_3", "response", "positive", 5);
	self function_65f8953a("player_opened_pap", "response", "positive", 5);
	self function_65f8953a("player_spore_enhanced", "response", "positive", 30);
	self function_65f8953a("player_revealed_cache_plant_good", "response", "positive", 60, 0, 1);
	self function_65f8953a("player_ate_fruit_success", "response", "positive", 60, 0);
	self function_65f8953a("player_got_gasmask_part", "pickup", "generic", 5);
	self function_65f8953a("player_got_ww_part", "pickup", "generic", 5);
	self function_65f8953a("player_got_valve_part", "pickup", "generic", 5);
	self function_65f8953a("player_got_craftable_piece_for_craft_shield_zm", "pickup", "generic", 5);
	self function_65f8953a("player_revealed_cache_plant_bad", "response", "negative", 60, 0, 1);
	self function_65f8953a("player_got_gold_bucket", "ee", "bucket", 5);
	self function_65f8953a("player_upgraded_ww", "quest_ww", "pickup", 5);
	self function_65f8953a("player_got_mirg2000", "quest_ww", "pickup", 5);
	self function_65f8953a("player_tried_pickup_mirg2000", "quest_ww", "pickup_attempt", 30, 0);
	self function_65f8953a("player_killed_zombie_with_mirg2000", "kill", "kt4", 60);
	self function_65f8953a("player_hit_plant_with_mirg2000", "use", "kt4", 60, 3);
	self function_65f8953a("player_got_lightning_shield", "ee", "shield", 20);
	self function_65f8953a("player_saw_good_thrasher_creation", "ee", "thrasher_create", 10, 1, 1);
	self function_65f8953a("player_saw_good_thrasher_death", "ee", "thrasher_dies", 10, 1, 1);
	self function_65f8953a("skullweapon_killed_zombie", "keeperskull", "kill", 60);
	self function_65f8953a("skullweapon_mesmerized_zombie", "keeperskull", "protect", 60);
	self function_65f8953a("skullweapon_revealed_location", "keeperskull", "reveal", 10, 0, 5);
	self function_65f8953a("skull_weapon_fully_charged", "keeperskull", "recharged", 10, 0, 1);
	self function_65f8953a("player_killed_spider", "spider", "kill", 30, 5, 1);
	self function_65f8953a("tearing_web", "web", "remove", 30, 5);
	self function_65f8953a("aquired_spider_equipment", "ee", "spider_equip", 10, 1);
	self function_65f8953a("player_used_controllable_spider", "ee", "spider_use", 10, 3);
	self function_65f8953a("player_eaten_by_thrasher", "thrasher", "eaten", 1, 0, 1);
	self function_65f8953a("player_enraged_thrasher", "thrasher", "enraged", 120, 0, 1);
	self function_65f8953a("player_stunned_thrasher", "thrasher", "stun", 120);
	self function_65f8953a("player_killed_thrasher", "thrasher", "kill", 120);
	self function_65f8953a("sewer_over", "sewer", "use", 10, 5);
	self function_65f8953a("zipline_start", "zipline", "use", 10, 5);
	self function_65f8953a("player_started_proptrap", "trap", "prop_start", 5, 0);
	self function_65f8953a("player_started_walltrap", "trap", "fan_start", 5, 0);
	self function_65f8953a("player_saw_proptrap_kill", "trap", "prop_kill", 10, 0);
	self function_65f8953a("player_saw_walltrap_kill", "trap", "fan_kill", 10, 0);
	self thread function_81d644a1();
}

/*
	Name: main
	Namespace: namespace_f333593c
	Checksum: 0x761138F8
	Offset: 0x25A0
	Size: 0x33
	Parameters: 0
	Flags: None
*/
function main()
{
	level thread function_c261e8aa();
	level thread function_3f78fe22();
}

/*
	Name: on_player_connect
	Namespace: namespace_f333593c
	Checksum: 0x99EC1590
	Offset: 0x25E0
	Size: 0x3
	Parameters: 0
	Flags: None
*/
function on_player_connect()
{
}

/*
	Name: function_218256bd
	Namespace: namespace_f333593c
	Checksum: 0x20571FC8
	Offset: 0x25F0
	Size: 0x169
	Parameters: 1
	Flags: None
*/
function function_218256bd(var_eca8128e)
{
	foreach(player in level.activePlayers)
	{
		if(isdefined(player))
		{
			player.dontspeak = var_eca8128e;
			player clientfield::set_to_player("isspeaking", var_eca8128e);
		}
	}
	if(var_eca8128e)
	{
		foreach(player in level.activePlayers)
		{
			while(isdefined(player) && (isdefined(player.isSpeaking) && player.isSpeaking))
			{
				wait(0.1);
			}
		}
	}
}

/*
	Name: function_cf8fccfe
	Namespace: namespace_f333593c
	Checksum: 0x6641EC93
	Offset: 0x2768
	Size: 0x6F
	Parameters: 1
	Flags: None
*/
function function_cf8fccfe(var_eca8128e)
{
	self.dontspeak = var_eca8128e;
	self clientfield::set_to_player("isspeaking", var_eca8128e);
	if(var_eca8128e)
	{
		while(isdefined(self) && (isdefined(self.isSpeaking) && self.isSpeaking))
		{
			wait(0.1);
		}
	}
}

/*
	Name: function_7b697614
	Namespace: namespace_f333593c
	Checksum: 0xA390CF39
	Offset: 0x27E0
	Size: 0x35F
	Parameters: 5
	Flags: None
*/
function function_7b697614(var_96896ff5, n_delay, b_wait_if_busy, var_a8564a44, var_d1295208)
{
	if(!isdefined(n_delay))
	{
		n_delay = 0;
	}
	if(!isdefined(b_wait_if_busy))
	{
		b_wait_if_busy = 0;
	}
	if(!isdefined(var_a8564a44))
	{
		var_a8564a44 = 0;
	}
	if(!isdefined(var_d1295208))
	{
		var_d1295208 = 0;
	}
	self endon("death");
	self endon("disconnect");
	self endon("stop_vo_convo");
	if(isdefined(self.var_e1f8edd6) && self.var_e1f8edd6)
	{
		return 0;
	}
	if(zm_audio::areNearbySpeakersActive(10000) && (!isdefined(var_d1295208) && var_d1295208))
	{
		return 0;
	}
	if(isdefined(self.isSpeaking) && self.isSpeaking || (isdefined(level.sndVoxOverride) && level.sndVoxOverride) || self IsPlayerUnderwater())
	{
		if(isdefined(b_wait_if_busy) && b_wait_if_busy)
		{
			while(isdefined(self.isSpeaking) && self.isSpeaking || (isdefined(level.sndVoxOverride) && level.sndVoxOverride) || self IsPlayerUnderwater())
			{
				wait(0.1);
			}
			wait(0.35);
		}
		else
		{
			return 0;
		}
	}
	if(n_delay > 0)
	{
		wait(n_delay);
	}
	if(isdefined(self.isSpeaking) && self.isSpeaking && (isdefined(self.b_wait_if_busy) && self.b_wait_if_busy))
	{
		while(isdefined(self.isSpeaking) && self.isSpeaking)
		{
			wait(0.1);
		}
	}
	else if(isdefined(self.isSpeaking) && self.isSpeaking && (!isdefined(self.b_wait_if_busy) && self.b_wait_if_busy) || (isdefined(level.sndVoxOverride) && level.sndVoxOverride))
	{
		return 0;
	}
	self.isSpeaking = 1;
	level.sndVoxOverride = 1;
	self.n_vo_priority = var_a8564a44;
	self.str_vo_being_spoken = var_96896ff5;
	Array::add(level.a_e_speakers, self, 1);
	var_2df3d133 = var_96896ff5 + "_vo_done";
	if(IsActor(self) || isPlayer(self))
	{
		self PlaySoundWithNotify(var_96896ff5, var_2df3d133, "J_head");
	}
	else
	{
		self PlaySoundWithNotify(var_96896ff5, var_2df3d133);
	}
	self waittill(var_2df3d133);
	self function_8995134a();
	return 1;
}

/*
	Name: function_8995134a
	Namespace: namespace_f333593c
	Checksum: 0x958EDB42
	Offset: 0x2B48
	Size: 0xFB
	Parameters: 0
	Flags: None
*/
function function_8995134a()
{
	self.str_vo_being_spoken = "";
	self.n_vo_priority = 0;
	self.isSpeaking = 0;
	level.sndVoxOverride = 0;
	b_in_a_e_speakers = 0;
	foreach(e_checkme in level.a_e_speakers)
	{
		if(e_checkme == self)
		{
			b_in_a_e_speakers = 1;
			break;
		}
	}
	if(isdefined(b_in_a_e_speakers) && b_in_a_e_speakers)
	{
		ArrayRemoveValue(level.a_e_speakers, self);
	}
}

/*
	Name: function_502f946b
	Namespace: namespace_f333593c
	Checksum: 0x507C1E94
	Offset: 0x2C50
	Size: 0x5B
	Parameters: 0
	Flags: None
*/
function function_502f946b()
{
	self endon("death");
	if(isdefined(self.str_vo_being_spoken) && self.str_vo_being_spoken != "")
	{
		self stopSound(self.str_vo_being_spoken);
	}
	function_8995134a();
}

/*
	Name: function_2426269b
	Namespace: namespace_f333593c
	Checksum: 0x4E10A72C
	Offset: 0x2CB8
	Size: 0x231
	Parameters: 2
	Flags: None
*/
function function_2426269b(v_pos, n_range)
{
	if(!isdefined(n_range))
	{
		n_range = 1000;
	}
	if(isdefined(level.a_e_speakers))
	{
		foreach(var_d211180f in level.a_e_speakers)
		{
			if(!isdefined(var_d211180f))
			{
				continue;
			}
			if(!isdefined(v_pos) || DistanceSquared(var_d211180f.origin, v_pos) <= n_range * n_range)
			{
				if(isdefined(var_d211180f.str_vo_being_spoken) && var_d211180f.str_vo_being_spoken != "")
				{
					var_d211180f stopSound(var_d211180f.str_vo_being_spoken);
				}
				var_d211180f.deleteme = 1;
				var_d211180f.str_vo_being_spoken = "";
				var_d211180f.n_vo_priority = 0;
				var_d211180f.isSpeaking = 0;
			}
		}
		i = 0;
		while(isdefined(level.a_e_speakers) && i < level.a_e_speakers.size)
		{
			if(isdefined(level.a_e_speakers[i].deleteme) && level.a_e_speakers[i].deleteme == 1)
			{
				ArrayRemoveValue(level.a_e_speakers, level.a_e_speakers[i]);
				i = 0;
			}
			else
			{
				i++;
			}
		}
	}
}

/*
	Name: function_cf763858
	Namespace: namespace_f333593c
	Checksum: 0x117596B6
	Offset: 0x2EF8
	Size: 0xB3
	Parameters: 0
	Flags: None
*/
function function_cf763858()
{
	if(isdefined(self.speakingLine) && self.speakingLine != "")
	{
		self stopSound(self.speakingLine);
		self.speakingLine = "";
		self.isSpeaking = 0;
	}
	if(isdefined(self.str_vo_being_spoken) && self.str_vo_being_spoken != "")
	{
		self stopSound(self.str_vo_being_spoken);
		self function_8995134a();
	}
}

/*
	Name: function_897246e4
	Namespace: namespace_f333593c
	Checksum: 0x1261864
	Offset: 0x2FB8
	Size: 0x1F3
	Parameters: 5
	Flags: None
*/
function function_897246e4(var_96896ff5, n_wait, b_wait_if_busy, var_a8564a44, var_d1295208)
{
	if(!isdefined(n_wait))
	{
		n_wait = 0;
	}
	if(!isdefined(b_wait_if_busy))
	{
		b_wait_if_busy = 0;
	}
	if(!isdefined(var_a8564a44))
	{
		var_a8564a44 = 0;
	}
	if(!isdefined(var_d1295208))
	{
		var_d1295208 = 0;
	}
	var_942373f4 = 0;
	var_9689ca97 = 0;
	var_81132431 = StrTok(var_96896ff5, "_");
	if(var_81132431[1] === "grop")
	{
		var_942373f4 = 1;
	}
	else if(var_81132431[7] === "pa")
	{
		var_9689ca97 = 1;
	}
	else if(var_81132431[1] === "plr")
	{
		var_edf0b06 = Int(var_81132431[2]);
		e_speaker = zm_utility::get_specific_character(var_edf0b06);
	}
	else
	{
		e_speaker = undefined;
		/#
			Assert(0, "Dev Block strings are not supported" + var_96896ff5 + "Dev Block strings are not supported");
		#/
	}
	if(!var_942373f4 && !var_9689ca97)
	{
		if(zm_utility::is_player_valid(e_speaker))
		{
			return e_speaker function_7b697614(var_96896ff5, n_wait, b_wait_if_busy, var_a8564a44);
		}
	}
}

/*
	Name: function_63c44c5a
	Namespace: namespace_f333593c
	Checksum: 0xACD4376A
	Offset: 0x31B8
	Size: 0x14B
	Parameters: 5
	Flags: None
*/
function function_63c44c5a(var_cbd11028, var_e21e86b8, b_wait_if_busy, var_a8564a44, var_d1295208)
{
	if(!isdefined(b_wait_if_busy))
	{
		b_wait_if_busy = 0;
	}
	if(!isdefined(var_a8564a44))
	{
		var_a8564a44 = 0;
	}
	if(!isdefined(var_d1295208))
	{
		var_d1295208 = 0;
	}
	function_218256bd(1);
	for(i = 0; i < var_cbd11028.size; i++)
	{
		if(isdefined(var_e21e86b8))
		{
			var_e27770b1 = var_e21e86b8[i];
		}
		else
		{
			var_e27770b1 = 0;
		}
		var_4f1e87a6 = self function_7b697614(var_cbd11028[i], var_e27770b1, b_wait_if_busy, var_a8564a44, var_d1295208);
		if(!isdefined(var_4f1e87a6))
		{
			return;
			function_218256bd(0);
		}
	}
	function_218256bd(0);
}

/*
	Name: function_7aa5324a
	Namespace: namespace_f333593c
	Checksum: 0x9D32D349
	Offset: 0x3310
	Size: 0x15B
	Parameters: 5
	Flags: None
*/
function function_7aa5324a(var_cbd11028, var_e21e86b8, b_wait_if_busy, var_a8564a44, var_d1295208)
{
	if(!isdefined(b_wait_if_busy))
	{
		b_wait_if_busy = 0;
	}
	if(!isdefined(var_a8564a44))
	{
		var_a8564a44 = 0;
	}
	if(!isdefined(var_d1295208))
	{
		var_d1295208 = 0;
	}
	function_218256bd(1);
	for(i = 0; i < var_cbd11028.size; i++)
	{
		if(isdefined(var_e21e86b8))
		{
			var_e27770b1 = var_e21e86b8[i];
		}
		else
		{
			var_e27770b1 = 0.5;
		}
		var_4f1e87a6 = function_897246e4(var_cbd11028[i], var_e27770b1, b_wait_if_busy, var_a8564a44, var_d1295208);
		if(!isdefined(var_4f1e87a6) || (!isdefined(var_4f1e87a6) && var_4f1e87a6))
		{
			function_218256bd(0);
			return;
		}
	}
	function_218256bd(0);
}

/*
	Name: function_642e6aef
	Namespace: namespace_f333593c
	Checksum: 0xC21E8F
	Offset: 0x3478
	Size: 0x3C5
	Parameters: 7
	Flags: None
*/
function function_642e6aef(impact, mod, weapon, zombie, instakill, dist, player)
{
	close_dist = 4096;
	med_dist = 15376;
	far_dist = 160000;
	if(zombie.damageWeapon.name == "sticky_grenade_widows_wine")
	{
		return "default";
	}
	if(weapon.name == "hero_mirg2000")
	{
		return undefined;
	}
	if(zm_utility::is_placeable_mine(weapon))
	{
		if(!instakill)
		{
			return "betty";
		}
		else
		{
			return "weapon_instakill";
		}
	}
	if(zombie.damageWeapon.name == "cymbal_monkey")
	{
		if(instakill)
		{
			return "weapon_instakill";
		}
		else
		{
			return "monkey";
		}
	}
	if(weapon.name == "ray_gun" || weapon.name == "ray_gun_upgraded" && dist > far_dist)
	{
		if(!instakill)
		{
			return "raygun";
		}
		else
		{
			return "weapon_instakill";
		}
	}
	if(zm_utility::is_headshot(weapon, impact, mod) && dist >= far_dist)
	{
		return "headshot";
	}
	if(mod == "MOD_MELEE" || mod == "MOD_UNKNOWN" && dist < close_dist)
	{
		if(!instakill)
		{
			return "melee";
		}
		else
		{
			return "melee_instakill";
		}
	}
	if(zm_utility::is_explosive_damage(mod) && weapon.name != "ray_gun" && weapon.name != "ray_gun_upgraded" && (!isdefined(zombie.is_on_fire) && zombie.is_on_fire))
	{
		if(!instakill)
		{
			return "explosive";
		}
		else
		{
			return "weapon_instakill";
		}
	}
	if(weapon.doesFireDamage && (mod == "MOD_BURNED" || mod == "MOD_GRENADE" || mod == "MOD_GRENADE_SPLASH"))
	{
		if(!instakill)
		{
			return "flame";
		}
		else
		{
			return "weapon_instakill";
		}
	}
	if(!isdefined(impact))
	{
		impact = "";
	}
	if(mod != "MOD_MELEE" && zombie.missingLegs)
	{
		return "crawler";
	}
	if(mod != "MOD_BURNED" && dist < close_dist)
	{
		return "close";
	}
	if(mod == "MOD_RIFLE_BULLET" || mod == "MOD_PISTOL_BULLET")
	{
		if(!instakill)
		{
			return "bullet";
		}
		else
		{
			return "weapon_instakill";
		}
	}
	if(instakill)
	{
		return "default";
	}
	return "default";
}

/*
	Name: function_772aa229
	Namespace: namespace_f333593c
	Checksum: 0xBF58149C
	Offset: 0x3848
	Size: 0xE7
	Parameters: 0
	Flags: None
*/
function function_772aa229()
{
	self endon("_zombie_game_over");
	while(1)
	{
		level waittill("start_of_round");
		if(function_70e6e39e() == 0)
		{
			if(level.activePlayers.size == 1)
			{
				level thread function_54cd030a();
			}
			else
			{
				level thread function_cc4d4a7c();
			}
		}
		level waittill("end_of_round");
		if(function_70e6e39e() == 0)
		{
			if(level.activePlayers.size == 1)
			{
				level thread function_340dc03();
			}
			else
			{
				level thread function_7ca05725();
			}
		}
	}
}

/*
	Name: function_54cd030a
	Namespace: namespace_f333593c
	Checksum: 0x73B84154
	Offset: 0x3938
	Size: 0x83
	Parameters: 0
	Flags: None
*/
function function_54cd030a()
{
	if(level.round_number <= 1)
	{
		e_speaker = level.players[0];
		var_5da47f0d = function_11b41a76(e_speaker.characterindex, "round_start_solo", level.round_number);
		e_speaker function_e4acaa37(var_5da47f0d);
	}
}

/*
	Name: function_340dc03
	Namespace: namespace_f333593c
	Checksum: 0x16ED1AB0
	Offset: 0x39C8
	Size: 0xDB
	Parameters: 0
	Flags: None
*/
function function_340dc03()
{
	var_5df8c4ee = level.round_number - 1;
	if(var_5df8c4ee <= 2)
	{
		e_speaker = level.players[0];
		if(var_5df8c4ee == 2 && e_speaker.characterindex === 3 && level.var_7ccadaab === 11)
		{
			var_380dee9e = "vox_plr_3_round2_end_solo_japalt_0";
		}
		else
		{
			var_380dee9e = function_11b41a76(e_speaker.characterindex, "round_end_solo", var_5df8c4ee);
		}
		e_speaker function_e4acaa37(var_380dee9e);
	}
}

/*
	Name: function_cc4d4a7c
	Namespace: namespace_f333593c
	Checksum: 0xEA4ECB1D
	Offset: 0x3AB0
	Size: 0x163
	Parameters: 0
	Flags: None
*/
function function_cc4d4a7c()
{
	a_players = ArrayCopy(level.activePlayers);
	var_e8669 = zm_utility::get_specific_character(2);
	if(level.round_number <= 2 && isdefined(var_e8669))
	{
		a_vo_lines = [];
		a_vo_lines[0] = function_11b41a76(var_e8669.characterindex, "round_start_coop", level.round_number);
		ArrayRemoveValue(a_players, var_e8669);
		var_261100d2 = ArrayGetClosest(var_e8669.origin, a_players);
		a_vo_lines[1] = function_11b41a76(var_261100d2.characterindex, "round_start_coop", level.round_number);
		var_e8669 thread function_280223ba(a_vo_lines);
	}
	else if(level.round_number == 1)
	{
		level thread function_3cdbc215();
	}
}

/*
	Name: function_7ca05725
	Namespace: namespace_f333593c
	Checksum: 0xA48EAA29
	Offset: 0x3C20
	Size: 0x16B
	Parameters: 0
	Flags: None
*/
function function_7ca05725()
{
	a_players = ArrayCopy(level.activePlayers);
	var_e8669 = zm_utility::get_specific_character(2);
	var_5df8c4ee = level.round_number - 1;
	if(var_5df8c4ee <= 2 && isdefined(var_e8669))
	{
		a_vo_lines = [];
		a_vo_lines[0] = function_11b41a76(var_e8669.characterindex, "round_end_coop", var_5df8c4ee);
		ArrayRemoveValue(a_players, var_e8669);
		var_261100d2 = ArrayGetClosest(var_e8669.origin, a_players);
		a_vo_lines[1] = function_11b41a76(var_261100d2.characterindex, "round_end_coop", var_5df8c4ee);
		var_e8669 thread function_280223ba(a_vo_lines);
	}
	else
	{
		level thread function_3cdbc215();
	}
}

/*
	Name: function_b83e53a5
	Namespace: namespace_f333593c
	Checksum: 0xB37B4BDB
	Offset: 0x3D98
	Size: 0x1C3
	Parameters: 0
	Flags: None
*/
function function_b83e53a5()
{
	var_910a2ebc = 0;
	var_121146b = 0;
	foreach(player in level.activePlayers)
	{
		if(player.characterindex == 2)
		{
			var_910a2ebc = 1;
			continue;
		}
		if(player.characterindex == 0)
		{
			var_121146b = 1;
		}
	}
	if(isdefined(var_121146b) && var_121146b && (isdefined(var_910a2ebc) && var_910a2ebc))
	{
		var_c9fd3802 = Array("vox_plr_0_outro_igc_31", "vox_plr_2_outro_igc_32");
		level thread function_7aa5324a(var_c9fd3802);
	}
	else if(var_910a2ebc)
	{
		level thread function_897246e4("vox_plr_2_outro_igc_32");
	}
	else
	{
		s_org = struct::get("ending_igc_exit_" + 2);
		playsoundatposition("vox_plr_2_outro_igc_32", s_org.origin);
	}
}

/*
	Name: function_267933e4
	Namespace: namespace_f333593c
	Checksum: 0xD4941AB9
	Offset: 0x3F68
	Size: 0x7E5
	Parameters: 0
	Flags: None
*/
function function_267933e4()
{
	level.var_b7e67f82 = Array(0, 0, 0, 0);
	var_85fdde46 = [];
	var_85fdde46[0] = Array("vox_plr_0_interaction_demp_niko_1_0", "vox_plr_1_interaction_demp_niko_1_0");
	var_85fdde46[1] = Array("vox_plr_0_interaction_demp_niko_2_0", "vox_plr_1_interaction_demp_niko_2_0");
	var_85fdde46[2] = Array("vox_plr_1_interaction_demp_niko_3_0", "vox_plr_0_interaction_demp_niko_3_0");
	var_85fdde46[3] = Array("vox_plr_1_interaction_demp_niko_4_0", "vox_plr_0_interaction_demp_niko_4_0");
	var_85fdde46[4] = Array("vox_plr_0_interaction_demp_niko_5_0", "vox_plr_1_interaction_demp_niko_5_0");
	level.var_85fdde46 = var_85fdde46;
	level.var_5705772e = 0;
	level.var_b7e67f82[0] = level.var_b7e67f82[0] + var_85fdde46.size;
	level.var_b7e67f82[1] = level.var_b7e67f82[1] + var_85fdde46.size;
	var_559f698d = [];
	var_559f698d[0] = Array("vox_plr_0_interaction_rich_demp_1_0", "vox_plr_2_interaction_rich_demp_1_0");
	var_559f698d[1] = Array("vox_plr_2_interaction_rich_demp_2_0", "vox_plr_0_interaction_rich_demp_2_0");
	var_559f698d[2] = Array("vox_plr_2_interaction_rich_demp_3_0", "vox_plr_0_interaction_rich_demp_3_0");
	var_559f698d[3] = Array("vox_plr_2_interaction_rich_demp_4_0", "vox_plr_0_interaction_rich_demp_4_0");
	var_559f698d[4] = Array("vox_plr_2_interaction_rich_demp_5_0", "vox_plr_0_interaction_rich_demp_5_0");
	level.var_559f698d = var_559f698d;
	level.var_d9e67775 = 0;
	level.var_b7e67f82[0] = level.var_b7e67f82[0] + var_559f698d.size;
	level.var_b7e67f82[2] = level.var_b7e67f82[2] + var_559f698d.size;
	var_b16db601 = [];
	var_b16db601[0] = Array("vox_plr_3_interaction_demp_takeo_1_0", "vox_plr_0_interaction_demp_takeo_1_0");
	var_b16db601[1] = Array("vox_plr_3_interaction_demp_takeo_2_0", "vox_plr_0_interaction_demp_takeo_2_0");
	var_b16db601[2] = Array("vox_plr_0_interaction_demp_takeo_3_0", "vox_plr_3_interaction_demp_takeo_3_0");
	var_b16db601[3] = Array("vox_plr_0_interaction_demp_takeo_4_0", "vox_plr_3_interaction_demp_takeo_4_0");
	var_b16db601[4] = Array("vox_plr_3_interaction_demp_takeo_5_0", "vox_plr_0_interaction_demp_takeo_5_0");
	level.var_b16db601 = var_b16db601;
	level.var_a47c9479 = 0;
	level.var_b7e67f82[0] = level.var_b7e67f82[0] + var_b16db601.size;
	level.var_b7e67f82[3] = level.var_b7e67f82[3] + var_b16db601.size;
	var_4d918dae = [];
	var_4d918dae[0] = Array("vox_plr_1_interaction_rich_niko_1_0", "vox_plr_2_interaction_rich_niko_1_0");
	var_4d918dae[1] = Array("vox_plr_1_interaction_rich_niko_2_0", "vox_plr_2_interaction_rich_niko_2_0");
	var_4d918dae[2] = Array("vox_plr_1_interaction_rich_niko_3_0", "vox_plr_2_interaction_rich_niko_3_0");
	var_4d918dae[3] = Array("vox_plr_1_interaction_rich_niko_4_0", "vox_plr_2_interaction_rich_niko_4_0");
	var_4d918dae[4] = Array("vox_plr_2_interaction_rich_niko_5_0", "vox_plr_1_interaction_rich_niko_5_0");
	level.var_4d918dae = var_4d918dae;
	level.var_2ed438a6 = 0;
	level.var_b7e67f82[1] = level.var_b7e67f82[1] + var_4d918dae.size;
	level.var_b7e67f82[2] = level.var_b7e67f82[2] + var_4d918dae.size;
	var_ec060c98 = [];
	var_ec060c98[0] = Array("vox_plr_3_interaction_takeo_niko_1_0", "vox_plr_1_interaction_takeo_niko_1_0");
	var_ec060c98[1] = Array("vox_plr_3_interaction_takeo_niko_2_0", "vox_plr_1_interaction_takeo_niko_2_0");
	var_ec060c98[2] = Array("vox_plr_1_interaction_takeo_niko_3_0", "vox_plr_3_interaction_takeo_niko_3_0");
	var_ec060c98[3] = Array("vox_plr_1_interaction_takeo_niko_4_0", "vox_plr_3_interaction_takeo_niko_4_0");
	var_ec060c98[4] = Array("vox_plr_1_interaction_takeo_niko_5_0", "vox_plr_3_interaction_takeo_niko_5_0");
	level.var_ec060c98 = var_ec060c98;
	level.var_e06e7300 = 0;
	level.var_b7e67f82[1] = level.var_b7e67f82[1] + var_ec060c98.size;
	level.var_b7e67f82[3] = level.var_b7e67f82[3] + var_ec060c98.size;
	var_4303fff9 = [];
	var_4303fff9[0] = Array("vox_plr_3_interaction_rich_takeo_1_0", "vox_plr_2_interaction_rich_takeo_1_0");
	var_4303fff9[1] = Array("vox_plr_3_interaction_rich_takeo_2_0", "vox_plr_2_interaction_rich_takeo_2_0");
	var_4303fff9[2] = Array("vox_plr_3_interaction_rich_takeo_3_0", "vox_plr_2_interaction_rich_takeo_3_0");
	var_4303fff9[3] = Array("vox_plr_3_interaction_rich_takeo_4_0", "vox_plr_2_interaction_rich_takeo_4_0");
	var_4303fff9[4] = Array("vox_plr_2_interaction_rich_takeo_5_0", "vox_plr_3_interaction_rich_takeo_5_0");
	level.var_4303fff9 = var_4303fff9;
	level.var_2e004fe1 = 0;
	level.var_b7e67f82[2] = level.var_b7e67f82[2] + var_4303fff9.size;
	level.var_b7e67f82[3] = level.var_b7e67f82[3] + var_4303fff9.size;
	var_312fb587 = 11;
	var_7ccadaab = GetDvarInt("loc_language");
	if(var_7ccadaab === var_312fb587)
	{
		var_4303fff9[2] = Array("vox_plr_3_interaction_rich_takeo_3_jap_alt_0", "vox_plr_2_interaction_rich_takeo_3_japalt_0");
	}
}

/*
	Name: function_3cdbc215
	Namespace: namespace_f333593c
	Checksum: 0x3E855167
	Offset: 0x4758
	Size: 0x683
	Parameters: 0
	Flags: None
*/
function function_3cdbc215()
{
	if(level.activePlayers.size > 1)
	{
		a_players = Array::randomize(level.activePlayers);
		var_e8669 = undefined;
		var_261100d2 = undefined;
		do
		{
			var_e8669 = a_players[0];
			ArrayRemoveValue(a_players, var_e8669);
		}
		while(!(a_players.size > 0 && level.var_b7e67f82[var_e8669.characterindex] === 0));
		if(level.var_b7e67f82[var_e8669.characterindex] > 0)
		{
			do
			{
				var_261100d2 = ArrayGetClosest(var_e8669.origin, a_players, 1000);
				ArrayRemoveValue(a_players, var_261100d2);
			}
			while(!(a_players.size > 0 && isdefined(var_261100d2) && level.var_b7e67f82[var_261100d2.characterindex] === 0));
		}
		var_a40c0bd2 = 0;
		var_b89804c3 = 0;
		if(isdefined(var_e8669))
		{
			var_a40c0bd2 = level.var_b7e67f82[var_e8669.characterindex];
		}
		if(isdefined(var_261100d2))
		{
			var_b89804c3 = level.var_b7e67f82[var_261100d2.characterindex];
		}
		if(var_a40c0bd2 > 0 && var_b89804c3 > 0)
		{
			if(var_e8669.characterindex == 0 && var_261100d2.characterindex == 1 || (var_261100d2.characterindex == 0 && var_e8669.characterindex == 1))
			{
				if(level.var_5705772e < level.var_85fdde46.size)
				{
					var_e8669 thread function_280223ba(level.var_85fdde46[level.var_5705772e]);
					level.var_5705772e++;
					level.var_b7e67f82[0]--;
					level.var_b7e67f82[1]--;
				}
			}
			else if(var_e8669.characterindex == 0 && var_261100d2.characterindex == 2 || (var_261100d2.characterindex == 0 && var_e8669.characterindex == 2))
			{
				if(level.var_d9e67775 < level.var_559f698d.size)
				{
					var_e8669 thread function_280223ba(level.var_559f698d[level.var_d9e67775]);
					level.var_d9e67775++;
					level.var_b7e67f82[0]--;
					level.var_b7e67f82[2]--;
				}
			}
			else if(var_e8669.characterindex == 0 && var_261100d2.characterindex == 3 || (var_261100d2.characterindex == 0 && var_e8669.characterindex == 3))
			{
				if(level.var_a47c9479 < level.var_b16db601.size)
				{
					var_e8669 thread function_280223ba(level.var_b16db601[level.var_a47c9479]);
					level.var_a47c9479++;
					level.var_b7e67f82[0]--;
					level.var_b7e67f82[3]--;
				}
			}
			else if(var_e8669.characterindex == 1 && var_261100d2.characterindex == 2 || (var_261100d2.characterindex == 1 && var_e8669.characterindex == 2))
			{
				if(level.var_2ed438a6 < level.var_4d918dae.size)
				{
					var_e8669 thread function_280223ba(level.var_4d918dae[level.var_2ed438a6]);
					level.var_2ed438a6++;
					level.var_b7e67f82[1]--;
					level.var_b7e67f82[2]--;
				}
			}
			else if(var_e8669.characterindex == 1 && var_261100d2.characterindex == 3 || (var_261100d2.characterindex == 1 && var_e8669.characterindex == 3))
			{
				if(level.var_e06e7300 < level.var_ec060c98.size)
				{
					var_e8669 thread function_280223ba(level.var_ec060c98[level.var_e06e7300]);
					level.var_e06e7300++;
					level.var_b7e67f82[1]--;
					level.var_b7e67f82[3]--;
				}
			}
			else if(var_e8669.characterindex == 2 && var_261100d2.characterindex == 3 || (var_261100d2.characterindex == 2 && var_e8669.characterindex == 3))
			{
				if(level.var_2e004fe1 < level.var_4303fff9.size)
				{
					var_e8669 thread function_280223ba(level.var_4303fff9[level.var_2e004fe1]);
					level.var_2e004fe1++;
					level.var_b7e67f82[2]--;
					level.var_b7e67f82[3]--;
				}
			}
		}
		else
		{
			iprintln("Dev Block strings are not supported");
		}
		/#
		#/
	}
}

/*
	Name: function_3f78fe22
	Namespace: namespace_f333593c
	Checksum: 0x801BB56A
	Offset: 0x4DE8
	Size: 0x2E3
	Parameters: 0
	Flags: None
*/
function function_3f78fe22()
{
	level thread function_7fc6d0cd(Array("zone_ruins"), Array("connect_swamp_to_ruins"), "ruins");
	level thread function_7fc6d0cd(Array("zone_jungle_lab_upper", "zone_swamp_lab_inside"), Array("connect_jungle_lab_to_jungle_lab_upper", "connect_swamp_lab_to_swamp_lab_inside"), "lab");
	level thread function_35fd7118(Array("zone_bunker_interior_2"), Array("connect_bunker_exterior_to_bunker_interior"), "bunker");
	level thread function_7fc6d0cd(Array("zone_operating_rooms"), Array("connect_bunker_interior_to_operating_rooms"), "experiment", 0, 0, "", 0);
	level thread function_7fc6d0cd(Array("zone_bunker_right"), Array("connect_bunker_interior_to_bunker_right"), "living", 1, 2);
	level thread function_7fc6d0cd(Array("zone_bunker_left"), Array("connect_bunker_interior_to_bunker_left"), "power");
	level thread function_7fc6d0cd(Array("zone_bunker_prison"), Array("enable_zone_bunker_prison"), "m_ee", 1, 0, "5");
	level thread function_7fc6d0cd(Array("zone_spider_boss"), Array("connect_spider_lair_to_spider_boss"), "m_ee", 1, 0, "4");
	level thread function_7fc6d0cd(Array("zone_jungle_lab_secret_room"), Array("connect_jungle_lab_to_jungle_lab_upper"), "", 1, 0, "dragon");
}

/*
	Name: function_7fc6d0cd
	Namespace: namespace_f333593c
	Checksum: 0x84E37236
	Offset: 0x50D8
	Size: 0x1DB
	Parameters: 7
	Flags: None
*/
function function_7fc6d0cd(a_str_zones, var_7a4c869a, var_87fad49a, var_142db61a, n_delay, var_a907ca47, var_b55bf9b4)
{
	if(!isdefined(var_142db61a))
	{
		var_142db61a = 1;
	}
	if(!isdefined(n_delay))
	{
		n_delay = 0;
	}
	if(!isdefined(var_a907ca47))
	{
		var_a907ca47 = "";
	}
	if(!isdefined(var_b55bf9b4))
	{
		var_b55bf9b4 = 1;
	}
	if(var_b55bf9b4 == 1)
	{
		level flag::wait_till_any(var_7a4c869a);
	}
	var_b24c0d65 = undefined;
	while(!isdefined(var_b24c0d65))
	{
		foreach(player in level.activePlayers)
		{
			if(player namespace_8aed53c9::function_f2a55b5f(a_str_zones))
			{
				var_b24c0d65 = player;
				break;
			}
		}
		wait(1);
	}
	if(isdefined(var_b24c0d65))
	{
		if(n_delay > 0)
		{
			wait(n_delay);
		}
		if(var_a907ca47 == "")
		{
			var_b24c0d65 thread function_5ebe7974(var_87fad49a, var_142db61a);
		}
		else
		{
			var_b24c0d65 thread function_d258c672(var_a907ca47);
		}
	}
}

/*
	Name: function_35fd7118
	Namespace: namespace_f333593c
	Checksum: 0xA3B0EE61
	Offset: 0x52C0
	Size: 0x1DB
	Parameters: 4
	Flags: None
*/
function function_35fd7118(a_str_zones, var_7a4c869a, var_87fad49a, var_142db61a)
{
	if(!isdefined(var_142db61a))
	{
		var_142db61a = 1;
	}
	self endon("death");
	self endon("hash_56cd6f57");
	level flag::wait_till_any(var_7a4c869a);
	var_e45f469a = GetEnt("t_pap_lookat", "targetname");
	var_b24c0d65 = undefined;
	while(!zm_utility::is_player_valid(var_b24c0d65))
	{
		var_e45f469a waittill("trigger", var_b24c0d65);
		if(zm_utility::is_player_valid(var_b24c0d65))
		{
			foreach(player in level.activePlayers)
			{
				if(player != var_b24c0d65)
				{
					player notify("hash_56cd6f57");
				}
			}
			if(!level flag::get("pap_water_drained"))
			{
				var_b24c0d65 thread function_5ebe7974(var_87fad49a, var_142db61a);
			}
			var_e45f469a delete();
		}
		else
		{
			var_b24c0d65 = undefined;
		}
	}
}

/*
	Name: function_5ebe7974
	Namespace: namespace_f333593c
	Checksum: 0x43C9CE99
	Offset: 0x54A8
	Size: 0x22B
	Parameters: 2
	Flags: None
*/
function function_5ebe7974(var_87fad49a, var_142db61a)
{
	self endon("death");
	if(zm_utility::is_player_valid(self))
	{
		while(isdefined(self.var_7a36438e) && self.var_7a36438e)
		{
			self waittill("hash_c40cfd1a");
			wait(3);
		}
		var_e1bda0d1 = "vox_plr_" + self.characterindex + "_" + var_87fad49a + "_encounter_0";
		foreach(player in level.players)
		{
			if(player.characterindex === 2)
			{
				var_1c428c3 = player;
			}
		}
		if(self.characterindex !== 2 && (isdefined(var_142db61a) && var_142db61a) && isdefined(var_1c428c3) && DistanceSquared(self.origin, var_1c428c3.origin) < 1048576)
		{
			var_7c01b3a = "vox_plr_" + 2 + "_" + var_87fad49a + "_encounter_0";
			var_cbd11028 = Array(var_e1bda0d1, var_7c01b3a);
			level thread function_7aa5324a(var_cbd11028, undefined, 1);
		}
		else
		{
			level thread function_897246e4(var_e1bda0d1, 0, 1);
		}
	}
}

/*
	Name: function_d258c672
	Namespace: namespace_f333593c
	Checksum: 0x2B15A1ED
	Offset: 0x56E0
	Size: 0x10B
	Parameters: 1
	Flags: None
*/
function function_d258c672(var_a907ca47)
{
	self endon("death");
	if(zm_utility::is_player_valid(self))
	{
		var_7c01b3a = "vox_plr_" + 2 + "_mq_ee_" + var_a907ca47 + "_response_0_0";
		if(self.characterindex !== 2)
		{
			var_e1bda0d1 = "vox_plr_" + self.characterindex + "_mq_ee_" + var_a907ca47 + "_0";
			var_cbd11028 = Array(var_e1bda0d1, var_7c01b3a);
			level thread function_7aa5324a(var_cbd11028, undefined, 1);
		}
		else
		{
			level thread function_897246e4(var_7c01b3a, 0, 1);
		}
	}
}

/*
	Name: function_6fc10b64
	Namespace: namespace_f333593c
	Checksum: 0xB0251A48
	Offset: 0x57F8
	Size: 0xAB
	Parameters: 0
	Flags: None
*/
function function_6fc10b64()
{
	self endon("disconnect");
	wait(1.5);
	if(zm_utility::is_player_valid(self))
	{
		self clientfield::set("player_vomit_fx", 1);
		self util::delay(5, "disconnect", &clientfield::set, "player_vomit_fx", 0);
		self function_1881817("fruit", "vomit", 10, 0);
	}
}

/*
	Name: function_97ed7288
	Namespace: namespace_f333593c
	Checksum: 0x6FB81AEC
	Offset: 0x58B0
	Size: 0x10B
	Parameters: 0
	Flags: None
*/
function function_97ed7288()
{
	if(!level flag::exists("first_skull_s_pickedup_vo_done"))
	{
		self thread function_cdc8a72a("_quest_skull_pickup_0");
		level flag::init("first_skull_s_pickedup_vo_done");
		level flag::set("first_skull_s_pickedup_vo_done");
		level flag::set("skull_s_pickup_vo_locked");
	}
	else if(!level flag::get("skull_s_pickup_vo_locked"))
	{
		self thread function_1881817("quest_skull", "pickup_generic", 60);
		level flag::set("skull_s_pickup_vo_locked");
	}
}

/*
	Name: function_9984d8f0
	Namespace: namespace_f333593c
	Checksum: 0x2A59B9BF
	Offset: 0x59C8
	Size: 0x83
	Parameters: 0
	Flags: None
*/
function function_9984d8f0()
{
	if(!level flag::exists("first_skull_s_placed_vo_done"))
	{
		self thread function_cdc8a72a("_quest_skull_place_0");
		level flag::init("first_skull_s_placed_vo_done");
		level flag::set("first_skull_s_placed_vo_done");
	}
}

/*
	Name: function_87d97caa
	Namespace: namespace_f333593c
	Checksum: 0x61E455E5
	Offset: 0x5A58
	Size: 0x83
	Parameters: 0
	Flags: None
*/
function function_87d97caa()
{
	if(!level flag::exists("skull_p_pickup_vo_done"))
	{
		self thread function_cdc8a72a("_quest_skull_pickup_purified_0");
		level flag::init("skull_p_pickup_vo_done");
		level flag::set("skull_p_pickup_vo_done");
	}
}

/*
	Name: function_64f4c27
	Namespace: namespace_f333593c
	Checksum: 0x90B8F326
	Offset: 0x5AE8
	Size: 0xA3
	Parameters: 0
	Flags: None
*/
function function_64f4c27()
{
	if(!level flag::exists("skull_p_place_vo_done"))
	{
		self thread function_cdc8a72a("_quest_skull_place_purified_0");
		level flag::init("skull_p_place_vo_done");
		level flag::set("skull_p_place_vo_done");
	}
	level flag::clear("skull_s_pickup_vo_locked");
}

/*
	Name: function_5dbba1d3
	Namespace: namespace_f333593c
	Checksum: 0x8D6B7641
	Offset: 0x5B98
	Size: 0x23
	Parameters: 0
	Flags: None
*/
function function_5dbba1d3()
{
	self thread function_cdc8a72a("_quest_skull_place_purified_final_0");
}

/*
	Name: function_ab027b72
	Namespace: namespace_f333593c
	Checksum: 0x42D66795
	Offset: 0x5BC8
	Size: 0x23
	Parameters: 0
	Flags: None
*/
function function_ab027b72()
{
	self thread function_cdc8a72a("_quest_skull_weapon_trap_0");
}

/*
	Name: function_b2a7853b
	Namespace: namespace_f333593c
	Checksum: 0xE970D58B
	Offset: 0x5BF8
	Size: 0x23
	Parameters: 0
	Flags: None
*/
function function_b2a7853b()
{
	self thread function_cdc8a72a("quest_skull_weapon_success_0");
}

/*
	Name: function_cdc8a72a
	Namespace: namespace_f333593c
	Checksum: 0x41F9E3D1
	Offset: 0x5C28
	Size: 0x10B
	Parameters: 1
	Flags: None
*/
function function_cdc8a72a(var_8d8f9222)
{
	if(!isdefined(level.var_aa673a57))
	{
		level.var_aa673a57 = [];
	}
	if(!(isdefined(level.var_aa673a57[var_8d8f9222]) && level.var_aa673a57[var_8d8f9222]))
	{
		level.var_aa673a57[var_8d8f9222] = 1;
		var_217a1cbf = "vo_plr_2_" + var_8d8f9222;
		if(self.characterindex !== 2)
		{
			var_6a57fbd1 = "vox_plr_" + self.characterindex + var_8d8f9222;
			var_cbd11028 = Array(var_6a57fbd1, var_217a1cbf);
			level thread function_7aa5324a(var_cbd11028);
		}
		else
		{
			level thread function_897246e4(var_217a1cbf);
		}
	}
}

/*
	Name: function_c426b455
	Namespace: namespace_f333593c
	Checksum: 0x29D993C
	Offset: 0x5D40
	Size: 0x13F
	Parameters: 0
	Flags: None
*/
function function_c426b455()
{
	while(1)
	{
		level waittill("hash_9c49b4a8");
		if(!level flag::exists("first_spider_round"))
		{
			level flag::init("first_spider_round");
			foreach(player in level.activePlayers)
			{
				player thread function_5943b45();
			}
		}
		else
		{
			e_player = Array::random(level.activePlayers);
			e_player zm_audio::create_and_play_dialog("spider", "start");
		}
		do
		{
		}
		while(!!zm_utility::is_player_valid(e_player));
	}
}

/*
	Name: function_5943b45
	Namespace: namespace_f333593c
	Checksum: 0x5CEA0FB9
	Offset: 0x5E88
	Size: 0x213
	Parameters: 0
	Flags: None
*/
function function_5943b45()
{
	self endon("death");
	self endon("hash_cbca0f35");
	var_e8356f9e = 2560000;
	var_90d45ead = 0;
	while(!(isdefined(var_90d45ead) && var_90d45ead))
	{
		wait(0.5);
		var_388bdc38 = GetEntArray("zombie_spider", "targetname");
		if(zm_utility::is_player_valid(self))
		{
			foreach(Spider in var_388bdc38)
			{
				if(DistanceSquared(self.origin, Spider.origin) <= var_e8356f9e && self islookingat(Spider))
				{
					var_90d45ead = 1;
					foreach(var_3c6a24bf in level.players)
					{
						if(var_3c6a24bf != self)
						{
							var_3c6a24bf notify("hash_cbca0f35");
						}
					}
					break;
				}
			}
		}
	}
	self zm_audio::create_and_play_dialog("spider", "start");
}

/*
	Name: function_c8bcaf11
	Namespace: namespace_f333593c
	Checksum: 0x948FB22
	Offset: 0x60A8
	Size: 0xEB
	Parameters: 0
	Flags: None
*/
function function_c8bcaf11()
{
	if(!level flag::exists("temp_power_on_1"))
	{
		level flag::init("temp_power_on_1");
	}
	if(zm_utility::is_player_valid(self))
	{
		if(!level flag::get("temp_power_on_1"))
		{
			level thread function_c57ccaa9();
			self thread function_7f4cb4c("temp_power", "first_switch", 3);
		}
		else
		{
			self thread function_7f4cb4c("temp_power", "second_switch", 3);
		}
	}
}

/*
	Name: function_c57ccaa9
	Namespace: namespace_f333593c
	Checksum: 0x371321A6
	Offset: 0x61A0
	Size: 0x6B
	Parameters: 0
	Flags: None
*/
function function_c57ccaa9()
{
	level flag::set("temp_power_on_1");
	if(level.activePlayers.size > 1)
	{
		wait(level.var_7b5a9e65);
	}
	else
	{
		wait(level.var_7b5a9e65 * 2);
	}
	level flag::clear("temp_power_on_1");
}

/*
	Name: function_8eebdc4d
	Namespace: namespace_f333593c
	Checksum: 0xBFD372C3
	Offset: 0x6218
	Size: 0x317
	Parameters: 0
	Flags: None
*/
function function_8eebdc4d()
{
	while(1)
	{
		wait(1);
		if(!level flag::get("vo_lock_thrasher_appear_roar"))
		{
			var_bb184d70 = level.var_35a5aa88;
			e_speaker = undefined;
			var_d582de1 = undefined;
			foreach(player in level.activePlayers)
			{
				if(zm_utility::is_player_valid(player))
				{
					str_player_zone = player zm_zonemgr::get_player_zone();
					if(!isdefined(var_d582de1) && isdefined(str_player_zone))
					{
						foreach(var_e3372b59 in var_bb184d70)
						{
							if(!isdefined(var_e3372b59.var_dbb0b3dd) && var_e3372b59.var_dbb0b3dd && (!isdefined(var_e3372b59.var_36ba10fd) && var_e3372b59.var_36ba10fd) && var_e3372b59 zm_zonemgr::entity_in_zone(str_player_zone) && player islookingat(var_e3372b59))
							{
								e_speaker = player;
								var_e3372b59.var_dbb0b3dd = 1;
								var_d582de1 = var_e3372b59;
								break;
							}
						}
					}
					continue;
				}
				break;
			}
			if(!level flag::get("vo_lock_thrasher_appear_roar") && zm_utility::is_player_valid(e_speaker) && !level flag::get("takeofight_wave_spawning"))
			{
				level flag::set("thrasher_spotted");
				level thread flag::set_for_time(5, "vo_lock_thrasher_appear_roar");
				e_speaker function_1881817("thrasher", "appear", 60);
			}
		}
	}
}

/*
	Name: function_5ca4424
	Namespace: namespace_f333593c
	Checksum: 0xA02F1836
	Offset: 0x6538
	Size: 0x225
	Parameters: 0
	Flags: None
*/
function function_5ca4424()
{
	var_1430cde = 640000;
	level flag::wait_till("thrasher_spotted");
	while(1)
	{
		if(!level flag::get("vo_lock_thrasher_appear_roar"))
		{
			level waittill("hash_9b1446c2", var_f363f596);
			if(isalive(var_f363f596) && (!isdefined(var_f363f596.var_dbb0b3dd) && var_f363f596.var_dbb0b3dd && (!isdefined(var_f363f596.var_9d252861) && var_f363f596.var_9d252861)))
			{
				e_speaker = undefined;
				e_closest_player = ArrayGetClosest(var_f363f596.origin, level.activePlayers);
				if(!e_closest_player namespace_8aed53c9::is_facing(var_f363f596) && DistanceSquared(var_f363f596.origin, e_closest_player.origin) <= var_1430cde)
				{
					e_speaker = e_closest_player;
				}
				if(!level flag::get("vo_lock_thrasher_appear_roar") && zm_utility::is_player_valid(e_speaker))
				{
					var_f363f596.var_9d252861 = 1;
					wait(1);
					level thread flag::set_for_time(5, "vo_lock_thrasher_appear_roar");
					e_speaker function_1881817("thrasher", "roar", 10);
				}
			}
		}
		wait(1);
	}
}

/*
	Name: function_a5b6f9c0
	Namespace: namespace_f333593c
	Checksum: 0x13017C64
	Offset: 0x6768
	Size: 0x225
	Parameters: 0
	Flags: None
*/
function function_a5b6f9c0()
{
	var_1430cde = 640000;
	level flag::wait_till("thrasher_spotted");
	while(1)
	{
		level waittill("hash_49c2b21f", var_f363f596);
		if(isalive(var_f363f596) && (!isdefined(var_f363f596.var_36ba10fd) && var_f363f596.var_36ba10fd))
		{
			e_speaker = undefined;
			foreach(e_player in level.activePlayers)
			{
				if(zm_utility::is_player_valid(e_player))
				{
					str_player_zone = e_player zm_zonemgr::get_player_zone();
					if(isdefined(str_player_zone) && var_f363f596 zm_zonemgr::entity_in_zone(str_player_zone) && e_player islookingat(var_f363f596))
					{
						e_speaker = e_player;
						break;
					}
				}
			}
			if(zm_utility::is_player_valid(e_speaker) && !level flag::get("takeofight_wave_spawning"))
			{
				var_f363f596.var_36ba10fd = 1;
				e_speaker function_1881817("thrasher", "create", 10);
			}
		}
		wait(1);
	}
}

/*
	Name: function_b978ce37
	Namespace: namespace_f333593c
	Checksum: 0x592874BF
	Offset: 0x6998
	Size: 0x67
	Parameters: 1
	Flags: None
*/
function function_b978ce37(e_attacker)
{
	if(self.archetype === "thrasher" && zm_utility::is_player_valid(e_attacker) && !level flag::get("takeofight_wave_spawning"))
	{
		e_attacker notify("hash_d2789392");
	}
}

/*
	Name: function_1e767f71
	Namespace: namespace_f333593c
	Checksum: 0xEE4623AA
	Offset: 0x6A08
	Size: 0x237
	Parameters: 7
	Flags: None
*/
function function_1e767f71(e_target, n_min_dist, var_79d0b667, var_b03cc213, var_a099ce87, var_ac3beede, n_duration)
{
	if(!isdefined(n_min_dist))
	{
		n_min_dist = 600;
	}
	if(!isdefined(var_a099ce87))
	{
		var_a099ce87 = 1;
	}
	if(!isdefined(var_ac3beede))
	{
		var_ac3beede = 0;
	}
	if(!isdefined(n_duration))
	{
		n_duration = 0;
	}
	e_target endon("hash_9ed7f404");
	e_target endon("death");
	while(1)
	{
		var_45edf029 = ArraySortClosest(level.players, e_target.origin);
		foreach(player in var_45edf029)
		{
			if(zm_utility::is_player_valid(player) && player util::is_player_looking_at(e_target GetCentroid(), 0.5, 1, e_target) && Distance2DSquared(player.origin, e_target.origin) <= n_min_dist * n_min_dist)
			{
				player thread function_1881817(var_79d0b667, var_b03cc213, var_a099ce87, var_ac3beede);
				return;
			}
		}
		if(n_duration > 0)
		{
			n_duration--;
		}
		else if(n_duration < 0)
		{
			wait(1);
			continue;
		}
		else
		{
			return;
		}
		wait(1);
	}
}

/*
	Name: function_65f8953a
	Namespace: namespace_f333593c
	Checksum: 0x9BDA9508
	Offset: 0x6C48
	Size: 0x13D
	Parameters: 8
	Flags: None
*/
function function_65f8953a(str_event, var_79d0b667, var_b03cc213, var_a099ce87, var_32802234, n_delay, v_loc, var_c2a3d8e1)
{
	if(!isdefined(var_a099ce87))
	{
		var_a099ce87 = 10;
	}
	if(!isdefined(var_32802234))
	{
		var_32802234 = 0;
	}
	if(!isdefined(n_delay))
	{
		n_delay = 0;
	}
	if(!isdefined(var_c2a3d8e1))
	{
		var_c2a3d8e1 = 1;
	}
	if(isdefined(str_event))
	{
		Array::add(self.var_bac3b790, str_event);
		self.var_38d92be7[str_event] = var_79d0b667;
		self.var_8bcf7c3a[str_event] = var_b03cc213;
		self.var_2c67f767[str_event] = var_a099ce87;
		self.var_4b332a77[str_event] = var_32802234;
		self.var_bc80de72[str_event] = n_delay;
		self.var_9c6abc49[str_event] = v_loc;
		self.var_caa91bc0[str_event] = var_c2a3d8e1;
	}
}

/*
	Name: function_81d644a1
	Namespace: namespace_f333593c
	Checksum: 0xF5690BD0
	Offset: 0x6D90
	Size: 0x127
	Parameters: 0
	Flags: None
*/
function function_81d644a1()
{
	self endon("death");
	Array::add(self.var_bac3b790, "death");
	Array::add(self.var_bac3b790, "disconnect");
	while(1)
	{
		str_event = self util::waittill_any_array_return(self.var_bac3b790);
		if(self.var_bc80de72[str_event] > 0)
		{
			wait(self.var_bc80de72[str_event]);
		}
		if(zm_utility::is_player_valid(self) || (!isdefined(self.var_caa91bc0[str_event]) && self.var_caa91bc0[str_event]))
		{
			self function_1881817(self.var_38d92be7[str_event], self.var_8bcf7c3a[str_event], self.var_2c67f767[str_event], self.var_4b332a77[str_event]);
		}
	}
}

/*
	Name: function_c261e8aa
	Namespace: namespace_f333593c
	Checksum: 0x8CFF18F8
	Offset: 0x6EC0
	Size: 0xE7
	Parameters: 0
	Flags: None
*/
function function_c261e8aa()
{
	while(1)
	{
		str_event = level util::waittill_any_array_return(level.var_bac3b790);
		if(level.var_bc80de72[str_event] > 0)
		{
			wait(level.var_bc80de72[str_event]);
		}
		e_player = namespace_8aed53c9::function_4bf4ac40(level.var_9c6abc49[str_event]);
		if(zm_utility::is_player_valid(e_player))
		{
			e_player function_1881817(level.var_38d92be7[str_event], level.var_8bcf7c3a[str_event], level.var_2c67f767[str_event], level.var_4b332a77[str_event]);
		}
	}
}

/*
	Name: function_1881817
	Namespace: namespace_f333593c
	Checksum: 0x5422BF17
	Offset: 0x6FB0
	Size: 0x197
	Parameters: 4
	Flags: None
*/
function function_1881817(var_79d0b667, var_b03cc213, var_a099ce87, var_32802234)
{
	if(!isdefined(var_a099ce87))
	{
		var_a099ce87 = 10;
	}
	if(!isdefined(var_32802234))
	{
		var_32802234 = 0;
	}
	self endon("death");
	var_4aa3754 = 0;
	if(zm_utility::is_player_valid(self) && (!isdefined(self.var_e1f8edd6) && self.var_e1f8edd6))
	{
		var_346d981 = var_79d0b667 + var_b03cc213 + "_vo";
		if(!self flag::exists(var_346d981))
		{
			self flag::init(var_346d981);
		}
		if(!self flag::get(var_346d981))
		{
			self flag::set(var_346d981);
			if(var_32802234 == 0)
			{
				self thread zm_audio::create_and_play_dialog(var_79d0b667, var_b03cc213);
			}
			else
			{
				self thread function_7f4cb4c(var_79d0b667, var_b03cc213, var_32802234);
			}
			var_4aa3754 = 1;
			self thread function_ecc335b6(var_346d981, var_a099ce87);
		}
	}
	return var_4aa3754;
}

/*
	Name: function_ecc335b6
	Namespace: namespace_f333593c
	Checksum: 0x2DB2BD48
	Offset: 0x7150
	Size: 0x3B
	Parameters: 2
	Flags: None
*/
function function_ecc335b6(var_346d981, var_a099ce87)
{
	self endon("disconnect");
	wait(var_a099ce87);
	self flag::clear(var_346d981);
}

/*
	Name: function_7f4cb4c
	Namespace: namespace_f333593c
	Checksum: 0x315A514B
	Offset: 0x7198
	Size: 0xB1
	Parameters: 3
	Flags: None
*/
function function_7f4cb4c(var_79d0b667, var_b03cc213, var_41d7d192)
{
	if(!isdefined(var_41d7d192))
	{
		var_41d7d192 = 3;
	}
	str_index = var_79d0b667 + "_" + var_b03cc213;
	if(!isdefined(self.var_10f58653[str_index]))
	{
		self.var_10f58653[str_index] = 0;
	}
	if(self.var_10f58653[str_index] < var_41d7d192)
	{
		self thread zm_audio::create_and_play_dialog(var_79d0b667, var_b03cc213);
		self.var_10f58653[str_index]++;
	}
}

/*
	Name: function_e4acaa37
	Namespace: namespace_f333593c
	Checksum: 0xAEBAB2B4
	Offset: 0x7258
	Size: 0x73
	Parameters: 1
	Flags: None
*/
function function_e4acaa37(str_vo)
{
	function_218256bd(1);
	function_2426269b(self.origin);
	self function_7b697614(str_vo, undefined, 1);
	function_218256bd(0);
}

/*
	Name: function_280223ba
	Namespace: namespace_f333593c
	Checksum: 0xE5865865
	Offset: 0x72D8
	Size: 0x7B
	Parameters: 1
	Flags: None
*/
function function_280223ba(var_d44b84c3)
{
	function_218256bd(1);
	function_2426269b(self.origin, 10000);
	function_7aa5324a(var_d44b84c3, undefined, 1);
	function_218256bd(0);
}

/*
	Name: function_11b41a76
	Namespace: namespace_f333593c
	Checksum: 0xD9D63220
	Offset: 0x7360
	Size: 0x18D
	Parameters: 5
	Flags: None
*/
function function_11b41a76(n_player_index, str_type, var_f73f0bfc, var_69467b37, var_434400ce)
{
	if(!isdefined(var_69467b37))
	{
		var_69467b37 = 0;
	}
	if(!isdefined(var_434400ce))
	{
		var_434400ce = 0;
	}
	switch(str_type)
	{
		case "round_start_solo":
		{
			str_vo = "vox_plr_" + n_player_index + "_round" + var_f73f0bfc + "_start_solo_0";
			break;
		}
		case "round_end_solo":
		{
			str_vo = "vox_plr_" + n_player_index + "_round" + var_f73f0bfc + "_end_solo_0";
			break;
		}
		case "round_start_coop":
		{
			str_vo = "vox_plr_" + n_player_index + "_round" + var_f73f0bfc + "_start_0";
			break;
		}
		case "round_end_coop":
		{
			str_vo = "vox_plr_" + n_player_index + "_round" + var_f73f0bfc + "_end_0";
			break;
		}
		case default:
		{
			str_vo = "vox_plr_" + n_player_index + "_" + str_type + var_f73f0bfc + "_" + var_69467b37;
			break;
		}
	}
	return str_vo;
}

/*
	Name: function_5803cf05
	Namespace: namespace_f333593c
	Checksum: 0x7B65682A
	Offset: 0x74F8
	Size: 0x81
	Parameters: 2
	Flags: None
*/
function function_5803cf05(n_max, var_6e653641)
{
	/#
		Assert(!isdefined(var_6e653641) || var_6e653641 < n_max, "Dev Block strings are not supported");
	#/
	do
	{
		var_ee3cd374 = RandomInt(n_max);
	}
	while(!var_ee3cd374 === var_6e653641);
	return var_ee3cd374;
}

/*
	Name: function_574a0ffc
	Namespace: namespace_f333593c
	Checksum: 0x76A244B6
	Offset: 0x7588
	Size: 0x21
	Parameters: 1
	Flags: None
*/
function function_574a0ffc(n_char_index)
{
	return zm_utility::get_specific_character(n_char_index);
}

/*
	Name: function_70e6e39e
	Namespace: namespace_f333593c
	Checksum: 0x10C84649
	Offset: 0x75B8
	Size: 0x91
	Parameters: 0
	Flags: None
*/
function function_70e6e39e()
{
	var_28ff596b = 0;
	for(i = 1; i <= 4; i++)
	{
		str_flag = "skullquest_ritual_inprogress" + i;
		if(level flag::exists(str_flag) && level flag::get(str_flag))
		{
			var_28ff596b++;
		}
	}
	return var_28ff596b;
}

/*
	Name: function_3bf2d62a
	Namespace: namespace_f333593c
	Checksum: 0xB7483DF6
	Offset: 0x7658
	Size: 0x411
	Parameters: 4
	Flags: None
*/
function function_3bf2d62a(var_da379925, var_c57fa913, bunker, var_82860e04)
{
	if(!isdefined(var_c57fa913))
	{
		var_c57fa913 = 0;
	}
	if(!isdefined(bunker))
	{
		bunker = 0;
	}
	if(!isdefined(var_82860e04))
	{
		var_82860e04 = 0;
	}
	wait(1);
	soundAlias = "vox_faci_pa_" + var_da379925 + "_0";
	var_f6dffc36 = "vox_faci_pa_" + var_da379925 + "_int" + "_0";
	if(var_c57fa913)
	{
		level.var_b7d1a34e = struct::get_array("sndJungleLabPa", "targetname");
		if(!isdefined(level.var_b7d1a34e))
		{
			return;
		}
		foreach(location in level.var_b7d1a34e)
		{
			if(location.script_string == "interior")
			{
				playsoundatposition(var_f6dffc36, location.origin);
				wait(0.05);
				continue;
			}
			playsoundatposition(soundAlias, location.origin);
			wait(0.05);
		}
	}
	else if(bunker)
	{
		level.var_e2b8ee4d = struct::get_array("sndBunkerPa", "targetname");
		if(!isdefined(level.var_e2b8ee4d))
		{
			return;
		}
		foreach(location in level.var_e2b8ee4d)
		{
			if(location.script_string == "interior")
			{
				playsoundatposition(var_f6dffc36, location.origin);
				wait(0.05);
				continue;
			}
			playsoundatposition(soundAlias, location.origin);
			wait(0.05);
		}
	}
	else if(var_82860e04)
	{
		level.var_eef090b3 = struct::get_array("sndSwampLabPa", "targetname");
		if(!isdefined(level.var_eef090b3))
		{
			return;
		}
		foreach(location in level.var_eef090b3)
		{
			if(location.script_string == "interior")
			{
				playsoundatposition(var_f6dffc36, location.origin);
				wait(0.05);
				continue;
			}
			playsoundatposition(soundAlias, location.origin);
			wait(0.05);
		}
	}
}

/*
	Name: function_5f161c52
	Namespace: namespace_f333593c
	Checksum: 0x5B3FB671
	Offset: 0x7A78
	Size: 0x2B
	Parameters: 0
	Flags: None
*/
function function_5f161c52()
{
	self function_7f4cb4c("ee", "spider", 1);
}

