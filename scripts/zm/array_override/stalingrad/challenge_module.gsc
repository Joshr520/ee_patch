#using scripts\shared\flag_shared;
#using scripts\zm\array_override\array_override_common;
#insert scripts\zm\array_override\array_override_common.gsh;

#namespace challenge_module;

#define SYSTEM_NAME "stalingrad_challenge_module"

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
	if (array.size == 6 && level flag::get("keys_placed"))
	{
		foreach(index, loc in array)
		{
			if (isdefined(loc.script_string) && loc.script_string == "ee_command") 
			{
				level notify("module_done");
				return array[index];
			}
		}
	}
}

function main()
{
	level waittill("module_done");
	UNREGISTER_OVERRIDE(SYSTEM_NAME,ARRAY_RANDOM);
}