#using scripts\zm\array_override\array_override_common;
#insert scripts\zm\array_override\array_override_common.gsh;

#namespace ee_tube_puzzle;

#define SYSTEM_NAME "stalingrad_tube"

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
	if (IsInArray(GetEntArray("ee_tube_terminal", "targetname"),array[0]))
	{
		foreach(index, tube in array)
		{
			if (tube.script_label == "command")
			{
				a_temp = array[5];
				array[5] = array[index];
				array[index] = a_temp;
			}
			if (tube.script_label == "store")
			{
				a_temp = array[0];
				array[0] = array[index];
				array[index] = a_temp;
			}
		}
		level notify("tube_done");
		return array;
	}
}

function main()
{
	level waittill("tube_done");
	UNREGISTER_OVERRIDE(SYSTEM_NAME,ARRAY_RANDOMIZE);
}