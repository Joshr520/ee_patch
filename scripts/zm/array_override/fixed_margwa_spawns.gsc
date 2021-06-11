
#using scripts\shared\flag_shared;


#using scripts\zm\_zm_zonemgr;


#using scripts\zm\array_override\array_override_common;
#insert scripts\zm\array_override\array_override_common.gsh;

#namespace fixed_margwa_spawns;

#define MAPS_APPLIED array("zm_zod")

#define SYSTEM_NAME "fixed_margwa_spawns"
function init()
{
	if (IsInArray(MAPS_APPLIED,GetDvarString("mapname")))
	{
		REGISTER_OVERRIDE(SYSTEM_NAME,ARRAY_RANDOM,&random_override);
		thread main();
	}
}

function random_override(array)
{
	if (IsInArray(level.zm_loc_types["margwa_location"],array[0]))
	{
		//get the zone that the host player is in
		p_zone = zm_zonemgr::get_zone_from_position(GetPlayers()[0].origin + VectorScale((0, 0, 1), 32), 0);
		r_loc = undefined;

		// find the spawn point in the passed-in array that is in the same zone as the player
		for (i = 0; i < array.size; i++)
		{
			zone = zm_zonemgr::get_zone_from_position(array[i].origin + VectorScale((0, 0, 1), 32), 0);
			if (zone == p_zone)
			{
				r_loc = array[i];
				break;
			}
		}
		
		// if possible, spawn the margwa in the same zone as the host player
		return r_loc;
	}
	else if (array[0].targetname == "sword_quest_margwa_spawnpoint")
	{
		desired_spawn_index = level.fixed_margwa_circle_spawns[array[0].script_int][level.fixed_margwa_circle_spawn_index];
		level.fixed_margwa_circle_spawn_index = !level.fixed_margwa_circle_spawn_index;
		return array[desired_spawn_index];
	}
}

// INDICATE THE DESIRED SPOTS BY THEIR FILTERED INDEX (filtered by script_int)
// PUT 2 INDICES FOR ALL 4, PUT THE MOST DESIRED ONE SECOND FOR THE SINGLE MARGWA RITUAL
/*
junction circle margwa spots (filtered index - absolute index - location description)
0 - 0 - bgb machine
1 - 6 - civil protector box
2 - 7 - canal side before boardable entry
3 - 8 - canal side next to auto pistol wallbuy
4 - 9 - between civil protector box and bgb machine
*/

#define JUNCTION_MARGWAS array(0,4)

/*
canal circle margwa spots
0 - 1 - beast basin
1 - 2 - stairs
2 - 3 - crafting table
3 - 4 - magic box
4 - 5 - between box and table
*/

#define CANAL_MARGWAS array(3,2)

/*
theater circle margwa spots
0 - 10 - straigt across from burlesque entrance at the boardless entry
1 - 11 - the one outisde playable area
2 - 12 - to the right of the burlesque entrance facing toward the entrance
3 - 13 - far back on the right path facing away from the burlesque entrance
4 - 14 - on the left path facing away from burlesque entrance
*/

#define THEATER_MARGWAS array(1,0)

/*
slums circle margwa spots
0 - 15 - trip mines side
1 - 16 - tripe mines side right next to 0/15
2 - 17 - opposite side of 15 and 16 in the corner
3 - 18 - opposite side of 15 and 16 at the turning corner of the gym
4 - 19 - inside gym
*/

#define SLUMS_MARGWAS array(1,0)

function main()
{
	//array must be ordered by script_int
	level.fixed_margwa_circle_spawns = array(SLUMS_MARGWAS,CANAL_MARGWAS,THEATER_MARGWAS,JUNCTION_MARGWAS);
	level.fixed_margwa_circle_spawn_index = 1;

	//UNREGISTER_OVERRIDE(SYSTEM_NAME,ARRAY_RANDOM);
}