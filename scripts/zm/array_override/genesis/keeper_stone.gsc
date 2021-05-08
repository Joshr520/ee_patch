#using scripts\codescripts\struct;
#using scripts\shared\flag_shared;
#using scripts\zm\array_override\array_override_common;

#insert scripts\zm\array_override\array_override_common.gsh;

#namespace keeper_stone;

#define PRISON 0
#define ASYLUM 1
#define TEMPLE 2

#define KEEPER_STONE PRISON

#define SYSTEM_NAME "keeper_stone"
function init()
{
	if (GetDvarString("mapname") == "zm_genesis")
	{
		REGISTER_OVERRIDE(SYSTEM_NAME,ARRAY_RANDOM,&random_override);
		thread main();
	}
}

function random_override(array)
{
	if (IsInArray(struct::get_array("audio1_start", "targetname"),array[0]))
	{
		level notify("fixed_keeper_stone");
		return array[level.fixed_stone_index];
	}
}



function main()
{
	level.fixed_keeper_stone = 0;
	level.fixed_stone_index = KEEPER_STONE;

	level waittill("fixed_keeper_stone");

	wait .05;

	level.fixed_keeper_stone = 1;

	UNREGISTER_OVERRIDE(SYSTEM_NAME,ARRAY_RANDOM);
}