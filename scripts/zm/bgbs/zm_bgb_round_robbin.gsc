#using scripts\codescripts\struct;
#using scripts\shared\ai\zombie_utility;
#using scripts\shared\flag_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;
#using scripts\zm\_zm_bgb;
#using scripts\zm\_zm_powerups;
#using scripts\zm\_zm_score;
#using scripts\zm\_zm_utility;

#namespace namespace_98efd7b6;

/*
	Name: __init__sytem__
	Namespace: namespace_98efd7b6
	Checksum: 0x23F7AA0A
	Offset: 0x1C8
	Size: 0x33
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("zm_bgb_round_robbin", &__init__, undefined, "bgb");
}

/*
	Name: __init__
	Namespace: namespace_98efd7b6
	Checksum: 0x25FAEC89
	Offset: 0x208
	Size: 0x63
	Parameters: 0
	Flags: None
*/
function __init__()
{
	if(!(isdefined(level.bgb_in_use) && level.bgb_in_use))
	{
		return;
	}
	bgb::register("zm_bgb_round_robbin", "activated", 1, undefined, undefined, &validation, &activation);
}

/*
	Name: validation
	Namespace: namespace_98efd7b6
	Checksum: 0x8B874073
	Offset: 0x278
	Size: 0xB1
	Parameters: 0
	Flags: None
*/
function validation()
{
	if(!level flag::get("spawn_zombies"))
	{
		return 0;
	}
	zombies = GetAITeamArray(level.zombie_team);
	if(!isdefined(zombies) || zombies.size < 1)
	{
		return 0;
	}
	if(isdefined(level.var_35efa94c))
	{
		if(![[level.var_35efa94c]]())
		{
			return 0;
		}
	}
	if(isdefined(level.var_dfd95560) && level.var_dfd95560)
	{
		return 0;
	}
	return 1;
}

/*
	Name: activation
	Namespace: namespace_98efd7b6
	Checksum: 0xFA8FA683
	Offset: 0x338
	Size: 0x101
	Parameters: 0
	Flags: None
*/
function activation()
{
	level.var_dfd95560 = 1;
	round_number = level.round_number;
	function_8824774d(level.round_number + 1);
	foreach(player in level.players)
	{
		if(zm_utility::is_player_valid(player))
		{
			multiplier = zm_score::get_points_multiplier(player);
			player zm_score::add_to_player_score(multiplier * 1600);
		}
	}
	wait 2;
	while(level.round_number != round_number + 1) function_8824774d(level.round_number + 1);
}

/*
	Name: function_b10a9b0c
	Namespace: namespace_98efd7b6
	Checksum: 0x5ADE134F
	Offset: 0x448
	Size: 0x85
	Parameters: 1
	Flags: None
*/
function function_b10a9b0c(zombie)
{
	if(!isdefined(zombie))
	{
		return 0;
	}
	if(isdefined(zombie.ignore_round_robbin_death) && zombie.ignore_round_robbin_death || (isdefined(zombie.marked_for_death) && zombie.marked_for_death) || zm_utility::is_magic_bullet_shield_enabled(zombie))
	{
		return 0;
	}
	return 1;
}

/*
	Name: function_8824774d
	Namespace: namespace_98efd7b6
	Checksum: 0x4ADBD36B
	Offset: 0x4D8
	Size: 0x2E1
	Parameters: 1
	Flags: None
*/
function function_8824774d(target_round)
{
	if(target_round < 1)
	{
		target_round = 1;
	}
	level.zombie_total = 0;
	zombie_utility::ai_calculate_health(target_round);
	level.round_number = target_round - 1;
	level notify("kill_round");
	playsoundatposition("zmb_bgb_round_robbin", (0, 0, 0));
	wait(0.1);
	zombies = GetAITeamArray(level.zombie_team);
	for(i = 0; i < zombies.size; i++)
	{
		if(isdefined(zombies[i].ignore_round_robbin_death) && zombies[i].ignore_round_robbin_death)
		{
			ArrayRemoveValue(zombies, zombies[i]);
		}
	}
	if(isdefined(zombies))
	{
		e_last = undefined;
		foreach(zombie in zombies)
		{
			if(function_b10a9b0c(zombie))
			{
				e_last = zombie;
			}
		}
		if(isdefined(e_last))
		{
			level.last_ai_origin = e_last.origin;
			level notify("last_ai_down", e_last);
		}
	}
	util::wait_network_frame();
	if(isdefined(zombies))
	{
		foreach(zombie in zombies)
		{
			if(!function_b10a9b0c(zombie))
			{
				continue;
			}
			zombie DoDamage(zombie.health + 666, zombie.origin);
		}
	}
	level.var_dfd95560 = undefined;
}