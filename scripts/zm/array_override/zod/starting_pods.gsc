
#using scripts\shared\array_shared;

#using scripts\zm\array_override\array_override_common;
#insert scripts\zm\array_override\array_override_common.gsh;

#namespace zod_starting_pods;

#define SYSTEM_NAME "starting_pods"

// specifying which zones to spawn pods in is precise enough
#define DESIRED_ZONES array("zone_start")

function private randomize_override(array)
{
	IF_TARGETNAME_MATCH("fungus_pod",array[0])
	{
		a_desired_zones = DESIRED_ZONES;
		i = 0;
		foreach (index,pod in array)
		{
			if (IsInArray(a_desired_zones,pod.zone))
			{
				i++;
				array::swap( array, index , array.size - i );
			}
		}
		level notify("fixed_pods");
		return array;
	}
}

function main()
{
	CALL_ONCE_FLAG(init_fixed_starting_pods)
	REGISTER_OVERRIDE_EX_NOTIF(SYSTEM_NAME,ARRAY_RANDOMIZE,&randomize_override);
	level waittill("fixed_pods");
	UNREGISTER_OVERRIDE_EX_NOTIF(SYSTEM_NAME,ARRAY_RANDOMIZE);
}