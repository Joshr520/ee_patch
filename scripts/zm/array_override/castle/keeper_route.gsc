#using scripts\shared\flag_shared;

#insert scripts\shared\shared.gsh;

#using scripts\zm\array_override\array_override_common;
#insert scripts\zm\array_override\array_override_common.gsh;

#namespace castle_keeper_route;

#define COURTYARD 1
#define DOUBLE_TAP 2
#define POWER 3
#define MULE_KICK 4

#define KEEPER_PATH_ORDER_0 array(COURTYARD,MULE_KICK,DOUBLE_TAP,POWER)
#define KEEPER_PATH_ORDER_1 array(DOUBLE_TAP,MULE_KICK,COURTYARD,POWER)
//#define KEEPER_ELEMENTS_ORDER array()


#define SYSTEM_NAME "keeper_route"
function init()
{
	if (GetDvarString("mapname") == "zm_castle")
	{
		REGISTER_OVERRIDE(SYSTEM_NAME,ARRAY_RANDOMIZE,&randomize_override);
		thread main();
	}
}

function randomize_override(array)
{
	if (array.size == 4 && level flag::get("start_channeling_stone_step") && !(level.keeper_route_done))
	{
		keeper_route = true;
		for (i = 1; i <= array.size; i++)
		{
			if (array[i - 1] != i)
			{
				keeper_route = false;
				break;
			}
		}
		if (keeper_route)
		{
			ret = level.fixed_keeper_route;
			level notify("keeper_route_done");
			if (ret.size == array.size) return ret;
		}
	}
}


function main()
{
	level flag::wait_till("initial_blackscreen_passed");
	
	level.keeper_route_done = 0;

	if (GetPlayers().size != 2)	level.fixed_keeper_route = KEEPER_PATH_ORDER_0;
	else level.fixed_keeper_route = KEEPER_PATH_ORDER_1;

	level waittill("keeper_route_done");

	level.keeper_route_done = 1;

	UNREGISTER_OVERRIDE(SYSTEM_NAME,ARRAY_RANDOMIZE);
	
}