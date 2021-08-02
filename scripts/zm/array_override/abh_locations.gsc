#using scripts\codescripts\struct;
#using scripts\shared\array_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\callbacks_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\util_shared;
#using scripts\zm\array_override\bgb_common;
#using scripts\zm\_zm_zonemgr;
#using scripts\zm\array_override\array_override_common;

#insert scripts\shared\shared.gsh;
#insert scripts\zm\array_override\array_override_common.gsh;
#insert scripts\zm\array_override\abh_locations.gsh;

#namespace abh_locations;

function random_override(array)
{
	if (array[0].targetname == "player_respawn_point")
	{
		if (!self common_validation()) return;
		if (isdefined(level.abh_validation) && !self [[level.abh_validation]]()) return;
		point = undefined;
		if (isdefined(level.abh_point_lookup_override))
		{
			point = [[level.abh_point_lookup_override]](self.next_abh);
		}
		if (!isdefined(point))
		{
			foreach (s_point in array)
			{
				zone = zm_zonemgr::get_zone_from_position(s_point.origin + (0,0,32), 1);

				// if this is the next zone in our predetermined locations list, return this respawn point so the player tps there
				if (zone == self.next_abh)
				{
					point = s_point;
					break;
				}
			}
		}
		b_valid = isdefined(point) && IsInArray(array,point);
		if (b_valid || !IS_TRUE(self.is_next_abh_persistent))
		{
			self notify("next_abh_zone_reached",1);
			if (b_valid) return point;
		}
	}
}

#define USING_ROLES 0

#define SYSTEM_NAME "abh_locations"
function main()
{
	level endon("end_game");

	level.b_using_player_roles[SYSTEM_NAME] = USING_ROLES;

	MAP_ASSIGN_LIST_2_RETURN(level.abh_zones_m,level.abh_zones_c)
	MAP_ASSIGN_FUNC(level.abh_validation)
	level.desired_zones = level.abh_zones_c;

	thread abh_locations_using_megas();

	callback::on_connect(&monitor_abh);

	if (GetDvarString("mapname") == "zm_tomb") thread init_tomb_abh();
}

function init_tomb_abh()
{
	points = struct::get_array("player_respawn_point","targetname");
	level.zoneless_abh_points = array();
	level.zoneless_abh_points["zone_nml_farm"] = points[0];
	level.zoneless_abh_points["zone_nml_11"] = points[1];
	level.zoneless_abh_points["zone_nml_3"] = points[2];
	level.zoneless_abh_points["zone_nml_5"] = points[3];
	level.zoneless_abh_points["zone_nml_16"] = points[4];
	level.zoneless_abh_points["zone_village_0"] = points[5];
	level.zoneless_abh_points["zone_village_1"] = points[6];
	level.zoneless_abh_points["zone_village_2"] = points[7];
	level.zoneless_abh_points["zone_chamber_0"] = points[8];
	level.zoneless_abh_points["zone_start"] = points[9];
	level.zoneless_abh_points["zone_bunker_2"] = points[10];
	level.zoneless_abh_points["zone_bunker_5b"] = points[11];
	level.zoneless_abh_points["zone_bunker_tank_c"] = points[12];
	level.zoneless_abh_points["zone_bunker_tank_a1"] = points[13];
	level.zoneless_abh_points["zone_bunker_tank_e1"] = points[14];
	level.zoneless_abh_points["zone_bunker_3a"] = points[15];
	level.zoneless_abh_points["zone_bunker_1"] = points[16];
	level.zoneless_abh_points["zone_bunker_4c"] = points[17];
	level.zoneless_abh_points["zone_start_b"] = points[18];
	level.zoneless_abh_points["zone_start_a"] = points[19];

	level.abh_point_lookup_override = &abh_point_lookup;
}
function abh_point_lookup(str_name)
{
	return level.zoneless_abh_points[str_name];
}

function monitor_abh()
{
	level endon("end_game");
	self endon("disconnect");

	level flag::wait_till("start_zombie_round_logic");

	self waittill("bgb_update_give_zm_bgb_anywhere_but_here");
	if (IS_TRUE(level.b_using_player_roles[SYSTEM_NAME]))
	{
		if (!self flag::get("player_role_determined")) self waittill("player_role_determined");
	}
	else if (!isdefined(self.role)) self.role = self GetEntityNumber();

	self REGISTER_OVERRIDE(SYSTEM_NAME,ARRAY_RANDOM,&random_override);

	self.abh_index = 0;

	while(self.abh_index < level.desired_zones[self.role].size)
	{
		self.next_abh = level.desired_zones[self.role][self.abh_index];
		thread check_next_abh_persistent();
		self waittill("next_abh_zone_reached",b_increment);
		if (b_increment)
		{
			wait 2;
			self.abh_index++;
		}
	}
	self UNREGISTER_OVERRIDE(SYSTEM_NAME,ARRAY_RANDOM);
}

function check_next_abh_persistent()
{
	pers_prefix = TRY_TOKEN;
	if (IsSubStr(self.next_abh,pers_prefix))
	{
		self.is_next_abh_persistent = false;
		zone_name = StrTok(self.next_abh,pers_prefix)[ZONE_NAME_INDEX];
		self.next_abh = zone_name;
	}
	else self.is_next_abh_persistent = true;
}

function abh_locations_using_megas()
{
	level flag::wait_till("bgb_loadout_determined");

	if (level flag::get("using_megas"))
	{
		level.desired_zones = level.abh_zones_m;
	}
}

// VAlIDATION
function common_validation()
{
	if (self IsSwitchingWeapons()) return 0;

	return 1;
}
function zod_validation()
{
	if (IS_TRUE(self.altbody)) return 0;

	return 1;
}

function factory_validation()
{
	if (IS_TRUE(self.b_teleporting)) return 0;
	return 1;
}

function castle_validation()
{
	if (IS_TRUE(self.b_teleporting)) return 0;
	if (self clientfield::get_to_player("flinger_flying_postfx")) return 0;
	if(level flag::get("boss_fight_begin") && !level flag::get("boss_fight_completed")) return 0;

	return 1;
}

function island_validation()
{
	return 1;
}

function stalingrad_validation()//incomplete
{
	if (level flag::get("lockdown_active")) return 0;

	return 1;
}

function genesis_validation()
{
	if (IS_TRUE(self.b_teleporting)) return 0;
	if (self clientfield::get_to_player("flinger_flying_postfx")) return 0;
	if(level flag::get("boss_fight_begin") && !level flag::get("boss_fight_completed")) return 0;
	if(self IsTouching(GetEnt("samanthas_room_zone", "targetname"))) return 0;
	if(level flag::get("boss_fight") || level flag::get("arena_occupied_by_player")) return 0;

	return 1;
}

function tomb_validation()
{
	if(IsSubStr(self.zone_name, "zone_chamber")) return 0;
	if(IS_TRUE(self.b_already_on_tank)) return 0;
	if (isdefined(self.in_giant_robot_head)) return 0;
	if (isdefined(self.giant_robot_transition)) return 0;
	if(self.is_stomped === 1) return 0;

	return 1;
}

function default_validation()
{
	return 1;
}