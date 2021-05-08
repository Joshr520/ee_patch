#using scripts\codescripts\struct;
#using scripts\shared\array_shared;
#using scripts\shared\flag_shared;
#using scripts\zm\array_override\array_override_common;

#insert scripts\zm\array_override\array_override_common.gsh;

#namespace zod_craftable_locations;

#define SYSTEM_NAME "zod_parts"
function init()
{
	if (GetDvarString("mapname") == "zm_zod")
	{
		REGISTER_OVERRIDE(SYSTEM_NAME,ARRAY_RANDOMIZE,&randomize_override);
		thread main();
	}
}

//pod sprayer indexes
#define SPAWN_BEAST 0
#define SPAWN_TRUCK 1
#define SPAWN_STAIRS 8
#define JUNCTION_CRANE 2
#define JUNCTION_CHAIR 3
#define JUNCTION_BOX 4
#define CANAL_ENTRANCE 5
#define CANAL_BEAST 7
#define CANAL_BGB 9
#define SLUMS_BGB 6
#define SLUMS_STAIRS 10
#define SLUMS_TRAP 11

#define SPAWN_SPRAYER SPAWN_BEAST
#define JUNCTION_SPRAYER JUNCTION_CRANE
#define CANAL_SPRAYER CANAL_ENTRANCE
#define SLUMS_SPRAYER SLUMS_BGB

#define SPRAYERS array(SPAWN_SPRAYER,JUNCTION_SPRAYER,CANAL_SPRAYER,SLUMS_SPRAYER)


function randomize_override(array)
{
	if (array[0].targetname == "pod_sprayer_location")
	{
		a_ret = array;
		sprayers = SPRAYERS;
		for (i = 0; i < sprayers.size; i++)
		{
			index = sprayers[i];
			int = array[index].script_int;
			for (j = 0; j < int; j++)
			{
				if (array[j].script_int == int)
				{
					array::swap(array,j,index);
					break;
				}
			}
		}
		level notify("fixed_pod_sprayers");
		return array;
	}
}

function main()
{
	level waittill("fixed_pod_sprayers");

	wait .05;

	UNREGISTER_OVERRIDE(SYSTEM_NAME,ARRAY_RANDOMIZE);
}