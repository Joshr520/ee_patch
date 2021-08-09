//defining each predetermined drop for the game: 
// [0] drop name, 
// [1] round number to drop it on, 
// [2] if true, the game will drop it after the desired round if it hasn't yet,
// [3] array of condition pairs, each condition pair is a function pointer and an array of arguments to pass into it (see _conditions.gsh)
#define ZOD_FORCED_DROP_0 array("nuke",1,false)
#define ZOD_FORCED_DROP_1 array("double_points",3,true,array(DROP_INSIDE("zone_subway_central")))
#define ZOD_FORCED_DROP_2 array("full_ammo",3,true)
#define ZOD_FORCED_DROP_3 array("insta_kill",4,true)
#define ZOD_FORCED_DROP_4 array("double_points",4,true)
#define ZOD_FORCED_DROP_5 array("full_ammo",4,true)
#define ZOD_FORCED_DROP_6 array("nuke",4,true,array(DROP_INSIDE("zone_theater_burlesque")))
#define ZOD_FORCED_DROP_7 array("double_points",5,true,array(DROP_INSIDE("zone_slums_high_B")))

#define TOMB_FORCED_DROP_0 array("nuke",1,true,array(NUM_ZOMBIES_LEFT(1)))
#define TOMB_FORCED_DROP_1 array("insta_kill",3,true,array(DROP_INSIDE("zone_bunker_3a")))
#define TOMB_FORCED_DROP_2 array("double_points",3,true)
#define TOMB_FORCED_DROP_3 array("zombie_blood",3,true)
#define TOMB_FORCED_DROP_4 array("full_ammo",3,true)
#define TOMB_FORCED_DROP_5 array("nuke",4,true,array(NUM_STAFF_PARTS("elemental_staff_air",2)))
#define TOMB_FORCED_DROP_6 array("double_points",5,true)
//#define TOMB_FORCED_DROP_7 array("nuke",9,false,array(NUM_ZOMBIES_LEFT(1)))

// the complete list of all predetermined drops for the _zm_powerups script to use
#define ZOD array(ZOD_FORCED_DROP_0,ZOD_FORCED_DROP_1,ZOD_FORCED_DROP_2,ZOD_FORCED_DROP_3,ZOD_FORCED_DROP_4,ZOD_FORCED_DROP_5,ZOD_FORCED_DROP_6,ZOD_FORCED_DROP_7)
#define FACTORY array()
#define CASTLE array()
#define ISLAND array()
#define STALINGRAD array()
#define GENESIS array()
#define PROTOTYPE array()
#define ASYLUM array()
#define SUMPF array()
#define THEATER array()
#define COSMODROME array()
#define TEMPLE array()
#define MOON array()
#define TOMB array(TOMB_FORCED_DROP_0,TOMB_FORCED_DROP_1,TOMB_FORCED_DROP_2,TOMB_FORCED_DROP_3,TOMB_FORCED_DROP_4,TOMB_FORCED_DROP_5,TOMB_FORCED_DROP_6)

// index definitions for this script to use
#define DROP_NAME_INDEX 0
#define DROP_ROUND_INDEX 1
#define DROP_B_WAIT_INDEX 2
#define DROP_FUNC_INDEX 3
#define DROP_FUNC_ARG_INDEX 4