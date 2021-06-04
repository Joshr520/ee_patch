#using scripts\shared\flag_shared;
#using scripts\codescripts\struct;
#using scripts\zm\array_override\array_override_common;

#insert scripts\zm\array_override\array_override_common.gsh;

#namespace boss_mechz_spawn_point;

#define SYSTEM_NAME "boss_mechz_spawn_point"
function init()
{
	if (GetDvarString("mapname") == "zm_castle")
	{
		thread main();
	}
}

function random_override(array)
{
	if (IsInArray(level.mechz_spawns, array[0]))
	{
		return array[level.spawns_index];
		level notify("next_spawn");
	}
}

function main()
{
	level flag::wait_till("boss_fight_begin");

	REGISTER_OVERRIDE(SYSTEM_NAME,ARRAY_RANDOM,&random_override);

	level.mechz_spawns = struct::get_array("boss_mech_spawn_point", "targetname");

	level.spawns_index = 0;
	while(1)
	{
		level waittill("next_spawn");
		level.spawns_index++;
		if(level.spawns_index > 13) level.spawns_index = 0;
	}
}