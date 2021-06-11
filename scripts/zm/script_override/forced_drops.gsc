#using scripts\shared\array_shared;
#using scripts\zm\_zm_zonemgr;

#namespace forced_drops;

#define DROP_DEFAULT_FUNC &drop_default

#define DROP_IN_ZONE_FUNC &drop_powerup_in_zone
#define DROP_IN_ZONE(zone,inside) array(zone,inside)
#define DROP_INSIDE(zone) DROP_IN_ZONE(zone,true)
#define DROP_OUTSIDE(zone) DROP_IN_ZONE(zone,false)

//defining each predetermined drop for the game: 
// [0] drop name, 
// [1] round number to drop it on, 
// [2] if true, the game will drop it after the desired round if it hasn't yet,
// [3] the function (ptr) to call when all other conditions are true to further specify a situation where the drop should spawn
// [4] the array of arguments to pass into the above function
// the most useful function in [3] will be drop_powerup_in_zone(), exactly what it sounds like, but also with the option of
// inclusivity or exclusivity (i.e. only in a specified zone or anywhere except that zone)
#define ZOD_FORCED_DROP_0 array("insta_kill",1,true)
#define ZOD_FORCED_DROP_1 array("double_points",3,true,DROP_IN_ZONE_FUNC,DROP_INSIDE("zone_subway_central"))
#define ZOD_FORCED_DROP_3 array("nuke",4,true)
#define ZOD_FORCED_DROP_2 array("full_ammo",5,true)

#define CASTLE_FORCED_DROP_0 array("insta_kill",2,true)
#define CASTLE_FORCED_DROP_1 array("double_points",3,true)

// the complete list of all predetermined drops for the _zm_powerups script to use
#define ZOD_FORCED_DROPS array(ZOD_FORCED_DROP_0,ZOD_FORCED_DROP_1,ZOD_FORCED_DROP_2,ZOD_FORCED_DROP_3)
#define CASTLE_FORCED_DROPS array(CASTLE_FORCED_DROP_0,CASTLE_FORCED_DROP_1)

// index definitions for this script to use
#define DROP_NAME_INDEX 0
#define DROP_ROUND_INDEX 1
#define DROP_B_WAIT_INDEX 2
#define DROP_FUNC_INDEX 3
#define DROP_FUNC_ARG_INDEX 4

function init()
{
	//define and populate the level array var for _zm_powerups to use
	forced_drops_list();

	//define and populate a corresponding array of the condition functions for each drop (default function if unspecified, meaning no further conditions)
	level.forced_drop_functions = array();
	for (i = 0; i < level.forced_drops.size; i++)
	{
		level.forced_drop_functions[i] = SpawnStruct();
		level.forced_drop_functions[i].func = ( isdefined(level.forced_drops[i][DROP_FUNC_INDEX]) ? level.forced_drops[i][DROP_FUNC_INDEX] : DROP_DEFAULT_FUNC);
		level.forced_drop_functions[i].arg = (isdefined(level.forced_drops[i][DROP_FUNC_ARG_INDEX]) ? level.forced_drops[i][DROP_FUNC_ARG_INDEX] : array());
	}
}

function forced_drops_list()
{
 	switch (GetDvarString("mapname"))
 	{
 		case "zm_zod":
 			level.forced_drops = ZOD_FORCED_DROPS;
 			break;
 		case "zm_castle":
 			level.forced_drops = CASTLE_FORCED_DROPS;
 			break;
 	}
}

/*
FUNCTIONS
*/

/*

	drop_powerup_in_zone()

	a_zone: ARRAY - an array of 1-3 elements, 1st being the zone(s)* in question, 2nd being inclusivity boolean, 3rd being the lobby index of the player to check

	*multiple zones can be passed in as an array instead of just 1, allowing for flexibility

	only the zone is required to be passed in, the rest of the arguments are optional

*/

function drop_powerup_in_zone(a_zone)
{
	//defaulting the variables
	if (!IsArray(a_zone)) a_zone = array(a_zone);
	str_zone = (isdefined(a_zone[0]) ? a_zone[0] : "zone_start");
	b_drop_in_zone = (isdefined(a_zone[1]) ? a_zone[1] : true);
	p_id = (isdefined(a_zone[2]) ? a_zone[2] : 0);
	player = GetPlayers()[p_id];

	//compare player's zone and the passed-in zone to check for a match
	zone = player zm_zonemgr::get_player_zone();
	if (!IsArray(str_zone)) str_zone = array(str_zone);
	b_ret = false;
	foreach (z in str_zone)
	{
		if ( (zone != z && !b_drop_in_zone) || (zone == z && b_drop_in_zone) )
		{
			b_ret = true;
			break;
		}
	}
	return b_ret;
}


function drop_default(a_arg)
{
	return true;
}