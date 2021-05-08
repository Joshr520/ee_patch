#using scripts\shared\flag_shared;
#using scripts\zm\hud\hud_common;

#insert scripts\zm\hud\enemy_counter.gsh;
#insert scripts\shared\shared.gsh;

#namespace enemy_counter;

function init()
{
	level.enemy_count_current = [];
	level.enemy_count_total = 0;
	level.counter_num = 0;

	level flag::wait_till("initial_blackscreen_passed");
	thread count_archetypes();
	thread monitor_round_type();
}

function count_archetypes()
{
	self endon("special_counter_start");

	while(1)
	{
		count = [];
		count["zombie"] = 0;
		enemies = GetAITeamArray(level.zombie_team);
		foreach(index, enemy in enemies)
		{
			if(IS_TRUE(enemy.ignore_enemy_count)) continue;
			if(index == 0) count[enemy.archetype] = 0;
			if(!isdefined(level.enemy_count_current[enemy.archetype])) 
			{
				level.enemy_count_current[enemy.archetype] = 0;			
				if(enemy.archetype == "zombie") thread make_counter(2, enemy.archetype);
				else thread make_counter(1, enemy.archetype);
			}
			count[enemy.archetype]++;
			level.enemy_count_current[enemy.archetype] = count[enemy.archetype];
		}
		level.enemy_count_total = count["zombie"] + level.zombie_total;
		foreach(index, enemy in count)
		{
			if(count[index] == 0) level.enemy_count_current[index] = 0;
		}
		count = undefined;
		wait 0.1;
	}
}

function monitor_round_type()
{
	while(1)
	{
		level waittill("between_round_over");
		wait 0.1;
		if(level flag::get("special_round"))
		{
			level notify("special_counter_start");

			if(level flag::get("dog_round")) thread special_counter("dog");
			else if(level flag::get("raps_round")) thread special_counter("raps");
			else if(level flag::get("raz_round")) thread special_counter("raz");
			else if(level flag::get("sentinel_round")) thread special_counter("sentinel");
			else if(level flag::get("spider_round")) thread special_counter("spider");
			else if(level flag::get("wasp_round")) thread special_counter("wasp");
		}
	}
}

function special_counter(type)
{
	thread make_counter(2, "", type);
	level waittill("between_round_over");
	thread count_archetypes();
}

function make_counter(c_num, archetype, type)
{
	if(isdefined(type))
	{
		switch(type)
		{
			case "dog":
				archetype = "zombie_dog";
				break;
			case "raps":
				archetype = "raps";
				break;
			case "raz":
				archetype = "raz";
				break;
			case "sentinel":
				archetype = "sentinel_drone";
				break;
			case "spider":
				archetype = "spider";
				break;
			case "wasp":
				archetype = "wasp";
				break;
		}
	}

	IPrintLnBold("Attempting Counter For: " + archetype);

	foreach (p in GetPlayers())
	{
		x = T_X;
		y = T_Y;
		for(i = 0; i < c_num; i++)
		{
			if(i % 2 == 1) x = T_X + X_INCREMENT;
			else x = T_X;
			y = T_Y + (Y_INCREMENT * level.counter_num);

			if(c_num == 1) color = COLOR_TOTAL;
			else if(i % 2 == 1) color = COLOR_CURRENT;
			else color = COLOR_TOTAL;

			p.counter[i] = NewClientHudElem(p);
			if(isdefined(type))
			{
				p.counter[i] hud_common::reset_hud(0,ALIGNX,ALIGNY,HORZALIGN,VERTALIGN,FOREGROUND,HIDEINMENU,x,T_Y + Y_INCREMENT * I,FONT,FONTSCALE,color,TEXT);
				p.counter[i] thread hud_common::main(0,"",&counter_flag_display,&special_flag_destroy,"","",0,0);
			}
			else
			{
				p.counter[i] hud_common::reset_hud(0,ALIGNX,ALIGNY,HORZALIGN,VERTALIGN,FOREGROUND,HIDEINMENU,x,y,FONT,FONTSCALE,color,TEXT);
				p.counter[i] thread hud_common::main(0,"",&counter_flag_display,&counter_flag_destroy,"","",0,0);
			}

			if(i % 2 == 0 && isdefined(type)) p.counter[i] thread lifetime_total(archetype, "special");
			else if(i % 2 == 0 && archetype == "zombie") thread lifetime_total(archetype);
			else if(isdefined(type)) thread lifetime_total(archetype, "special");
			else p.counter[i] thread lifetime_current(archetype);

			level.counter_num++;
		}
	}
}

function special_flag_destroy()
{
	level waittill("between_round_over");
	self Destroy();
}

function counter_flag_destroy()
{
	level waittill("end_game");
	self Destroy();
}

function lifetime_total(archetype, special)
{
	if(isdefined(special)) self endon("between_round_over");

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
		case "raps":
			text_s = "Rap";
			text_p = "Raps";
			break;
		case "raz":
			text_s = "Mangler";
			text_p = "Manglers";
			break;
		case "sentinel_drone":
			text_s = "Sentinel";
			text_p = "Sentinels";
			break;
		case "spider":
			text_s = "Spider";
			text_p = "Spiders";
			break;
		case "wasp":
			text_s = "Wasp";
			text_p = "Wasps";
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
		if (level.enemy_count_total != lastcount)
		{
			lastcount = level.enemy_count_total;
			if(lastcount == 0) str = "";
			else if(lastcount == 1) str = lastcount + " " + text_s + " Remaining";
			else str = lastcount + " " + text_p + " Remaining";
			self SetText(str);
		}
		wait 0.1;
	}
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
		case "raps":
			text_s = "Rap";
			text_p = "Raps";
			break;
		case "raz":
			text_s = "Mangler";
			text_p = "Manglers";
			break;
		case "sentinel_drone":
			text_s = "Sentinel";
			text_p = "Sentinels";
			break;
		case "spider":
			text_s = "Spider";
			text_p = "Spiders";
			break;
		case "wasp":
			text_s = "Wasp";
			text_p = "Wasps";
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
		if (level.enemy_count_current[archetype] != lastcount)
		{
			lastcount = level.enemy_count_current[archetype];
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