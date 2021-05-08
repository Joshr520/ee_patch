#using scripts\codescripts\struct;
#using scripts\shared\ai\zombie_utility;
#using scripts\shared\clientfield_shared;
#using scripts\shared\array_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\util_shared;
#using scripts\zm\_zm_powerups;
#using scripts\zm\_zm_spawner;
#using scripts\zm\_zm_weapons;
#using scripts\zm\array_override\array_override_common;

#insert scripts\zm\array_override\array_override_common.gsh;

#namespace void_symbols;

#define SYSTEM_NAME "demongate_quest"
function init()
{
	if (GetDvarString("mapname") == "zm_castle")
	{
		thread main();
	}
}

//#define SYMBOL_ARR array("demonic_rune_lor", "demonic_rune_ulla", "demonic_rune_oth", "demonic_rune_zor", "demonic_rune_mar", "demonic_rune_uja")
#define SYMBOL_ARR array("demonic_rune_zor", "demonic_rune_oth", "demonic_rune_mar", "demonic_rune_lor", "demonic_rune_ulla", "demonic_rune_uja")

function randomize_override(array)
{
	if (IsInArray(SYMBOL_ARR,array[0]) && array.size == 6)
	{
		level.demonic_symbols_arr = SYMBOL_ARR;
		return SYMBOL_ARR;
	}
	if (array[0].targetname == "aq_dg_circle_rune_trig")
	{
		return array;
	}
	if (array[0].targetname == "aq_dg_armor_rune_struct")
	{
		return array;
	}
}

/*symbol mapping

horn 	- dna strip 	- demonic_rune_ulla
crown 	- circle 		- demonic_rune_zor
door 	- beast symbol 	- demonic_rune_oth
stag 	- horns 		- demonic_rune_mar
heart 	- triangles 	- demonic_rune_uja
griffon - tear drops 	- demonic_rune_lor

*/

function main()
{
	//thread debug();
	
	level flag::wait_till("demon_gate_seal");

	REGISTER_OVERRIDE(SYSTEM_NAME,ARRAY_RANDOMIZE,&randomize_override);

	level.demongate_player = get_demon_gate_owner();

	monitor_rune_step();

	UNREGISTER_OVERRIDE(SYSTEM_NAME,ARRAY_RANDOMIZE);
}

function drop_demonic_rune(e_attacker)
{
	if (!level flag::get("demon_gate_crawlers")) return;
	if(!level flag::get("demonic_rune_dropped"))
	{
		if(self valid_death(level.demongate_player))
		{
			self.no_powerups = 1;
			str_name = level.demonic_symbols_arr[level.rune_index];
			level flag::set("demonic_rune_dropped");
			level._powerup_timeout_override = &demonic_rune_timeout;
			level thread zm_powerups::specific_powerup_drop(str_name, self.origin, undefined, undefined, undefined, level.demongate_player);
			level._powerup_timeout_override = undefined;
		}
	}
}

function monitor_rune_step()
{
	zm_spawner::register_zombie_death_event_callback(&drop_demonic_rune);
	monitor_symbols();
	zm_spawner::deregister_zombie_death_event_callback(&drop_demonic_rune);
}

function monitor_symbols()
{
	level endon("demon_gate_runes");
	level.rune_index = 0;
	while(1)
	{
		level flag::wait_till("demonic_rune_dropped");
		level waittill("demonic_rune_grabbed");
		level.rune_index++;
		if (level.rune_index >= 6)
		{
			break;
		}
		level flag::wait_till_clear("demonic_rune_dropped");
	}
}

function get_demon_gate_owner()
{
	index = clientfield::get("quest_owner_demon");

	index = index - 1;

	foreach (p in GetPlayers())
	{
		if (p.characterIndex == index)
		{
			return p;
		}
	}
}

function demonic_rune_timeout()
{
	self endon("powerup_grabbed");
	self endon("death");
	self endon("powerup_reset");
	self zm_powerups::powerup_show(1);
	wait_time = 1;
	if(isdefined(level._powerup_timeout_custom_time))
	{
		time = [[level._powerup_timeout_custom_time]](self);
		if(time == 0)
		{
			return;
		}
		wait_time = time;
	}
	wait(wait_time);
	for(i = 20; i > 0; i--)
	{
		if(i % 2)
		{
			self zm_powerups::powerup_show(0);
		}
		else
		{
			self zm_powerups::powerup_show(1);
		}
		if(i > 15)
		{
			wait(0.3);
		}
		if(i > 10)
		{
			wait(0.25);
			continue;
		}
		if(i > 5)
		{
			wait(0.15);
			continue;
		}
		wait(0.1);
	}
	level flag::clear("demonic_rune_dropped");
	self notify("powerup_timedout");
	self zm_powerups::powerup_delete();
}

function valid_death(e_player, e_volume)
{
	if(!isdefined(e_volume))
	{
		e_volume = undefined;
	}
	if(!isdefined(self) || self.isdog || self.archetype === "mechz")
	{
		return 0;
	}
	if(!isdefined(e_player) || self.attacker !== e_player)
	{
		return 0;
	}
	if(isdefined(e_volume))
	{
		if(!self istouching(e_volume))
		{
			return 0;
		}
	}
	return 1;
}

function debug()
{
	level.player_starting_points = 50000;

	level flag::wait_till("initial_blackscreen_passed");

	wait 5;
	level flag::set("soul_catchers_charged");

	pl = GetPlayers()[0];

	weap = GetWeapon("elemental_bow");

	pl zm_weapons::weapon_give(weap, 0, 0, 1);

	pl thread crawlers();
}

function crawlers()
{
	while (1)
	{
		if (self ActionSlotThreeButtonPressed() || self ActionSlotFourButtonPressed())
		{
			a_ai = GetAIArray();
			for(i = 0; i < a_ai.size; i++)
			{
				if(isdefined(a_ai[i]) && IsAlive(a_ai[i]) && a_ai[i].archetype === "zombie" && isdefined(a_ai[i].gibdef))
				{
					dist = DistanceSquared(self.origin, a_ai[i].origin);
					if(dist < 360000)
					{
						a_ai[i] zombie_utility::makeZombieCrawler();
					}
				}
			}
		}
		wait .1;
	}
}