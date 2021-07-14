#using scripts\shared\flag_shared;
#using scripts\zm\_zm_powerups;

#namespace fixed_zombie_blood;

function init()
{
	if (GetDvarString("mapname") == "zm_tomb")
	{
		thread main();
	}
}

function main()
{
	level flag::wait_till("ee_mech_zombie_fight_completed");

	level.custom_zombie_powerup_drop = &give_zombie_blood;
	level waittill("Zombie Blood Done");
	level.custom_zombie_powerup_drop = undefined;
}

function give_zombie_blood(drop_point)
{
	powerup = zm_powerups::specific_powerup_drop("zombie_blood", drop_point);
	level notify("Zombie Blood Done");
	return 1;
}