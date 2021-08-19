#using scripts\codescripts\struct;
#using scripts\shared\array_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\ai\zombie_utility;

#using scripts\zm\array_override\array_override_common;
#insert scripts\zm\array_override\array_override_common.gsh;

#using scripts\zm\_zm_zonemgr;

#namespace fixed_ai_spawns;

// condition function entries - define them here, they should all be arrays with [0] being the function ptr, and [1] being the array of arguments
#define IS_FLAG_SET(a_args) array(&is_flag_set,a_args)


// SPAWN "REQUESTS": fixed zombies spawns for very early rounds (not for high rounds, as spawns eventually even out and are effectively no longer random)
// [0] Zone name of the desired spawner
#define ZONE_INDEX 0
// [1] Index of the spawner in that zone's spawner array of the desired spawner type ("zombie_location","margwa_location",etc.)
#define SPAWNER_INDEX 1
// [2] Number of zombies to spawn (doesn't need to be any more than 3 if it's a boardable entry)
#define NUM_Z_INDEX 2
// [3] Round number to deliver this request
#define N_RND_INDEX 3
// [4] Extra conditions (each condition is an array of 2 elements, [0] the condition function (boolean) and [1] the array of args to pass in
#define FUNC_INDEX 4

#define SOLO_ZOD_SPAWN_0 array("zone_subway_north",0,10,3,array())
#define SOLO_ZOD_SPAWN_1 array("zone_theater_A",0,6,4,array())
#define SOLO_ZOD_SPAWN_2 array("zone_theater_A",1,6,4,array())
#define SOLO_ZOD_SPAWN_3 array("zone_slums_high_B",1,10,5,array())
#define SOLO_ZOD_SPAWN_4 array("zone_junction_start",1,1,5,array())
#define SOLO_ZOD_SPAWN_5 array("zone_junction_slums",1,1,5,array())

#define FACTORY_SPAWN_0 array("receiver_zone",3,6,1,array())
#define FACTORY_SPAWN_1 array("receiver_zone",3,8,2,array())

#define SOLO_CASTLE_SPAWN_0 array("zone_great_hall",0,4,2,array())
#define SOLO_CASTLE_SPAWN_1 array("zone_lower_courtyard",1,4,3,array())
#define SOLO_CASTLE_SPAWN_2 array("zone_undercroft",1,4,4,array())
#define SOLO_CASTLE_SPAWN_3 array("zone_v10_pad",3,6,6,array())
#define SOLO_CASTLE_SPAWN_4 array("zone_gatehouse",1,6,6,array())
#define SOLO_CASTLE_SPAWN_5 array("zone_clocktower",0,6,6,array())
#define SOLO_CASTLE_SPAWN_6 array("zone_undercroft",2,10,7,array())
#define SOLO_CASTLE_SPAWN_7 array("zone_undercroft",3,10,7,array())

#define DUO_CASTLE_SPAWN_0 array("zone_lower_courtyard",1,3,2,array())
#define DUO_CASTLE_SPAWN_1 array("zone_lower_courtyard",1,3,3,array())
#define DUO_CASTLE_SPAWN_2 array("zone_great_hall",0,3,3,array())
#define DUO_CASTLE_SPAWN_3 array("zone_undercroft",1,4,4,array())
#define DUO_CASTLE_SPAWN_4 array("zone_great_hall",0,3,4,array())
#define DUO_CASTLE_SPAWN_5 array("zone_tram_to_subclocktower_top",1,3,6,array())
#define DUO_CASTLE_SPAWN_6 array("zone_v10_pad",3,5,6,array())
#define DUO_CASTLE_SPAWN_7 array("zone_gatehouse",1,2,6,array())
#define DUO_CASTLE_SPAWN_8 array("zone_clocktower",0,5,6,array())
#define DUO_CASTLE_SPAWN_9 array("zone_undercroft",2,10,7,array())
#define DUO_CASTLE_SPAWN_10 array("zone_undercroft",3,10,7,array())
#define DUO_CASTLE_SPAWN_11 array("zone_tram_to_subclocktower_top",1,6,8,array())

#define STALINGRAD_SPAWN_0 array("judicial_street_zone",1,1,1,array())
#define STALINGRAD_SPAWN_1 array("yellow_D_zone",0,3,2,array())
#define STALINGRAD_SPAWN_2 array("red_brick_C_zone",2,3,3,array())
#define STALINGRAD_SPAWN_3 array("red_brick_C_zone",2,3,4,array())

#define TOMB_SPAWN_0 array("zone_village_2",0,32,4,array())
#define TOMB_SPAWN_1 array("zone_village_2",0,32,5,array())
#define TOMB_SPAWN_2 array("zone_chamber_5",0,8,6,array())
#define TOMB_SPAWN_3 array("zone_chamber_5",1,8,6,array())
#define TOMB_SPAWN_4 array("zone_chamber_0",1,8,9,array())
#define TOMB_SPAWN_5 array("zone_chamber_0",2,8,9,array())
#define TOMB_SPAWN_6 array("zone_chamber_6",0,16,11,array())
#define TOMB_SPAWN_7 array("zone_chamber_6",1,16,11,array())
#define TOMB_SPAWN_8 array("zone_village_2",0,12,12,array())
#define TOMB_SPAWN_9 array("zone_village_2",0,10,13,array())
#define TOMB_SPAWN_10 array("zone_chamber_0",0,8,19,array())
#define TOMB_SPAWN_11 array("zone_chamber_0",1,8,19,array())
#define TOMB_SPAWN_12 array("zone_chamber_0",2,8,19,array())
#define TOMB_SPAWN_13 array("zone_chamber_0",3,8,19,array())
#define TOMB_SPAWN_14 array("zone_chamber_3",0,8,19,array())
#define TOMB_SPAWN_15 array("zone_chamber_3",1,8,19,array())
#define TOMB_SPAWN_16 array("zone_chamber_3",2,8,19,array())
#define TOMB_SPAWN_17 array("zone_chamber_3",3,8,19,array())
#define TOMB_SPAWN_18 array("zone_chamber_0",0,8,20,array())
#define TOMB_SPAWN_19 array("zone_chamber_0",1,8,20,array())
#define TOMB_SPAWN_20 array("zone_chamber_0",2,8,20,array())
#define TOMB_SPAWN_21 array("zone_chamber_0",3,8,20,array())
#define TOMB_SPAWN_22 array("zone_chamber_3",0,8,20,array())
#define TOMB_SPAWN_23 array("zone_chamber_3",1,8,20,array())
#define TOMB_SPAWN_24 array("zone_chamber_3",2,8,20,array())
#define TOMB_SPAWN_25 array("zone_chamber_3",3,8,20,array())
#define TOMB_SPAWN_26 array("zone_chamber_0",0,8,21,array())
#define TOMB_SPAWN_27 array("zone_chamber_0",1,8,21,array())
#define TOMB_SPAWN_28 array("zone_chamber_0",2,8,21,array())
#define TOMB_SPAWN_29 array("zone_chamber_0",3,8,21,array())
#define TOMB_SPAWN_30 array("zone_chamber_3",0,8,21,array())
#define TOMB_SPAWN_31 array("zone_chamber_3",1,8,21,array())
#define TOMB_SPAWN_32 array("zone_chamber_3",2,8,21,array())
#define TOMB_SPAWN_33 array("zone_chamber_3",3,8,21,array())


#define SOLO_ZOD_FIXED_SPAWNS array(SOLO_ZOD_SPAWN_0,SOLO_ZOD_SPAWN_1,SOLO_ZOD_SPAWN_2,SOLO_ZOD_SPAWN_3,SOLO_ZOD_SPAWN_4,SOLO_ZOD_SPAWN_5)
#define DUO_ZOD_FIXED_SPAWNS array()
#define FACTORY_FIXED_SPAWNS array(FACTORY_SPAWN_0,FACTORY_SPAWN_1)
#define SOLO_CASTLE_FIXED_SPAWNS array(SOLO_CASTLE_SPAWN_0,SOLO_CASTLE_SPAWN_1,SOLO_CASTLE_SPAWN_2,SOLO_CASTLE_SPAWN_3,SOLO_CASTLE_SPAWN_4,SOLO_CASTLE_SPAWN_5,SOLO_CASTLE_SPAWN_6,SOLO_CASTLE_SPAWN_7)
#define DUO_CASTLE_FIXED_SPAWNS array(DUO_CASTLE_SPAWN_0,DUO_CASTLE_SPAWN_1,DUO_CASTLE_SPAWN_2,DUO_CASTLE_SPAWN_3,DUO_CASTLE_SPAWN_4,DUO_CASTLE_SPAWN_5,DUO_CASTLE_SPAWN_6,DUO_CASTLE_SPAWN_7,DUO_CASTLE_SPAWN_8,DUO_CASTLE_SPAWN_9,DUO_CASTLE_SPAWN_10,DUO_CASTLE_SPAWN_11)
#define ISLAND_FIXED_SPAWNS array()
#define STALINGRAD_FIXED_SPAWNS array(STALINGRAD_SPAWN_0,STALINGRAD_SPAWN_1,STALINGRAD_SPAWN_2,STALINGRAD_SPAWN_3)
#define GENESIS_FIXED_SPAWNS array()
#define PROTOTYPE_FIXED_SPAWNS array()
#define ASYLUM_FIXED_SPAWNS array()
#define SUMPF_FIXED_SPAWNS array()
#define THEATER_FIXED_SPAWNS array()
#define COSMODROME_FIXED_SPAWNS array()
#define TEMPLE_FIXED_SPAWNS array()
#define MOON_FIXED_SPAWNS array()
#define TOMB_FIXED_SPAWNS array(TOMB_SPAWN_0,TOMB_SPAWN_1,TOMB_SPAWN_2,TOMB_SPAWN_3,TOMB_SPAWN_4,TOMB_SPAWN_5,TOMB_SPAWN_6,TOMB_SPAWN_7,TOMB_SPAWN_8,TOMB_SPAWN_9,TOMB_SPAWN_10,TOMB_SPAWN_11,TOMB_SPAWN_12,TOMB_SPAWN_13,TOMB_SPAWN_14,TOMB_SPAWN_15,TOMB_SPAWN_16,TOMB_SPAWN_17,TOMB_SPAWN_18,TOMB_SPAWN_19,TOMB_SPAWN_20,TOMB_SPAWN_21,TOMB_SPAWN_22,TOMB_SPAWN_23,TOMB_SPAWN_24,TOMB_SPAWN_25,TOMB_SPAWN_26,TOMB_SPAWN_27,TOMB_SPAWN_28,TOMB_SPAWN_29,TOMB_SPAWN_30,TOMB_SPAWN_31,TOMB_SPAWN_32,TOMB_SPAWN_33)

#define SYSTEM_NAME "fixed_z_spawns"
function init()
{
	REGISTER_OVERRIDE(SYSTEM_NAME,ARRAY_RANDOM,&random_override);
	thread main();
}

function random_override(array)
{
	if (IsInArray(level.zm_loc_types["zombie_location"],array[0]) && level.available_spawn_requests.size)
	{
		spawns = ArrayCopy(level.available_spawn_requests);
		for (i = 0; i < level.available_spawn_requests.size; i++)
		{
			fixed_spawn_index = spawns[RandomInt(spawns.size)];
			ArrayRemoveValue(spawns,fixed_spawn_index);
			fixed_spawn = level.spawn_requests[fixed_spawn_index];
			if ([[level.can_do_fixed_spawn_func]](fixed_spawn.zone))
			{
				should_spawn = 1;
				foreach (f in fixed_spawn.condition_func)
				{
					if (![[f.func]](f.arg))
					{
						should_spawn = 0;
						break;
					}
				}
				if (should_spawn)
				{
					desired = [[level.next_fixed_spawn_loc_func]](array,fixed_spawn.zone,fixed_spawn.spawner_index);
					level notify("fixed_zombie_spawn",fixed_spawn.n_index);
					if (isdefined(desired))
					{
						return desired;
					}
				}
			}
		}
	}
}


function main()
{
	level.fixed_spawns = get_map_fixed_spawns();
	level.spawn_requests = array();
	level.available_spawn_requests = array();
	level.can_do_fixed_spawn_func = &can_do_fixed_spawn;
	level.next_fixed_spawn_loc_func = &get_spawn_loc;

	foreach (i, entry in level.fixed_spawns)
	{
		level.spawn_requests[i] = write_spawn_entry(i,entry);
	}

	thread lifetime();

	level.fixed_spawns = undefined;

	for (i = 0; i < level.spawn_requests.size; i++)
	{
		level waittill("fixed_spawn_done");
	}

	level notify("all_fixed_spawns_done");

	level.spawn_requests = undefined;
	level.available_spawn_requests = undefined;
	level.can_do_fixed_spawn_func = undefined;
	level.next_fixed_spawn_loc_func = undefined;

	UNREGISTER_OVERRIDE(SYSTEM_NAME,ARRAY_RANDOM);
}

// for now we will reasonably assume the entries are already ordered by round number
function lifetime()
{
	thread monitor_fixed_spawns_given();
	level flag::wait_till("initial_blackscreen_passed");
	for (i = 0; i < level.spawn_requests.size; i++)
	{
		while (level.round_number < level.spawn_requests[i].n_rnd) level waittill("between_round_over");
		array::add(level.available_spawn_requests,level.spawn_requests[i].n_index);
	}
}

function monitor_fixed_spawns_given()
{
	level endon("all_fixed_spawns_done");
	while(1)
	{
		level waittill("fixed_zombie_spawn",index);
		level.spawn_requests[index].n_zombies++;
		if (level.spawn_requests[index].n_zombies >= level.spawn_requests[index].n_zombie_total)
		{
			ArrayRemoveValue(level.available_spawn_requests,level.spawn_requests[index].n_index);
			level notify("fixed_spawn_done");
		}
	}
}

function write_spawn_entry(index,entry)
{
	s_ret = SpawnStruct();
	s_ret.n_index = index;
	s_ret.zone = entry[ZONE_INDEX];
	s_ret.spawner_index = entry[SPAWNER_INDEX];
	s_ret.n_rnd = entry[N_RND_INDEX];
	s_ret.n_zombie_total = entry[NUM_Z_INDEX];
	s_ret.n_zombies = 0;

	s_ret.condition_func = array();

	condition_function_array = entry[FUNC_INDEX];

	for (i = 0; i < condition_function_array.size; i++)
	{
		func_data = condition_function_array[i];
		array::add(s_ret.condition_func, SpawnStruct());
		s_ret.condition_func[i].func = func_data[0];
		s_ret.condition_func[i].arg = func_data[1];
	}

	return s_ret;
}

function can_do_fixed_spawn(arg_zone)
{	
	if (!isdefined(arg_zone)) return 1;

	if (IsFunctionPtr(arg_zone))
	{
		zone = [[arg_zone]]();
	}
	else
	{
		zone = arg_zone;
	}

	s_zone = level.zones[zone];

	return (s_zone.is_enabled && s_zone.is_active && s_zone.is_spawning_allowed);
}

function get_spawn_loc(array,str_zone,n_index,str_type = "zombie_location")
{
	zone = level.zones[str_zone];
	desired = zone.a_loc_types[str_type][n_index];
	foreach(i,loc in array)
	{
		if (loc == desired)
		{
			return loc;
		}
	}
}

function get_zone_from_ref_point(ref_point)
{
	if (IsFunctionPtr(ref_point))
	{
		return &get_zone_from_vector_function;
	}
	zone = zm_zonemgr::get_zone_from_position(ref_point + VectorScale((0, 0, 1), 32), 0);
	if (!isdefined(zone)) 
	{
		playable_area = GetEntArray("player_volume","script_noteworthy");
		zone = ArrayGetClosest(ref_point,playable_area).targetname;
	}
	return zone;
}

function get_zone_from_vector_function(vector_function,a_args)
{
	vec = [[vector_function]](a_args);
	return zm_zonemgr::get_zone_from_position(vec + VectorScale((0, 0, 1), 32), 0);
}

function get_map_fixed_spawns()
{
	switch(GetDvarString("mapname"))
	{
		case "zm_zod":
			if (GetPlayers().size == 1)	return SOLO_ZOD_FIXED_SPAWNS;
			else return DUO_ZOD_FIXED_SPAWNS;
		case "zm_factory":
			return FACTORY_FIXED_SPAWNS;
		case "zm_castle":
			if (GetPlayers().size == 1)	return SOLO_CASTLE_FIXED_SPAWNS;
			else return DUO_CASTLE_FIXED_SPAWNS;
		case "zm_island":
			return ISLAND_FIXED_SPAWNS;
		case "zm_stalingrad":
			return STALINGRAD_FIXED_SPAWNS;
		case "zm_genesis":
			return GENESIS_FIXED_SPAWNS;
		case "zm_prototype":
			return PROTOTYPE_FIXED_SPAWNS;
		case "zm_asylum":
			return  ASYLUM_FIXED_SPAWNS;
		case "zm_sumpf":
			return SUMPF_FIXED_SPAWNS;
		case "zm_theater":
			return THEATER_FIXED_SPAWNS;
		case "zm_cosmodrome":
			return COSMODROME_FIXED_SPAWNS;
		case "zm_temple":
			return TEMPLE_FIXED_SPAWNS;
		case "zm_moon":
			return MOON_FIXED_SPAWNS;
		case "zm_tomb":
			return TOMB_FIXED_SPAWNS;
	}
}


// VECTOR FUNCTIONS - Not properly integrated - would be added instead of the zone name - no obvious utility
function get_player_origin(a_args)
{
	role_index = a_args[0];
	if (!isdefined(role_index)) role_index = 0;
	player = undefined;
	foreach (p in level.players)
	{
		if (isdefined(p.role) && p.role == role_index)
		{
			player = p;
		}
	}
	if (!isdefined(player)) player = level.players[0];
	return player.origin;
}


// CONDITION FUNCTIONS
function is_flag_set(a_args) //untested
{
	str_flag = a_args[0];
	if (!isdefined(str_flag)) return false;

	ent_function = a_args[1];
	ent_function_args = a_args[2];
	if (IsFunctionPtr(ent_function)) ent = [[ent_function]](ent_function_args);
	else ent = undefined;

	if (isdefined(ent))
	{
		return ent flag::get(str_flag);
	}
	else return level flag::get(str_flag);
}