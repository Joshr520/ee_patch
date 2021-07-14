#using scripts\shared\array_shared;
#using scripts\zm\array_override\array_override_common;

#insert scripts\zm\array_override\array_override_common.gsh;

#namespace fixed_digsites;

#define SYSTEM_NAME "fixed_digsites"
function init()
{
	if (GetDvarString("mapname") == "zm_tomb")
	{
		thread main();
	}
}

function randomize_override(array)
{
	if (IsInArray(level.a_dig_spots, array[0]))
	{
		for (i = 0; i < array.size; i++)
		{
			j = RandomInt(array.size);
			temp = array[i];
			array[i] = array[j];
			array[j] = temp;
		}

		foreach(index, item in array)
		{
			if(item == level.a_dig_spots[7])
			{
				temp = array[0];
				array[0] = item;
				item = temp;
			}
			if(item == level.a_dig_spots[14])
			{
				temp = array[1];
				array[1] = item;
				item = temp;
			}
			if(item == level.a_dig_spots[26])
			{
				temp = array[2];
				array[2] = item;
				item = temp;
			}
		}

		level notify("Digs Done");
		return array;
	}
}

function main()
{
	REGISTER_OVERRIDE(SYSTEM_NAME,ARRAY_RANDOMIZE,&randomize_override);

	level waittill("Digs Done");

	UNREGISTER_OVERRIDE(SYSTEM_NAME,ARRAY_RANDOM);
}