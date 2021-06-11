#using scripts\shared\flag_shared;
#using scripts\shared\ai\zombie_utility;
#using scripts\zm\hud\hud_common;

#insert scripts\zm\hud\enemy_counter.gsh;
#insert scripts\shared\shared.gsh;

#namespace enemy_counter;

function init()
{
	level.enemy_count = [];
	level.ignored_enemy_count = [];
	level.archetypes = ARCHETYPES_ALL;
	level.c_active = 0;
	level.special_round_type = "nothing";

	foreach(archetype in level.archetypes)
	{
		level.enemy_count[archetype] = 0;
		level.ignored_enemy_count[archetype] = 0;
	}

	level flag::wait_till("initial_blackscreen_passed");
	thread count_archetypes();
	thread make_counters();
	thread monitor_round_type();
}

function count_archetypes()
{
	self endon("special_counter_start");

	while(1)
	{
		// Determine archetype enemy counts
		count = [];
		ignored_count = [];
		enemies = GetAISpeciesArray(level.zombie_team, "all");
		foreach(enemy in enemies)
		{
			if(!isdefined(count[enemy.archetype]))
			{
				count[enemy.archetype] = 0;
				ignored_count[enemy.archetype] = 0;
			}
			if(IS_TRUE(enemy.ignore_enemy_count))
			{
				ignored_count[enemy.archetype]++;
			}
			else
			{
				count[enemy.archetype]++;
			}
		}
		// Iterate through each archetype and determine if it should be added to the count or not
		foreach(archetype in level.archetypes)
		{
			if(isdefined(count[archetype]))
			{
				level.enemy_count[archetype] = count[archetype];
			}
			else level.enemy_count[archetype] = 0;

			if(isdefined(ignored_count[archetype]))
			{
				level.ignored_enemy_count[archetype] = ignored_count[archetype];
			}
			else level.ignored_enemy_count[archetype] = 0;
		}
		wait 0.1;
	}
}

function make_counters()
{
	foreach(index,archetype in level.archetypes)
	{
		thread make_counter(archetype);
	}
}

function make_counter(archetype)
{
	if(archetype == ARCHETYPE_ZOMBIE)
	{
		counter_total = NewHudElem();
		counter_total hud_common::reset_hud(0,ALIGNX,ALIGNY,HORZALIGN,VERTALIGN,FOREGROUND,HIDEINMENU,T_X,T_Y,FONT,FONTSCALE,COLOR_TOTAL,TEXT);
		counter_total thread hud_common::main(0,"",&counter_flag_display,&counter_flag_destroy,"","",0,0);
		counter_total thread lifetime_total(archetype);
	}

	counter = NewHudElem();
	counter hud_common::reset_hud(0,ALIGNX,ALIGNY,HORZALIGN,VERTALIGN,FOREGROUND,HIDEINMENU,T_X + X_INCREMENT,T_Y,FONT,FONTSCALE,COLOR_CURRENT,TEXT);
	counter thread hud_common::main(0,"",&counter_flag_display,&counter_flag_destroy,"","",0,0);
	counter thread lifetime_current(archetype);

	c_active = 0;

	while(1)
	{
		if(level.enemy_count[archetype] != 0)
		{
			if(c_active == 0)
			{
				c_active = 1;
				level.c_active++;
			}
			counter.y = T_Y + (Y_INCREMENT * level.c_active);
			//IPrintLnBold("Type: " + archetype + " Active: " + level.c_active + " Y: " + counter.y);
		}
		else if(c_active == 1)
		{
			c_active = 0;
			level.c_active--;
		}
		wait 0.1;
	}
}

function monitor_round_type()
{
	while(1)
	{
		level waittill("between_round_over");
		wait 0.1;
		if(IS_TRUE(level flag::get("special_round")))
		{
			if(IS_TRUE(level flag::get("dog_round"))) level.special_round_type = "zombie_dog";
			else if(IS_TRUE(level flag::get("raps_round"))) level.special_round_type = "raps";
			else if(IS_TRUE(level flag::get("raz_round"))) level.special_round_type = "raz";
			else if(IS_TRUE(level flag::get("sentinel_round"))) level.special_round_type = "sentinel_drone";
			else if(IS_TRUE(level flag::get("spider_round"))) level.special_round_type = "spider";
			else if(IS_TRUE(level flag::get("wasp_round"))) level.special_round_type = "parasite";
			wait 0.1;
			level notify("special_done");
		}
		// For some reason, monkey rounds don't seem to set a special_round flag
		if(IS_TRUE(level flag::get("monkey_round"))) level.special_round_type = "monkey";
	}
}

function counter_flag_destroy()
{
	level waittill("end_game");
	self Destroy();
}

/*
	Recursive function to constantly monitor the amount of zombies left in the round
	
	If the round is currently a special round, we create the counter with a different archetype, passed in by the notify
	in monitor_round_type()
	
	Get the text to output to the screen based off of the given enemy archetype
	
	While we're not in a special round, get the enemy count and set the counter to display that number
	
	If we encounter a special round, call the function again to get back to the special round counter
*/
function lifetime_total(archetype)
{
	text_s = "";
	text_p = "";

	lastcount = 0;
	enemy_count = 0;

	if(IS_TRUE(level flag::get("special_round")) || IS_TRUE(level flag::get("monkey_round")))
	{
		level waittill("special_done");
		switch(level.special_round_type)
		{
			case "zombie_dog":
				text_s = "Dog";
				text_p = "Dogs";
				break;
			case "parasite":
				text_s = "Parasite";
				text_p = "Parasites";
				break;
			case "raps":
				text_s = "Raps";
				text_p = "Raps";
				break;
			case "spider":
				text_s = "Spider";
				text_p = "Spiders";
				break;
			case "sentinel_drone":
				text_s = "Sentinel";
				text_p = "Sentinels";
				break;
			case "raz":
				text_s = "Mangler";
				text_p = "Manglers";
				break;
			case "monkey":
				text_s = "Monkey";
				text_p = "Monkeys";
				break;
		}
		IPrintLnBold(text_s + " " + text_p);
		while(IS_TRUE(level flag::get("special_round")) || IS_TRUE(level flag::get("monkey_round")))
		{
			if (zombie_utility::get_current_zombie_count() + level.zombie_total != lastcount)
			{
				lastcount = zombie_utility::get_current_zombie_count() + level.zombie_total;
				if(lastcount == 0) str = "";
				else if(lastcount == 1) str = lastcount + " " + text_s + " Remaining";
				else str = lastcount + " " + text_p + " Remaining";
				self SetText(str);
			}
			wait 0.1;
		}
	}

	switch(archetype)
	{
		case "zombie":
			text_s = "Zombie";
			text_p = "Zombies";
			break;
		case "zombie_dog":
			text_s = "Dog";
			text_p = "Dogs";
			break;
		case "parasite":
			text_s = "Parasite";
			text_p = "Parasites";
			break;
		case "raps":
			text_s = "Raps";
			text_p = "Raps";
			break;
		case "spider":
			text_s = "Spider";
			text_p = "Spiders";
			break;
		case "sentinel_drone":
			text_s = "Sentinel";
			text_p = "Sentinels";
			break;
		case "thrasher":
			text_s = "Thrasher";
			text_p = "Thrashers";
			break;
		case "raz":
			text_s = "Mangler";
			text_p = "Manglers";
			break;
		case "monkey":
			text_s = "Monkey";
			text_p = "Monkeys";
			break;
		case "margwa":
			text_s = "Margwa";
			text_p = "Margwas";
			break;
		case "mechz":
			text_s = "Panzer";
			text_p = "Panzers";
			break;
	}

	if(text_s == "" && text_p == "")
	{
		text_s += archetype;
		text_p += archetype;
	}

	while(!IS_TRUE(level flag::get("special_round")))
	{
		if (zombie_utility::get_current_zombie_count() + level.zombie_total != lastcount)
		{
			lastcount = zombie_utility::get_current_zombie_count() + level.zombie_total;
			if(lastcount == 0) str = "";
			else if(lastcount == 1) str = lastcount + " " + text_s + " Remaining";
			else str = lastcount + " " + text_p + " Remaining";
			self SetText(str);
		}
		wait 0.1;
	}
	lifetime_total(archetype);
}

function lifetime_current(archetype)
{
	text_s = "";
	text_p = "";

	switch(archetype)
	{
		case "zombie":
			text_s = "Zombie";
			text_p = "Zombies";
			break;
		case "zombie_dog":
			text_s = "Dog";
			text_p = "Dogs";
			break;
		case "parasite":
			text_s = "Parasite";
			text_p = "Parasites";
			break;
		case "raps":
			text_s = "Rap";
			text_p = "Raps";
			break;
		case "spider":
			text_s = "Spider";
			text_p = "Spiders";
			break;
		case "sentinel_drone":
			text_s = "Sentinel";
			text_p = "Sentinels";
			break;
		case "thrasher":
			text_s = "Thrasher";
			text_p = "Thrashers";
			break;
		case "raz":
			text_s = "Mangler";
			text_p = "Manglers";
			break;
		case "monkey":
			text_s = "Monkey";
			text_p = "Monkeys";
			break;
		case "margwa":
			text_s = "Margwa";
			text_p = "Margwas";
			break;
		case "mechz":
			text_s = "Panzer";
			text_p = "Panzers";
			break;
	}

	if(text_s == "" && text_p == "")
	{
		text_s += archetype;
		text_p += archetype;
	}

	lastcount = 0;
	enemy_count = 0;
	while(1)
	{
		if (level.enemy_count[archetype] != lastcount)
		{
			lastcount = level.enemy_count[archetype];
			if(lastcount == 0) str = "";
			else if(lastcount == 1) str = lastcount + " " + text_s + " Spawned";
			else str = lastcount + " " + text_p + " Spawned";
			self SetText(str);
		}
		wait 0.1;
	}
}

function counter_flag_display()
{
}