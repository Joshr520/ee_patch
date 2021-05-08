#using scripts\codescripts\struct;
#using scripts\shared\ai\systems\gib;
#using scripts\shared\flag_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;
#using scripts\zm\_zm_bgb;
#using scripts\zm\_zm_lightning_chain;
#using scripts\zm\_zm_powerups;
#using scripts\zm\_zm_utility;

#namespace namespace_112fb534;

/*
	Name: __init__sytem__
	Namespace: namespace_112fb534
	Checksum: 0x5D6D53E0
	Offset: 0x1D8
	Size: 0x33
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("zm_bgb_pop_shocks", &__init__, undefined, "bgb");
}

/*
	Name: __init__
	Namespace: namespace_112fb534
	Checksum: 0x45DDD2C6
	Offset: 0x218
	Size: 0xA3
	Parameters: 0
	Flags: None
*/
function __init__()
{
	if(!(isdefined(level.bgb_in_use) && level.bgb_in_use))
	{
		return;
	}
	bgb::register("zm_bgb_pop_shocks", "event", &event, undefined, undefined, undefined);
	bgb::function_3422638b("zm_bgb_pop_shocks", &actor_damage_override);
	bgb::function_e22c6124("zm_bgb_pop_shocks", &vehicle_damage_override);
}

/*
	Name: event
	Namespace: namespace_112fb534
	Checksum: 0x235259FA
	Offset: 0x2C8
	Size: 0x4F
	Parameters: 0
	Flags: None
*/
function event()
{
	self endon("disconnect");
	self endon("death");
	self endon("hash_994d5e9e");
	self.var_69d5dd7c = 5;
	while(self.var_69d5dd7c > 0)
	{
		wait(0.1);
	}
}

/*
	Name: actor_damage_override
	Namespace: namespace_112fb534
	Checksum: 0xAB421B3C
	Offset: 0x320
	Size: 0x8F
	Parameters: 12
	Flags: None
*/
function actor_damage_override(inflictor, attacker, damage, flags, meansOfDeath, weapon, vPoint, vDir, sHitLoc, psOffsetTime, boneIndex, surfaceType)
{
	if(meansOfDeath === "MOD_MELEE")
	{
		attacker function_e0e68a99(self);
	}
	return damage;
}

/*
	Name: vehicle_damage_override
	Namespace: namespace_112fb534
	Checksum: 0x8B94DF9E
	Offset: 0x3B8
	Size: 0xA7
	Parameters: 15
	Flags: None
*/
function vehicle_damage_override(eInflictor, eAttacker, iDamage, iDFlags, sMeansOfDeath, weapon, vPoint, vDir, sHitLoc, vDamageOrigin, psOffsetTime, damageFromUnderneath, modelIndex, partName, vSurfaceNormal)
{
	if(sMeansOfDeath === "MOD_MELEE")
	{
		eAttacker function_e0e68a99(self);
	}
	return iDamage;
}

/*
	Name: function_e0e68a99
	Namespace: namespace_112fb534
	Checksum: 0xB40BFF8C
	Offset: 0x468
	Size: 0x1C9
	Parameters: 1
	Flags: None
*/
function function_e0e68a99(target)
{
	if(isdefined(self.beastmode) && self.beastmode)
	{
		return;
	}
	self bgb::do_one_shot_use();
	self.var_69d5dd7c = self.var_69d5dd7c - 1;
	self bgb::set_timer(self.var_69d5dd7c, 5);
	self playsound("zmb_bgb_popshocks_impact");
	zombie_list = GetAITeamArray(level.zombie_team);
	foreach(ai in zombie_list)
	{
		if(!isdefined(ai) || !isalive(ai))
		{
			continue;
		}
		test_origin = ai GetCentroid();
		dist_sq = DistanceSquared(target.origin, test_origin);
		if(dist_sq < 16384)
		{
			self thread function_20654ca0(ai);
		}
	}
}

/*
	Name: function_20654ca0
	Namespace: namespace_112fb534
	Checksum: 0x4D924C41
	Offset: 0x640
	Size: 0xC3
	Parameters: 1
	Flags: None
*/
function function_20654ca0(ai)
{
	self endon("disconnect");
	if(!isdefined(ai) || !isalive(ai))
	{
		return;
	}
	ai notify("bhtn_action_notify", "electrocute");
	if(!isdefined(self.tesla_enemies_hit))
	{
		self.tesla_enemies_hit = 1;
	}
	function_3e9ddcc7();
	ai.tesla_death = 0;
	ai thread function_fe8a580e(self);
	ai thread tesla_death();
}

/*
	Name: function_3e9ddcc7
	Namespace: namespace_112fb534
	Checksum: 0x2FBCB64C
	Offset: 0x710
	Size: 0x5F
	Parameters: 0
	Flags: None
*/
function function_3e9ddcc7()
{
	level.var_96e991b8 = lightning_chain::create_lightning_chain_params(5);
	level.var_96e991b8.head_gib_chance = 100;
	level.var_96e991b8.network_death_choke = 4;
	level.var_96e991b8.should_kill_enemies = 0;
}

/*
	Name: function_fe8a580e
	Namespace: namespace_112fb534
	Checksum: 0x2DA98F28
	Offset: 0x778
	Size: 0x53
	Parameters: 1
	Flags: None
*/
function function_fe8a580e(player)
{
	player endon("disconnect");
	if(isdefined(self.zombie_tesla_hit) && self.zombie_tesla_hit)
	{
		return;
	}
	self lightning_chain::arc_damage_ent(player, 1, level.var_96e991b8);
}

/*
	Name: tesla_death
	Namespace: namespace_112fb534
	Checksum: 0xB398D8D7
	Offset: 0x7D8
	Size: 0x53
	Parameters: 0
	Flags: None
*/
function tesla_death()
{
	self endon("death");
	self thread function_862aadab(1);
	wait(2);
	self DoDamage(self.health + 1, self.origin);
}

/*
	Name: function_862aadab
	Namespace: namespace_112fb534
	Checksum: 0xB70D9173
	Offset: 0x838
	Size: 0x133
	Parameters: 1
	Flags: None
*/
function function_862aadab(random_gibs)
{
	self waittill("death");
	if(isdefined(self) && IsActor(self))
	{
		if(!random_gibs || RandomInt(100) < 50)
		{
			GibServerUtils::GibHead(self);
		}
		if(!random_gibs || RandomInt(100) < 50)
		{
			GibServerUtils::GibLeftArm(self);
		}
		if(!random_gibs || RandomInt(100) < 50)
		{
			GibServerUtils::GibRightArm(self);
		}
		if(!random_gibs || RandomInt(100) < 50)
		{
			GibServerUtils::GibLegs(self);
		}
	}
}

