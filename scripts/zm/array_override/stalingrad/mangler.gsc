#using scripts\shared\flag_shared;
#using scripts\codescripts\struct;
#using scripts\zm\array_override\array_override_common;
#insert scripts\zm\array_override\array_override_common.gsh;

#namespace mangler;

#define SYSTEM_NAME "stalingrad_mangler"

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
	if (IsInArray(struct::get_array("raz_location", "script_noteworthy"), array[0]) && level flag::get("keys_placed"))
	{
		foreach(index, spawn in array)
		{
			if (isdefined(spawn.targetname) && spawn.targetname == "library_B_spawn")
			{
				level notify("mangler_done");
				return array[index];
			}
		}
	}
}

function main()
{
	level waittill("mangler_done");
	UNREGISTER_OVERRIDE(SYSTEM_NAME,ARRAY_RANDOM);
}