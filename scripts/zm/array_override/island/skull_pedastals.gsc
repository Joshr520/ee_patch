#using scripts\zm\array_override\array_override_common;

#insert scripts\zm\array_override\array_override_common.gsh;

// ISLAND SKULL ORDER
/*
0 - right
1 - front
2 - back
3 - left
*/

#namespace island_skull_pedastals;

#define SYSTEM_NAME "skull_pedastals"
function init()
{
	if (GetDvarString("mapname") == "zm_island")
	{
		REGISTER_OVERRIDE(SYSTEM_NAME,ARRAY_RANDOMIZE,&randomize_override);
		thread main();
	}
}

function randomize_override(array)
{
	if (array.size == 4)
	{
		skulls = 1;
		for (i = 0; i < 4; i++)
		{
			if (array[i] != (i + 1))
			{
				skulls = 0;
				break;
			}
		}
		if (skulls)
		{
			level notify("fixed_skull_pedastals");
			a_temp = array[0];
			array[0] = array[1];
			array[1] = a_temp;
			a_temp = array[2];
			array[2] = array[3];
			array[3] = a_temp;
			return array;
		}
	}
}

function main()
{
	level waittill("fixed_skull_pedastals");

	wait .05;

	UNREGISTER_OVERRIDE(SYSTEM_NAME,ARRAY_RANDOMIZE);
}