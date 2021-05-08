#using scripts\shared\flag_shared;
#using scripts\zm\array_override\array_override_common;
#insert scripts\zm\array_override\array_override_common.gsh;

#namespace bombs;

#define ARMORY 0
#define BARRACKS 1
#define COMMAND 2
#define STORE 3
#define SUPPLY 4
#define TANK 5

#define BOMBS_ORDER array(ARMORY, SUPPLY, STORE, TANK, BARRACKS, COMMAND)

#define SYSTEM_NAME "stalingrad_bombs"

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
	if (level flag::get("keys_placed") && !level.fixed_bombs_done)
	{
		if (array.size == 6)
		{
			cont = false;
			if (array[0] == "armory") cont = true;
			if (cont)
			{
				switch (GetPlayers().size) 
				{
					case 1:
						a_temp = Array("armory", "supply", "store", "tank", "barracks", "command");
						break;
					case 2:
						a_temp = Array("store", "tank", "barracks", "armory", "supply", "command");
						break;
					case 3:
						a_temp = Array("store", "tank", "supply", "barracks", "armory", "command");
						break;
					case 4:
						a_temp = Array("tank", "supply", "department", "command", "barracks", "armory");
						break;
					default:
						a_temp = array;
						break;
				}
				level notify("bombs_chosen");
				return a_temp;
			}
		}
	}
}

function main()
{
	level.fixed_bombs_done = 0;

	level waittill("bombs_chosen");

	level.fixed_bombs_done = 1;
	UNREGISTER_OVERRIDE(SYSTEM_NAME,ARRAY_RANDOMIZE);
}