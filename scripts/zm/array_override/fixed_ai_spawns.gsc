#using scripts\codescripts\struct;
#using scripts\shared\array_shared;
#using scripts\shared\flag_shared;
#using scripts\zm\array_override\array_override_common;
#using scripts\zm\_zm_zonemgr;
#using scripts\shared\ai\zombie_utility;

#insert scripts\zm\array_override\array_override_common.gsh;

#namespace fixed_ai_spawns;

#define ENTRY_HALL_BACK (-1074,3955,664)
#define ENTRY_LCOURTYARD (1730,2679,383)
#define ENTRY_LEFT_UNDERCROFT (-1190,2010,200)
#define ENTRY_RIGHT_UNDERCROFT (-1190,2620,200)
#define ENTRY_CLOCKTOWER (-1364,1504,808)
#define ENTRY_GATEHOUSE (1832,1514,400)
#define ENTRY_ROCKET (5718,-2950,-2291)
#define ENTRY_VOID (-875,1330,505)
#define ENTRY_COURTYARD (-510,1960,608)

#define ENTRY_FOOTLIGHT_BOTTOM (4770,-4070,128)
#define ENTRY_FOOTLIGHT_MIDDLE (4030,-4310,128)
#define ENTRY_WATRERFRONT_EGG (3090,-7800,256)
#define ENTRY_JUNCTION_LAUNDRY (2070,-5550,128)
#define ENTRY_RIFT_LEFT (2090,-4480,-398)

#define ENTRY_COMMAND_BOTTOM_CLOSE (405,4000,5)
#define ENTRY_BUNKER_TRUCK (-210,2450,10)
#define ENTRY_INFIRMARY_TOP_FRONT (-620,2900,320)
#define ENTRY_ARMORY_MIDDLE_WINDOW (620,3210,165)
#define ENTRY_ARMORY_DROPDOWN (920,3535,160)
#define ENTRY_ARMORY_TO_DC (770,3450,0)

// SPAWN "REQUESTS": fixed zombies spawns for very early rounds (not for high rounds, as spawns eventually even out and are effectively no longer random)
// [0] Coordinates of an entity that the zombies should spawn closest to
#define REF_POINT_INDEX 0
// [1] Number of zombies to spawn (doesn't need to be any more than 3 if it's a boardable entry)
#define NUM_Z_INDEX 1
#define N_RND_INDEX 2
#define FUNC_INDEX 3

#define SOLO_CASTLE_SPAWN_0 array(ENTRY_HALL_BACK,4,2,array())
#define SOLO_CASTLE_SPAWN_1 array(ENTRY_LCOURTYARD,4,3,array())
#define SOLO_CASTLE_SPAWN_2 array(ENTRY_LEFT_UNDERCROFT,4,4,array())
#define SOLO_CASTLE_SPAWN_3 array(ENTRY_ROCKET,6,6,array())
#define SOLO_CASTLE_SPAWN_4 array(ENTRY_GATEHOUSE,6,6,array())
#define SOLO_CASTLE_SPAWN_5 array(ENTRY_CLOCKTOWER,6,6,array())
#define SOLO_CASTLE_SPAWN_6 array(ENTRY_LEFT_UNDERCROFT,10,7,array())
#define SOLO_CASTLE_SPAWN_7 array(ENTRY_RIGHT_UNDERCROFT,10,7,array())

#define DUO_CASTLE_SPAWN_0 array(ENTRY_LCOURTYARD,3,2,array())
#define DUO_CASTLE_SPAWN_1 array(ENTRY_LCOURTYARD,3,3,array())
#define DUO_CASTLE_SPAWN_2 array(ENTRY_HALL_BACK,3,3,array())
#define DUO_CASTLE_SPAWN_3 array(ENTRY_LEFT_UNDERCROFT,4,4,array())
#define DUO_CASTLE_SPAWN_4 array(ENTRY_HALL_BACK,3,4,array())
#define DUO_CASTLE_SPAWN_5 array(ENTRY_VOID,3,6,array())
#define DUO_CASTLE_SPAWN_6 array(ENTRY_ROCKET,5,6,array())
#define DUO_CASTLE_SPAWN_7 array(ENTRY_GATEHOUSE,2,6,array())
#define DUO_CASTLE_SPAWN_8 array(ENTRY_CLOCKTOWER,5,6,array())
#define DUO_CASTLE_SPAWN_9 array(ENTRY_LEFT_UNDERCROFT,10,7,array())
#define DUO_CASTLE_SPAWN_10 array(ENTRY_RIGHT_UNDERCROFT,10,7,array())
#define DUO_CASTLE_SPAWN_11 array(ENTRY_VOID,6,8,array())

#define SOLO_ZOD_SPAWN_0 array(ENTRY_RIFT_LEFT,10,3,array())
#define SOLO_ZOD_SPAWN_1 array(ENTRY_FOOTLIGHT_BOTTOM,6,4,array())
#define SOLO_ZOD_SPAWN_2 array(ENTRY_FOOTLIGHT_MIDDLE,6,4,array())
#define SOLO_ZOD_SPAWN_3 array(ENTRY_WATRERFRONT_EGG,10,5,array())
#define SOLO_ZOD_SPAWN_4 array(ENTRY_JUNCTION_LAUNDRY,2,5,array())

#define STALINGRAD_SPAWN_1 array(ENTRY_ARMORY_TO_DC,1,1,array())
#define STALINGRAD_SPAWN_2 array(ENTRY_ARMORY_DROPDOWN,3,2,array())
#define STALINGRAD_SPAWN_3 array(ENTRY_INFIRMARY_TOP_FRONT,3,3,array())
#define STALINGRAD_SPAWN_4 array(ENTRY_INFIRMARY_TOP_FRONT,3,4,array())

#define SOLO_ZOD_FIXED_SPAWNS array(SOLO_ZOD_SPAWN_0,SOLO_ZOD_SPAWN_1,SOLO_ZOD_SPAWN_2,SOLO_ZOD_SPAWN_3,SOLO_ZOD_SPAWN_4)
#define DUO_ZOD_FIXED_SPAWNS array()
#define STALINGRAD_FIXED_SPAWNS array(STALINGRAD_SPAWN_1,STALINGRAD_SPAWN_2,STALINGRAD_SPAWN_3,STALINGRAD_SPAWN_4)
#define FACTORY_FIXED_SPAWNS array()
#define SOLO_CASTLE_FIXED_SPAWNS array(SOLO_CASTLE_SPAWN_0,SOLO_CASTLE_SPAWN_1,SOLO_CASTLE_SPAWN_2,SOLO_CASTLE_SPAWN_3,SOLO_CASTLE_SPAWN_4,SOLO_CASTLE_SPAWN_5,SOLO_CASTLE_SPAWN_6,SOLO_CASTLE_SPAWN_7)
#define DUO_CASTLE_FIXED_SPAWNS array(DUO_CASTLE_SPAWN_0,DUO_CASTLE_SPAWN_1,DUO_CASTLE_SPAWN_2,DUO_CASTLE_SPAWN_3,DUO_CASTLE_SPAWN_4,DUO_CASTLE_SPAWN_5,DUO_CASTLE_SPAWN_6,DUO_CASTLE_SPAWN_7,DUO_CASTLE_SPAWN_8,DUO_CASTLE_SPAWN_9,DUO_CASTLE_SPAWN_10,DUO_CASTLE_SPAWN_11)

#define SYSTEM_NAME "fixed_z_spawns"
function init()
{
	REGISTER_OVERRIDE(SYSTEM_NAME,ARRAY_RANDOM,&random_override);
	thread main();
	thread fixed_zombie_speed();
}

function random_override(array)
{
	if (IsInArray(level.zm_loc_types["zombie_location"],array[0]) && level.available_spawn_requests.size)
	{
		if(!isdefined(level.zombie_force_run)) level.zombie_force_run = 0;
		else level.zombie_force_run++;
		spawns = ArrayCopy(level.available_spawn_requests);
		for (i = level.available_spawn_requests.size; i > 0; i--)
		{
			fixed_spawn_index = array::random(spawns);
			ArrayRemoveValue(spawns,fixed_spawn_index);
			fixed_spawn = level.spawn_requests[fixed_spawn_index];
			if ([[level.can_do_fixed_spawn_func]](array,fixed_spawn.zone,fixed_spawn.ref_point))
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
					desired = [[level.next_fixed_spawn_loc_func]](array,fixed_spawn.ref_point);
					level notify("fixed_zombie_spawn",fixed_spawn.n_index);
					if (isdefined(desired)) return desired;
				}
			}
		}
	}
}


function main()
{
	map = GetDvarString("mapname");
	switch(map)
	{
		case "zm_zod":
			if (GetPlayers().size == 1)	level.fixed_spawns = SOLO_ZOD_FIXED_SPAWNS;
			else level.fixed_spawns = DUO_ZOD_FIXED_SPAWNS;
			break;
		case "zm_factory":
			level.fixed_spawns = FACTORY_FIXED_SPAWNS;
			break;
		case "zm_stalingrad":
			level.fixed_spawns = STALINGRAD_FIXED_SPAWNS;
			break;
		case "zm_castle":
			if (GetPlayers().size == 1)	level.fixed_spawns = SOLO_CASTLE_FIXED_SPAWNS;
			else level.fixed_spawns = DUO_CASTLE_FIXED_SPAWNS;
			break;
	}

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
	s_ret.ref_point = entry[REF_POINT_INDEX];
	s_ret.zone = get_zone_from_ref_point(s_ret.ref_point);
	s_ret.n_zombie_total = entry[NUM_Z_INDEX];
	s_ret.n_zombies = 0;
	s_ret.n_rnd = entry[N_RND_INDEX];

	s_ret.condition_func = array();

	for (i = 0; i < entry[FUNC_INDEX].size; i++)
	{
		func_data = entry[FUNC_INDEX][i];
		array::add(s_ret.condition_func, SpawnStruct());
		s_ret.condition_func[i].func = func_data[0];
		s_ret.condition_func[i].arg = func_data[1];
	}

	return s_ret;
}

function can_do_fixed_spawn(a_points,arg_zone,ref_point)
{	
	if (!isdefined(arg_zone)) return 1;
	if (IsFunctionPtr(arg_zone)) zone = [[arg_zone]](ref_point);
	else zone = arg_zone;
	zone_spawners = zone + "_spawners";
	b_ret = 0;
	id = 0;
	for (i = 0; i < a_points.size; i++)
	{
		if (a_points[i].targetname == zone_spawners)
		{
			id = i;
			b_ret = 1;
			break;
		}
	}
	return b_ret;
}

function get_spawn_loc(a_points,ref_point)
{
	return ArrayGetClosest(ref_point,a_points);
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

function get_zone_from_vector_function(vector_function)
{
	vec = [[vector_function]]();
	return get_zone_from_ref_point(vec);
}

function fixed_zombie_speed()
{
	while(1)
	{
		enemies = GetAISpeciesArray(level.zombie_team, "all");
		last = 0;

		foreach(enemy in enemies)
		{
			if (!(enemy.ignore_enemy_count) && enemy.archetype == "zombie")
			{
				if(level.zombie_move_speed > 1 && isdefined(enemy.zombie_move_speed_override) && zombie_utility::get_current_zombie_count() + level.zombie_total <= 3)
				{
					switch(GetDvarString("mapname"))
					{
						case "zm_zod":
							while(!zombie_utility::get_current_zombie_count() + level.zombie_total <= 1) wait 0.1;
							if(IsAlive(enemy))
							{
								enemy zombie_utility::set_zombie_run_cycle_restore_from_override();
								enemy zombie_utility::set_zombie_run_cycle("sprint");
							}
						case "zm_castle":
						case "zm_stalingrad":
							if(level.round_number > 3)
							{
								if(IsAlive(enemy))
								{
									enemy zombie_utility::set_zombie_run_cycle_restore_from_override();
									enemy zombie_utility::set_zombie_run_cycle("run");
									enemy thread monitor_single_zombie_speed();
									last = 1;
								}
							}
					}
				}
				else if (!isdefined(enemy.zombie_move_speed_override) && enemy.zombie_move_speed != "super_sprint")
				{
					if (level.zombie_move_speed > 1) if(IsAlive(enemy)) enemy zombie_utility::set_zombie_run_cycle_override_value("run");
					if (level.zombie_move_speed > 36) if(IsAlive(enemy)) enemy zombie_utility::set_zombie_run_cycle_override_value("sprint");
				}
			}
		}

		if(last) level waittill("between_round_over");

		wait 0.05;
	}
}

function monitor_single_zombie_speed()
{
	while(!zombie_utility::get_current_zombie_count() + level.zombie_total <= 1) wait 0.1;
	if(IsAlive(self)) self zombie_utility::set_zombie_run_cycle("sprint");
	return;
}