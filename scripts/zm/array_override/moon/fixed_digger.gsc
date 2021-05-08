#using scripts\shared\flag_shared;
#using scripts\zm\array_override\array_override_common;

#insert scripts\zm\array_override\array_override_common.gsh;

#namespace fixed_digger;

#define PI "teleporter"
#define EPSILON "hangar"
#define OMICRON "biodome"

#define DIGGER_ORDER array(PI)

#define SYSTEM_NAME "moon_digger"
function init()
{
	if (GetDvarString("mapname") == "zm_moon")
	{
		thread main();
	}
}

function random_override(array)
{
	if (IsInArray(level.diggers,array[0]))
	{
		if (IsInArray(array,level.next_dig_loc))
		{
			ret = level.next_dig_loc;
			level notify("fixed_dig_loc");
			return ret;
		}
	}
}

function main()
{

	level.fixed_digger_order = DIGGER_ORDER;

	level.fixed_digger_index = 0;

	level flag::wait_till("power_on");
	REGISTER_OVERRIDE(SYSTEM_NAME,ARRAY_RANDOM,&random_override);

	while(level.fixed_digger_index < level.fixed_digger_order.size)
	{
		level.next_dig_loc = level.fixed_digger_order[level.fixed_digger_index];
		level waittill("fixed_dig_loc");
		level.fixed_digger_index++;
	}

	wait .05;

	UNREGISTER_OVERRIDE(SYSTEM_NAME,ARRAY_RANDOM);
}