#using scripts\shared\array_shared;
#using scripts\shared\flag_shared;
#using scripts\zm\_zm_spawner;
#using scripts\zm\_zm_zonemgr;
#using scripts\shared\clientfield_shared;

//custom scripts

#using scripts\zm\array_override\abh_locations;
#using scripts\zm\array_override\bgb_common;
#using scripts\zm\array_override\bgb_cycle;
#using scripts\zm\array_override\fixed_ai_spawns;
#using scripts\zm\array_override\fixed_margwa_spawns;
#using scripts\zm\array_override\initial_spawn_points;
#using scripts\zm\array_override\fixed_specific_powerups;

#using scripts\zm\array_override\zod\zod_craftable_locations;
#using scripts\zm\array_override\zod\starting_pods;

#using scripts\zm\array_override\castle\keeper_route;
#using scripts\zm\array_override\castle\wisps;
#using scripts\zm\array_override\castle\void_symbols;
#using scripts\zm\array_override\castle\rune_prison_fireplace;
#using scripts\zm\array_override\castle\castle_tram_powerup;
#using scripts\zm\array_override\castle\boss_mechz_spawn_point;

#using scripts\zm\array_override\island\fixed_island_challenges;
#using scripts\zm\array_override\island\skull_pedastals;

#using scripts\zm\array_override\stalingrad\bombs;
#using scripts\zm\array_override\stalingrad\challenge_module;
#using scripts\zm\array_override\stalingrad\gersch;
#using scripts\zm\array_override\stalingrad\mangler;
#using scripts\zm\array_override\stalingrad\modules;
#using scripts\zm\array_override\stalingrad\stalingrad_challenges;

#using scripts\zm\array_override\genesis\fixed_genesis_challenges;
#using scripts\zm\array_override\genesis\keeper_stone;
#using scripts\zm\array_override\genesis\keeper_parts;

#using scripts\zm\array_override\moon\fixed_digger;

#using scripts\zm\array_override\tomb\templar_target;
#using scripts\zm\array_override\tomb\fixed_ice_tiles;
#using scripts\zm\array_override\tomb\fixed_digsites;

#using scripts\zm\script_override\craftable_locations;
#using scripts\zm\script_override\fixed_random_perks;
#using scripts\zm\script_override\forced_drops;
#using scripts\zm\script_override\bgb_machine_override;
#using scripts\zm\script_override\tomb\fixed_crypt_discs;

#using scripts\zm\variable_override\fixed_special_rounds;

#using scripts\zm\variable_override\tomb\vinyl_locations;
#using scripts\zm\variable_override\tomb\ice_weather_fix;

#using scripts\zm\variable_override\zod\idgun_pieces;
#using scripts\zm\variable_override\zod\zod_margwa_rounds;
#using scripts\zm\variable_override\fixed_meatball_count;

#using scripts\zm\variable_override\stalingrad\stalingrad_overrides;
#using scripts\zm\variable_override\island_overrides;

#using scripts\zm\hud\zm_hud_ee_patch;
//#using scripts\zm\hud\enemy_counter;
#using scripts\zm\hud\rocket_test_timer;

//#using scripts\zm\hud\bot_testing;

#insert scripts\shared\shared.gsh;

#namespace ee_patch;


function start()
{
	//thread bot_testing::bot();
	//thread debug();
	//thread stalingrad_debug();
	//thread zone_monitor_name();
	//thread zone_monitor_origin();

	thread array_override();
	thread script_override();
	thread variable_override();
	//thread custom_spawn_detection();
}

function array_override()
{
	thread bgb_common::using_megas();

	bgb_cycle::init();
	abh_locations::init();

	fixed_ai_spawns::init();
	fixed_margwa_spawns::init();
	
	initial_spawn_points::init();
	fixed_specific_powerups::init();

	// ZOD
	zod_starting_pods::init();
	zod_craftable_locations::init();

	// CASTLE
	castle_keeper_route::init();
	castle_wisps::init();
	void_symbols::init();
	castle_tram_powerup::init();
	rune_prison_fireplace::init();
	boss_mechz_spawn_point::init();

	// ISLAND
	fixed_island_challenges::init();
	island_skull_pedastals::init();

	// STALINGRAD
	bombs::init();
	challenge_module::init();
	gersch::init();
	mangler::init();
	modules::init();
	stalingrad_challenges::init();

	// GENESIS
	fixed_genesis_challenges::init();
	genesis_keeper_parts::init();
	keeper_stone::init();

	// MOON
	fixed_digger::init();

	// TOMB
	templar_target::init();
	fixed_ice_tiles::init();
	fixed_digsites::init();
}

function script_override()
{
	thread bgb_machine_override::init();
	thread fixed_random_perks::init();
	thread fixed_crypt_discs::init();
	forced_drops::init();
	craftable_locations::init();

	// free first bgb even offline
	SetDvar("scr_firstGumFree",1);
	SetDvar("zm_private_rankedmatch",1);

	level flag::wait_till("initial_blackscreen_passed");

	thread show_custom_hud_elements();
}

// any map specifics such as special rounds

function variable_override(map)
{
	map_specific_vars();

	zod_idgun_pieces::init();
	zod_margwa_rounds::init();

	tomb_vinyl_locations::init();
	ice_weather_fix::init();
}
function map_specific_vars()
{
	switch (GetDvarString("mapname"))
	{
		case "zm_zod":
			thread fixed_special_rounds::zod_bug_rounds();
			thread fixed_meatball_count::monitor_meatball_count();
			break;
		case "zm_factory":
			thread fixed_special_rounds::factory_dog_rounds();
			break;
		case "zm_castle":
			thread fixed_special_rounds::castle_dog_rounds();
			break;
		case "zm_island":
			thread fixed_special_rounds::island_spider_rounds();
			thread island_overrides::main();
			break;
		case "zm_stalingrad":
			thread fixed_special_rounds::stalingrad_sentinel_rounds();
			thread stalingrad_overrides::main();
			break;
		case "zm_genesis":
			break;
		case "zm_prototype":
			break;
		case "zm_asylum":
			break;
		case "zm_sumpf":
			break;
		case "zm_theater":
			thread fixed_special_rounds::factory_dog_rounds();
			break;
		case "zm_cosmodrome":
			break;
		case "zm_temple":
			break;
		case "zm_moon":
			break;
		case "zm_tomb":
			break;
	}
}

function show_custom_hud_elements()
{
	host = GetPlayers()[0];

	thread zm_hud_ee_patch::init();
	//thread enemy_counter::init();
	thread rocket_test_timer::main();
}

function zone_monitor_name()
{
    while (1)
    {
        player = GetPlayers()[0];
        zone = zm_zonemgr::get_zone_from_position(player.origin + VectorScale((0, 0, 1), 32), 1);
        IPrintLnBold("Zone: " + zone);
        wait 2.5;
    }
}

function zone_monitor_origin()
{
	while(1)
	
{		org = GetPlayers()[0].origin;
		str = "( " + org[0] + " , " + org[1] + " , " + org[2] + " )";
		IPrintLn(str);
		wait 2.5;
	}
}

function debug()
{
	level.player_starting_points = 50000;

	level flag::wait_till("initial_blackscreen_passed");

	/*while(1)
	{
		enemies = GetAISpeciesArray(level.zombie_team, "all");
		foreach(enemy in enemies)
		{
			enemy DoDamage(enemy.health, enemy.origin);
		}
		wait 0.05;
	}*/
}

function stalingrad_debug()
{
	level flag::wait_till("initial_blackscreen_passed");

	level flag::set("generator_charged");
	level flag::set("generator_on");
	level flag::set("tube_puzzle_complete");
	level flag::set("ee_cylinder_acquired");
	level flag::set("key_placement");
	level flag::set("keys_placed");
}

function custom_spawn_detection()
{
	while(1)
	{
		spawn_locs = level.zm_loc_types["zombie_location"];
		if(!isdefined(level.n_player_spawn_selection_index))
		{
			level.n_player_spawn_selection_index = 0;
		}
		players = GetPlayers();
		level.n_player_spawn_selection_index++;
		if(level.n_player_spawn_selection_index >= players.size)
		{
			level.n_player_spawn_selection_index = 0;
		}
		curr_player = players[level.n_player_spawn_selection_index];
		ArraySortClosest(spawn_locs, curr_player.origin);
		spawn_candidates = [];
		player_angles = AnglesToForward(curr_player.angles);
		for(i = 0; i < spawn_locs.size; i++)
		{
			distance = spawn_locs[i].origin - curr_player.origin;
			dot_product = VectorDot(player_angles, distance);
			if(dot_product >= 0)
			{
				spawn_candidates[spawn_candidates.size] = spawn_locs[i];
				if(spawn_candidates.size > 10)
				{
					break;
				}
			}
		}
		if(spawn_candidates.size == 1)
		{
			// DEBUG
			foreach(spawn_loc in spawn_candidates)
			{
				IPrintLnBold("( " + spawn_loc.origin[0] + " , " + spawn_loc.origin[1] + " , " + spawn_loc.origin[2] + " )");
				wait 0.5;
			}
			// DEBUG
		}
		wait 0.1;
	}
}