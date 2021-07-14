#using scripts\shared\array_shared;
#using scripts\shared\flag_shared;
#using scripts\zm\_zm_utility;
#using scripts\shared\ai\zombie_utility;
#using scripts\zm\hud\hud_common;

#insert scripts\zm\hud\hud_common.gsh;
#insert scripts\zm\hud\zombie_counter.gsh;

#namespace zombie_counter;

#define RESET_HUD_TOTAL hud_common::reset_hud(TEXT_ID,ALIGNX,ALIGNY,HORZALIGN,VERTALIGN,FOREGROUND,HIDEINMENU,X_TOTAL,Y_TOTAL,FONT,FONTSCALE,COLOR_TOTAL,TEXT)
#define RESET_HUD_CURRENT hud_common::reset_hud(TEXT_ID,ALIGNX,ALIGNY,HORZALIGN,VERTALIGN,FOREGROUND,HIDEINMENU,X_CURRENT,Y_CURRENT,FONT,FONTSCALE,COLOR_CURRENT,TEXT)

#define COUNTER_DESTROY_NOTIFY "stop_counting"

#define ZOMBIE_COUNTER_TEXT_TOTAL_PLURAL "Zombies Remaining"
#define ZOMBIE_COUNTER_TEXT_TOTAL_SINGULAR "Zombie Remaining"
#define ZOMBIE_COUNTER_TEXT_CURRENT_PLURAL "Zombies Spawned"
#define ZOMBIE_COUNTER_TEXT_CURRENT_SINGULAR "Zombie Spawned"
#define NO_ENEMIES_TEXT ""

function init()
{
	level.zombie_counter_text_total = ZOMBIE_COUNTER_TEXT_TOTAL_SINGULAR;
	level.zombie_counter_text_current = ZOMBIE_COUNTER_TEXT_CURRENT_SINGULAR;

	thread count_zombies();

	foreach (p in GetPlayers())
	{
		p.hud_zombie_counter_total = NewClientHudElem(p);
		p.hud_zombie_counter_total RESET_HUD_TOTAL;
		p.hud_zombie_counter_total thread hud_common::main(TEXT_ID,"",&counter_flag_display,&counter_flag_destroy,&counter_lifetime_total,COUNTER_DESTROY_NOTIFY,FADEIN_TIME,FADEOUT_TIME);

		p.hud_zombie_counter_current = NewClientHudElem(p);
		p.hud_zombie_counter_current RESET_HUD_CURRENT;
		p.hud_zombie_counter_current thread hud_common::main(TEXT_ID,"",&counter_flag_display,&counter_flag_destroy,&counter_lifetime_current,COUNTER_DESTROY_NOTIFY,FADEIN_TIME,FADEOUT_TIME);
		if (GetDvarString("mapname") == "zm_zod") p thread manage_hud_in_beastmode();
	}
}

function counter_flag_destroy()
{
	level waittill("end_game");
	self Destroy();
}

function counter_lifetime_total()
{
	self endon(COUNTER_DESTROY_NOTIFY);
	lastcount = 0;
	while(1)
	{
		if (level.counted_zombies != lastcount)
		{
			lastcount = level.counted_zombies_total;
			if(lastcount == 0) str = NO_ENEMIES_TEXT;
			else if(lastcount == 1) str = lastcount + " " + ZOMBIE_COUNTER_TEXT_TOTAL_SINGULAR;
			else str = lastcount + " " + ZOMBIE_COUNTER_TEXT_TOTAL_PLURAL;
			self SetText(str);
		}
		wait .25;
	}
}

function counter_lifetime_current()
{
	self endon(COUNTER_DESTROY_NOTIFY);
	lastcount = 0;
	while(1)
	{
		if (level.counted_zombies != lastcount)
		{
			lastcount = level.counted_zombies_current;
			if(lastcount == 0) str = NO_ENEMIES_TEXT;
			else if(lastcount == 1) str = lastcount + " " + ZOMBIE_COUNTER_TEXT_CURRENT_SINGULAR;
			else str = lastcount + " " + ZOMBIE_COUNTER_TEXT_CURRENT_PLURAL;
			self SetText(str);
		}
		wait .25;
	}
}

function manage_hud_in_beastmode()
{
	level endon("end_game");
	self endon("disconnect");
	while(1)
	{
		self flag::wait_till("in_beastmode");

		self.hud_zombie_counter_total FadeOverTime(FADEOUT_TIME);
		self.hud_zombie_counter_total.alpha = 0;

		self.hud_zombie_counter_current FadeOverTime(FADEOUT_TIME);
		self.hud_zombie_counter_current.alpha = 0;

		self waittill("altbody_end");

		self.hud_zombie_counter_total FadeOverTime(FADEIN_TIME);
		self.hud_zombie_counter_total.alpha = 1;

		self.hud_zombie_counter_current FadeOverTime(FADEIN_TIME);
		self.hud_zombie_counter_current.alpha = 1;
	}
}

function count_zombies()
{
	level endon("end_game");
	level.counted_zombies_total = 0;
	level.counted_zombies_current = 0;
	while(1)
	{	
		level.counted_zombies_total = zombie_utility::get_current_zombie_count() + level.zombie_total;
		level.counted_zombies_current = zombie_utility::get_current_zombie_count();
		wait .1;
	}
}

function counter_flag_display()
{
}