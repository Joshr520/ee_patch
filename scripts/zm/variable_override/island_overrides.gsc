#using scripts\shared\flag_shared;

#namespace island_overrides;

function main()
{
	thread modify_bullet_plant();
}

function modify_bullet_plant()
{
	while(!isdefined(level.var_df105f37) || level.var_df105f37 == 50)
	{
		if(!(level flag::get("trilogy_released") && !level flag::get("aa_gun_ee_complete") && !level flag::get("player_has_aa_gun_ammo") && !level flag::get("aa_gun_ammo_loaded"))) wait 0.1;
		else if(isdefined(level.var_df105f37)) level.var_df105f37 = 100;
	}
}