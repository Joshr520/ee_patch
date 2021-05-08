#using scripts\shared\flag_shared;
#using scripts\zm\array_override\array_override_common;
#insert scripts\zm\array_override\array_override_common.gsh;

#namespace modules;

#define SYSTEM_NAME "stalingrad_modules"

function init()
{
	if (GetDvarString("mapname") == "zm_stalingrad")
	{
		REGISTER_OVERRIDE(SYSTEM_NAME,ARRAY_RANDOM,&random_override);
		thread main();
	}
}

function random_override(array)
{
	if (level flag::get("power_on") && array[0].targetname == "drop_pod" && !level.fixed_modules_done)
	{
		foreach(index, loc in array)
		{
			if (level.drop_pod_count == 0) 
			{
				if (IsSubStr(array[index].script_string, "yellow"))
				{
					level.drop_pod_count++;
					return array[index];
				}
			}
			if (level.drop_pod_count == 1) 
			{
				if (IsSubStr(array[index].script_string, "red"))
				{
					level.drop_pod_count++;
					return array[index];
				}
			}
			if (level.drop_pod_count == 2)
			{
				if (IsSubStr(array[index].script_string, "alley"))
				{
					level notify("modules_done");
					return array[index];
				}
			}
		}
	}
}

function main()
{
	level.drop_pod_count = 0;
	level.fixed_modules_done = 0;

	level waittill("modules_done");

	level.fixed_modules_done = 1;
	UNREGISTER_OVERRIDE(SYSTEM_NAME,ARRAY_RANDOM);
}