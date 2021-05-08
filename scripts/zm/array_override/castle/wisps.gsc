#using scripts\shared\array_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\util_shared;
#using scripts\zm\_zm_weapons;
#using scripts\zm\_zm_zonemgr;

#using scripts\zm\array_override\array_override_common;
#insert scripts\zm\array_override\array_override_common.gsh;

#namespace castle_wisps;

//WISP INDEXES
#define HALL_CLOCK 0
#define BARRACKS 1
#define POWER 2
#define HALL_RADIO 3
#define SPAWN 4
#define GATEHOUSE 5
#define GLOBE 6
#define WHEEL 7

#define WISP_ORDER_0 array(HALL_RADIO,HALL_CLOCK,POWER,GLOBE)
#define SOLO_WISP_ORDER_1 array(POWER, HALL_RADIO, HALL_CLOCK, BARRACKS)
#define DUO_WISP_ORDER_1 array(HALL_RADIO, HALL_CLOCK, GLOBE, POWER)


#define SOLO_WISP_ORDER_LIST array(WISP_ORDER_0,SOLO_WISP_ORDER_1)
#define DUO_WISP_ORDER_LIST array(WISP_ORDER_0,DUO_WISP_ORDER_1)

#define SYSTEM_NAME "castle_wisps"
function init()
{
	if (GetDvarString("mapname") == "zm_castle")
	{
		REGISTER_OVERRIDE(SYSTEM_NAME,ARRAY_RANDOM,&random_override);
		//thread debug();
		level thread main();
	}
}

function random_override(array)
{
	if (IsInArray(GetEntArray("activate_teleporter_object", "targetname"),array[0]) && !level.castle_wisps_done)
	{
		next_wisp = level.next_wisp_vec;
		level notify("next_wisp",1);
		ret = ArrayGetClosest(next_wisp,array);
		return ret;
	}
}


function main()
{
	level.castle_wisps_done = 0;

	if(GetPlayers().size == 1) level.wisp_order_list = wisps_struct_to_vec(SOLO_WISP_ORDER_LIST);
	else level.wisp_order_list = wisps_struct_to_vec(DUO_WISP_ORDER_LIST);

	level.wisp_order_set_index = 0;
	level.fixed_wisp_index = 0;
	
	thread wisp_sets_internal();

	while(level.wisp_order_set_index < level.wisp_order_list.size)
	{
		level waittill("time_travel_teleporter_ready");
		level.fixed_wisp_index = 0;
		level flag::wait_till_clear("time_travel_teleporter_ready");
		if (zm_zonemgr::any_player_in_zone("zone_past_laboratory")) level.wisp_order_set_index++;
		level notify("next_wisp",0);
	}

	level.castle_wisps_done = 1;

	UNREGISTER_OVERRIDE(SYSTEM_NAME,ARRAY_RANDOM);
}

function wisp_sets_internal()
{
	while (!level.castle_wisps_done)
	{
		level.next_wisp_vec = level.wisp_order_list[level.wisp_order_set_index][level.fixed_wisp_index];
		level waittill("next_wisp",b_increment);
		if (b_increment) level.fixed_wisp_index++;
	}
}

function wisps_struct_to_vec(arr_list)
{
	wisps = GetEntArray("activate_teleporter_object", "targetname");
	a_ret = array();
	foreach (i,list in arr_list)
	{
		array::add(a_ret,array());
		foreach (index in list)
		{
			array::add(a_ret[i],wisps[index].origin);
		}
	}
	return a_ret;
}

function debug()
{
	level.player_starting_points = 50000;

	level flag::wait_till("initial_blackscreen_passed");

	wait 5;
	level flag::set("soul_catchers_charged");
	level flag::set("elemental_storm_wallrun");
	level flag::set("elemental_storm_batteries");
	level flag::set("elemental_storm_beacons_charged");
	level flag::set("elemental_storm_repaired");
	level flag::set("elemental_storm_placed");
	level flag::set("elemental_storm_upgraded");
	level flag::set("elemental_storm_spawned");

	pl = GetPlayers()[0];

	weap = GetWeapon("elemental_bow_storm");

	pl zm_weapons::weapon_give(weap, 0, 0, 1);

	level flag::set("ee_start_done");
}