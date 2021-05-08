#using scripts\codescripts\struct;
#using scripts\shared\ai\systems\gib;
#using scripts\shared\ai\zombie_utility;
#using scripts\shared\ai_shared;
#using scripts\shared\animation_shared;
#using scripts\shared\array_shared;
#using scripts\shared\callbacks_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\demo_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\flagsys_shared;
#using scripts\shared\fx_shared;
#using scripts\shared\laststand_shared;
#using scripts\shared\math_shared;
#using scripts\shared\scene_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;
#using scripts\shared\visionset_mgr_shared;
#using scripts\zm\_util;
#using scripts\zm\_zm;
#using scripts\zm\_zm_audio;
#using scripts\zm\_zm_hero_weapon;
#using scripts\zm\_zm_laststand;
#using scripts\zm\_zm_net;
#using scripts\zm\_zm_score;
#using scripts\zm\_zm_spawner;
#using scripts\zm\_zm_utility;
#using scripts\zm\_zm_weap_annihilator;
#using scripts\zm\_zm_weapons;

#namespace namespace_f55b6585;

/*
	Name: __init__sytem__
	Namespace: namespace_f55b6585
	Checksum: 0x6A13479B
	Offset: 0x598
	Size: 0x3B
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("keeper_skull", &__init__, &__main__, undefined);
}

/*
	Name: __init__
	Namespace: namespace_f55b6585
	Checksum: 0x1436F9D2
	Offset: 0x5E0
	Size: 0x223
	Parameters: 0
	Flags: None
*/
function __init__()
{
	clientfield::register("toplayer", "skull_beam_fx", 9000, 2, "int");
	clientfield::register("toplayer", "skull_torch_fx", 9000, 2, "int");
	clientfield::register("allplayers", "skull_beam_3p_fx", 9000, 2, "int");
	clientfield::register("allplayers", "skull_torch_3p_fx", 9000, 2, "int");
	clientfield::register("allplayers", "skull_emissive", 9000, 1, "int");
	clientfield::register("actor", "death_ray_shock_eye_fx", 9000, 1, "int");
	clientfield::register("actor", "entranced", 9000, 1, "int");
	clientfield::register("actor", "thrasher_skull_fire", 9000, 1, "int");
	clientfield::register("actor", "zombie_explode", 9000, 1, "int");
	level.var_c003f5b = GetWeapon("skull_gun");
	level.var_1f1a653b = GetWeapon("skull_gun_1");
	zm_hero_weapon::register_hero_weapon("skull_gun");
	zm_hero_weapon::register_hero_weapon("skull_gun_1");
}

/*
	Name: __main__
	Namespace: namespace_f55b6585
	Checksum: 0x2FEFDB02
	Offset: 0x810
	Size: 0x23
	Parameters: 0
	Flags: None
*/
function __main__()
{
	callback::on_connect(&function_3028b9ff);
}

/*
	Name: function_3028b9ff
	Namespace: namespace_f55b6585
	Checksum: 0xA3F1B38E
	Offset: 0x840
	Size: 0x113
	Parameters: 0
	Flags: None
*/
function function_3028b9ff()
{
	self flag::init("has_skull");
	self.var_118ab24e = 100;
	self.var_e1f8edd6 = 0;
	self.var_141d363e = 0;
	self.var_9adfaccf = 0;
	self thread function_de235a27();
	self thread function_e703c25f();
	self thread watch_weapon_change();
	self thread function_eadaeb18();
	self thread function_6a46a0e0();
	self thread function_2dda41f5();
	self thread function_6b7bd037();
	self thread watch_player_death();
}

/*
	Name: watch_player_death
	Namespace: namespace_f55b6585
	Checksum: 0x604AEE1C
	Offset: 0x960
	Size: 0x67
	Parameters: 0
	Flags: None
*/
function watch_player_death()
{
	self endon("disconnect");
	while(1)
	{
		self waittill("bled_out");
		if(self flag::get("has_skull"))
		{
			self flag::clear("has_skull");
		}
	}
}

/*
	Name: function_6b7bd037
	Namespace: namespace_f55b6585
	Checksum: 0xDB6173D4
	Offset: 0x9D0
	Size: 0x8F
	Parameters: 0
	Flags: None
*/
function function_6b7bd037()
{
	self endon("disconnect");
	while(1)
	{
		if(self HasWeapon(level.var_c003f5b))
		{
			self.var_118ab24e = self GadgetPowerGet(0);
			if(self.var_118ab24e == 100)
			{
				self SetWeaponAmmoClip(level.var_c003f5b, 100);
			}
		}
		wait(0.05);
	}
}

/*
	Name: function_2dda41f5
	Namespace: namespace_f55b6585
	Checksum: 0x5088D8A1
	Offset: 0xA68
	Size: 0xED
	Parameters: 0
	Flags: None
*/
function function_2dda41f5()
{
	self endon("disconnect");
	if(isdefined(level.var_615d751))
	{
		self flag::wait_till("has_skull");
	}
	var_18e42304 = 1;
	while(1)
	{
		var_e18bd995 = self GadgetPowerGet(0);
		if(var_e18bd995 == 100 && var_18e42304 == 0)
		{
			if(!self laststand::player_is_in_laststand())
			{
				self notify("hash_dcf8ab17");
				var_18e42304 = 1;
				wait(30);
			}
		}
		else if(var_e18bd995 < 100)
		{
			var_18e42304 = 0;
		}
		wait(1);
	}
}

/*
	Name: function_de235a27
	Namespace: namespace_f55b6585
	Checksum: 0x530B3081
	Offset: 0xB60
	Size: 0x1F7
	Parameters: 0
	Flags: None
*/
function function_de235a27()
{
	self endon("disconnect");
	if(isdefined(level.var_615d751))
	{
		self flag::wait_till("has_skull");
	}
	while(1)
	{
		self util::waittill_attack_button_pressed();
		if(self function_97d08b97())
		{
			if(!self.var_e1f8edd6 && !self IsMeleeing())
			{
				self clientfield::set_to_player("skull_beam_fx", 1);
				self clientfield::set("skull_beam_3p_fx", 1);
				self function_123162a2();
				while(self util::attack_button_held() && self function_97d08b97() && !self.var_e1f8edd6 && self.var_118ab24e)
				{
					if(!self.var_9adfaccf)
					{
						self thread function_23e997f4();
					}
					self function_123162a2();
					wait(0.05);
				}
				self.var_9adfaccf = 0;
				self clientfield::set_to_player("skull_beam_fx", 0);
				self clientfield::set("skull_beam_3p_fx", 0);
			}
		}
		wait(0.05);
		self thread function_e00bc70a();
	}
}

/*
	Name: function_23e997f4
	Namespace: namespace_f55b6585
	Checksum: 0x2FF4797D
	Offset: 0xD60
	Size: 0x8B
	Parameters: 0
	Flags: None
*/
function function_23e997f4()
{
	self endon("disconnect");
	self.var_9adfaccf = 1;
	wait(0.1);
	if(self util::attack_button_held() && !self.var_e1f8edd6)
	{
		self clientfield::set_to_player("skull_beam_fx", 2);
		self clientfield::set("skull_beam_3p_fx", 2);
	}
}

/*
	Name: function_123162a2
	Namespace: namespace_f55b6585
	Checksum: 0x3C5F3C21
	Offset: 0xDF8
	Size: 0x17D
	Parameters: 0
	Flags: None
*/
function function_123162a2()
{
	a_zombies = GetAITeamArray(level.zombie_team);
	a_targets = util::get_array_of_closest(self.origin, a_zombies, undefined, 8, 500);
	for(i = 0; i < a_targets.size; i++)
	{
		if(isalive(a_targets[i]))
		{
			if(a_targets[i].var_20b8c74a !== 1 && (!isdefined(a_targets[i].var_3f6ea790) && a_targets[i].var_3f6ea790) && self function_fb77a973(a_targets[i]) && (!isdefined(a_targets[i].thrasherConsumed) && a_targets[i].thrasherConsumed))
			{
				a_targets[i].var_20b8c74a = 1;
				self thread function_32afe89a(a_targets[i]);
				wait(0.05);
			}
		}
	}
}

/*
	Name: function_f51dbd0a
	Namespace: namespace_f55b6585
	Checksum: 0xE31EFD8B
	Offset: 0xF80
	Size: 0x233
	Parameters: 0
	Flags: None
*/
function function_f51dbd0a()
{
	self notify("hash_f51dbd0a");
	self endon("hash_f51dbd0a");
	self endon("death");
	if(isdefined(self.isInMantleAction) && self.isInMantleAction)
	{
		var_553c631c = 1;
	}
	wait(0.05);
	self waittill("hash_2766d719");
	if(!isdefined(var_553c631c) && var_553c631c && !self zm::in_enabled_playable_area())
	{
		if(isdefined(self.chunk) && isdefined(self.first_node.zbarrier))
		{
			if(self.first_node.zbarrier GetZBarrierPieceState(self.chunk) == "opening")
			{
				self.first_node.zbarrier SetZBarrierPieceState(self.chunk, "open");
			}
			else
			{
				self.first_node.zbarrier SetZBarrierPieceState(self.chunk, "closed");
			}
		}
	}
	else if(isdefined(var_553c631c) && var_553c631c && isdefined(self.first_node) && isdefined(self.saved_attacking_spot_index))
	{
		forwardVec = AnglesToForward(self.first_node.angles);
		var_9f8b01da = self.first_node.attack_spots[self.saved_attacking_spot_index] + forwardVec * 75;
		var_9f8b01da = GetClosestPointOnNavMesh(var_9f8b01da);
		self ForceTeleport(var_9f8b01da, self GetAngles());
	}
}

/*
	Name: function_32afe89a
	Namespace: namespace_f55b6585
	Checksum: 0xC1314E25
	Offset: 0x11C0
	Size: 0x62B
	Parameters: 1
	Flags: None
*/
function function_32afe89a(ai_zombie)
{
	self endon("disconnect");
	ai_zombie endon("death");
	if(ai_zombie.archetype === "zombie" || (isdefined(ai_zombie.var_61f7b3a0) && ai_zombie.var_61f7b3a0))
	{
		ai_zombie thread zombie_utility::zombie_eye_glow_stop();
		ai_zombie clientfield::set("death_ray_shock_eye_fx", 1);
		if(isalive(ai_zombie) && (!isdefined(ai_zombie.var_61f7b3a0) && ai_zombie.var_61f7b3a0))
		{
			if(ai_zombie IsPlayingAnimScripted())
			{
				ai_zombie StopAnimScripted(0.3);
				wait(0.1);
			}
			ai_zombie thread scene::Play("cin_zm_dlc1_zombie_dth_deathray_04", ai_zombie);
			ai_zombie thread function_f51dbd0a();
		}
	}
	var_9ae6d5f2 = 0;
	while(self util::attack_button_held() && self function_97d08b97() && !self.var_e1f8edd6 && self.var_118ab24e)
	{
		if(isdefined(ai_zombie.var_3940f450) && ai_zombie.var_3940f450)
		{
			self function_4aedb20b(1);
			ai_zombie DoDamage(ai_zombie.health, ai_zombie.origin, self);
			break;
		}
		ai_zombie.var_20b8c74a = 1;
		if(ai_zombie.archetype === "zombie" || (isdefined(ai_zombie.var_61f7b3a0) && ai_zombie.var_61f7b3a0))
		{
			ai_zombie thread zm_audio::zmbAIVox_PlayVox(ai_zombie, "skull_scream", 1, 11);
			wait(1);
		}
		else
		{
			wait(3);
		}
		if(self util::attack_button_held() && self function_97d08b97() && !self.var_e1f8edd6 && self.var_118ab24e)
		{
			if(ai_zombie.archetype === "zombie")
			{
				ai_zombie clientfield::set("death_ray_shock_eye_fx", 0);
				self notify("hash_f93e3181");
				ai_zombie zombie_utility::zombie_head_gib(self);
				ai_zombie playsound("evt_zombie_skull_breathe");
			}
			wait(0.05);
			if(isdefined(ai_zombie.var_61f7b3a0) && ai_zombie.var_61f7b3a0)
			{
				if(var_9ae6d5f2 == 0)
				{
					ai_zombie clientfield::set("thrasher_skull_fire", 1);
				}
				if(var_9ae6d5f2 < ai_zombie.thrasherSpores.size)
				{
					if(!ai_zombie.thrasherIsBerserk)
					{
						ai_zombie.thrasherRageCount = 0;
					}
					var_9d06d0ea = ai_zombie.thrasherSpores[var_9ae6d5f2];
					self function_4aedb20b(3);
					ai_zombie DoDamage(var_9d06d0ea.health, ai_zombie GetTagOrigin(var_9d06d0ea.tag), self);
					var_9ae6d5f2++;
					ai_zombie.thrasherRageCount = 0;
				}
			}
			else
			{
				self function_4aedb20b(2);
				ai_zombie thread function_e31d6184();
				ai_zombie clientfield::set("zombie_explode", 1);
				ai_zombie DoDamage(ai_zombie.health, ai_zombie.origin, self);
			}
		}
	}
	ai_zombie.var_20b8c74a = 0;
	if(ai_zombie.archetype === "zombie" || (isdefined(ai_zombie.var_61f7b3a0) && ai_zombie.var_61f7b3a0))
	{
		ai_zombie notify("hash_2766d719");
		ai_zombie thread scene::stop("cin_zm_dlc1_zombie_dth_deathray_04");
		ai_zombie thread zombie_utility::zombie_eye_glow();
		ai_zombie clientfield::set("death_ray_shock_eye_fx", 0);
		if(isdefined(ai_zombie.var_61f7b3a0) && ai_zombie.var_61f7b3a0)
		{
			ai_zombie clientfield::set("thrasher_skull_fire", 0);
		}
	}
}

/*
	Name: function_e31d6184
	Namespace: namespace_f55b6585
	Checksum: 0x2AE805A3
	Offset: 0x17F8
	Size: 0xCB
	Parameters: 0
	Flags: None
*/
function function_e31d6184()
{
	wait(0.05);
	if(isdefined(self))
	{
		if(math::cointoss())
		{
			GibServerUtils::GibHead(self);
		}
		if(math::cointoss())
		{
			GibServerUtils::GibLeftArm(self);
		}
		if(math::cointoss())
		{
			GibServerUtils::GibRightArm(self);
		}
		if(math::cointoss())
		{
			GibServerUtils::GibLegs(self);
		}
		self zombie_utility::zombie_gut_explosion();
	}
}

/*
	Name: function_e703c25f
	Namespace: namespace_f55b6585
	Checksum: 0xEE4EC7E2
	Offset: 0x18D0
	Size: 0x44F
	Parameters: 0
	Flags: None
*/
function function_e703c25f()
{
	self endon("disconnect");
	if(isdefined(level.var_615d751))
	{
		self flag::wait_till("has_skull");
	}
	while(1)
	{
		if(self util::ads_button_held())
		{
			if(!self function_97d08b97())
			{
				while(self AdsButtonPressed())
				{
					wait(0.05);
				}
			}
			else if(self.var_118ab24e && !self AttackButtonPressed() && !self.var_e1f8edd6 && !self IsMeleeing())
			{
				if(!self.var_141d363e)
				{
					self.var_141d363e = 1;
					self clientfield::set_to_player("skull_torch_fx", 1);
					self clientfield::set("skull_torch_3p_fx", 1);
					self clientfield::set("skull_emissive", 1);
					self thread function_993fa661();
				}
				a_zombies = GetAITeamArray(level.zombie_team);
				a_targets = util::get_array_of_closest(self.origin, a_zombies, undefined, undefined, 500);
				foreach(ai_zombie in a_targets)
				{
					if(ai_zombie.var_9b59d7f8 !== 1 && self function_5fa274c1(ai_zombie) && ai_zombie.completed_emerging_into_playable_area === 1 && (!isdefined(ai_zombie.thrasherConsumed) && ai_zombie.thrasherConsumed) && (!isdefined(ai_zombie.var_3f6ea790) && ai_zombie.var_3f6ea790))
					{
						self thread function_c2e953fb(ai_zombie);
						self notify("hash_54bb0e43");
					}
				}
				wait(0.05);
			}
			else
			{
				self.var_141d363e = 0;
				self clientfield::set_to_player("skull_torch_fx", 0);
				self clientfield::set("skull_torch_3p_fx", 0);
				self clientfield::set("skull_emissive", 0);
			}
		}
		else
		{
			self.var_141d363e = 0;
			if(self clientfield::get_to_player("skull_torch_fx"))
			{
				self clientfield::set_to_player("skull_torch_fx", 0);
			}
			if(self clientfield::get("skull_torch_3p_fx"))
			{
				self clientfield::set("skull_torch_3p_fx", 0);
			}
			if(self clientfield::get("skull_emissive"))
			{
				self clientfield::set("skull_emissive", 0);
			}
		}
		wait(0.05);
	}
}

/*
	Name: function_993fa661
	Namespace: namespace_f55b6585
	Checksum: 0x55FECCA4
	Offset: 0x1D28
	Size: 0x8B
	Parameters: 0
	Flags: None
*/
function function_993fa661()
{
	self endon("disconnect");
	self endon("weapon_change");
	wait(0.1);
	if(self util::ads_button_held() && !self.var_e1f8edd6)
	{
		self clientfield::set_to_player("skull_torch_fx", 2);
		self clientfield::set("skull_torch_3p_fx", 2);
	}
}

/*
	Name: function_c2e953fb
	Namespace: namespace_f55b6585
	Checksum: 0xC74EE972
	Offset: 0x1DC0
	Size: 0x33B
	Parameters: 1
	Flags: None
*/
function function_c2e953fb(ai_zombie)
{
	self endon("disconnect");
	ai_zombie endon("death");
	while(self util::ads_button_held() && self.var_118ab24e && self function_5fa274c1(ai_zombie) && !self.var_9adfaccf && self function_97d08b97())
	{
		if(ai_zombie.var_9b59d7f8 !== 1)
		{
			ai_zombie.var_9b59d7f8 = 1;
			if(!(isdefined(ai_zombie.var_3940f450) && ai_zombie.var_3940f450))
			{
				ai_zombie thread zombie_utility::zombie_eye_glow_stop();
				ai_zombie clientfield::set("entranced", 1);
				ai_zombie thread function_3fca87eb();
			}
			else if(isdefined(ai_zombie.var_b4e06d32) && ai_zombie.var_b4e06d32)
			{
				ai_zombie clientfield::set("spider_glow_fx", 1);
				ai_zombie flag::set("spider_from_mars_identified");
				if(isdefined(level.var_5f1b87ca))
				{
					self [[level.var_5f1b87ca]]();
				}
			}
			else
			{
				ai_zombie SetGoal(ai_zombie.origin);
				ai_zombie ai::set_ignoreall(1);
			}
		}
		wait(0.05);
	}
	ai_zombie.var_9b59d7f8 = 0;
	ai_zombie ai::set_ignoreall(0);
	if(!(isdefined(ai_zombie.var_3940f450) && ai_zombie.var_3940f450))
	{
		ai_zombie thread zombie_utility::zombie_eye_glow();
		ai_zombie clientfield::set("entranced", 0);
		ai_zombie notify("hash_11c32d95");
		if(ai_zombie IsPlayingAnimScripted())
		{
			ai_zombie StopAnimScripted(0.3);
		}
	}
	else if(isdefined(ai_zombie.var_b4e06d32) && ai_zombie.var_b4e06d32 && (!isdefined(ai_zombie.var_f7522faa) && ai_zombie.var_f7522faa))
	{
		ai_zombie clientfield::set("spider_glow_fx", 0);
	}
}

/*
	Name: function_3fca87eb
	Namespace: namespace_f55b6585
	Checksum: 0x491CBC43
	Offset: 0x2108
	Size: 0x8F
	Parameters: 0
	Flags: None
*/
function function_3fca87eb()
{
	self endon("death");
	self endon("hash_11c32d95");
	n_index = randomIntRange(1, 7);
	while(1)
	{
		self thread animation::Play("ai_zm_dlc2_zombie_pacified_by_skullgun_" + n_index, self);
		wait(getanimlength("ai_zm_dlc2_zombie_pacified_by_skullgun_" + n_index));
	}
}

/*
	Name: function_5fa274c1
	Namespace: namespace_f55b6585
	Checksum: 0xF9E2B8EB
	Offset: 0x21A0
	Size: 0x47
	Parameters: 1
	Flags: None
*/
function function_5fa274c1(ai_zombie)
{
	if(Distance2DSquared(self.origin, ai_zombie.origin) <= 250000)
	{
		return 1;
	}
	return 0;
}

/*
	Name: function_fb77a973
	Namespace: namespace_f55b6585
	Checksum: 0xB8A93A
	Offset: 0x21F0
	Size: 0x85
	Parameters: 1
	Flags: None
*/
function function_fb77a973(ai_zombie)
{
	ai_zombie endon("death");
	if(self util::is_player_looking_at(ai_zombie.origin, 0.85, 0))
	{
		return 1;
	}
	if(self util::is_player_looking_at(ai_zombie GetCentroid(), 0.85, 0))
	{
		return 1;
	}
	return 0;
}

/*
	Name: function_3f3f64e9
	Namespace: namespace_f55b6585
	Checksum: 0xCA8620CF
	Offset: 0x2280
	Size: 0x75
	Parameters: 1
	Flags: None
*/
function function_3f3f64e9(var_fff2323a)
{
	if(self util::is_player_looking_at(var_fff2323a.origin, 0.85, 0))
	{
		return 1;
	}
	if(self util::is_player_looking_at(var_fff2323a GetCentroid(), 0.85, 0))
	{
		return 1;
	}
	return 0;
}

/*
	Name: function_6a46a0e0
	Namespace: namespace_f55b6585
	Checksum: 0xFD60FB63
	Offset: 0x2300
	Size: 0x20B
	Parameters: 0
	Flags: None
*/
function function_6a46a0e0()
{
	self endon("disconnect");
	while(1)
	{
		if(!self function_97d08b97())
		{
			self waittill("weapon_change");
			if(self.sessionstate != "spectator")
			{
				w_current = self GetCurrentWeapon();
				if(isdefined(w_current) && zm_utility::is_hero_weapon(w_current))
				{
					self.var_230f31ae = 1;
					self thread function_79e34741();
					wait(1);
				}
			}
		}
		if(self function_97d08b97() && (isdefined(self.var_230f31ae) && self.var_230f31ae))
		{
			if(self.sessionstate != "spectator")
			{
				self SetWeaponAmmoClip(level.var_c003f5b, Int(self.var_118ab24e));
				if(self util::ads_button_held() || self util::attack_button_held())
				{
					if(self.var_118ab24e > 0)
					{
						self GadgetPowerSet(0, self.var_118ab24e - 0.15);
					}
					else
					{
						self GadgetPowerSet(0, 0);
						self SetWeaponAmmoClip(level.var_c003f5b, 0);
						self zm_weapons::switch_back_primary_weapon(undefined, 1);
						self.var_230f31ae = 0;
					}
				}
			}
		}
		wait(0.05);
	}
}

/*
	Name: function_79e34741
	Namespace: namespace_f55b6585
	Checksum: 0xD706CA31
	Offset: 0x2518
	Size: 0xAB
	Parameters: 0
	Flags: None
*/
function function_79e34741()
{
	self endon("disconnect");
	while(1)
	{
		if(self WeaponSwitchButtonPressed())
		{
			self.var_230f31ae = 0;
			self GadgetPowerSet(0, self.var_118ab24e - 2);
			self SetWeaponAmmoClip(level.var_c003f5b, 0);
			self GadgetDeactivate(0, level.var_c003f5b);
			break;
		}
		wait(0.05);
	}
}

/*
	Name: function_97d08b97
	Namespace: namespace_f55b6585
	Checksum: 0xE7665754
	Offset: 0x25D0
	Size: 0x4F
	Parameters: 0
	Flags: None
*/
function function_97d08b97()
{
	w_current = self GetCurrentWeapon();
	if(w_current == level.var_c003f5b || w_current == level.var_1f1a653b)
	{
		return 1;
	}
	return 0;
}

/*
	Name: watch_weapon_change
	Namespace: namespace_f55b6585
	Checksum: 0x6841EDB4
	Offset: 0x2628
	Size: 0x5F
	Parameters: 0
	Flags: None
*/
function watch_weapon_change()
{
	self endon("disconnect");
	while(1)
	{
		if(self WeaponSwitchButtonPressed() || self.var_118ab24e < 1)
		{
			self function_e00bc70a();
		}
		wait(0.05);
	}
}

/*
	Name: function_eadaeb18
	Namespace: namespace_f55b6585
	Checksum: 0x97AACB83
	Offset: 0x2690
	Size: 0x3F
	Parameters: 0
	Flags: None
*/
function function_eadaeb18()
{
	self endon("disconnect");
	while(1)
	{
		self waittill("weapon_change_complete");
		self function_e00bc70a();
	}
}

/*
	Name: function_e00bc70a
	Namespace: namespace_f55b6585
	Checksum: 0x77462E92
	Offset: 0x26D8
	Size: 0x143
	Parameters: 0
	Flags: None
*/
function function_e00bc70a()
{
	if(self clientfield::get_to_player("skull_beam_fx"))
	{
		self clientfield::set_to_player("skull_beam_fx", 0);
	}
	else if(self clientfield::get_to_player("skull_torch_fx"))
	{
		self clientfield::set_to_player("skull_torch_fx", 0);
		self clientfield::set("skull_torch_3p_fx", 0);
		self clientfield::set("skull_emissive", 0);
	}
	if(self clientfield::get("skull_beam_3p_fx"))
	{
		self clientfield::set("skull_beam_3p_fx", 0);
	}
	else if(self clientfield::get("skull_torch_3p_fx"))
	{
		self clientfield::set("skull_torch_3p_fx", 0);
	}
}

/*
	Name: function_4aedb20b
	Namespace: namespace_f55b6585
	Checksum: 0x2BC66AD9
	Offset: 0x2828
	Size: 0x6F
	Parameters: 1
	Flags: None
*/
function function_4aedb20b(var_4ed57dca)
{
	if(self.var_118ab24e >= var_4ed57dca)
	{
		self GadgetPowerSet(0, self.var_118ab24e - var_4ed57dca);
	}
	else
	{
		self GadgetPowerSet(0, 0);
		self.var_230f31ae = 0;
	}
}

