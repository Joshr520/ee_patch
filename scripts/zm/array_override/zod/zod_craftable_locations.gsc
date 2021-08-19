
#using scripts\shared\array_shared;

#using scripts\zm\array_override\array_override_common;
#insert scripts\zm\array_override\array_override_common.gsh;

#namespace zod_craftable_locations;

#define SYSTEM_NAME "zod_parts"

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


function private randomize_override(array)
{
	IF_TARGETNAME_MATCH("pod_sprayer_location",array[0])
	{
		a_sprayers = SPRAYERS;
		for (i = 0; i < a_sprayers.size; i++)
		{
			array::swap(array,i, a_sprayers[i]);
		}
		level notify("fixed_pod_sprayers");
		return array;
	}
}

function main()
{
	CALL_ONCE_FLAG(init_fixed_pod_sprayers)
	REGISTER_OVERRIDE_EX_NOTIF(SYSTEM_NAME,ARRAY_RANDOMIZE,&randomize_override);
	level waittill("fixed_pod_sprayers");
	UNREGISTER_OVERRIDE_EX_NOTIF(SYSTEM_NAME,ARRAY_RANDOMIZE);
}