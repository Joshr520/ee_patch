#using scripts\shared\flag_shared;
#using scripts\zm\array_override\array_override_common;

#insert scripts\zm\array_override\array_override_common.gsh;

#namespace initial_spawn_points;

#define SYSTEM_NAME "initial_spawn_points"
function init()
{
	REGISTER_OVERRIDE(SYSTEM_NAME,ARRAY_RANDOMIZE,&randomize_override);
	thread main();
}

function randomize_override(array)
{
	if(!level flag::get("initial_blackscreen_passed"))
	{
		if(isdefined(level.fixed_player_spawn_points))
		{
			if(array[0].targetname == "initial_spawn_points")
			{
				a_ret = array();
				for (i = 0; i < array.size; i++)
				{
					index = level.fixed_player_spawn_points[i];
					if (!isdefined(index)) index = i;
					a_ret[i] = array[index];
				}
				return a_ret;
			}
		}
	}
}

function main()
{
	level.fixed_player_spawn_points = spawn_points_for_map();
	level flag::wait_till("initial_blackscreen_passed");
	UNREGISTER_OVERRIDE(SYSTEM_NAME,ARRAY_RANDOMIZE);
}

#define ZOD array(0,1,2,3)

#define FACTORY array(0,2,1,3)

#define CASTLE array(0,1,2,3)

#define ISLAND array(3,2,1,0)

#define STALINGRAD array(0,3,1,2)

#define GENESIS array(6,2,1,7,0,3,4,5)

#define PROTOTYPE array(2,3,0,1)

#define SUMPF array(3,0,1,2)

#define THEATER array(3,2,1,0)

#define TEMPLE array(0,3,1,2)

#define MOON array(3,1,2,0)

#define TOMB array(1,0,2,3)


function spawn_points_for_map()
{
	switch (GetDvarString("mapname"))
	{
		case "zm_zod":
			return ZOD;
		case "zm_factory":
			return FACTORY;
		case "zm_castle":
			return CASTLE;
		case "zm_island":
			return ISLAND;
		case "zm_stalingrad":
			return STALINGRAD;
		case "zm_genesis":
			return GENESIS;
		case "zm_prototype":
			return PROTOTYPE;
		case "zm_asylum":
			return undefined;
		case "zm_sumpf":
			return SUMPF;
		case "zm_theater":
			return THEATER;
		case "zm_cosmodrome":
			return undefined;
		case "zm_temple":
			return TEMPLE;
		case "zm_moon":
			return MOON;
		case "zm_tomb":
			return TOMB;
	}
}


/*
ZOD facing starting gate
0 - frnt right
1 - frnt left
2 - back left
3 - back right

DER facing away from pap
0 - frnt left
1 - back left
2 - frnt right
3 - back right

CAST facing toward the city below
0 - back right
1 - back left
2 - frnt right
3 - frnt left

ISLA facing skull pedastal
0 - far left
1 - mid left
2 - mid right
3 - far right

STAL facing quick revive
0 - far right
1 - mid left
2 - far left
3 - mid right

GENE - facing away from QR
0 - frnt right 1
1 - frnt right 2
2 - frnt left 2
3 - back left 1
4 - frnt right 0
5 - far right
6 - far left

NACHT - facing towards front of map
0 - frnt right
1 - back right
2 - frnt left
3 - back left

ASYLUM - 
0 - qr 0
1 - qr 1
2 - jug 0
3 - jug 1
4 - qr 2
5 - qr next to bgb
6 - jug
7 - jug closest to bgb

SUMPF - 
0 - 
1 - 
2 - 
3 - closest to bgb

TOMB - 
0 - shovel
1 - maxis
2 - back
3 - left


*/