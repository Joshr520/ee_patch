#using scripts\shared\array_shared;
#using scripts\shared\callbacks_shared;
#using scripts\shared\flag_shared;
#using scripts\zm\_zm_utility;
#using scripts\shared\ai\zombie_utility;
#using scripts\zm\hud\hud_common;

#insert scripts\zm\hud\hud_common.gsh;

#using scripts\shared\spawner_shared;
#using scripts\zm\_zm_spawner;

#namespace zombie_counter;

#precache( "lui_menu_data", "zombie_count_total" );
#precache( "lui_menu_data", "zombie_count_current" );

function init()
{
	thread main();
}

function main()
{
	level flag::wait_till("initial_players_connected");
	update_zombie_counter();
	level waittill("start_zombie_round_logic");
	array::thread_all(level.zombie_spawners, &spawner::add_spawn_function, &update_zombie_counter);
	zm_spawner::register_zombie_death_event_callback(&update_zombie_counter);
	level waittill("end_game");
	array::thread_all(level.zombie_spawners, &spawner::remove_spawn_function, &update_zombie_counter);
	zm_spawner::deregister_zombie_death_event_callback(&update_zombie_counter);
}

function update_zombie_counter(e_attacker)
{
	//if(self.archetype !== "zombie")	return;

	current = zombie_utility::get_current_zombie_count();
	total = level.zombie_total + current;

	foreach (player in level.players)
	{
		player SetControllerUIModelValue("zombie_count_total",total);
		player SetControllerUIModelValue("zombie_count_current",current);
	}
}