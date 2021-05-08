#using scripts\zm\array_override\array_override_common;
#insert scripts\zm\array_override\array_override_common.gsh;

#namespace castle_tram_powerup;

#define SYSTEM_NAME "castle_tram_powerup"

function init()
{
	if (GetDvarString("mapname") == "zm_castle")
	{
		REGISTER_OVERRIDE(SYSTEM_NAME,ARRAY_RANDOM,&random_override);
	}
}

function random_override(array)
{
	powerups = 1;
	foreach (str in array)
	{
		if (!IsInArray(level.zombie_powerup_array,str))
		{
			powerups = 0;
			break;
		}
	}
	if (powerups)
	{
		if (level.round_number <= 2) return "double_points";
		else return "full_ammo";
	}
}