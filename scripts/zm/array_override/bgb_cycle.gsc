#using scripts\shared\array_shared;
#using scripts\shared\flag_shared;

// script containing functions that are likely to be used for all bgb-related things
#using scripts\zm\array_override\bgb_common;

// header file that contains all the fixed bgb cycles for each map and each player,
// change the values in that header file to change the desired bgb cycles
#insert scripts\zm\array_override\bgb_cycle.gsh;

// the main script that we use to register and unregister this system
#using scripts\zm\array_override\array_override_common;
#insert scripts\zm\array_override\array_override_common.gsh;

#namespace bgb_cycle;

// init is where we register the system and thread its main function
#define SYSTEM_NAME "bgb_cycle"
function init()
{
	REGISTER_OVERRIDE(SYSTEM_NAME,ARRAY_RANDOMIZE,&randomize_override);
	thread main();
}

// the function that will be called in array::randomize() so long as this system is registered
// must always take 1 argument, namely the array passed in to array::randomize()
function randomize_override(array)
{
	if (array.size == 5 && IsInArray(GetEntArray("bgb_machine_use", "targetname"),self))
	{
		bgb = true;

		//check to make sure this array contains strings
		if (!IsString(array[0])) bgb = false;

		if (bgb) 
		{
			fixed = true;

			//Copy the passed-in array and we will make all the changes we want to this copy and then return it
			//a_ret = ArrayCopy(array);

			pl = ArraySort(level.activeplayers, self.unitrigger_stub.origin)[0];

			id = pl bgb_common::get_lobby_index();

			// populate a custom level var with the bgb loadout for the bgb_cycle script to use
			if (!isdefined(level.bgb_array)) level.bgb_array = array;

			// make sure we still have at least one more fixed bgb cycle to set
			if (!isdefined(level.bgb_fixed_cycles[id][level.cycle_index[id]]))
			{
				fixed = false;
			}

			if (fixed)
			{
				level flag::wait_till("bgb_megas_done");
				// populate the cycle with the desired bgb strings, based on the indexes we speicified in the bgb_cycle script
				for (i = 0; i < 5; i++)
				{
					//arr = array("zm_bgb_reign_drops","zm_bgb_dead_of_nuclear_winter","zm_bgb_extra_credit","zm_bgb_crawl_space","zm_bgb_perkaholic");
					//a_ret[i] = arr[i];
					a_ret[i] = level.bgb_fixed_cycles[id][level.cycle_index[id]][i];
				}

				// Confirm the array still has its original integrity and will still work
				if (a_ret.size != array.size || !isdefined(a_ret) || IsInArray(a_ret,undefined) || !IsSubStr(a_ret[0],"zm_bgb"))
				{
					return array;
				}
				else
				{
					//notify the level that the next bgb cycle has been set
					level notify("fresh_gum_cycle",id);
					return a_ret;
				}
			}
		}
	}
}


//main function for the system. The system is unregistered just before this function returns
function main()
{
	thread bgb_cycle_using_megas();

	level flag::wait_till("initial_players_connected");

	// leave this to default to the Classics list. the using_megas() function will make sure the Megas list is used if the player is using Megas
	bgb_cycles_list();
	level.bgb_fixed_cycles = level.bgb_cycles_c;

	//level.get_lobby_index_func = &bgb_common::get_lobby_index;

	//this is a counter that the array_shared script will use to index the array of predetermined bgb cycles
	level.cycle_index = array(0,0,0,0);
	level.bgb_cycles_done = ArrayCopy(level.cycle_index);

	while (!bgb_cycles_done())
	{
		//array_shared script will notify the level when the player's next bgb cycle has been set (which happens on the first bgb spin of each cycle)
		level waittill("fresh_gum_cycle",id);

		level.cycle_index[id]++;

		level flag::wait_till("bgb_megas_done");
		if (!isdefined(level.bgb_fixed_cycles[id][level.cycle_index[id]]))
			level.bgb_cycles_done[id] = 1;
	}

	UNREGISTER_OVERRIDE(SYSTEM_NAME,ARRAY_RANDOMIZE);

}

function bgb_cycles_done()
{
	foreach (pl in level.bgb_cycles_done)
	{
		if (!pl) return 0;
	}
	return 1;
}

function bgb_cycles_list()
{
	level.bgb_cycles_m = undefined;
	level.bgb_cycles_c = undefined;
	switch(GetDvarString("mapname"))
	{
		case "zm_zod":
			level.bgb_cycles_m = ZOD_BGB_CYCLES_M;
			level.bgb_cycles_c = ZOD_BGB_CYCLES_C;
			break;
		case "zm_factory":
			level.bgb_cycles_m = FACTORY_BGB_CYCLES_M;
			level.bgb_cycles_c = FACTORY_BGB_CYCLES_C;
			break;
		case "zm_castle":
			level.bgb_cycles_m = CASTLE_BGB_CYCLES_M;
			level.bgb_cycles_c = CASTLE_BGB_CYCLES_C;
			break;
		case "zm_island":
			level.bgb_cycles_m = ISLAND_BGB_CYCLES_M;
			level.bgb_cycles_c = ISLAND_BGB_CYCLES_C;
			break;
		case "zm_stalingrad":
			level.bgb_cycles_m = STALINGRAD_BGB_CYCLES_M;
			level.bgb_cycles_c = STALINGRAD_BGB_CYCLES_C;
			break;
		case "zm_genesis":
			level.bgb_cycles_m = GENESIS_BGB_CYCLES_M;
			level.bgb_cycles_c = GENESIS_BGB_CYCLES_C;
			break;
		case "zm_prototype":
			break;
		case "zm_asylum":
			break;
		case "zm_sumpf":
			break;
		case "zm_theater":
			break;
		case "zm_cosmodrome":
			level.bgb_cycles_m = COSMODROME_BGB_CYCLES_M;
			level.bgb_cycles_c = COSMODROME_BGB_CYCLES_C;
			break;
		case "zm_temple":
			level.bgb_cycles_m = TEMPLE_BGB_CYCLES_M;
			level.bgb_cycles_c = TEMPLE_BGB_CYCLES_C;
			break;
		case "zm_moon":
			level.bgb_cycles_m = MOON_BGB_CYCLES_M;
			level.bgb_cycles_c = MOON_BGB_CYCLES_C;
			break;
		case "zm_tomb":
			level.bgb_cycles_m = TOMB_BGB_CYCLES_M;
			level.bgb_cycles_c = TOMB_BGB_CYCLES_C;
			break;
	}
}

//this function will wait until the bgb_common script has determined whether megas are being used
// this way not every bgb-related script has to determine if megas are being used, instead the
// commmon script does it and sets the flag that is then read by all the other scripts
function bgb_cycle_using_megas()
{
	level flag::wait_till("bgb_loadout_determined");

	if (level flag::get("using_megas"))
	{
		level.bgb_fixed_cycles = level.bgb_cycles_m;
	}
	level flag::set("bgb_megas_done");
}