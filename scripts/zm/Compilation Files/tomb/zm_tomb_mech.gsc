#using scripts\codescripts\struct;
#using scripts\shared\ai\mechz;
#using scripts\shared\ai\systems\animation_state_machine_mocomp;
#using scripts\shared\ai\systems\animation_state_machine_utility;
#using scripts\shared\ai\systems\behavior_tree_utility;
#using scripts\shared\ai\zombie_shared;
#using scripts\shared\ai\zombie_utility;
#using scripts\shared\array_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\spawner_shared;
#using scripts\shared\util_shared;
#using scripts\zm\_zm_ai_mechz;
#using scripts\zm\_zm_audio;
#using scripts\zm\_zm_elemental_zombies;
#using scripts\zm\_zm_powerups;
#using scripts\zm\_zm_spawner;
#using scripts\zm\_zm_utility;
#using scripts\zm\_zm_weap_staff_air;
#using scripts\zm\_zm_weap_staff_fire;
#using scripts\zm\_zm_weap_staff_lightning;
#using scripts\zm\_zm_weap_staff_water;
#using scripts\zm\_zm_zonemgr;
#using scripts\zm\zm_tomb_tank;

#namespace namespace_baebcb1;

/*
	Name: init
	Namespace: namespace_baebcb1
	Checksum: 0x9A7CCB46
	Offset: 0x9C0
	Size: 0x473
	Parameters: 0
	Flags: None
*/
function init()
{
	function_e597e389();
	level.mechz_locations = struct::get_array("mechz_location", "script_noteworthy");
	if(level.mechz_spawners.size == 0)
	{
		return;
	}
	for(i = 0; i < level.mechz_spawners.size; i++)
	{
		level.mechz_spawners[i].is_enabled = 1;
		level.mechz_spawners[i].script_forcespawn = 1;
	}
	level thread mechz_setup_armor_pieces();
	level.mechz_base_health = 5000;
	level.mechz_health = level.mechz_base_health;
	level.mechz_health_increase = 1000;
	level.mechz_round_count = 0;
	level.mechz_damage_percent = 0.1;
	level.mechz_remove_helmet_head_dmg_base = 500;
	level.mechz_remove_helmet_head_dmg = level.mechz_remove_helmet_head_dmg_base;
	level.mechz_remove_helmet_head_dmg_increase = 250;
	level.mechz_explosive_dmg_head_scaler = 0.25;
	level.mechz_helmet_health_percentage = 0.1;
	level.mechz_powerplant_expose_dmg_base = 300;
	level.mechz_powerplant_expose_dmg = level.mechz_powerplant_expose_base_dmg;
	level.mechz_powerplant_expose_dmg_increase = 100;
	level.mechz_powerplant_destroy_dmg_base = 500;
	level.mechz_powerplant_destroy_dmg = level.mechz_powerplant_destroy_dmg_base;
	level.mechz_powerplant_destroy_dmg_increase = 150;
	level.mechz_powerplant_expose_health_percentage = 0.05;
	level.mechz_powerplant_destroyed_health_percentage = 0.025;
	level.mechz_explosive_dmg_to_cancel_claw_percentage = 0.1;
	level.mechz_min_round_fq = 3;
	level.mechz_max_round_fq = 4;
	level.mechz_min_round_fq_solo = 4;
	level.mechz_max_round_fq_solo = 6;
	level.mechz_reset_dist_sq = 65536;
	level.mechz_sticky_dist_sq = 1048576;
	level.mechz_aggro_dist_sq = 16384;
	level.mechz_zombie_per_round = 1;
	level.mechz_left_to_spawn = 0;
	level.mechz_players_in_zone_spawn_point_cap = 120;
	level.mechz_shotgun_damage_mod = 1.5;
	level.mechz_failed_paths_to_jump = 3;
	level.mechz_jump_dist_threshold = 4410000;
	level.mechz_jump_delay = 3;
	level.mechz_player_flame_dmg = 10;
	level.mechz_half_front_arc = cos(45);
	level.MECHZ_FT_SWEEP_CHANCE = 10;
	level.mechz_aim_max_pitch = 60;
	level.mechz_aim_max_yaw = 45;
	level.mechz_custom_goalradius = 48;
	level.mechz_custom_goalradius_sq = level.mechz_custom_goalradius * level.mechz_custom_goalradius;
	level.mechz_tank_knockdown_time = 5;
	level.mechz_robot_knockdown_time = 10;
	level.mechz_dist_for_sprint = 129600;
	level.mechz_dist_for_stop_sprint = 57600;
	level.mechz_claw_cooldown_time = 7000;
	level.mechz_flamethrower_cooldown_time = 5000;
	level.mechz_min_extra_spawn = 8;
	level.mechz_max_extra_spawn = 11;
	level.mechz_points_for_killer = 250;
	level.mechz_points_for_team = 500;
	level.mechz_points_for_helmet = 100;
	level.mechz_points_for_powerplant = 100;
	level.mechz_flogger_stun_time = 3;
	level.mechz_powerplant_stun_time = 4;
	if(isdefined(level.mechz_spawning_logic_override_func))
	{
		level thread [[level.mechz_spawning_logic_override_func]]();
	}
	else
	{
		level thread mechz_spawning_logic();
	}
	level.mechz_flamethrower_player_callback = &function_8166f050;
	level.mechz_flamethrower_ai_callback = &function_eeec66f5;
	level.mechz_staff_damage_override = &mechz_staff_damage_override;
	spawner::add_archetype_spawn_function("mechz", &function_8d3603b3);
	level.var_e1e49cc1 = &function_dbf487d9;
}

/*
	Name: function_8d3603b3
	Namespace: namespace_baebcb1
	Checksum: 0xC13E70F6
	Offset: 0xE40
	Size: 0x7B
	Parameters: 0
	Flags: Private
*/
function private function_8d3603b3()
{
	self.non_attacker_func = &function_4d1bc672;
	self.non_attack_func_takes_attacker = 1;
	self.instakill_func = &mechz_instakill_override;
	self.completed_emerging_into_playable_area = 1;
	self function_a3dfb444();
	self.no_damage_points = 1;
	self thread zm_spawner::enemy_death_detection();
}

/*
	Name: function_a3dfb444
	Namespace: namespace_baebcb1
	Checksum: 0xE4661CA3
	Offset: 0xEC8
	Size: 0x17B
	Parameters: 0
	Flags: Private
*/
function private function_a3dfb444()
{
	self.var_ba00c27 = [];
	foreach(var_d67b360d in level.mechz_armor_info)
	{
		armor_state = spawnstruct();
		armor_state.index = self.var_ba00c27.size;
		armor_state.tag = var_d67b360d.tag;
		armor_state.clientfield = var_d67b360d.clientfield;
		if(!isdefined(self.var_ba00c27))
		{
			self.var_ba00c27 = [];
		}
		else if(!IsArray(self.var_ba00c27))
		{
			self.var_ba00c27 = Array(self.var_ba00c27);
		}
		self.var_ba00c27[self.var_ba00c27.size] = armor_state;
	}
	self.var_ba00c27 = Array::randomize(self.var_ba00c27);
}

/*
	Name: function_dbf487d9
	Namespace: namespace_baebcb1
	Checksum: 0xE6EC0F7
	Offset: 0x1050
	Size: 0x7B
	Parameters: 0
	Flags: Private
*/
function private function_dbf487d9()
{
	self.actor_damage_func = &mechz_damage_override;
	self.faceplate_health = level.mechz_health * level.mechz_helmet_health_percentage;
	self.mechz_explosive_dmg_to_cancel_claw = level.mechz_health * level.mechz_explosive_dmg_to_cancel_claw_percentage;
	self.powercap_cover_health = level.mechz_health * level.mechz_powerplant_expose_health_percentage;
	self.powercap_health = level.mechz_health * level.mechz_powerplant_destroyed_health_percentage;
}

/*
	Name: mechz_instakill_override
	Namespace: namespace_baebcb1
	Checksum: 0x336C700B
	Offset: 0x10D8
	Size: 0x1F
	Parameters: 3
	Flags: Private
*/
function private mechz_instakill_override(player, mod, HIT_LOCATION)
{
	return 1;
}

/*
	Name: function_4d1bc672
	Namespace: namespace_baebcb1
	Checksum: 0x1ED8A495
	Offset: 0x1100
	Size: 0x4D
	Parameters: 3
	Flags: None
*/
function function_4d1bc672(damage, weapon, attacker)
{
	if(!isdefined(attacker))
	{
		attacker = undefined;
	}
	if(attacker === level.vh_tank)
	{
		self.var_32854687 = 1;
	}
	return 0;
}

/*
	Name: mechz_setup_armor_pieces
	Namespace: namespace_baebcb1
	Checksum: 0xF98B9E2F
	Offset: 0x1158
	Size: 0x203
	Parameters: 0
	Flags: None
*/
function mechz_setup_armor_pieces()
{
	level.mechz_armor_info = [];
	level.mechz_armor_info[0] = spawnstruct();
	level.mechz_armor_info[0].model = "c_zom_mech_armor_knee_left";
	level.mechz_armor_info[0].tag = "j_knee_attach_le";
	level.mechz_armor_info[0].clientfield = "mechz_lknee_armor_detached";
	level.mechz_armor_info[1] = spawnstruct();
	level.mechz_armor_info[1].model = "c_zom_mech_armor_knee_right";
	level.mechz_armor_info[1].tag = "j_knee_attach_ri";
	level.mechz_armor_info[1].clientfield = "mechz_rknee_armor_detached";
	level.mechz_armor_info[2] = spawnstruct();
	level.mechz_armor_info[2].model = "c_zom_mech_armor_shoulder_left";
	level.mechz_armor_info[2].tag = "j_shoulderarmor_le";
	level.mechz_armor_info[2].clientfield = "mechz_lshoulder_armor_detached";
	level.mechz_armor_info[3] = spawnstruct();
	level.mechz_armor_info[3].model = "c_zom_mech_armor_shoulder_right";
	level.mechz_armor_info[3].tag = "j_shoulderarmor_ri";
	level.mechz_armor_info[3].clientfield = "mechz_rshoulder_armor_detached";
}

/*
	Name: function_e597e389
	Namespace: namespace_baebcb1
	Checksum: 0xBBCA24B0
	Offset: 0x1368
	Size: 0x3B3
	Parameters: 0
	Flags: Private
*/
function private function_e597e389()
{
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("tombMechzGetTankTagService", &function_b6ebb97d);
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("tombMechzGetJumpPosService", &function_4f9821c3);
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("tombMechzShouldJump", &function_c9cd5bdd);
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("tombMechzShouldShootFlameAtTank", &function_9ea85604);
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("tombMechzWasKnockedDownByTank", &function_b47192a9);
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("tombMechzWasRobotStomped", &function_4bbd0723);
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("tombMechzShouldShowPain", &mechzShouldShowPain);
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("tombMechzJumpUpActionStart", &function_6f434f2b);
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("tombMechzJumpUpActionTerminate", &function_e3577caa);
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeAction("tombMechzJumpHoverAction", undefined, &function_7efad7ec, undefined);
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("tombMechzJumpDownActionStart", &function_58e29f36);
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("tombMechzJumpDownActionTerminate", &function_647ea967);
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("tombMechzRobotStompActionStart", &function_13bab4e7);
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeAction("tombMechzRobotStompActionLoop", undefined, &function_a833c7b2, undefined);
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("tombMechzRobotStompActionEnd", &function_e260a84c);
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeAction("tombMechzShootFlameAtTankAction", &function_84bcf2d9, &MechzBehavior::mechzShootFlameActionUpdate, &function_f10762);
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("tombMechzTankKnockdownActionStart", &function_f7a84bd6);
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeAction("tombMechzTankKnockdownActionLoop", undefined, &function_9dc92f99, undefined);
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("tombMechzTankKnockdownActionEnd", &function_5276dd35);
	AnimationStateNetwork::RegisterAnimationMocomp("mocomp_face_tank@mechz", &function_744a18d6, undefined, undefined);
	AnimationStateNetwork::RegisterAnimationMocomp("mocomp_jump_tank@mechz", &function_6024ae49, undefined, undefined);
	AnimationStateNetwork::RegisterAnimationMocomp("mocomp_tomb_mechz_traversal@mechz", &function_3b00a84, undefined, &function_5e254e4f);
}

/*
	Name: function_b6ebb97d
	Namespace: namespace_baebcb1
	Checksum: 0xAD48F0A4
	Offset: 0x1728
	Size: 0x137
	Parameters: 1
	Flags: Private
*/
function private function_b6ebb97d(entity)
{
	if(level.vh_tank flag::get("tank_moving"))
	{
		entity.var_afe67307 = undefined;
		return;
	}
	a_players_on_tank = zm_tomb_tank::get_players_on_tank();
	if(isdefined(entity.var_afe67307) && a_players_on_tank.size > 0)
	{
		return;
	}
	if(!isdefined(entity.favoriteenemy))
	{
		entity.var_afe67307 = undefined;
		return;
	}
	if(!entity.favoriteenemy zm_tomb_tank::entity_on_tank())
	{
		entity.var_afe67307 = undefined;
		return;
	}
	str_tag = level.vh_tank zm_tomb_tank::get_closest_mechz_tag_on_tank(entity, entity.favoriteenemy.origin);
	if(isdefined(str_tag))
	{
		entity.var_afe67307 = level.vh_tank zm_tomb_tank::function_21d81b2c(str_tag);
	}
}

/*
	Name: function_4f9821c3
	Namespace: namespace_baebcb1
	Checksum: 0x2BD5CDD5
	Offset: 0x1868
	Size: 0xC7
	Parameters: 1
	Flags: Private
*/
function private function_4f9821c3(entity)
{
	if(!level.vh_tank flag::get("tank_moving"))
	{
		entity.jump_pos = undefined;
		return;
	}
	if(!isdefined(entity.favoriteenemy))
	{
		entity.jump_pos = undefined;
		return;
	}
	if(!entity.favoriteenemy zm_tomb_tank::entity_on_tank())
	{
		entity.jump_pos = undefined;
		return;
	}
	if(!isdefined(entity.jump_pos))
	{
		entity.jump_pos = get_closest_mechz_spawn_pos(entity.origin);
	}
}

/*
	Name: function_c9cd5bdd
	Namespace: namespace_baebcb1
	Checksum: 0xB07D526C
	Offset: 0x1938
	Size: 0x7B
	Parameters: 1
	Flags: Private
*/
function private function_c9cd5bdd(entity)
{
	if(isdefined(entity.force_jump))
	{
		return 1;
	}
	if(!isdefined(entity.jump_pos))
	{
		return 0;
	}
	if(DistanceSquared(entity.origin, entity.jump_pos.origin) > 100)
	{
		return 0;
	}
	return 1;
}

/*
	Name: function_9ea85604
	Namespace: namespace_baebcb1
	Checksum: 0x5B4708A9
	Offset: 0x19C0
	Size: 0xF5
	Parameters: 1
	Flags: Private
*/
function private function_9ea85604(entity)
{
	/#
		if(isdefined(entity.shoot_flame) && entity.shoot_flame)
		{
			return 1;
		}
	#/
	if(entity.Berserk === 1)
	{
		return 0;
	}
	if(!isdefined(entity.var_afe67307))
	{
		return 0;
	}
	Distance2D = Distance2DSquared(entity.origin, entity.var_afe67307);
	Distance = DistanceSquared(entity.origin, entity.var_afe67307);
	if(Distance2D > 100)
	{
		return 0;
	}
	return 1;
}

/*
	Name: function_b47192a9
	Namespace: namespace_baebcb1
	Checksum: 0x4173E10D
	Offset: 0x1AC0
	Size: 0x25
	Parameters: 2
	Flags: Private
*/
function private function_b47192a9(entity, asmStateName)
{
	return isdefined(self.var_32854687) && self.var_32854687;
}

/*
	Name: function_4bbd0723
	Namespace: namespace_baebcb1
	Checksum: 0xF710C0A8
	Offset: 0x1AF0
	Size: 0x25
	Parameters: 2
	Flags: Private
*/
function private function_4bbd0723(entity, asmStateName)
{
	return isdefined(self.robot_stomped) && self.robot_stomped;
}

/*
	Name: mechzShouldShowPain
	Namespace: namespace_baebcb1
	Checksum: 0x3BB3795A
	Offset: 0x1B20
	Size: 0x45
	Parameters: 1
	Flags: Private
*/
function private mechzShouldShowPain(entity)
{
	if(entity.partDestroyed === 1)
	{
		return 1;
	}
	if(entity.show_pain_from_explosive_dmg === 1)
	{
		return 1;
	}
}

/*
	Name: function_6f434f2b
	Namespace: namespace_baebcb1
	Checksum: 0x61FBD904
	Offset: 0x1B70
	Size: 0x63
	Parameters: 2
	Flags: Private
*/
function private function_6f434f2b(entity, asmStateName)
{
	entity SetFreeCameraLockOnAllowed(0);
	entity thread mechz_jump_vo();
	entity PathMode("dont move");
}

/*
	Name: function_e3577caa
	Namespace: namespace_baebcb1
	Checksum: 0xE17C84A7
	Offset: 0x1BE0
	Size: 0xDF
	Parameters: 2
	Flags: Private
*/
function private function_e3577caa(entity, asmStateName)
{
	entity ghost();
	entity.mechz_hidden = 1;
	if(isdefined(entity.m_claw))
	{
		entity.m_claw ghost();
	}
	if(isdefined(entity.fx_field))
	{
		entity.fx_field_old = entity.fx_field;
	}
	entity thread zombie_utility::zombie_eye_glow_stop();
	entity.var_1ea3b675 = level.time + level.mechz_jump_delay * 1000;
}

/*
	Name: function_7efad7ec
	Namespace: namespace_baebcb1
	Checksum: 0x57D6A2F
	Offset: 0x1CC8
	Size: 0x5F
	Parameters: 2
	Flags: Private
*/
function private function_7efad7ec(entity, asmStateName)
{
	if(entity.var_1ea3b675 > level.time)
	{
		return 5;
	}
	if(level.vh_tank flag::get("tank_moving"))
	{
		return 5;
	}
	return 4;
}

/*
	Name: function_58e29f36
	Namespace: namespace_baebcb1
	Checksum: 0xD616D41D
	Offset: 0x1D30
	Size: 0x133
	Parameters: 2
	Flags: Private
*/
function private function_58e29f36(entity, asmStateName)
{
	entity.var_1ea3b675 = undefined;
	var_be0ab0a1 = get_best_mechz_spawn_pos(1);
	if(!isdefined(var_be0ab0a1.angles))
	{
		var_be0ab0a1.angles = (0, 0, 0);
	}
	entity ForceTeleport(var_be0ab0a1.origin, var_be0ab0a1.angles);
	entity.mechz_hidden = 0;
	entity show();
	if(isdefined(entity.m_claw))
	{
		entity.m_claw show();
	}
	entity.fx_field = entity.fx_field_old;
	entity.fx_field_old = undefined;
	entity thread zombie_utility::zombie_eye_glow();
}

/*
	Name: function_647ea967
	Namespace: namespace_baebcb1
	Checksum: 0x74EDC72A
	Offset: 0x1E70
	Size: 0x6B
	Parameters: 2
	Flags: Private
*/
function private function_647ea967(entity, asmStateName)
{
	entity solid();
	entity SetFreeCameraLockOnAllowed(1);
	entity.force_jump = undefined;
	entity PathMode("move allowed");
}

/*
	Name: function_13bab4e7
	Namespace: namespace_baebcb1
	Checksum: 0xCFC9A933
	Offset: 0x1EE8
	Size: 0x4F
	Parameters: 2
	Flags: Private
*/
function private function_13bab4e7(entity, asmStateName)
{
	entity function_97cf5f();
	entity.var_5819fc = level.time + level.mechz_robot_knockdown_time * 1000;
}

/*
	Name: function_a833c7b2
	Namespace: namespace_baebcb1
	Checksum: 0x93233663
	Offset: 0x1F40
	Size: 0x39
	Parameters: 2
	Flags: Private
*/
function private function_a833c7b2(entity, asmStateName)
{
	if(entity.var_5819fc > level.time)
	{
		return 5;
	}
	return 4;
}

/*
	Name: function_e260a84c
	Namespace: namespace_baebcb1
	Checksum: 0x450309CA
	Offset: 0x1F88
	Size: 0x2D
	Parameters: 2
	Flags: Private
*/
function private function_e260a84c(entity, asmStateName)
{
	entity.var_5819fc = undefined;
	entity.robot_stomped = undefined;
}

/*
	Name: function_84bcf2d9
	Namespace: namespace_baebcb1
	Checksum: 0x7181B0
	Offset: 0x1FC0
	Size: 0x41
	Parameters: 2
	Flags: Private
*/
function private function_84bcf2d9(entity, asmStateName)
{
	entity.doing_tank_sweep = 1;
	return MechzBehavior::mechzShootFlameActionStart(entity, asmStateName);
}

/*
	Name: function_f10762
	Namespace: namespace_baebcb1
	Checksum: 0xB36115F5
	Offset: 0x2010
	Size: 0x39
	Parameters: 2
	Flags: Private
*/
function private function_f10762(entity, asmStateName)
{
	entity.doing_tank_sweep = undefined;
	return MechzBehavior::mechzShootFlameActionEnd(entity, asmStateName);
}

/*
	Name: function_f7a84bd6
	Namespace: namespace_baebcb1
	Checksum: 0x65500571
	Offset: 0x2058
	Size: 0x87
	Parameters: 2
	Flags: Private
*/
function private function_f7a84bd6(entity, asmStateName)
{
	entity function_97cf5f();
	entity show();
	entity PathMode("move allowed");
	entity.var_918f1b56 = level.time + level.mechz_tank_knockdown_time * 1000;
}

/*
	Name: function_9dc92f99
	Namespace: namespace_baebcb1
	Checksum: 0x57FECECA
	Offset: 0x20E8
	Size: 0x39
	Parameters: 2
	Flags: Private
*/
function private function_9dc92f99(entity, asmStateName)
{
	if(entity.var_918f1b56 > level.time)
	{
		return 5;
	}
	return 4;
}

/*
	Name: function_5276dd35
	Namespace: namespace_baebcb1
	Checksum: 0xCBFF2C0B
	Offset: 0x2130
	Size: 0xE1
	Parameters: 2
	Flags: Private
*/
function private function_5276dd35(entity, asmStateName)
{
	if(!level.vh_tank flag::get("tank_moving") && entity istouching(level.vh_tank))
	{
		entity notsolid();
		entity ghost();
		if(isdefined(entity.var_b1d5a124))
		{
			entity.m_claw ghost();
		}
		entity.force_jump = 1;
	}
	entity.var_918f1b56 = undefined;
	entity.var_32854687 = undefined;
}

/*
	Name: function_744a18d6
	Namespace: namespace_baebcb1
	Checksum: 0x2D6896FC
	Offset: 0x2220
	Size: 0x73
	Parameters: 5
	Flags: Private
*/
function private function_744a18d6(entity, mocompAnim, mocompAnimBlendOutTime, mocompAnimFlag, mocompDuration)
{
	entity OrientMode("face direction", VectorNormalize(level.vh_tank.origin - entity.origin));
}

/*
	Name: function_6024ae49
	Namespace: namespace_baebcb1
	Checksum: 0x9533A3DF
	Offset: 0x22A0
	Size: 0x4B
	Parameters: 5
	Flags: Private
*/
function private function_6024ae49(entity, mocompAnim, mocompAnimBlendOutTime, mocompAnimFlag, mocompDuration)
{
	entity animMode("noclip", 0);
}

/*
	Name: function_3b00a84
	Namespace: namespace_baebcb1
	Checksum: 0x2254C0BE
	Offset: 0x22F8
	Size: 0xEB
	Parameters: 5
	Flags: Private
*/
function private function_3b00a84(entity, mocompAnim, mocompAnimBlendOutTime, mocompAnimFlag, mocompDuration)
{
	entity animMode("noclip", 0);
	if(isdefined(entity.traverseStartNode))
	{
		entity OrientMode("face angle", entity.traverseStartNode.angles[1]);
	}
	entity SetRepairPaths(0);
	entity ForceTeleport(entity.traverseStartNode.origin, entity.traverseStartNode.angles, 0);
}

/*
	Name: function_5e254e4f
	Namespace: namespace_baebcb1
	Checksum: 0x9C6FFDEA
	Offset: 0x23F0
	Size: 0x143
	Parameters: 5
	Flags: Private
*/
function private function_5e254e4f(entity, mocompAnim, mocompAnimBlendOutTime, mocompAnimFlag, mocompDuration)
{
	entity SetRepairPaths(1);
	if(isdefined(entity.traverseEndNode))
	{
		entity ForceTeleport(entity.traverseEndNode.origin, entity.traverseEndNode.angles, 0);
	}
	else
	{
		queryResult = PositionQuery_Source_Navigation(entity.origin, 0, 64, 20, 4);
		if(queryResult.data.size)
		{
			entity ForceTeleport(queryResult.data[0].origin, entity.angles, 0);
		}
	}
	entity finishtraversal();
}

/*
	Name: function_97cf5f
	Namespace: namespace_baebcb1
	Checksum: 0xC447CB99
	Offset: 0x2540
	Size: 0xBB
	Parameters: 0
	Flags: Private
*/
function private function_97cf5f()
{
	v_trace_start = self.origin + VectorScale((0, 0, 1), 100);
	v_trace_end = self.origin - VectorScale((0, 0, 1), 500);
	v_trace = PhysicsTrace(self.origin, v_trace_end, (-15, -15, -5), (15, 15, 5), self);
	self ForceTeleport(v_trace["position"], self.angles);
}

/*
	Name: get_closest_mechz_spawn_pos
	Namespace: namespace_baebcb1
	Checksum: 0xD3991D19
	Offset: 0x2608
	Size: 0x137
	Parameters: 1
	Flags: None
*/
function get_closest_mechz_spawn_pos(org)
{
	best_dist = -1;
	best_pos = undefined;
	for(i = 0; i < level.mechz_locations.size; i++)
	{
		dist = DistanceSquared(org, level.mechz_locations[i].origin);
		if(dist < best_dist || best_dist < 0)
		{
			best_dist = dist;
			best_pos = level.mechz_locations[i];
		}
	}
	/#
		if(!isdefined(best_pos))
		{
			println("Dev Block strings are not supported" + self.origin[0] + "Dev Block strings are not supported" + self.origin[1] + "Dev Block strings are not supported" + self.origin[2] + "Dev Block strings are not supported");
		}
	#/
	return best_pos;
}

/*
	Name: function_eeec66f5
	Namespace: namespace_baebcb1
	Checksum: 0xFC55BF05
	Offset: 0x2748
	Size: 0x161
	Parameters: 1
	Flags: None
*/
function function_eeec66f5(mechz)
{
	flameTrigger = mechz.flameTrigger;
	do_tank_sweep_auto_damage = isdefined(self.doing_tank_sweep) && self.doing_tank_sweep && !level.vh_tank flag::get("tank_moving");
	a_zombies = namespace_57695b4d::function_d41418b8();
	foreach(zombie in a_zombies)
	{
		if(do_tank_sweep_auto_damage && zombie zm_tomb_tank::entity_on_tank() || zombie istouching(flameTrigger) && zombie.var_e05d0be2 !== 1)
		{
			zombie namespace_57695b4d::function_f4defbc2();
		}
	}
}

/*
	Name: function_8166f050
	Namespace: namespace_baebcb1
	Checksum: 0x36D05BD4
	Offset: 0x28B8
	Size: 0x191
	Parameters: 1
	Flags: None
*/
function function_8166f050(entity)
{
	do_tank_sweep_auto_damage = isdefined(self.doing_tank_sweep) && self.doing_tank_sweep && !level.vh_tank flag::get("tank_moving");
	players = GetPlayers();
	foreach(player in players)
	{
		if(!(isdefined(player.is_burning) && player.is_burning))
		{
			if(do_tank_sweep_auto_damage && player zm_tomb_tank::entity_on_tank() || player istouching(entity.flameTrigger))
			{
				if(isdefined(entity.mechzFlameDamage))
				{
					player thread [[entity.mechzFlameDamage]]();
					continue;
				}
				player thread MechzBehavior::playerFlameDamage(entity);
			}
		}
	}
}

/*
	Name: mechz_staff_damage_override
	Namespace: namespace_baebcb1
	Checksum: 0x563F9FB
	Offset: 0x2A58
	Size: 0x115
	Parameters: 12
	Flags: None
*/
function mechz_staff_damage_override(inflictor, attacker, damage, dFlags, mod, weapon, point, dir, hitLoc, offsetTime, boneIndex, modelIndex)
{
	if(self namespace_ecdcc148::is_staff_fire_damage(weapon) && mod != "MOD_MELEE")
	{
		if(mod != "MOD_BURNED" && mod != "MOD_GRENADE_SPLASH")
		{
			return namespace_ecdcc148::get_impact_damage(weapon);
		}
	}
	if(self namespace_589e3c80::is_staff_air_damage(weapon) || self namespace_42f5ba79::is_staff_water_damage(weapon) || self namespace_dc4ed61a::is_staff_lightning_damage(weapon))
	{
		return damage;
	}
	return 0;
}

/*
	Name: enable_mechz_rounds
	Namespace: namespace_baebcb1
	Checksum: 0xE64054C7
	Offset: 0x2B78
	Size: 0x73
	Parameters: 0
	Flags: None
*/
function enable_mechz_rounds()
{
	/#
		if(GetDvarInt("Dev Block strings are not supported") >= 2)
		{
			return;
		}
	#/
	level.mechz_rounds_enabled = 1;
	level flag::init("mechz_round");
	level thread mechz_round_tracker();
}

/*
	Name: mechz_round_tracker
	Namespace: namespace_baebcb1
	Checksum: 0x2CDCE31F
	Offset: 0x2BF8
	Size: 0x3BF
	Parameters: 0
	Flags: None
*/
function mechz_round_tracker()
{
	level.num_mechz_spawned = 0;
	old_spawn_func = level.round_spawn_func;
	old_wait_func = level.round_wait_func;
	level flag::wait_till("activate_zone_nml");
	mech_start_round_num = 8;
	if(isdefined(level.is_forever_solo_game) && level.is_forever_solo_game)
	{
		mech_start_round_num = 8;
	}
	while(level.round_number < mech_start_round_num)
	{
		level waittill("between_round_over");
	}
	level.next_mechz_round = level.round_number;
	level thread debug_print_mechz_round();
	while(1)
	{
		if(level.num_mechz_spawned > 0)
		{
			level.mechz_should_drop_powerup = 1;
		}
		if(level.next_mechz_round <= level.round_number)
		{
			a_zombies = GetAISpeciesArray(level.zombie_team, "all");
			foreach(zombie in a_zombies)
			{
				if(isdefined(zombie.is_mechz) && zombie.is_mechz && isalive(zombie))
				{
					level.next_mechz_round++;
					break;
				}
			}
		}
		else if(level.mechz_left_to_spawn == 0 && level.next_mechz_round <= level.round_number)
		{
			mechz_health_increases();
			if(level.players.size == 1)
			{
				level.mechz_zombie_per_round = 1;
			}
			else if(level.mechz_round_count < 2)
			{
				level.mechz_zombie_per_round = 1;
			}
			else if(level.mechz_round_count < 5)
			{
				level.mechz_zombie_per_round = 2;
			}
			else
			{
				level.mechz_zombie_per_round = 3;
			}
			level.mechz_left_to_spawn = level.mechz_zombie_per_round;
			mechz_spawning = level.mechz_left_to_spawn;
			wait(RandomFloatRange(10, 15));
			level notify("spawn_mechz");
			if(isdefined(level.is_forever_solo_game) && level.is_forever_solo_game)
			{
				n_round_gap = randomIntRange(level.mechz_min_round_fq_solo, level.mechz_max_round_fq_solo);
			}
			else
			{
				n_round_gap = randomIntRange(level.mechz_min_round_fq, level.mechz_max_round_fq);
			}
			level.next_mechz_round = level.round_number + n_round_gap;
			level.mechz_round_count++;
			level thread debug_print_mechz_round();
			level.num_mechz_spawned = level.num_mechz_spawned + mechz_spawning;
		}
		level waittill("between_round_over");
	}
}

/*
	Name: debug_print_mechz_round
	Namespace: namespace_baebcb1
	Checksum: 0x52A291D6
	Offset: 0x2FC0
	Size: 0x4B
	Parameters: 0
	Flags: None
*/
function debug_print_mechz_round()
{
	level flag::wait_till("start_zombie_round_logic");
	/#
		iprintln("Dev Block strings are not supported" + level.next_mechz_round);
	#/
}

/*
	Name: mechz_spawning_logic
	Namespace: namespace_baebcb1
	Checksum: 0xD61C0576
	Offset: 0x3018
	Size: 0x14B
	Parameters: 0
	Flags: None
*/
function mechz_spawning_logic()
{
	level thread enable_mechz_rounds();
	while(1)
	{
		level waittill("spawn_mechz");
		while(level.mechz_left_to_spawn)
		{
			s_loc = function_27b9fdd3();
			if(!isdefined(s_loc))
			{
				continue;
			}
			ai = namespace_ef567265::spawn_mechz(s_loc, 1);
			waittillframeend;
			ai clientfield::set("tomb_mech_eye", 1);
			ai thread mechz_death();
			ai.no_widows_wine = 1;
			level.mechz_left_to_spawn--;
			if(level.mechz_left_to_spawn == 0)
			{
				level thread response_to_air_raid_siren_vo();
			}
			ai thread mechz_hint_vo();
			wait(RandomFloatRange(3, 6));
		}
	}
}

/*
	Name: mechz_death
	Namespace: namespace_baebcb1
	Checksum: 0xD404CFDF
	Offset: 0x3170
	Size: 0xF3
	Parameters: 0
	Flags: None
*/
function mechz_death()
{
	self waittill("hash_46c1e51d");
	self clientfield::set("tomb_mech_eye", 0);
	level notify("mechz_killed", self.origin);
	if(level flag::get("zombie_drop_powerups") && (!isdefined(self.no_powerups) && self.no_powerups))
	{
		var_d54b1ec = Array("double_points", "insta_kill", "full_ammo", "nuke");
		str_type = Array::random(var_d54b1ec);
		zm_powerups::specific_powerup_drop(str_type, self.origin);
	}
}

/*
	Name: get_best_mechz_spawn_pos
	Namespace: namespace_baebcb1
	Checksum: 0xF32BA25D
	Offset: 0x3270
	Size: 0x361
	Parameters: 1
	Flags: None
*/
function get_best_mechz_spawn_pos(ignore_used_positions)
{
	if(!isdefined(ignore_used_positions))
	{
		ignore_used_positions = 0;
	}
	best_dist = -1;
	best_pos = undefined;
	for(i = 0; i < level.mechz_locations.size; i++)
	{
		str_zone = zm_zonemgr::get_zone_from_position(level.mechz_locations[i].origin, 0);
		if(!isdefined(str_zone))
		{
			break;
		}
		if(!ignore_used_positions && (isdefined(level.mechz_locations[i].has_been_used) && level.mechz_locations[i].has_been_used))
		{
			break;
		}
		if(ignore_used_positions == 1 && (isdefined(level.mechz_locations[i].used_cooldown) && level.mechz_locations[i].used_cooldown))
		{
			break;
		}
		for(j = 0; j < level.players.size; j++)
		{
			if(zombie_utility::is_player_valid(level.players[j], 1, 1))
			{
				dist = DistanceSquared(level.mechz_locations[i].origin, level.players[j].origin);
				if(dist < best_dist || best_dist < 0)
				{
					best_dist = dist;
					best_pos = level.mechz_locations[i];
				}
			}
		}
	}
	if(ignore_used_positions && isdefined(best_pos))
	{
		best_pos thread jump_pos_used_cooldown();
	}
	if(isdefined(best_pos))
	{
		best_pos.has_been_used = 1;
	}
	else if(level.mechz_locations.size > 0)
	{
		var_634f9cbb = Array::randomize(level.mechz_locations);
		foreach(location in var_634f9cbb)
		{
			str_zone = zm_zonemgr::get_zone_from_position(location.origin, 0);
			if(isdefined(str_zone))
			{
				return location;
			}
		}
		return level.mechz_locations[RandomInt(level.mechz_locations.size)];
	}
	return best_pos;
}

/*
	Name: mechz_clear_spawns
	Namespace: namespace_baebcb1
	Checksum: 0x8A4EFBD4
	Offset: 0x35E0
	Size: 0x49
	Parameters: 0
	Flags: None
*/
function mechz_clear_spawns()
{
	for(i = 0; i < level.mechz_locations.size; i++)
	{
		level.mechz_locations[i].has_been_used = 0;
	}
}

/*
	Name: jump_pos_used_cooldown
	Namespace: namespace_baebcb1
	Checksum: 0x49B119F5
	Offset: 0x3638
	Size: 0x23
	Parameters: 0
	Flags: None
*/
function jump_pos_used_cooldown()
{
	self.used_cooldown = 1;
	wait(5);
	self.used_cooldown = 0;
}

/*
	Name: mechz_health_increases
	Namespace: namespace_baebcb1
	Checksum: 0xFB57B628
	Offset: 0x3668
	Size: 0x103
	Parameters: 0
	Flags: None
*/
function mechz_health_increases()
{
	if(!isdefined(level.mechz_last_spawn_round) || level.round_number > level.mechz_last_spawn_round)
	{
		a_players = GetPlayers();
		n_player_modifier = 1;
		if(a_players.size > 1)
		{
			n_player_modifier = a_players.size * 0.75;
		}
		level.mechz_health = Int(n_player_modifier * level.mechz_base_health + level.mechz_health_increase * level.mechz_round_count);
		if(level.mechz_health >= 22500 * n_player_modifier)
		{
			level.mechz_health = Int(22500 * n_player_modifier);
		}
		level.mechz_last_spawn_round = level.round_number;
	}
}

/*
	Name: mechz_damage_override
	Namespace: namespace_baebcb1
	Checksum: 0x57A9A14B
	Offset: 0x3778
	Size: 0x6FF
	Parameters: 11
	Flags: None
*/
function mechz_damage_override(inflictor, attacker, damage, flags, meansOfDeath, weapon, vPoint, vDir, sHitLoc, pOffsetTime, boneIndex)
{
	if(isdefined(self.b_flyin_done) && (!isdefined(self.b_flyin_done) && self.b_flyin_done))
	{
		return 0;
	}
	num_tiers = level.mechz_armor_info.size + 1;
	old_health_tier = Int(num_tiers * self.health / level.mechz_health);
	bonename = GetPartName("c_zom_mech_body", boneIndex);
	if(isdefined(attacker) && isalive(attacker) && isPlayer(attacker) && (level.zombie_vars[attacker.team]["zombie_insta_kill"] || (isdefined(attacker.personal_instakill) && attacker.personal_instakill)))
	{
		n_mechz_damage_percent = 1;
		n_mechz_headshot_modifier = 2;
	}
	else
	{
		n_mechz_damage_percent = level.mechz_damage_percent;
		n_mechz_headshot_modifier = 1;
	}
	if(isdefined(weapon) && weapon.weapClass == "spread")
	{
		n_mechz_damage_percent = n_mechz_damage_percent * level.mechz_shotgun_damage_mod;
		n_mechz_headshot_modifier = n_mechz_headshot_modifier * level.mechz_shotgun_damage_mod;
	}
	if(damage <= 10)
	{
		n_mechz_damage_percent = 1;
	}
	if(zm_utility::is_explosive_damage(meansOfDeath) || IsSubStr(weapon.name, "staff"))
	{
		if(n_mechz_damage_percent < 0.5)
		{
			n_mechz_damage_percent = 0.5;
		}
		if(!isdefined(self.has_faceplate) && self.has_faceplate && IsSubStr(weapon.name, "staff") && n_mechz_damage_percent < 1)
		{
			n_mechz_damage_percent = 1;
		}
		final_damage = damage * n_mechz_damage_percent;
		if(!isdefined(self.explosive_dmg_taken))
		{
			self.explosive_dmg_taken = 0;
		}
		self.explosive_dmg_taken = self.explosive_dmg_taken + final_damage;
		self MechzServerUtils::mechz_track_faceplate_damage(final_damage);
		if(isdefined(level.mechz_explosive_damage_reaction_callback))
		{
			[[level.mechz_explosive_damage_reaction_callback]]();
		}
		attacker MechzServerUtils::show_hit_marker();
	}
	else
	{
		final_damage = damage * n_mechz_damage_percent;
		if(sHitLoc === "torso_upper")
		{
			if(isdefined(self.has_faceplate) && self.has_faceplate)
			{
				faceplate_pos = self GetTagOrigin("j_faceplate");
				dist_sq = DistanceSquared(faceplate_pos, vPoint);
				if(dist_sq <= 144)
				{
					self MechzServerUtils::mechz_track_faceplate_damage(final_damage);
				}
				headlamp_dist_sq = DistanceSquared(vPoint, self GetTagOrigin("tag_headlamp_FX"));
				if(headlamp_dist_sq <= 9)
				{
					self MechzServerUtils::mechz_turn_off_headlamp(1);
				}
			}
			if(bonename == "tag_powersupply" || bonename == "tag_powersupply_hit")
			{
				if(isdefined(self.powercap_covered) && self.powercap_covered)
				{
					self MechzServerUtils::mechz_track_powercap_cover_damage(final_damage);
				}
				else if(isdefined(self.has_powercap) && self.has_powercap)
				{
					self MechzServerUtils::mechz_track_powercap_damage(final_damage);
				}
			}
		}
		else if(isdefined(self.e_grabbed) && (sHitLoc === "left_hand" || sHitLoc === "left_arm_lower" || sHitLoc === "left_arm_upper"))
		{
			if(isdefined(self.e_grabbed))
			{
				self.show_pain_from_explosive_dmg = 1;
			}
			if(isdefined(level.mechz_left_arm_damage_callback))
			{
				self [[level.mechz_left_arm_damage_callback]]();
			}
		}
		else if(sHitLoc == "head")
		{
			final_damage = damage * n_mechz_headshot_modifier;
		}
		attacker MechzServerUtils::show_hit_marker();
	}
	if(!isdefined(weapon) || weapon.name == "none")
	{
		if(!isPlayer(attacker))
		{
			final_damage = 0;
		}
	}
	new_health_tier = Int(num_tiers * self.health - final_damage / level.mechz_health);
	if(old_health_tier > new_health_tier)
	{
		while(old_health_tier > new_health_tier)
		{
			/#
				IPrintLnBold("Dev Block strings are not supported" + old_health_tier + "Dev Block strings are not supported" + new_health_tier + "Dev Block strings are not supported");
			#/
			if(old_health_tier < num_tiers)
			{
				self mechz_launch_armor_piece();
			}
			old_health_tier--;
		}
	}
	/#
		IPrintLnBold("Dev Block strings are not supported" + final_damage + "Dev Block strings are not supported" + self.health);
	#/
	return final_damage;
}

/*
	Name: mechz_launch_armor_piece
	Namespace: namespace_baebcb1
	Checksum: 0xD87A998B
	Offset: 0x3E80
	Size: 0xB3
	Parameters: 0
	Flags: Private
*/
function private mechz_launch_armor_piece()
{
	if(!isdefined(self.next_armor_piece))
	{
		self.next_armor_piece = 0;
	}
	if(!isdefined(self.var_ba00c27) || self.next_armor_piece >= self.var_ba00c27.size)
	{
		return;
	}
	self MechzServerUtils::hide_part(self.var_ba00c27[self.next_armor_piece].tag);
	self clientfield::set(self.var_ba00c27[self.next_armor_piece].clientfield, 1);
	self.next_armor_piece++;
}

/*
	Name: mechz_interrupt
	Namespace: namespace_baebcb1
	Checksum: 0xBAF849C8
	Offset: 0x3F40
	Size: 0x29
	Parameters: 0
	Flags: None
*/
function mechz_interrupt()
{
	self notify("kill_claw");
	self notify("kill_ft");
	self notify("kill_jump");
}

/*
	Name: mechz_robot_stomp_callback
	Namespace: namespace_baebcb1
	Checksum: 0x91A0603D
	Offset: 0x3F78
	Size: 0x33
	Parameters: 0
	Flags: None
*/
function mechz_robot_stomp_callback()
{
	self endon("death");
	if(isdefined(self.robot_stomped) && self.robot_stomped)
	{
		return;
	}
	self.robot_stomped = 1;
}

/*
	Name: response_to_air_raid_siren_vo
	Namespace: namespace_baebcb1
	Checksum: 0x5CA905E1
	Offset: 0x3FB8
	Size: 0x1FD
	Parameters: 0
	Flags: None
*/
function response_to_air_raid_siren_vo()
{
	wait(3);
	a_players = GetPlayers();
	if(a_players.size == 0)
	{
		return;
	}
	a_players = Array::randomize(a_players);
	foreach(player in a_players)
	{
		if(zombie_utility::is_player_valid(player))
		{
			if(!(isdefined(player.dontspeak) && player.dontspeak))
			{
				if(!isdefined(level.air_raid_siren_count))
				{
					player zm_audio::create_and_play_dialog("general", "siren_1st_time");
					level.air_raid_siren_count = 1;
					while(isdefined(player) && (isdefined(player.isSpeaking) && player.isSpeaking))
					{
						wait(0.1);
					}
					level thread start_see_mech_zombie_vo();
					break;
					continue;
				}
				if(level.mechz_zombie_per_round == 1)
				{
					player zm_audio::create_and_play_dialog("general", "siren_generic");
					break;
					continue;
				}
				player zm_audio::create_and_play_dialog("general", "multiple_mechs");
				break;
			}
		}
	}
}

/*
	Name: start_see_mech_zombie_vo
	Namespace: namespace_baebcb1
	Checksum: 0x5AF9FE4B
	Offset: 0x41C0
	Size: 0x1B1
	Parameters: 0
	Flags: None
*/
function start_see_mech_zombie_vo()
{
	wait(1);
	a_zombies = GetAISpeciesArray(level.zombie_team, "all");
	foreach(zombie in a_zombies)
	{
		if(isdefined(zombie.is_mechz) && zombie.is_mechz)
		{
			ai_mechz = zombie;
		}
	}
	a_players = GetPlayers();
	if(a_players.size == 0)
	{
		return;
	}
	if(isalive(ai_mechz))
	{
		foreach(player in a_players)
		{
			player thread player_looking_at_mechz_watcher(ai_mechz);
		}
	}
}

/*
	Name: player_looking_at_mechz_watcher
	Namespace: namespace_baebcb1
	Checksum: 0xB02AD253
	Offset: 0x4380
	Size: 0x103
	Parameters: 1
	Flags: None
*/
function player_looking_at_mechz_watcher(ai_mechz)
{
	self endon("disconnect");
	ai_mechz endon("death");
	level endon("first_mech_zombie_seen");
	while(1)
	{
		if(DistanceSquared(self.origin, ai_mechz.origin) < 1000000)
		{
			if(self zm_utility::is_player_looking_at(ai_mechz.origin + VectorScale((0, 0, 1), 60), 0.75))
			{
				if(!(isdefined(self.dontspeak) && self.dontspeak))
				{
					self zm_audio::create_and_play_dialog("general", "discover_mech");
					level notify("first_mech_zombie_seen");
					break;
				}
			}
		}
		wait(0.1);
	}
}

/*
	Name: mechz_grabbed_played_vo
	Namespace: namespace_baebcb1
	Checksum: 0x16D0F05
	Offset: 0x4490
	Size: 0xAB
	Parameters: 1
	Flags: None
*/
function mechz_grabbed_played_vo(ai_mechz)
{
	self endon("disconnect");
	self zm_audio::create_and_play_dialog("general", "mech_grab");
	while(isdefined(self) && (isdefined(self.isSpeaking) && self.isSpeaking))
	{
		wait(0.1);
	}
	wait(1);
	if(isalive(ai_mechz) && isdefined(ai_mechz.e_grabbed))
	{
		ai_mechz thread play_shoot_arm_hint_vo();
	}
}

/*
	Name: play_shoot_arm_hint_vo
	Namespace: namespace_baebcb1
	Checksum: 0xF15FB859
	Offset: 0x4548
	Size: 0x187
	Parameters: 0
	Flags: None
*/
function play_shoot_arm_hint_vo()
{
	self endon("death");
	while(1)
	{
		if(!isdefined(self.e_grabbed))
		{
			return;
		}
		a_players = GetPlayers();
		foreach(player in a_players)
		{
			if(player == self.e_grabbed)
			{
				continue;
			}
			if(DistanceSquared(self.origin, player.origin) < 1000000)
			{
				if(player zm_utility::is_player_looking_at(self.origin + VectorScale((0, 0, 1), 60), 0.75))
				{
					if(!(isdefined(player.dontspeak) && player.dontspeak))
					{
						player zm_audio::create_and_play_dialog("general", "shoot_mech_arm");
						return;
					}
				}
			}
		}
		wait(0.1);
	}
}

/*
	Name: mechz_hint_vo
	Namespace: namespace_baebcb1
	Checksum: 0x178BEB31
	Offset: 0x46D8
	Size: 0xD
	Parameters: 0
	Flags: None
*/
function mechz_hint_vo()
{
	self endon("death");
}

/*
	Name: shoot_mechz_head_vo
	Namespace: namespace_baebcb1
	Checksum: 0x729326FE
	Offset: 0x46F0
	Size: 0x16B
	Parameters: 0
	Flags: None
*/
function shoot_mechz_head_vo()
{
	self endon("death");
	a_players = GetPlayers();
	foreach(player in a_players)
	{
		if(isdefined(self.e_grabbed) && self.e_grabbed == player)
		{
			continue;
		}
		if(DistanceSquared(self.origin, player.origin) < 1000000)
		{
			if(player zm_utility::is_player_looking_at(self.origin + VectorScale((0, 0, 1), 60), 0.75))
			{
				if(!(isdefined(player.dontspeak) && player.dontspeak))
				{
					player zm_audio::create_and_play_dialog("general", "shoot_mech_head");
					return;
				}
			}
		}
	}
}

/*
	Name: mechz_jump_vo
	Namespace: namespace_baebcb1
	Checksum: 0x3CC61F3E
	Offset: 0x4868
	Size: 0x153
	Parameters: 0
	Flags: None
*/
function mechz_jump_vo()
{
	a_players = GetPlayers();
	foreach(player in a_players)
	{
		if(DistanceSquared(self.origin, player.origin) < 1000000)
		{
			if(player zm_utility::is_player_looking_at(self.origin + VectorScale((0, 0, 1), 60), 0.5))
			{
				if(!(isdefined(player.dontspeak) && player.dontspeak))
				{
					player util::delay(3, undefined, &zm_audio::create_and_play_dialog, "general", "rspnd_mech_jump");
					return;
				}
			}
		}
	}
}

/*
	Name: mechz_stomped_by_giant_robot_vo
	Namespace: namespace_baebcb1
	Checksum: 0xFDE34DC5
	Offset: 0x49C8
	Size: 0x153
	Parameters: 0
	Flags: None
*/
function mechz_stomped_by_giant_robot_vo()
{
	self endon("death");
	wait(5);
	a_players = GetPlayers();
	foreach(player in a_players)
	{
		if(DistanceSquared(self.origin, player.origin) < 1000000)
		{
			if(player zm_utility::is_player_looking_at(self.origin + VectorScale((0, 0, 1), 60), 0.75))
			{
				if(!(isdefined(player.dontspeak) && player.dontspeak))
				{
					player thread zm_audio::create_and_play_dialog("general", "robot_crush_mech");
					return;
				}
			}
		}
	}
}

/*
	Name: function_27b9fdd3
	Namespace: namespace_baebcb1
	Checksum: 0xF1B73085
	Offset: 0x4B28
	Size: 0x23D
	Parameters: 0
	Flags: None
*/
function function_27b9fdd3()
{
	var_fffe05f0 = Array::randomize(level.mechz_locations);
	var_1fae6c0 = [];
	for(i = 0; i < var_fffe05f0.size; i++)
	{
		s_loc = var_fffe05f0[i];
		str_zone = zm_zonemgr::get_zone_from_position(s_loc.origin, 1);
		if(isdefined(str_zone) && level.zones[str_zone].is_occupied)
		{
			var_1fae6c0[var_1fae6c0.size] = s_loc;
		}
	}
	if(var_1fae6c0.size == 0)
	{
		for(i = 0; i < var_fffe05f0.size; i++)
		{
			s_loc = var_fffe05f0[i];
			str_zone = zm_zonemgr::get_zone_from_position(s_loc.origin, 1);
			if(isdefined(str_zone) && level.zones[str_zone].is_active)
			{
				var_1fae6c0[var_1fae6c0.size] = s_loc;
			}
		}
	}
	else if(var_1fae6c0.size > 0)
	{
		return var_1fae6c0[0];
	}
	foreach(s_loc in var_fffe05f0)
	{
		str_zone = zm_zonemgr::get_zone_from_position(s_loc.origin, 0);
		if(isdefined(str_zone))
		{
			return s_loc;
		}
	}
	return var_fffe05f0[0];
}

