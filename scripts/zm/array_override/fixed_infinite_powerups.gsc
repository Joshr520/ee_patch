


#namespace fixed_infinite_powerups;

function get_random_override()
{
	/*
	switch (map)
	{
		case "zm_zod":
			level thread zod_main(str_remove_notify);
			level notify(str_add_notify,&zod_random_override);
			break;
		case "zm_factory":
			break;
		case "zm_castle":
			level thread castle_main(str_remove_notify);
			level notify(str_add_notify,&castle_random_override);
			break;
		case "zm_island":
			break;
	}
	*/
	return &zod_random_override;
}

function zod_random_override(array)
{
	if ( array.size == 3 && GetDvarString("mapname") == "zm_zod" )
	{
		powerups = true;
		//make sure this is an array of powerup names
		for (i = 0; i < 3; i++)
		{
			if (array[i] != "double_points" && array[i] != "insta_kill" && array[i] != "full_ammo")
			{
				powerups = false;
				break;
			}
		}
		//set the infinite powerup: "double_points", "insta_kill", or "full_ammo"
		if (powerups)
		{
			if (isdefined(level.fixed_infinite_powerup)) str_ret = level.fixed_infinite_powerup;
			else str_ret =  "double_points";
			level notify("fixed_infinite_powerup");
			return str_ret;
		}
	}
}

#define ZOD_INFINITE_POWERUP "double_points"

function zod_main(str_notify)
{
	level.fixed_infinite_powerup = ZOD_INFINITE_POWERUP;

	level waittill("fixed_infinite_powerup");

	level notify(str_notify, &zod_random_override);
}

function castle_random_override(array)
{

}

function castle_main(str_notify)
{

}