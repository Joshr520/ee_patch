#using scripts\shared\flag_shared;
#using scripts\codescripts\struct;
#using scripts\zm\array_override\array_override_common;
#insert scripts\zm\array_override\array_override_common.gsh;

#namespace gersch;

#define SYSTEM_NAME "stalingrad_gersch"

function init()
{
	if (GetDvarString("mapname") == "zm_stalingrad")
	{
		REGISTER_OVERRIDE(SYSTEM_NAME,ARRAY_RANDOMIZE,&randomize_override);
		thread main();
	}
}

function randomize_override(array)
{
	if (IsInArray(struct::get_array("ee_pursue_position", "targetname"), array[0]))
	{
		a_temp = array[0];
		array[0] = array[3];
		array[3] = a_temp;
		return array;
	}
}

function main()
{
	level waittill("gersch_done");
	UNREGISTER_OVERRIDE(SYSTEM_NAME,ARRAY_RANDOMIZE);
}