#using scripts\shared\array_shared;
#using scripts\zm\array_override\array_override_common;

#insert scripts\zm\array_override\array_override_common.gsh;

#namespace zod_starting_pods;

#define SYSTEM_NAME "starting_pods"
function init()
{
	if (GetDvarString("mapname") == "zm_zod")
	{
		REGISTER_OVERRIDE(SYSTEM_NAME,ARRAY_RANDOMIZE,&randomize_override);
		thread main();
	}
}

function randomize_override(array)
{
	if (array[0].targetname == "fungus_pod")
	{
		foreach (index,pod in array)
		{
			if (pod.zone == "zone_start")
			{
				array::swap( array, index , array.size - 1 );
				break;
			}
		}
		level notify("fixed_pods");
		return array;
	}
}

function main()
{
	level waittill("fixed_pods");

	wait .05;

	UNREGISTER_OVERRIDE(SYSTEM_NAME,ARRAY_RANDOMIZE);
}