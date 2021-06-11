#using scripts\shared\flag_shared;

#namespace fixed_random_perks;

#define PERK(name) ("specialty_"+name)

#define REVIVE PERK("quickrevive")
#define DOUBLE PERK("doubletap2")
#define JUG PERK("armorvest")
#define SPEED PERK("fastreload")
#define WIDOWS PERK("widowswine")
#define STAMINUP PERK("staminup")
#define MULEKICK PERK("additionalprimaryweapon")
#define CHERRY PERK("electriccherry")
#define DEADSHOT PERK("deadshot")

//the list of the predetermined random perk bottles to be given in order (from Reign Drops)
#define FIXED_PERKS_ZOD array(STAMINUP,MULEKICK,DOUBLE,JUG,SPEED,WIDOWS,REVIVE)
#define FIXED_PERKS_STALINGRAD array(STAMINUP,MULEKICK,DOUBLE,JUG,SPEED,WIDOWS,CHERRY,DEADSHOT)
#define FIXED_PERKS_CASTLE array(STAMINUP,MULEKICK,JUG,DOUBLE,SPEED,WIDOWS,CHERRY,DEADSHOT,REVIVE)
#define FIXED_PERKS array(STAMINUP,DOUBLE,JUG,SPEED)

function init()
{
	thread main();
}

function main()
{
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
	level flag::wait_till("all_players_connected");
	players = GetPlayers();
	for (i = 0; i < players.size; i++)
	{
		players[i].fixed_perks = ( IsArray(level.fixed_perks[0]) ? level.fixed_perks[i] : level.fixed_perks );
		players[i] thread player_perks();
	}
}

function player_perks()
{
	self.fixed_perks_given = 0;

	self.perk_index = 0;

	while(self.perk_index < self.fixed_perks.size)
	{
		self waittill("fixed_random_perk");
		self.perk_index++;
	}

	self.fixed_perks_given = 1;
}