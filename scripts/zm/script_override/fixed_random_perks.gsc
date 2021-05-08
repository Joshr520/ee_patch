#namespace fixed_random_perks;

#define PERK(name) ("specialty_"+name)

#define REVIVE PERK("quickrevive")
#define DOUBLE PERK("doubletap2")
#define JUG PERK("armorvest")
#define SPEED PERK("fastreload")
#define WIDOWS PERK("widowswine")
#define STAMINUP PERK("staminup")
#define MULEKICK PERK("additionalprimaryweapon")
#define CHERRY PERK("specialty_electriccherry")
#define DEADSHOT PERK("specialty_deadshot")

//the list of the predetermined random perk bottles to be given in order (from Reign Drops)
#define FIXED_PERKS_ZOD array(STAMINUP,MULEKICK,DOUBLE,JUG,SPEED,WIDOWS,REVIVE)
#define FIXED_PERKS_STALINGRAD array(STAMINUP,MULEKICK,DOUBLE,JUG,SPEED,WIDOWS,CHERRY,DEADSHOT)
#define FIXED_PERKS_CASTLE array(STAMINUP,MULEKICK,JUG,DOUBLE,SPEED,WIDOWS,CHERRY,DEADSHOT,REVIVE)
#define FIXED_PERKS array(STAMINUP,DOUBLE,JUG,SPEED)

function main()
{
	//flag to set when all the desired perks are given.
	level.fixed_perks_given = false;

	//populate the level array var with the desired perks for the _zm_perks script to use
	switch (GetDvarString("mapname"))
	{
		case "zm_zod":
			level.fixed_perks = FIXED_PERKS_ZOD;
			break;
		case "zm_stalingrad":
			level.fixed_perks = FIXED_PERKS_STALINGRAD;
			break;
		case "zm_castle":
			level.fixed_perks = FIXED_PERKS_CASTLE;
			break;
		default:
			level.fixed_perks = FIXED_PERKS;
	}
	level.perk_index = 0;

	while(level.perk_index < level.fixed_perks.size)
	{
		//_zm_perks script will notify level when a "random" perk has been given
		level waittill("fixed_random_perk");
		wait(1);
		level.perk_index++;
	}

	//all desired perks have been given
	level.fixed_perks_given = true;
}