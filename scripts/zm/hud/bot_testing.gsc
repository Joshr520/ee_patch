#using scripts\shared\ai\zombie_utility;
#using scripts\shared\flag_shared;
#using scripts\shared\array_shared;

#define NUM_BOTS 4

#namespace bot_testing;

function bot()
{
	SetDvar("bot_difficulty","3");
	SetDvar("player_meleeRangeDefault","24");
	zombie_utility::set_zombie_var("zombie_health_increase_multiplier",0,true);
	level flag::wait_till("initial_players_connected");

	level.bot_order = array();
	level.bot_index = 0;

	for (i = GetPlayers().size; i < NUM_BOTS; i++)
	{
		bot = AddTestClient();
		bot thread bot_lifetime();
		array::add(level.bot_order,i);
	}

	level thread bot_order();
}

function bot_lifetime()
{
	level flag::wait_till("initial_blackscreen_passed");

	bgb_machine = (2930.36,-5481.4,128);

	wait_loc = (2585,-5251,128);

	gate = (1960,-5359,126);

	id = 0;

	self goto(gate,20);

	while (!level flag::get("connect_start_to_junction"))
	{
		self BotPressButton(3);
		wait .05;
	}

	grabbed_gum = 0;

	while(1)
	{
		if (level.current_bot == id)
		{
			self goto(bgb_machine,10);
			self press(3,"bgb_spin");
			wait 3.3;
			self BotPressButton(3);
			grabbed_gum = 1;
		}

		self goto(wait_loc,50);

		if (grabbed_gum) 
		{
			level waittill("end_of_round");
			grabbed_gum = 0;
		}

	}

}

function press(num,str)
{
	level endon(str);
	self endon(str);
	while(1)
	{
		self BotPressButton(num);
		wait .05;
	}
}

function bot_order()
{
	level.bot_count = 0;
	while(1)
	{
		if (!isdefined(level.current_bot)) level.current_bot = array::random(level.bot_order);
		else level.current_bot = level.bot_order[level.bot_index];

		level waittill("bgb_spin",id);

		wait 3;

		level.bot_index++;
		level.bot_count++;

		if (level.bot_index >= level.bot_order.size)
		{
			level.bot_index = 0;
		}

		if (level.bot_count >= level.bot_order.size)
		{
			level.current_bot = undefined;
			level waittill("between_round_over");
			level.bot_count = 0;
		}
	}
}

function goto(loc,radius = 0)
{
	self BotSetGoal(loc,radius);
	self.bot.sprintToGoal = 1;
	self waittill("bot_goal_reached");
}
