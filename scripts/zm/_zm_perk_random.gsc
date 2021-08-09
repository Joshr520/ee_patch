#using scripts\shared\array_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\flagsys_shared;
#using scripts\shared\scene_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;
#using scripts\zm\_zm_devgui;
#using scripts\zm\_zm_equipment;
#using scripts\zm\_zm_perks;
#using scripts\zm\_zm_score;
#using scripts\zm\_zm_stats;
#using scripts\zm\_zm_unitrigger;
#using scripts\zm\_zm_utility;

#namespace zm_perk_random;

/*
	Name: __init__sytem__
	Namespace: zm_perk_random
	Checksum: 0x283C952E
	Offset: 0x6D0
	Size: 0x3B
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("zm_perk_random", &__init__, &__main__, undefined);
}

/*
	Name: __init__
	Namespace: zm_perk_random
	Checksum: 0x77CF1E8D
	Offset: 0x718
	Size: 0x24B
	Parameters: 0
	Flags: None
*/
function __init__()
{
	level._random_zombie_perk_cost = 1500;
	clientfield::register("scriptmover", "perk_bottle_cycle_state", 5000, 2, "int");
	clientfield::register("zbarrier", "set_client_light_state", 5000, 2, "int");
	clientfield::register("zbarrier", "client_stone_emmissive_blink", 5000, 1, "int");
	clientfield::register("zbarrier", "init_perk_random_machine", 5000, 1, "int");
	clientfield::register("scriptmover", "turn_active_perk_light_green", 5000, 1, "int");
	clientfield::register("scriptmover", "turn_on_location_indicator", 5000, 1, "int");
	clientfield::register("zbarrier", "lightning_bolt_FX_toggle", 10000, 1, "int");
	clientfield::register("scriptmover", "turn_active_perk_ball_light", 5000, 1, "int");
	clientfield::register("scriptmover", "zone_captured", 5000, 1, "int");
	level._effect["perk_machine_light_yellow"] = "dlc1/castle/fx_wonder_fizz_light_yellow";
	level._effect["perk_machine_light_red"] = "dlc1/castle/fx_wonder_fizz_light_red";
	level._effect["perk_machine_light_green"] = "dlc1/castle/fx_wonder_fizz_light_green";
	level._effect["perk_machine_location"] = "fx/zombie/fx_wonder_fizz_lightning_all";
	level flag::init("machine_can_reset");
}

/*
	Name: __main__
	Namespace: zm_perk_random
	Checksum: 0xFD3D7909
	Offset: 0x970
	Size: 0x6B
	Parameters: 0
	Flags: None
*/
function __main__()
{
	if(!isdefined(level.perk_random_machine_count))
	{
		level.perk_random_machine_count = 1;
	}
	if(!isdefined(level.perk_random_machine_state_func))
	{
		level.perk_random_machine_state_func = &process_perk_random_machine_state;
	}
	/#
		level thread setup_devgui();
	#/
	level thread setup_perk_random_machines();
}

/*
	Name: setup_perk_random_machines
	Namespace: zm_perk_random
	Checksum: 0x3552057F
	Offset: 0x9E8
	Size: 0x7B
	Parameters: 0
	Flags: Private
*/
function private setup_perk_random_machines()
{
	waittillframeend;
	level.perk_bottle_weapon_array = ArrayCombine(level.machine_assets, level._custom_perks, 0, 1);
	level.perk_random_machines = GetEntArray("perk_random_machine", "targetname");
	level.perk_random_machine_count = level.perk_random_machines.size;
	perk_random_machine_init();
}

/*
	Name: perk_random_machine_init
	Namespace: zm_perk_random
	Checksum: 0x21374172
	Offset: 0xA70
	Size: 0x14B
	Parameters: 0
	Flags: None
*/
function perk_random_machine_init()
{
	foreach(machine in level.perk_random_machines)
	{
		if(!isdefined(machine.cost))
		{
			machine.cost = 1500;
		}
		machine.current_perk_random_machine = 0;
		machine.uses_at_current_location = 0;
		machine create_perk_random_machine_unitrigger_stub();
		machine clientfield::set("init_perk_random_machine", 1);
		wait(0.5);
		machine thread set_perk_random_machine_state("power_off");
	}
	//level.perk_random_machines = Array::randomize(level.perk_random_machines);
	init_starting_perk_random_machine_location();
}

/*
	Name: init_starting_perk_random_machine_location
	Namespace: zm_perk_random
	Checksum: 0x3C8889CF
	Offset: 0xBC8
	Size: 0x13D
	Parameters: 0
	Flags: Private
*/
function private init_starting_perk_random_machine_location()
{
	b_starting_machine_found = 0;
	for(i = 0; i < level.perk_random_machines.size; i++)
	{
		if(i == 0)
		{
			level.perk_random_machines[i].current_perk_random_machine = 1;
			level.perk_random_machines[i] thread machine_think();
			level.perk_random_machines[i] thread set_perk_random_machine_state("initial");
			b_starting_machine_found = 1;
			continue;
		}
		level.perk_random_machines[i] thread wait_for_power();
	}
}

/*
	Name: create_perk_random_machine_unitrigger_stub
	Namespace: zm_perk_random
	Checksum: 0x2ACF63F4
	Offset: 0xD10
	Size: 0x183
	Parameters: 0
	Flags: None
*/
function create_perk_random_machine_unitrigger_stub()
{
	self.unitrigger_stub = spawnstruct();
	self.unitrigger_stub.script_width = 70;
	self.unitrigger_stub.script_height = 30;
	self.unitrigger_stub.script_length = 40;
	self.unitrigger_stub.origin = self.origin + AnglesToRight(self.angles) * self.unitrigger_stub.script_length + anglesToUp(self.angles) * self.unitrigger_stub.script_height / 2;
	self.unitrigger_stub.angles = self.angles;
	self.unitrigger_stub.script_unitrigger_type = "unitrigger_box_use";
	self.unitrigger_stub.trigger_target = self;
	zm_unitrigger::unitrigger_force_per_player_triggers(self.unitrigger_stub, 1);
	self.unitrigger_stub.prompt_and_visibility_func = &perk_random_machine_trigger_update_prompt;
	self.unitrigger_stub.script_int = self.script_int;
	thread zm_unitrigger::register_static_unitrigger(self.unitrigger_stub, &perk_random_unitrigger_think);
}

/*
	Name: perk_random_machine_trigger_update_prompt
	Namespace: zm_perk_random
	Checksum: 0x690433B2
	Offset: 0xEA0
	Size: 0x8F
	Parameters: 1
	Flags: None
*/
function perk_random_machine_trigger_update_prompt(player)
{
	can_use = self perk_random_machine_stub_update_prompt(player);
	if(isdefined(self.hint_string))
	{
		if(isdefined(self.hint_parm1))
		{
			self setHintString(self.hint_string, self.hint_parm1);
		}
		else
		{
			self setHintString(self.hint_string);
		}
	}
	return can_use;
}

/*
	Name: perk_random_machine_stub_update_prompt
	Namespace: zm_perk_random
	Checksum: 0xAAC49FB4
	Offset: 0xF38
	Size: 0x277
	Parameters: 1
	Flags: None
*/
function perk_random_machine_stub_update_prompt(player)
{
	self setcursorhint("HINT_NOICON");
	if(!self trigger_visible_to_player(player))
	{
		return 0;
	}
	self.hint_parm1 = undefined;
	n_power_on = is_power_on(self.stub.script_int);
	if(!n_power_on)
	{
		self.hint_string = &"ZOMBIE_NEED_POWER";
		return 0;
	}
	else if(self.stub.trigger_target.State == "idle" || self.stub.trigger_target.State == "vending")
	{
		n_purchase_limit = player zm_utility::get_player_perk_purchase_limit();
		if(!player zm_utility::can_player_purchase_perk())
		{
			self.hint_string = &"ZOMBIE_RANDOM_PERK_TOO_MANY";
			if(isdefined(n_purchase_limit))
			{
				self.hint_parm1 = n_purchase_limit;
			}
			return 0;
		}
		else if(isdefined(self.stub.trigger_target.machine_user))
		{
			if(isdefined(self.stub.trigger_target.grab_perk_hint) && self.stub.trigger_target.grab_perk_hint)
			{
				self.hint_string = &"ZOMBIE_RANDOM_PERK_PICKUP";
				return 1;
			}
			else
			{
				self.hint_string = "";
				return 0;
			}
		}
		else
		{
			n_purchase_limit = player zm_utility::get_player_perk_purchase_limit();
			if(!player zm_utility::can_player_purchase_perk())
			{
				self.hint_string = &"ZOMBIE_RANDOM_PERK_TOO_MANY";
				if(isdefined(n_purchase_limit))
				{
					self.hint_parm1 = n_purchase_limit;
				}
				return 0;
			}
			else
			{
				self.hint_string = &"ZOMBIE_RANDOM_PERK_BUY";
				self.hint_parm1 = level._random_zombie_perk_cost;
				return 1;
			}
		}
	}
	else
	{
		self.hint_string = &"ZOMBIE_RANDOM_PERK_ELSEWHERE";
		return 0;
	}
}

/*
	Name: trigger_visible_to_player
	Namespace: zm_perk_random
	Checksum: 0xD1353C47
	Offset: 0x11B8
	Size: 0x127
	Parameters: 1
	Flags: None
*/
function trigger_visible_to_player(player)
{
	self SetInvisibleToPlayer(player);
	visible = 1;
	if(isdefined(self.stub.trigger_target.machine_user))
	{
		if(player != self.stub.trigger_target.machine_user || zm_utility::is_placeable_mine(self.stub.trigger_target.machine_user GetCurrentWeapon()))
		{
			visible = 0;
		}
	}
	else if(!player can_buy_perk())
	{
		visible = 0;
	}
	if(!visible)
	{
		return 0;
	}
	if(player player_has_all_available_perks())
	{
		return 0;
	}
	self SetVisibleToPlayer(player);
	return 1;
}

/*
	Name: player_has_all_available_perks
	Namespace: zm_perk_random
	Checksum: 0x2A91E080
	Offset: 0x12E8
	Size: 0x57
	Parameters: 0
	Flags: None
*/
function player_has_all_available_perks()
{
	for(i = 0; i < level._random_perk_machine_perk_list.size; i++)
	{
		if(!self hasPerk(level._random_perk_machine_perk_list[i]))
		{
			return 0;
		}
	}
	return 1;
}

/*
	Name: can_buy_perk
	Namespace: zm_perk_random
	Checksum: 0xCFD7DDCA
	Offset: 0x1348
	Size: 0xA3
	Parameters: 0
	Flags: None
*/
function can_buy_perk()
{
	if(isdefined(self.IS_DRINKING) && self.IS_DRINKING > 0)
	{
		return 0;
	}
	current_weapon = self GetCurrentWeapon();
	if(zm_utility::is_placeable_mine(current_weapon) || zm_equipment::is_equipment_that_blocks_purchase(current_weapon))
	{
		return 0;
	}
	if(self zm_utility::in_revive_trigger())
	{
		return 0;
	}
	if(current_weapon == level.weaponNone)
	{
		return 0;
	}
	return 1;
}

/*
	Name: perk_random_unitrigger_think
	Namespace: zm_perk_random
	Checksum: 0x257050EF
	Offset: 0x13F8
	Size: 0x53
	Parameters: 1
	Flags: None
*/
function perk_random_unitrigger_think(player)
{
	self endon("kill_trigger");
	while(1)
	{
		self waittill("trigger", player);
		self.stub.trigger_target notify("trigger", player);
	}
}

/*
	Name: machine_think
	Namespace: zm_perk_random
	Checksum: 0xE47E3542
	Offset: 0x1458
	Size: 0x66F
	Parameters: 0
	Flags: None
*/
function machine_think()
{
	level notify("machine_think");
	level endon("machine_think");
	self.num_time_used = 0;
	self.num_til_moved = randomIntRange(3, 7);
	if(self.State !== "initial" || "idle")
	{
		self thread set_perk_random_machine_state("arrive");
		self waittill("arrived");
		self thread set_perk_random_machine_state("initial");
		wait(1);
	}
	if(isdefined(level.zm_custom_perk_random_power_flag))
	{
		level flag::wait_till(level.zm_custom_perk_random_power_flag);
		break;
	}
	while(!is_power_on(self.script_int))
	{
		wait(1);
	}
	self thread set_perk_random_machine_state("idle");
	if(isdefined(level.bottle_spawn_location))
	{
		level.bottle_spawn_location delete();
	}
	level.bottle_spawn_location = spawn("script_model", self.origin);
	level.bottle_spawn_location SetModel("tag_origin");
	level.bottle_spawn_location.angles = self.angles;
	level.bottle_spawn_location.origin = level.bottle_spawn_location.origin + VectorScale((0, 0, 1), 65);
	while(1)
	{
		self waittill("trigger", player);
		level flag::clear("machine_can_reset");
		if(!player zm_score::can_player_purchase(level._random_zombie_perk_cost))
		{
			self playsound("evt_perk_deny");
			continue;
		}
		self.machine_user = player;
		self.num_time_used++;
		player zm_stats::increment_client_stat("use_perk_random");
		player zm_stats::increment_player_stat("use_perk_random");
		player zm_score::minus_to_player_score(level._random_zombie_perk_cost);
		self thread set_perk_random_machine_state("vending");
		if(isdefined(level.perk_random_vo_func_usemachine) && isdefined(player))
		{
			player thread [[level.perk_random_vo_func_usemachine]]();
		}
		while(1)
		{
			random_perk = get_weighted_random_perk(player);
			self playsound("zmb_rand_perk_start");
			self PlayLoopSound("zmb_rand_perk_loop", 1);
			wait(1);
			self notify("bottle_spawned");
			self thread start_perk_bottle_cycling();
			self thread perk_bottle_motion();
			model = get_perk_weapon_model(random_perk);
			wait(3);
			self notify("done_cycling");
			if(self.num_time_used >= self.num_til_moved && level.perk_random_machine_count > 1)
			{
				level.bottle_spawn_location SetModel("wpn_t7_zmb_perk_bottle_bear_world");
				self StopLoopSound(0.5);
				self thread set_perk_random_machine_state("leaving");
				wait(3);
				player zm_score::add_to_player_score(level._random_zombie_perk_cost);
				level.bottle_spawn_location SetModel("tag_origin");
				self thread machine_selector();
				self clientfield::set("lightning_bolt_FX_toggle", 0);
				self.machine_user = undefined;
				break;
			}
			else
			{
				level.bottle_spawn_location SetModel(model);
			}
			self playsound("zmb_rand_perk_bottle");
			self.grab_perk_hint = 1;
			self thread grab_check(player, random_perk);
			self thread time_out_check();
			self util::waittill_either("grab_check", "time_out_check");
			self.grab_perk_hint = 0;
			self playsound("zmb_rand_perk_stop");
			self StopLoopSound(0.5);
			self.machine_user = undefined;
			level.bottle_spawn_location SetModel("tag_origin");
			self thread set_perk_random_machine_state("idle");
			break;
		}
		level flag::wait_till("machine_can_reset");
	}
}

/*
	Name: grab_check
	Namespace: zm_perk_random
	Checksum: 0xCA803AD6
	Offset: 0x1AD0
	Size: 0x263
	Parameters: 2
	Flags: None
*/
function grab_check(player, random_perk)
{
	self endon("time_out_check");
	perk_is_bought = 0;
	while(!perk_is_bought)
	{
		self waittill("trigger", e_triggerer);
		if(e_triggerer == player)
		{
			if(isdefined(player.IS_DRINKING) && player.IS_DRINKING > 0)
			{
				wait(0.1);
				continue;
			}
			if(player zm_utility::can_player_purchase_perk())
			{
				perk_is_bought = 1;
			}
			else
			{
				self playsound("evt_perk_deny");
				self notify("time_out_or_perk_grab");
				return;
			}
		}
	}
	player zm_stats::increment_client_stat("grabbed_from_perk_random");
	player zm_stats::increment_player_stat("grabbed_from_perk_random");
	player thread monitor_when_player_acquires_perk();
	self notify("grab_check");
	self notify("time_out_or_perk_grab");
	player notify("perk_purchased", random_perk);
	gun = player zm_perks::perk_give_bottle_begin(random_perk);
	evt = player util::waittill_any_ex("fake_death", "death", "player_downed", "weapon_change_complete", self, "time_out_check");
	if(evt == "weapon_change_complete")
	{
		player thread zm_perks::wait_give_perk(random_perk, 1);
	}
	player zm_perks::perk_give_bottle_end(gun, random_perk);
	if(!(isdefined(player.has_drunk_wunderfizz) && player.has_drunk_wunderfizz))
	{
		player.has_drunk_wunderfizz = 1;
	}
}

/*
	Name: monitor_when_player_acquires_perk
	Namespace: zm_perk_random
	Checksum: 0xFB5BF82B
	Offset: 0x1D40
	Size: 0x53
	Parameters: 0
	Flags: None
*/
function monitor_when_player_acquires_perk()
{
	self util::waittill_any("perk_acquired", "death_or_disconnect", "player_downed");
	level flag::set("machine_can_reset");
}

/*
	Name: time_out_check
	Namespace: zm_perk_random
	Checksum: 0x9D806B1
	Offset: 0x1DA0
	Size: 0x43
	Parameters: 0
	Flags: None
*/
function time_out_check()
{
	self endon("grab_check");
	wait(10);
	self notify("time_out_check");
	level flag::set("machine_can_reset");
}

/*
	Name: wait_for_power
	Namespace: zm_perk_random
	Checksum: 0xC5D5DDFB
	Offset: 0x1DF0
	Size: 0xB3
	Parameters: 0
	Flags: None
*/
function wait_for_power()
{
	if(isdefined(self.script_int))
	{
		str_wait = "power_on" + self.script_int;
		level flag::wait_till(str_wait);
	}
	else if(isdefined(level.zm_custom_perk_random_power_flag))
	{
		level flag::wait_till(level.zm_custom_perk_random_power_flag);
	}
	else
	{
		level flag::wait_till("power_on");
	}
	self thread set_perk_random_machine_state("away");
}

/*
	Name: machine_selector
	Namespace: zm_perk_random
	Checksum: 0xD9D79CEB
	Offset: 0x1EB0
	Size: 0xC3
	Parameters: 0
	Flags: None
*/
function machine_selector()
{
	if(level.perk_random_machines.size == 1)
	{
		new_machine = level.perk_random_machines[0];
		new_machine thread machine_think();
	}
	else
	{
		new_machine = level.perk_random_machines[RandomInt(level.perk_random_machines.size)];
		new_machine.current_perk_random_machine = 1;
		self.current_perk_random_machine = 0;
		wait(10);
		new_machine thread machine_think();
	}
	do
	{
	}
	while(!new_machine.current_perk_random_machine == 1);
}

/*
	Name: include_perk_in_random_rotation
	Namespace: zm_perk_random
	Checksum: 0xD2727DC5
	Offset: 0x1F80
	Size: 0x91
	Parameters: 1
	Flags: None
*/
function include_perk_in_random_rotation(perk)
{
	if(!isdefined(level._random_perk_machine_perk_list))
	{
		level._random_perk_machine_perk_list = [];
	}
	if(!isdefined(level._random_perk_machine_perk_list))
	{
		level._random_perk_machine_perk_list = [];
	}
	else if(!IsArray(level._random_perk_machine_perk_list))
	{
		level._random_perk_machine_perk_list = Array(level._random_perk_machine_perk_list);
	}
	level._random_perk_machine_perk_list[level._random_perk_machine_perk_list.size] = perk;
}

/*
	Name: get_weighted_random_perk
	Namespace: zm_perk_random
	Checksum: 0xEF6DF889
	Offset: 0x2020
	Size: 0x14B
	Parameters: 1
	Flags: None
*/
function get_weighted_random_perk(player)
{
	if (!player hasPerk("specialty_fastreload")) return "specialty_fastreload";
	if (!player hasPerk("specialty_armorvest")) return "specialty_armorvest";
	if (!player hasPerk("specialty_doubletap2")) return "specialty_doubletap2";
	if (!player hasPerk("specialty_widowswine")) return "specialty_widowswine";
	keys = Array::randomize(getArrayKeys(level._random_perk_machine_perk_list));
	if(isdefined(level.custom_random_perk_weights))
	{
		keys = player [[level.custom_random_perk_weights]]();
	}
	/#
		forced_perk = GetDvarString("Dev Block strings are not supported");
		if(forced_perk != "Dev Block strings are not supported" && isdefined(level._random_perk_machine_perk_list[forced_perk]))
		{
			ArrayInsert(keys, forced_perk, 0);
		}
	#/
	for(i = 0; i < keys.size; i++)
	{
		if(player hasPerk(level._random_perk_machine_perk_list[keys[i]]))
		{
			continue;
		}
		return level._random_perk_machine_perk_list[keys[i]];
	}
	return level._random_perk_machine_perk_list[keys[0]];
}

/*
	Name: perk_bottle_motion
	Namespace: zm_perk_random
	Checksum: 0x53B9C182
	Offset: 0x2178
	Size: 0x203
	Parameters: 0
	Flags: None
*/
function perk_bottle_motion()
{
	putOutTime = 3;
	putBackTime = 10;
	v_float = AnglesToForward(self.angles - (0, 90, 0)) * 10;
	level.bottle_spawn_location.origin = self.origin + (0, 0, 53);
	level.bottle_spawn_location.angles = self.angles;
	level.bottle_spawn_location.origin = level.bottle_spawn_location.origin - v_float;
	level.bottle_spawn_location moveto(level.bottle_spawn_location.origin + v_float, putOutTime, putOutTime * 0.5);
	level.bottle_spawn_location.angles = level.bottle_spawn_location.angles + (0, 0, 10);
	level.bottle_spawn_location RotateYaw(720, putOutTime, putOutTime * 0.5);
	self waittill("done_cycling");
	level.bottle_spawn_location.angles = self.angles;
	level.bottle_spawn_location moveto(level.bottle_spawn_location.origin - v_float, putBackTime, putBackTime * 0.5);
	level.bottle_spawn_location RotateYaw(90, putBackTime, putBackTime * 0.5);
}

/*
	Name: start_perk_bottle_cycling
	Namespace: zm_perk_random
	Checksum: 0xE398CB3C
	Offset: 0x2388
	Size: 0x131
	Parameters: 0
	Flags: None
*/
function start_perk_bottle_cycling()
{
	self endon("done_cycling");
	array_key = getArrayKeys(level.perk_bottle_weapon_array);
	timer = 0;
	while(1)
	{
		for(i = 0; i < array_key.size; i++)
		{
			if(isdefined(level.perk_bottle_weapon_array[array_key[i]].weapon))
			{
				model = GetWeaponModel(level.perk_bottle_weapon_array[array_key[i]].weapon);
			}
			else
			{
				model = GetWeaponModel(level.perk_bottle_weapon_array[array_key[i]].perk_bottle_weapon);
			}
			level.bottle_spawn_location SetModel(model);
			wait(0.2);
		}
	}
}

/*
	Name: get_perk_weapon_model
	Namespace: zm_perk_random
	Checksum: 0xF19FCA71
	Offset: 0x24C8
	Size: 0x91
	Parameters: 1
	Flags: None
*/
function get_perk_weapon_model(perk)
{
	weapon = level.machine_assets[perk].weapon;
	if(isdefined(level._custom_perks[perk]) && isdefined(level._custom_perks[perk].perk_bottle_weapon))
	{
		weapon = level._custom_perks[perk].perk_bottle_weapon;
	}
	return GetWeaponModel(weapon);
}

/*
	Name: perk_random_vending
	Namespace: zm_perk_random
	Checksum: 0xF1758D0F
	Offset: 0x2568
	Size: 0xCB
	Parameters: 0
	Flags: None
*/
function perk_random_vending()
{
	self clientfield::set("client_stone_emmissive_blink", 1);
	self thread perk_random_loop_anim(5, "opening", "opening");
	self thread perk_random_loop_anim(3, "closing", "closing");
	self thread perk_random_vend_sfx();
	self notify("vending");
	self waittill("bottle_spawned");
	self SetZBarrierPieceState(4, "opening");
}

/*
	Name: perk_random_loop_anim
	Namespace: zm_perk_random
	Checksum: 0x75256F3C
	Offset: 0x2640
	Size: 0xE3
	Parameters: 3
	Flags: None
*/
function perk_random_loop_anim(n_piece, s_anim_1, s_anim_2)
{
	self endon("zbarrier_state_change");
	current_state = self.State;
	while(self.State == current_state)
	{
		self SetZBarrierPieceState(n_piece, s_anim_1);
		while(self GetZBarrierPieceState(n_piece) == s_anim_1)
		{
			wait(0.05);
		}
		self SetZBarrierPieceState(n_piece, s_anim_2);
		while(self GetZBarrierPieceState(n_piece) == s_anim_2)
		{
			wait(0.05);
		}
	}
}

/*
	Name: perk_random_vend_sfx
	Namespace: zm_perk_random
	Checksum: 0x97A7402C
	Offset: 0x2730
	Size: 0x7B
	Parameters: 0
	Flags: None
*/
function perk_random_vend_sfx()
{
	self PlayLoopSound("zmb_rand_perk_sparks");
	level.bottle_spawn_location PlayLoopSound("zmb_rand_perk_vortex");
	self waittill("zbarrier_state_change");
	self StopLoopSound();
	level.bottle_spawn_location StopLoopSound();
}

/*
	Name: perk_random_initial
	Namespace: zm_perk_random
	Checksum: 0x559BEA0C
	Offset: 0x27B8
	Size: 0x23
	Parameters: 0
	Flags: None
*/
function perk_random_initial()
{
	self SetZBarrierPieceState(3, "opening");
}

/*
	Name: perk_random_idle
	Namespace: zm_perk_random
	Checksum: 0xB15CADC1
	Offset: 0x27E8
	Size: 0xA3
	Parameters: 0
	Flags: None
*/
function perk_random_idle()
{
	self clientfield::set("client_stone_emmissive_blink", 0);
	if(isdefined(level.perk_random_idle_effects_override))
	{
		self [[level.perk_random_idle_effects_override]]();
	}
	else
	{
		self clientfield::set("lightning_bolt_FX_toggle", 1);
		while(self.State == "idle")
		{
			wait(0.05);
		}
		self clientfield::set("lightning_bolt_FX_toggle", 0);
	}
}

/*
	Name: perk_random_arrive
	Namespace: zm_perk_random
	Checksum: 0xE8BC4486
	Offset: 0x2898
	Size: 0x41
	Parameters: 0
	Flags: None
*/
function perk_random_arrive()
{
	while(self GetZBarrierPieceState(0) == "opening")
	{
		wait(0.05);
	}
	self notify("arrived");
}

/*
	Name: perk_random_leaving
	Namespace: zm_perk_random
	Checksum: 0xF2E27F6C
	Offset: 0x28E8
	Size: 0x5B
	Parameters: 0
	Flags: None
*/
function perk_random_leaving()
{
	while(self GetZBarrierPieceState(0) == "closing")
	{
		wait(0.05);
	}
	wait(0.05);
	self thread set_perk_random_machine_state("away");
}

/*
	Name: set_perk_random_machine_state
	Namespace: zm_perk_random
	Checksum: 0x8EF1C898
	Offset: 0x2950
	Size: 0x87
	Parameters: 1
	Flags: None
*/
function set_perk_random_machine_state(State)
{
	wait(0.1);
	for(i = 0; i < self GetNumZBarrierPieces(); i++)
	{
		self HideZBarrierPiece(i);
	}
	self notify("zbarrier_state_change");
	self [[level.perk_random_machine_state_func]](State);
}

/*
	Name: process_perk_random_machine_state
	Namespace: zm_perk_random
	Checksum: 0x3C003421
	Offset: 0x29E0
	Size: 0x499
	Parameters: 1
	Flags: None
*/
function process_perk_random_machine_state(State)
{
	switch(State)
	{
		case "arrive":
		{
			self ShowZBarrierPiece(0);
			self ShowZBarrierPiece(1);
			self SetZBarrierPieceState(0, "opening");
			self SetZBarrierPieceState(1, "opening");
			self clientfield::set("set_client_light_state", 1);
			self thread perk_random_arrive();
			self.State = "arrive";
			break;
		}
		case "idle":
		{
			self ShowZBarrierPiece(5);
			self ShowZBarrierPiece(2);
			self SetZBarrierPieceState(2, "opening");
			self clientfield::set("set_client_light_state", 1);
			self.State = "idle";
			self thread perk_random_idle();
			break;
		}
		case "power_off":
		{
			self ShowZBarrierPiece(2);
			self SetZBarrierPieceState(2, "closing");
			self clientfield::set("set_client_light_state", 0);
			self.State = "power_off";
			break;
		}
		case "vending":
		{
			self ShowZBarrierPiece(5);
			self ShowZBarrierPiece(3);
			self ShowZBarrierPiece(4);
			self clientfield::set("set_client_light_state", 1);
			self.State = "vending";
			self thread perk_random_vending();
			break;
		}
		case "leaving":
		{
			self ShowZBarrierPiece(1);
			self ShowZBarrierPiece(0);
			self SetZBarrierPieceState(0, "closing");
			self SetZBarrierPieceState(1, "closing");
			self clientfield::set("set_client_light_state", 3);
			self thread perk_random_leaving();
			self.State = "leaving";
			break;
		}
		case "away":
		{
			self ShowZBarrierPiece(2);
			self SetZBarrierPieceState(2, "closing");
			self clientfield::set("set_client_light_state", 3);
			self.State = "away";
			break;
		}
		case "initial":
		{
			self ShowZBarrierPiece(3);
			self SetZBarrierPieceState(3, "opening");
			self ShowZBarrierPiece(5);
			self clientfield::set("set_client_light_state", 0);
			self.State = "initial";
			break;
		}
		default:
		{
			if(isdefined(level.custom_perk_random_state_handler))
			{
				self [[level.custom_perk_random_state_handler]](State);
			}
			break;
		}
	}
}

/*
	Name: machine_sounds
	Namespace: zm_perk_random
	Checksum: 0x99C56238
	Offset: 0x2E88
	Size: 0xE7
	Parameters: 0
	Flags: None
*/
function machine_sounds()
{
	level endon("machine_think");
	while(1)
	{
		level waittill("pmstrt");
		rndprk_ent = spawn("script_origin", self.origin);
		rndprk_ent stopsounds();
		state_switch = level util::waittill_any_return("pmstop", "pmmove", "machine_think");
		rndprk_ent StopLoopSound(1);
		if(state_switch == "pmstop")
		{
		}
		rndprk_ent delete();
	}
}

/*
	Name: GetWeaponModel
	Namespace: zm_perk_random
	Checksum: 0x823D1651
	Offset: 0x2F78
	Size: 0x19
	Parameters: 1
	Flags: None
*/
function GetWeaponModel(weapon)
{
	return weapon.worldmodel;
}

/*
	Name: is_power_on
	Namespace: zm_perk_random
	Checksum: 0x7423B031
	Offset: 0x2FA0
	Size: 0xB3
	Parameters: 1
	Flags: None
*/
function is_power_on(n_power_index)
{
	if(isdefined(n_power_index))
	{
		str_power = "power_on" + n_power_index;
		n_power_on = level flag::get(str_power);
	}
	else if(isdefined(level.zm_custom_perk_random_power_flag))
	{
		n_power_on = level flag::get(level.zm_custom_perk_random_power_flag);
	}
	else
	{
		n_power_on = level flag::get("power_on");
	}
	return n_power_on;
}

/*
	Name: setup_devgui
	Namespace: zm_perk_random
	Checksum: 0x91F7209E
	Offset: 0x3060
	Size: 0x1B
	Parameters: 0
	Flags: None
*/
function setup_devgui()
{
	/#
		level.perk_random_devgui_callback = &wunderfizz_devgui_callback;
	#/
}

/*
	Name: wunderfizz_devgui_callback
	Namespace: zm_perk_random
	Checksum: 0xEB126833
	Offset: 0x3088
	Size: 0x1D5
	Parameters: 1
	Flags: None
*/
function wunderfizz_devgui_callback(cmd)
{
	/#
		players = GetPlayers();
		a_e_wunderfizzes = GetEntArray("Dev Block strings are not supported", "Dev Block strings are not supported");
		e_wunderfizz = ArrayGetClosest(GetPlayers()[0].origin, a_e_wunderfizzes);
		switch(cmd)
		{
			case "Dev Block strings are not supported":
			{
				e_wunderfizz thread set_perk_random_machine_state("Dev Block strings are not supported");
				break;
			}
			case "Dev Block strings are not supported":
			{
				e_wunderfizz thread set_perk_random_machine_state("Dev Block strings are not supported");
				break;
			}
			case "Dev Block strings are not supported":
			{
				e_wunderfizz thread set_perk_random_machine_state("Dev Block strings are not supported");
				e_wunderfizz notify("bottle_spawned");
				break;
			}
			case "Dev Block strings are not supported":
			{
				e_wunderfizz thread set_perk_random_machine_state("Dev Block strings are not supported");
				break;
			}
			case "Dev Block strings are not supported":
			{
				e_wunderfizz thread set_perk_random_machine_state("Dev Block strings are not supported");
				break;
			}
			case "Dev Block strings are not supported":
			{
				e_wunderfizz thread set_perk_random_machine_state("Dev Block strings are not supported");
				break;
			}
			case "Dev Block strings are not supported":
			{
				e_wunderfizz thread set_perk_random_machine_state("Dev Block strings are not supported");
				break;
			}
		}
	#/
}

