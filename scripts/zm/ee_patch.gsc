#using scripts\shared\array_shared;
#using scripts\shared\flag_shared;
#using scripts\zm\_zm_spawner;
#using scripts\zm\_zm_zonemgr;

//custom scripts

#using scripts\zm\array_override\abh_locations;
#using scripts\zm\array_override\bgb_common;
#using scripts\zm\array_override\bgb_cycle;
#using scripts\zm\array_override\fixed_ai_spawns;
#using scripts\zm\array_override\fixed_margwa_spawns;

#using scripts\zm\array_override\zod\zod_craftable_locations;
#using scripts\zm\array_override\zod\starting_pods;

#using scripts\zm\array_override\castle\keeper_route;
#using scripts\zm\array_override\castle\wisps;
#using scripts\zm\array_override\castle\void_symbols;
#using scripts\zm\array_override\castle\rune_prison_fireplace;
#using scripts\zm\array_override\castle\castle_tram_powerup;

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

#using scripts\zm\script_override\craftable_locations;
#using scripts\zm\script_override\fixed_random_perks;
#using scripts\zm\script_override\forced_drops;
#using scripts\zm\script_override\bgb_machine_override;

#using scripts\zm\variable_override\fixed_special_rounds;

#using scripts\zm\variable_override\tomb\vinyl_locations;
#using scripts\zm\variable_override\tomb\ice_weather_fix;

#using scripts\zm\variable_override\zod\idgun_pieces;
#using scripts\zm\variable_override\zod\zod_margwa_rounds;
#using scripts\zm\variable_override\fixed_meatball_count;

#using scripts\zm\variable_override\stalingrad_overrides;
#using scripts\zm\variable_override\island_overrides;

//#using scripts\zm\hud\zombie_counter;
#using scripts\zm\hud\enemy_counter;
#using scripts\zm\hud\zombie_timer;

#using scripts\zm\hud\player_healthbar;

//#using scripts\zm\hud\bot_testing;

#insert scripts\shared\shared.gsh;

#namespace ee_patch;


function start()
{
	thread player_healthbar::init();
	//thread bot_testing::bot();
	thread debug();
	//thread zone_monitor_name();
	//thread zone_monitor_origin();

	thread array_override();
	thread script_override();
	thread variable_override();
}

function array_override()
{
	thread bgb_common::using_megas();

	bgb_cycle::init();
	abh_locations::init();

	fixed_ai_spawns::init();
	fixed_margwa_spawns::init();

	// ZOD
	zod_starting_pods::init();
	zod_craftable_locations::init();

	// CASTLE
	castle_keeper_route::init();
	castle_wisps::init();
	void_symbols::init();
	castle_tram_powerup::init();
	rune_prison_fireplace::init();

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
}

function script_override()
{
	thread bgb_machine_override::init();
	thread fixed_random_perks::main();
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

	//thread zombie_counter::init();
	thread enemy_counter::init();
	thread zombie_timer::init();
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
	{
		org = GetPlayers()[0].origin;
		str = "( " + org[0] + " , " + org[1] + " , " + org[2] + " )";
		IPrintLnBold(str);
		wait 2.5;
	}
}

function debug()
{
	level.player_starting_points = 50000;
}
