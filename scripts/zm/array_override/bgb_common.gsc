#using scripts\shared\flag_shared;


#namespace bgb_common;

function get_lobby_index()
{
	players = GetPlayers();
	for (i=0;i<players.size;i++)
	{
		if (players[i] == self)
			return i;
	}
}

function using_megas(str = "cycle",a_abh)
{
	//level.bgb_array will be defined and populated in the array_shared script once the player spins his first bgb
	level flag::init("bgb_loadout_determined");
	level flag::init("using_megas");
	level flag::init("bgb_megas_done");
	while(!isdefined(level.bgb_array))
	{
		wait 1;
	}

	//if Reign Drops and Wall Power aren't being used, it's safe to assume the player is using Classics
	if (IsInArray(level.bgb_array,"zm_bgb_reign_drops") || IsInArray(level.bgb_array,"zm_bgb_wall_power"))
	{
		level flag::set("using_megas");
		if (str == "cycle") level.bgb_fixed_cycles = level.bgb_cycles_m;
		else if (str == "abh")
		{
			level.desired_zones = a_abh;
			level.next_abh = level.desired_zones[level.abh_index];
		}
	}
	level flag::set("bgb_loadout_determined");
}