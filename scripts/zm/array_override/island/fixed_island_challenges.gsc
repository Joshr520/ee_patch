#using scripts\shared\flag_shared;
#using scripts\zm\array_override\array_override_common;

#insert scripts\zm\array_override\array_override_common.gsh;

#namespace fixed_island_challenges;
/*
//LEVEL 1 CHALLENGES
#define WATER_PLANT_3 0
#define SPORE_UNDERWATER 1
#define WATER_PLANT_5 2
#define 5_SPORES 3
#define 5_WEBS 4

//LEVEL 2 CHALLENGES
#define ENRAGED 0
#define POWERUP 1
#define PURPLE 2
#define SPORE_INFECTED 3
#define KILLS_UNDERWATER 4
#define FAN 5

//LEVEL 3 CHALLENGES
#define SPIDERS 0
#define MUTATING 1
#define FRUIT 2
#define PLANE 3
#define HEADS 4
*/
#define P1_CHALLENGES array(3,0,4)
#define P2_CHALLENGES array(2,1,3)
#define P3_CHALLENGES array(3,3,1)
#define P4_CHALLENGES array(4,0,0)

#define ISLAND_CHALLENGES array(P1_CHALLENGES,P2_CHALLENGES,P3_CHALLENGES,P4_CHALLENGES)

#define SYSTEM_NAME "island_challenges"
function init()
{
	if (GetDvarString("mapname") == "zm_island")
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

	level.fixed_challenges = ISLAND_CHALLENGES;
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