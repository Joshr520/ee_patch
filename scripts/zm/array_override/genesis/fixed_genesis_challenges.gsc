#using scripts\shared\flag_shared;
#using scripts\zm\array_override\array_override_common;

#insert scripts\zm\array_override\array_override_common.gsh;

#namespace fixed_genesis_challenges;

/*
// LEVEL 1 CHALLENGES
#define 1_1 	0 // Kill 5 zombies with each type of trap
#define 1_2 	1 // Use beam to kill 15 zombies
#define 1_5 	2 // Head shot 10 Apothicon Furies
#define 1_8 	3 // Equip the Dragon Shield
#define 1_10 	4 // Craft the Keeper Protector Altar
#define 3_6 	5 // Complete Corruption Engine without any kills

// LEVEL 2 CHALLENGES
#define 2_2 	0 // Use beam deflections to kill 10 zombies
#define 2_7 	1 // Survive 7 rounds in Nacht Der Untoten
#define 2_8 	2 // Kill 15 spiders
#define 1_9 	3 // Kill 10 spiders with the shield
#define 2_10 	4 // Kill 10 zombies while they are jumping between islands
#define 2_11 	5 // Kill 5 zombies on each island within the same round

// LEVEL 3 CHALLENGES
#define 3_1 	0 // Kill 5 zombies on an island that you are currently not on
#define 3_2 	1 // Kill a Mech Z without taking damage
#define 3_3 	2 // Three shot kill a Margwa
#define 3_4 	3 // Kill one of each elemental Margwa
#define 3_9 	4 // Kill 3 Margwas inside the Apothicon
#define 2_9 	5 // Survive for 15 minutes inside the Apothicon
*/

#define P1_CHALLENGES array(5,2,4)
#define P2_CHALLENGES array(3,3,3)
#define P3_CHALLENGES array(4,5,2)
#define P4_CHALLENGES array(2,1,1)

#define GENESIS_CHALLENGES array(P1_CHALLENGES,P2_CHALLENGES,P3_CHALLENGES,P4_CHALLENGES)

#define SYSTEM_NAME "genesis_challenges"
function init()
{
	if (GetDvarString("mapname") == "zm_genesis")
	{
		REGISTER_OVERRIDE(SYSTEM_NAME,ARRAY_RANDOM,&random_override);
		thread main();
	}
}

function random_override(array)
{
	if (level flag::get("flag_init_player_challenges") && !level.fixed_challenges_done)
	{
		if (array.size == 5 || array.size == 6)
		{
			if (isdefined(array[0].n_index) && array[0].n_index < 4)
			{
				index = level.next_challenge_array[(array[0].n_index) - 1];
				level notify("next_fixed_challenge");
				if (isdefined(array[index])) return array[index];
			}
		}
	}
}

function main()
{
	level.fixed_challenges_done = 0;

	level.fixed_challenges = GENESIS_CHALLENGES;
	level.fixed_challenges_playerindex = 0;
	level.fixed_challenges_challengeindex = 0;
	
	while(level.fixed_challenges_playerindex < level.fixed_challenges.size)
	{
		level.next_challenge_array = level.fixed_challenges[level.fixed_challenges_playerindex];
		level waittill("next_fixed_challenge");
		level.fixed_challenges_challengeindex++;
		if (level.fixed_challenges_challengeindex > 2)
		{
			level.fixed_challenges_challengeindex = 0;
			level.fixed_challenges_playerindex++;
		}
	}

	level.fixed_challenges_done = 1;

	UNREGISTER_OVERRIDE(SYSTEM_NAME,ARRAY_RANDOM);
}