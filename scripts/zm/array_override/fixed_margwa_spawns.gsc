#using scripts\zm\array_override\array_override_common;
#insert scripts\zm\array_override\array_override_common.gsh;

#namespace fixed_margwa_spawns;

#define MAPS_APPLIED array("zm_zod")

#define SYSTEM_NAME "fixed_margwa_spawns"
function init()
{
	map = GetDvarString("mapname");
	if (IsInArray(MAPS_APPLIED,map))
	{
		REGISTER_OVERRIDE(SYSTEM_NAME,ARRAY_RANDOM,&random_override);
		thread main();
	}
}

function random_override(array)
{
	if (IsInArray(array,level.zm_loc_types["margwa_location"][0]))
	{
		//get the zone that the host player is in
		p_zone = [[level.abh_zone_function]](GetPlayers()[0].origin + VectorScale((0, 0, 1), 32), 0);
		r_loc = undefined;

		// find the spawn point in the passed-in array that is in the same zone as the player
		for (i = 0; i < array.size; i++)
		{
			zone = [[level.abh_zone_function]](array[i].origin + VectorScale((0, 0, 1), 32), 0);
			if (zone == p_zone)
			{
				r_loc = array[i];
				break;
			}
		}

		// if possible, spawn the margwa in the same zone as the host player
		return r_loc;
	}
}

function main()
{
	//UNREGISTER_OVERRIDE(SYSTEM_NAME,ARRAY_RANDOM);
}