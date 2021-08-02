#using scripts\shared\flag_shared;

#namespace fixed_special_rounds;

#define BUG_ROUND 6
#define RAPS_ROUND 10

function zod_bug_rounds_simple()
{
	level flag::wait_till("initial_blackscreen_passed");
	level.next_wasp_round = BUG_ROUND;
	level.n_next_raps_round = RAPS_ROUND;
}

#define BUG_ROUND_ARR array(6,10,14,19)

function zod_bug_rounds()
{
	level endon("end_of_game");
	level flag::wait_till("initial_blackscreen_passed");
	bug_rounds = BUG_ROUND_ARR;
	last_bug_round = (-2);
	level.next_wasp_round = 5;
	level.n_next_raps_round = 9;
	i = 0;
	while (i < bug_rounds.size)
	{
		if (i % 2) level.n_next_raps_round = bug_rounds[i];
		else level.next_wasp_round = bug_rounds[i];
		last_bug_round = bug_rounds[i];
		while(level.round_number < last_bug_round+2)
		{
			level waittill("end_of_round");
		}
		i++;
	}
}

#define FACTORY_DOGS_ARR array(5,9,13,17,21,25,29,33,37,41,45,49)

function factory_dog_rounds()
{
	level endon("end_of_game");
	level flag::wait_till("initial_blackscreen_passed");
	dog_rounds = FACTORY_DOGS_ARR;
	i = 0;
	while (i < dog_rounds.size)
	{
		level.next_dog_round = dog_rounds[i];
		while(level.round_number <= dog_rounds[i]) level waittill("end_of_round");
		i++;
	}
}

#define CASTLE_DOGS_1 5

#define CASTLE_DOGS_ARR array(5,12,19,26,33,40,47,54,61,68,75,82,89,96)

function castle_dog_rounds_simple()
{
	level endon("end_of_game");
	level flag::wait_till("initial_blackscreen_passed");
	level.next_dog_round = CASTLE_DOGS_1;
}

function castle_dog_rounds()
{
	level endon("end_of_game");
	level flag::wait_till("initial_blackscreen_passed");
	dog_rounds = CASTLE_DOGS_ARR;
	i = 0;
	while (i < dog_rounds.size)
	{
		level.next_dog_round = dog_rounds[i];
		while(level.round_number <= dog_rounds[i]) level waittill("end_of_round");
		i++;
	}
}

#define ISLAND_SPIDERS_ARR array(6,10,14,18,22,26,30,34,38,42,46,50)

function island_spider_rounds()
{
	level endon("end_of_game");
	level flag::wait_till("initial_blackscreen_passed");
	spider_rounds = ISLAND_SPIDERS_ARR;
	i = 0;
	while (i < spider_rounds.size)
	{
		level.n_next_spider_round = spider_rounds[i];
		while(level.round_number <= spider_rounds[i])
		{
			level waittill("end_of_round");
		}
		i++;
	}
}

#define STALINGRAD_SENTINEL_ARR array(10,17,24,31,38,45)

function stalingrad_sentinel_rounds()
{
	level endon("end_of_game");
	level flag::wait_till("initial_blackscreen_passed");
	sentinel_rounds = STALINGRAD_SENTINEL_ARR;
	i = 0;
	while (i < sentinel_rounds.size)
	{
		level.n_next_sentinel_round = sentinel_rounds[i];
		while(level.round_number <= sentinel_rounds[i])
		{
			level waittill("end_of_round");
		}
		i++;
	}
}