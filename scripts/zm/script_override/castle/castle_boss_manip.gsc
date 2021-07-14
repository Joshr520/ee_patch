#using scripts\zm\zm_castle_ee_bossfight;
#using scripts\shared\flag_shared;

#namespace castle_boss_manip;

function init()
{
	if (!GetDvarString("mapname") == "zm_castle")
	{
		return;
	}

	level flag::wait_till("boss_fight_begin");
	IPrintLnBold("Manip Starting");
}

function boss_manip()
{
	while(!isdefined(self.var_41c1a53f)) wait 0.1;

	while(isdefined(self.var_41c1a53f))
	{
		wait 0.1;
		IPrintLnBold(self.var_41c1a53f.size);
		self.var_41c1a53f[0] = &namespace_b1bc995c::function_74d4ae55;
		self.var_41c1a53f[1] = &namespace_b1bc995c::function_f6b53f16;
		self.var_41c1a53f[2] = &namespace_b1bc995c::function_74d4ae55;
		self.var_41c1a53f[3] = &namespace_b1bc995c::function_f6b53f16;
	}
}