#using scripts\shared\clientfield_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;
#using scripts\zm\_zm_magicbox;
#using scripts\zm\_zm_unitrigger;
#using scripts\zm\_zm_utility;

#namespace namespace_bafc277e;

/*
	Name: __init__sytem__
	Namespace: namespace_bafc277e
	Checksum: 0xC6DA96E3
	Offset: 0x248
	Size: 0x33
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("tomb_magicbox", &__init__, undefined, undefined);
}

/*
	Name: __init__
	Namespace: namespace_bafc277e
	Checksum: 0xAEFCF4F1
	Offset: 0x288
	Size: 0x1A3
	Parameters: 0
	Flags: None
*/
function __init__()
{
	clientfield::register("zbarrier", "magicbox_initial_fx", 21000, 1, "int");
	clientfield::register("zbarrier", "magicbox_amb_fx", 21000, 2, "int");
	clientfield::register("zbarrier", "magicbox_open_fx", 21000, 1, "int");
	clientfield::register("zbarrier", "magicbox_leaving_fx", 21000, 1, "int");
	level.chest_joker_custom_movement = &custom_joker_movement;
	level.custom_magic_box_timer_til_despawn = &custom_magic_box_timer_til_despawn;
	level.custom_magic_box_do_weapon_rise = &custom_magic_box_do_weapon_rise;
	level.custom_magic_box_weapon_wait = &custom_magic_box_weapon_wait;
	level.custom_magicbox_float_height = 50;
	level.custom_magic_box_fx = &function_61903aae;
	level.custom_treasure_chest_glowfx = &function_e4e60ea;
	level.magic_box_zbarrier_state_func = &set_magic_box_zbarrier_state;
	level thread wait_then_create_base_magic_box_fx();
	level thread handle_fire_sale();
}

/*
	Name: function_61903aae
	Namespace: namespace_bafc277e
	Checksum: 0x99EC1590
	Offset: 0x438
	Size: 0x3
	Parameters: 0
	Flags: None
*/
function function_61903aae()
{
}

/*
	Name: function_e4e60ea
	Namespace: namespace_bafc277e
	Checksum: 0x99EC1590
	Offset: 0x448
	Size: 0x3
	Parameters: 0
	Flags: None
*/
function function_e4e60ea()
{
}

/*
	Name: custom_joker_movement
	Namespace: namespace_bafc277e
	Checksum: 0xC3EBAB52
	Offset: 0x458
	Size: 0x1DD
	Parameters: 0
	Flags: None
*/
function custom_joker_movement()
{
	v_origin = self.weapon_model.origin - VectorScale((0, 0, 1), 5);
	self.weapon_model delete();
	m_lock = util::spawn_model(level.chest_joker_model, v_origin, self.angles);
	m_lock playsound("zmb_hellbox_bear");
	wait(0.5);
	level notify("weapon_fly_away_start");
	wait(1);
	m_lock RotateYaw(3000, 4, 4);
	wait(3);
	v_angles = AnglesToForward(self.angles - VectorScale((0, 1, 0), 90));
	m_lock moveto(m_lock.origin + 20 * v_angles, 0.5, 0.5);
	m_lock waittill("movedone");
	m_lock moveto(m_lock.origin + -100 * v_angles, 0.5, 0.5);
	m_lock waittill("movedone");
	m_lock delete();
	self notify("box_moving");
	level notify("weapon_fly_away_end");
}

/*
	Name: custom_magic_box_timer_til_despawn
	Namespace: namespace_bafc277e
	Checksum: 0x64BA8F14
	Offset: 0x640
	Size: 0xCB
	Parameters: 1
	Flags: None
*/
function custom_magic_box_timer_til_despawn(magic_box)
{
	self endon("kill_weapon_movement");
	putBackTime = 12;
	v_float = AnglesToForward(magic_box.angles - VectorScale((0, 1, 0), 90)) * 40;
	self moveto(self.origin - v_float * 0.25, putBackTime, putBackTime * 0.5);
	wait(putBackTime);
	if(isdefined(self))
	{
		self delete();
	}
}

/*
	Name: custom_magic_box_weapon_wait
	Namespace: namespace_bafc277e
	Checksum: 0x5F337FCE
	Offset: 0x718
	Size: 0xB
	Parameters: 0
	Flags: None
*/
function custom_magic_box_weapon_wait()
{
	wait(0.5);
}

/*
	Name: wait_then_create_base_magic_box_fx
	Namespace: namespace_bafc277e
	Checksum: 0xFF0846BE
	Offset: 0x730
	Size: 0xE9
	Parameters: 0
	Flags: None
*/
function wait_then_create_base_magic_box_fx()
{
	while(!isdefined(level.chests))
	{
		wait(0.5);
	}
	while(!isdefined(level.chests[level.chests.size - 1].zbarrier))
	{
		wait(0.5);
	}
	foreach(Chest in level.chests)
	{
		Chest.zbarrier clientfield::set("magicbox_initial_fx", 1);
	}
}

/*
	Name: set_magic_box_zbarrier_state
	Namespace: namespace_bafc277e
	Checksum: 0x8DEB4968
	Offset: 0x828
	Size: 0x2BD
	Parameters: 1
	Flags: None
*/
function set_magic_box_zbarrier_state(State)
{
	for(i = 0; i < self GetNumZBarrierPieces(); i++)
	{
		self HideZBarrierPiece(i);
	}
	self notify("zbarrier_state_change");
	switch(State)
	{
		case "away":
		{
			self ShowZBarrierPiece(0);
			self.State = "away";
			self.owner.is_locked = 0;
			break;
		}
		case "arriving":
		{
			self ShowZBarrierPiece(1);
			self thread magic_box_arrives();
			self.State = "arriving";
			break;
		}
		case "initial":
		{
			self ShowZBarrierPiece(1);
			self thread magic_box_initial();
			thread zm_unitrigger::register_static_unitrigger(self.owner.unitrigger_stub, &zm_magicbox::magicbox_unitrigger_think);
			self.State = "close";
			break;
		}
		case "open":
		{
			self ShowZBarrierPiece(2);
			self thread magic_box_opens();
			self.State = "open";
			break;
		}
		case "close":
		{
			self ShowZBarrierPiece(2);
			self thread magic_box_closes();
			self.State = "close";
			break;
		}
		case "leaving":
		{
			self ShowZBarrierPiece(1);
			self thread magic_box_leaves();
			self.State = "leaving";
			self.owner.is_locked = 0;
			break;
		}
		case default:
		{
			if(isdefined(level.custom_magicbox_state_handler))
			{
				self [[level.custom_magicbox_state_handler]](State);
			}
			break;
		}
	}
}

/*
	Name: magic_box_initial
	Namespace: namespace_bafc277e
	Checksum: 0x7E4F1856
	Offset: 0xAF0
	Size: 0x4B
	Parameters: 0
	Flags: None
*/
function magic_box_initial()
{
	self SetZBarrierPieceState(1, "open");
	wait(1);
	self clientfield::set("magicbox_amb_fx", 1);
}

/*
	Name: magic_box_arrives
	Namespace: namespace_bafc277e
	Checksum: 0x3F37CB33
	Offset: 0xB48
	Size: 0x12B
	Parameters: 0
	Flags: None
*/
function magic_box_arrives()
{
	self clientfield::set("magicbox_leaving_fx", 0);
	self SetZBarrierPieceState(1, "opening");
	while(self GetZBarrierPieceState(1) == "opening")
	{
		wait(0.05);
	}
	self notify("arrived");
	self.State = "close";
	s_zone_capture_area = level.zone_capture.zones[self.zone_capture_area];
	if(isdefined(s_zone_capture_area))
	{
		if(!s_zone_capture_area flag::get("player_controlled"))
		{
			self clientfield::set("magicbox_amb_fx", 1);
		}
		else
		{
			self clientfield::set("magicbox_amb_fx", 2);
		}
	}
}

/*
	Name: magic_box_leaves
	Namespace: namespace_bafc277e
	Checksum: 0x64F0EDA5
	Offset: 0xC80
	Size: 0x187
	Parameters: 0
	Flags: None
*/
function magic_box_leaves()
{
	self notify("stop_open_idle");
	self clientfield::set("magicbox_leaving_fx", 1);
	self clientfield::set("magicbox_open_fx", 0);
	self SetZBarrierPieceState(1, "closing");
	self playsound("zmb_hellbox_rise");
	while(self GetZBarrierPieceState(1) == "closing")
	{
		wait(0.1);
	}
	self notify("left");
	s_zone_capture_area = level.zone_capture.zones[self.zone_capture_area];
	if(isdefined(s_zone_capture_area))
	{
		if(s_zone_capture_area flag::get("player_controlled"))
		{
			self clientfield::set("magicbox_amb_fx", 3);
		}
		else
		{
			self clientfield::set("magicbox_amb_fx", 0);
		}
	}
	if(isdefined(level.dig_magic_box_moved) && !level.dig_magic_box_moved)
	{
		level.dig_magic_box_moved = 1;
	}
}

/*
	Name: magic_box_opens
	Namespace: namespace_bafc277e
	Checksum: 0xF61D9DC9
	Offset: 0xE10
	Size: 0xB3
	Parameters: 0
	Flags: None
*/
function magic_box_opens()
{
	self clientfield::set("magicbox_open_fx", 1);
	self SetZBarrierPieceState(2, "opening");
	self playsound("zmb_hellbox_open");
	while(self GetZBarrierPieceState(2) == "opening")
	{
		wait(0.1);
	}
	self notify("opened");
	self thread magic_box_open_idle();
}

/*
	Name: magic_box_open_idle
	Namespace: namespace_bafc277e
	Checksum: 0x4FA48284
	Offset: 0xED0
	Size: 0x97
	Parameters: 0
	Flags: None
*/
function magic_box_open_idle()
{
	self endon("stop_open_idle");
	self HideZBarrierPiece(2);
	self ShowZBarrierPiece(5);
	while(1)
	{
		self SetZBarrierPieceState(5, "opening");
		while(self GetZBarrierPieceState(5) != "open")
		{
			wait(0.05);
		}
	}
}

/*
	Name: magic_box_closes
	Namespace: namespace_bafc277e
	Checksum: 0x4E92E672
	Offset: 0xF70
	Size: 0xE1
	Parameters: 0
	Flags: None
*/
function magic_box_closes()
{
	self notify("stop_open_idle");
	self HideZBarrierPiece(5);
	self ShowZBarrierPiece(2);
	self SetZBarrierPieceState(2, "closing");
	self playsound("zmb_hellbox_close");
	self clientfield::set("magicbox_open_fx", 0);
	while(self GetZBarrierPieceState(2) == "closing")
	{
		wait(0.1);
	}
	self notify("closed");
}

/*
	Name: custom_magic_box_do_weapon_rise
	Namespace: namespace_bafc277e
	Checksum: 0xDD61BD07
	Offset: 0x1060
	Size: 0x16B
	Parameters: 0
	Flags: None
*/
function custom_magic_box_do_weapon_rise()
{
	self endon("box_hacked_respin");
	wait(0.5);
	self SetZBarrierPieceState(3, "closed");
	self SetZBarrierPieceState(4, "closed");
	util::wait_network_frame();
	self ZBarrierPieceUseBoxRiseLogic(3);
	self ZBarrierPieceUseBoxRiseLogic(4);
	self ShowZBarrierPiece(3);
	self ShowZBarrierPiece(4);
	self SetZBarrierPieceState(3, "opening");
	self SetZBarrierPieceState(4, "opening");
	while(self GetZBarrierPieceState(3) != "open")
	{
		wait(0.5);
	}
	self HideZBarrierPiece(3);
	self HideZBarrierPiece(4);
}

/*
	Name: handle_fire_sale
	Namespace: namespace_bafc277e
	Checksum: 0xFBF850B3
	Offset: 0x11D8
	Size: 0x159
	Parameters: 0
	Flags: None
*/
function handle_fire_sale()
{
	while(1)
	{
		level waittill("fire_sale_off");
		for(i = 0; i < level.chests.size; i++)
		{
			if(level.chest_index != i && isdefined(level.chests[i].was_temp))
			{
				if(isdefined(level.chests[i].zbarrier.zone_capture_area) && level.zone_capture.zones[level.chests[i].zbarrier.zone_capture_area] flag::get("player_controlled"))
				{
					level.chests[i].zbarrier clientfield::set("magicbox_amb_fx", 3);
					continue;
				}
				level.chests[i].zbarrier clientfield::set("magicbox_amb_fx", 0);
			}
		}
	}
}

