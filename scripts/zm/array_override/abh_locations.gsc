#using scripts\codescripts\struct;
#using scripts\shared\array_shared;
#using scripts\shared\flag_shared;
#using scripts\zm\array_override\bgb_common;
#using scripts\zm\_zm_zonemgr;
#using scripts\zm\array_override\array_override_common;

#insert scripts\zm\array_override\array_override_common.gsh;

#namespace abh_locations;

#define LOBBY_INDEX bgb_common::get_lobby_index()

// Possible ABH locations by zone on SOE
/* 
"zone_start" 			- starting area
"zone_theater_B" 		- theater outside train
"zone_theater_high_A"	- theater by perk machine
"zone_theater_junction" - theater district entrance
"zone_slums_D" 			- slums down by the HVK
"zone_slums_high_B" 	- slums by perk machine/egg statue
"zone_slums_junction"	- slums district entrance
"zone_canal_D"			- canal by train outside ruby rabbit
"zone_canal_high_A"		- canal by perk machine
"zone_canal_junction"	- canal district entrance
"zone_subway_central"	- underground by the sword locker
"zone_subway_pap_ritual"- pap room by ritual table
*/

#define ZOD_P0_ABH_ZONES_C array("zone_slums_junction","zone_subway_central","zone_start","zone_theater_high_A","zone_slums_D","zone_start","zone_theater_high_A","zone_subway_central")
#define ZOD_P0_ABH_ZONES_M array("zone_slums_junction","zone_subway_central","zone_start","zone_theater_high_A","zone_slums_D","zone_start","zone_theater_high_A","zone_subway_central")

#define ZOD_P1_ABH_ZONES_C array()
#define ZOD_P1_ABH_ZONES_M array()

#define ZOD_P2_ABH_ZONES_C array()
#define ZOD_P2_ABH_ZONES_M array()

#define ZOD_P3_ABH_ZONES_C array()
#define ZOD_P3_ABH_ZONES_M array()

#define ZOD_ABH_ZONES_C array(ZOD_P0_ABH_ZONES_C,ZOD_P1_ABH_ZONES_C,ZOD_P2_ABH_ZONES_C,ZOD_P3_ABH_ZONES_C)
#define ZOD_ABH_ZONES_M array(ZOD_P0_ABH_ZONES_M,ZOD_P1_ABH_ZONES_M,ZOD_P2_ABH_ZONES_M,ZOD_P3_ABH_ZONES_M)

// Possible ABH locations by zone on DE
/*
"zone_start"					- starting area
"zone_tram_to_gatehouse"		- outside spawn behind gatehouse
"zone_lower_gatehouse"			- gatehouse next to doubletap
"zone_lower_courtyard"			- lower courtyard in front of gatehouse
"zone_lower_courtyard_upper"	- lower courtyard on the bridge
"zone_gatehouse"				- top gatehouse by wundersphere
"zone_rooftop"					- next to pap by death ray
"zone_clocktower"				- in the clocktower
"zone_courtyard_edge"			- next to gumball machine outside clocktower
"zone_great_hall_upper_left"	- great hall staircase behind speedcola
"zone_great_hall_upper"			- great hall door leading to power
"zone_courtyard"				- staircase leading to great hall
"zone_tram_to_subclocktower"	- path leading from mulekick to courtyard
"zone_undercroft_pap_hall"		- undercroft door leading to lower corutyard
"zone_undercroft"				- in front of undercroft dragon
"zone_v10_pad"					- next to teleporter at rocket test
"zone_v10_pad_door"				- outside rocket test
*/

#define CASTLE_P0_ABH_ZONES_C array("zone_rooftop","zone_undercroft","zone_gatehouse","zone_undercroft","zone_rooftop","zone_clocktower")
#define CASTLE_P0_ABH_ZONES_M array("zone_rooftop","zone_undercroft","zone_gatehouse","zone_undercroft","zone_rooftop","zone_clocktower")

#define CASTLE_P1_ABH_ZONES_C array("zone_v10_pad","zone_tram_to_subclocktower","zone_tram_to_subclocktower")
#define CASTLE_P1_ABH_ZONES_M array("zone_v10_pad","zone_tram_to_subclocktower","zone_tram_to_subclocktower")

#define CASTLE_P2_ABH_ZONES_C array()
#define CASTLE_P2_ABH_ZONES_M array()

#define CASTLE_P3_ABH_ZONES_C array()
#define CASTLE_P3_ABH_ZONES_M array()

#define CASTLE_ABH_ZONES_C array(CASTLE_P0_ABH_ZONES_C,CASTLE_P1_ABH_ZONES_C,CASTLE_P2_ABH_ZONES_C,CASTLE_P3_ABH_ZONES_C)
#define CASTLE_ABH_ZONES_M array(CASTLE_P0_ABH_ZONES_M,CASTLE_P1_ABH_ZONES_M,CASTLE_P2_ABH_ZONES_M,CASTLE_P3_ABH_ZONES_M)

// Possible ABH locations by zone on GK
/*
"start_A_zone"						- first half of starting area
"department_store_floor2_A_zone"	- second floor of department store by the stairs leading up
"bunker_zone"						- bunker by shield craftable
"judicial_A_zone"					- dragon commmand by sophia
"factory_C_zone"					- tank factory by double tap
"library_B_zone"					- supply by the gumball machine
"pavlovs_B_zone"					- hatchery by pap
*/

#define STALINGRAD_P0_ABH_ZONES_C array("library_B_zone", "bunker_zone", "pavlovs_B_zone", "start_A_zone", "judicial_A_zone", "department_store_floor2_A_zone", "factory_C_zone", "start_A_zone", "pavlovs_B_zone","judicial_A_zone","start_A_zone")
#define STALINGRAD_P0_ABH_ZONES_M array("library_B_zone", "bunker_zone", "pavlovs_B_zone", "start_A_zone", "judicial_A_zone", "department_store_floor2_A_zone", "factory_C_zone", "start_A_zone", "pavlovs_B_zone","judicial_A_zone","start_A_zone")

#define STALINGRAD_P1_ABH_ZONES_C array()
#define STALINGRAD_P1_ABH_ZONES_M array()

#define STALINGRAD_P2_ABH_ZONES_C array()
#define STALINGRAD_P2_ABH_ZONES_M array()

#define STALINGRAD_P3_ABH_ZONES_C array()
#define STALINGRAD_P3_ABH_ZONES_M array()

#define STALINGRAD_ABH_ZONES_C array(STALINGRAD_P0_ABH_ZONES_C,STALINGRAD_P1_ABH_ZONES_C,STALINGRAD_P3_ABH_ZONES_C,STALINGRAD_P3_ABH_ZONES_C)
#define STALINGRAD_ABH_ZONES_M array(STALINGRAD_P0_ABH_ZONES_M,STALINGRAD_P1_ABH_ZONES_M,STALINGRAD_P2_ABH_ZONES_M,STALINGRAD_P3_ABH_ZONES_M)

#define SYSTEM_NAME "abh_locations"
function init()
{
	REGISTER_OVERRIDE(SYSTEM_NAME,ARRAY_RANDOM,&random_override);
	thread main();
}

function random_override(array)
{
	if (level flag::get("initial_blackscreen_passed") && !level.abh_done)
	{
		if (array[0].targetname == "player_respawn_point")
		{
			if(self IsSwitchingWeapons()) self waittill("weapon_change_complete", weapon);

			pl = ArraySort(level.activeplayers, self.origin, 1)[0];

			id = pl bgb_common::get_lobby_index();
			
			/*foreach(abh in level.desired_zones[id])
			{
				IPrintLnBold(abh);
			}*/
			
			// for each respawn point, check if it is in the zone that we want to teleport to.
			foreach (sp in array)
			{
				//level.abh_zone_function gets the zone name from the given coordinates
				zone = zm_zonemgr::get_zone_from_position(sp.origin + VectorScale((0, 0, 1), 32), 0);

				// if this is the next zone in our predetermined locations list, return this respawn point so the player tps there
				if (zone == level.desired_zones[id][level.abh_index[id]])
				{
					//notify the custom abh_locations script that abh has been used
					level notify("next_abh_zone_reached",id);
					return sp;
				}
			}
		}
	}
}

function main()
{
	//monitor the bgb cycle to see if Megas are being used, if so it will set predetermined locations array to be the Megas one
	abh_zones_lists();
	thread abh_locations_using_megas();

	//since the array script doesn't include zm_zonemgr script, store the function (ptr) from the script that is needed in a level var
	//level.abh_zone_function = &zm_zonemgr::get_zone_from_position;

	//flag to set when we've teleported to all the desired abh locations
	level.abh_done = false;

	//set the locations array for the correct map in the level var
	level.desired_zones = level.abh_zones_c;

	level.abh_index = array(0,0,0,0);

	level flag::wait_till("bgb_megas_done");

	while (1)
	{
		//get the next desired abh location (used in the array_shared script)
		level.next_abh = level.desired_zones[level.abh_index];

		//the array_shared script will notify the level when the player has used ABH
		level waittill("next_abh_zone_reached",id);
		wait 2;

		level.abh_index[id]++;
		if (level.abh_index >= level.desired_zones.size) break;
	}

	level.abh_done = true;

	UNREGISTER_OVERRIDE(SYSTEM_NAME,ARRAY_RANDOM);
}

function abh_players_think()
{
	level flag::wait_till("initial_players_connected");
	foreach (p in GetPlayers())	p thread monitor_abh();
}

function monitor_abh()
{
	self.abh_index = 0;
	self thread monitor_role();
	while(1)
	{
		self.next_abh = level.desired_zones[self.role][self.abh_index];
		self waittill("next_abh_zone_reached",b_increment);
		if (b_increment)
		{
			wait 2;
			self.abh_index++;
		}
	}
}

function monitor_role()
{
	self.role = 0;

}

function abh_zones_lists()
{
	level.abh_zones_m = undefined;
	level.abh_zones_c = undefined;
	switch (GetDvarString("mapname"))
	{
		case "zm_zod":
			level.abh_zones_c = ZOD_ABH_ZONES_C;
			level.abh_zones_m = ZOD_ABH_ZONES_M;
			break;
		case "zm_factory":
			break;
		case "zm_castle":
			level.abh_zones_c = CASTLE_ABH_ZONES_C;
			level.abh_zones_m = CASTLE_ABH_ZONES_M;
			break;
		case "zm_stalingrad":
			level.abh_zones_c = STALINGRAD_ABH_ZONES_C;
			level.abh_zones_m = STALINGRAD_ABH_ZONES_M;
			break;
			/*
		case "zm_island":
			level.abh_zones_c = ISLAND_ABH_ZONES_C;
			level.abh_zones_m = ISLAND_ABH_ZONES_M;
			break;
		case "zm_genesis":
			level.abh_zones_c = GENESIS_ABH_ZONES_C;
			level.abh_zones_m = GENESIS_ABH_ZONES_M;
			break;
		case "zm_tomb":
			level.abh_zones_c = TOMB_ABH_ZONES_C;
			level.abh_zones_m = TOMB_ABH_ZONES_M;
			break;*/
	}
}

function abh_locations_using_megas()
{
	level flag::wait_till("bgb_megas_done");

	if (level flag::get("using_megas"))
	{
		level.desired_zones = level.abh_zones_m;
	}
}