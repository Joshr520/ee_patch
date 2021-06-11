#using scripts\shared\flag_shared;

#namespace fixed_meatball_count;

function monitor_meatball_count()
{
	level flag::wait_till("initial_blackscreen_passed");
	while (level.round_number < 10)
	{
		level waittill("end_of_round");
	}
	while (level.round_number == 10)
	{
		if (level.zombie_total > 10)
		{
			level.zombie_total = 10;
		}
		wait(1);
	}
}