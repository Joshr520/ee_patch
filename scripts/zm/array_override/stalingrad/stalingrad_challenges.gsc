#using scripts\shared\flag_shared;
#using scripts\zm\array_override\array_override_common;
#insert scripts\zm\array_override\array_override_common.gsh;

#namespace stalingrad_challenges;

#define MODULE 0
#define VALKYRIE 1
#define MANGLER 2
#define BOMBS 3
#define GERSCH 4

// For some reason, the code makes it so VALKYRIE and MANGLER challenges can't be next to each other, so never set them as that or it will be random again

#define STALINGRAD_CHALLENGE_ORDER_SOLO array(BOMBS, MODULE, MANGLER, GERSCH, VALKYRIE)
#define STALINGRAD_CHALLENGE_ORDER_COOP array(VALKYRIE, MODULE, BOMBS, GERSCH, MANGLER)

#define SYSTEM_NAME "stalingrad_challenges"

function init()
{
	if (GetDvarString("mapname") == "zm_stalingrad")
	{
		REGISTER_OVERRIDE(SYSTEM_NAME,ARRAY_RANDOMIZE,&randomize_override);
		thread main();
	}
}

function randomize_override(array)
{
	if (array.size == 5 && level flag::get("keys_placed") && !level.stalingrad_challenges_done)
	{
		level notify("pick_challenges");

		level waittill("challenges_done");

		ret = [];
		foreach (index, challenge in level.stalingrad_challenges)
		{
			ArrayInsert(ret, array[challenge], index);
		}
		return ret;
	}
}

function main()
{
	level.stalingrad_challenges_done = 0;
	level.stalingrad_challenges = [];

	level waittill("pick_challenges");

	if (GetPlayers().size == 1) level.stalingrad_challenges = STALINGRAD_CHALLENGE_ORDER_SOLO;
	else level.stalingrad_challenges = STALINGRAD_CHALLENGE_ORDER_COOP;

	level notify("challenges_done");

	level.stalingrad_challenges_done = 1;

	UNREGISTER_OVERRIDE(SYSTEM_NAME,ARRAY_RANDOMIZE);
}