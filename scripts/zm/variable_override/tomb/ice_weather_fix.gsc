#using scripts\shared\flag_shared;
#using scripts\shared\ai\zombie_utility;
#using scripts\shared\clientfield_shared;
#using scripts\shared\util_shared;

#namespace ice_weather_fix;

function init()
{
	if (GetDvarString("mapname") == "zm_tomb")
	{
		thread fixSnow();
	 	thread fixDigs();
	}
}

//This function makes it so that the player gets the ice parts in a total of 5 digs.
function fixDigs() {
	level flag::wait_till("initial_blackscreen_passed");

	for (;;) {	
		wait 3;

		if (isDefined(level.ice_staff_pieces[0].num_misses) && level.ice_staff_pieces[0].num_misses >= 1) {			
			level.ice_staff_pieces[0].num_misses = 4;
		}

		if (isDefined(level.ice_staff_pieces[1].num_misses) && level.ice_staff_pieces[1].num_misses >= 1) {			
			level.ice_staff_pieces[1].num_misses = 4;
		}

		if (isDefined(level.ice_staff_pieces[2].num_misses)) {			
			level.ice_staff_pieces[2].num_misses = 4;
		}
	}
}


//This function makes it so there is 3 4 5 6 snow.
function fixSnow() {
	level flag::wait_till("initial_blackscreen_passed");
	//IPrintLnBold("The second callback::on_spawned is working");
	
	//These two lines SHOULDN'T have any effect on the snow rounds, but is in just in case.
	level.force_weather[3] = "snow";
	level.force_weather[4] = "snow";

	//Force rounds since snow >> 3.
	level.last_snow_round = -4;
	level.weather_snow = randomIntRange(1, 5);
	while(1) {
		level clientfield::set("snow_level", level.weather_snow);
		wait(2);
		foreach(player in GetPlayers())
		{
			if(zombie_utility::is_player_valid(player, 0, 1))
			{
				player set_weather_to_player();
			}
		}
		level waittill("end_of_round");
	}
}

function set_weather_to_player()
{
	self clientfield::set_to_player("player_weather_visionset", level.weather_vision);
	switch(level.weather_vision)
	{
		case 3:
		{
			level util::set_lighting_state(0);
			break;
		}
		case 1:
		{
			level util::set_lighting_state(0);
			break;
		}
		case 2:
		{
			level util::set_lighting_state(1);
			break;
		}
	}
}