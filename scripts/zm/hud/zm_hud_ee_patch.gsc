#using scripts\shared\callbacks_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\lui_shared;

//#using scripts\zm\hud\beastcode_hud;
#using scripts\zm\hud\zombie_counter;
//#using scripts\zm\hud\playable_area_timer;
//#using scripts\zm\hud\override_function_counter;

#namespace zm_hud_ee_patch;

#precache( "lui_menu", "T7Hud_zm_ee_patch" );

function init()
{
	//playable_area_timer::init();

	//override_function_counter::init();

	//beastcode_hud::init();
	zombie_counter::init();

	callback::on_spawned( &on_player_spawned );
}

function private on_player_spawned()
{
	self.zm_ee_patch_hud = self OpenLUIMenu("T7Hud_zm_ee_patch");
}