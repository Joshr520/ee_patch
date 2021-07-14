#using scripts\shared\flag_shared;
#using scripts\shared\util_shared;
#using scripts\shared\clientfield_shared;

#namespace fixed_crypt_discs;

function init()
{
	if (GetDvarString("mapname") == "zm_tomb")
	{
		thread main();
	}
}

function main()
{
	level flag::wait_till("disc_rotation_active");
	wait 2;
	//level flag::wait_till_clear("disc_rotation_active");

	discs = GetEntArray("crypt_puzzle_disc", "script_noteworthy");
	change_discs(discs, array(2,0,2,0));
	
	level flag::wait_till("staff_water_upgrade_unlocked");

	discs = GetEntArray("crypt_puzzle_disc", "script_noteworthy");
	change_discs(discs, array(1,3,1,3));

	level flag::wait_till("staff_air_upgrade_unlocked");

	change_discs(discs, array(3,1,3,1));

	level flag::wait_till("staff_lightning_upgrade_unlocked");

	change_discs(discs, array(0,2,0,2));
}

function change_discs(discs, pos)
{
	prev_disc_pos = 0;
	foreach(index, disc in discs)
	{
		if(!isdefined(disc.target))
		{
			continue;
		}
		if(disc.position != pos[index-1]) disc.position = pos[index-1];
		wait 2;
	}
	move_all_discs(discs);
}

function move_all_discs(discs)
{
	if(!isdefined(discs))
	{
		discs = undefined;
	}
	//level flag::set("disc_rotation_active");
	if(!isdefined(discs))
	{
		discs = GetEntArray("chamber_puzzle_disc", "script_noteworthy");
	}
	foreach(e_disc in discs)
	{
		e_disc move_disc();
	}
	//level flag::clear("disc_rotation_active");
}

function move_disc()
{
	new_angles = (self.angles[0], self.position * 90, self.angles[2]);
	self RotateTo(new_angles, 1, 0, 0);
	self PlaySound("zmb_crypt_disc_turn");
	wait(1 * 0.75);
	self bryce_cake_light_update(0);
	wait(1 * 0.25);
	self bryce_cake_light_update(0);
	self PlaySound("zmb_crypt_disc_stop");
	rumble_nearby_players(self.origin, 1000, 2);
}

function bryce_cake_light_update(b_on)
{
	if(!isdefined(b_on))
	{
		b_on = 1;
	}
	if(!isdefined(self.n_bryce_cake))
	{
		self.n_bryce_cake = 0;
	}
	if(!b_on)
	{
		self.n_bryce_cake = self.n_bryce_cake + 1 % 2;
	}
	else
	{
		self.n_bryce_cake = 2;
	}
	if(isdefined(self.var_b1c02d8a))
	{
		self.var_b1c02d8a clientfield::set("bryce_cake", self.n_bryce_cake);
	}
}

function rumble_nearby_players(v_center, n_range, n_rumble_enum)
{
	n_range_sq = n_range * n_range;
	a_players = GetPlayers();
	a_rumbled_players = [];
	foreach(e_player in a_players)
	{
		if(DistanceSquared(v_center, e_player.origin) < n_range_sq)
		{
			e_player clientfield::set_to_player("player_rumble_and_shake", n_rumble_enum);
			a_rumbled_players[a_rumbled_players.size] = e_player;
		}
	}
	util::wait_network_frame();
	foreach(e_player in a_rumbled_players)
	{
		e_player clientfield::set_to_player("player_rumble_and_shake", 0);
	}
}