//RANDOM overrides
#define ZOD_INFINITE_POWERUP "zod_infinite_powerup"
function zod_infinite_powerup(array)
{
	#define DESIRED_POWERUP "double_points"
	if (array.size == 3)
	{
		powerups = true;
		for (i = 0; i < 3; i++)
		{
			if (array[i] != "double_points" && array[i] != "insta_kill" && array[i] != "full_ammo")
			{
				powerups = false;
				break;
			}
		}
		if (powerups)
		{
			level notify("pre_spawn_override_done",ZOD_INFINITE_POWERUP,0);
			return DESIRED_POWERUP;
		}
	}
}

// RANDOMIZE overrides
#define CHARACTERS "characters"
function characters(array)
{
	#define ZOD_CHARACTERS array(3,1,2,0)
	#define CASTLE_CHARACTERS array(2,3,1,0)

	#define CHARACTER_SETS_MAPS array("zm_zod","zm_castle")
	#define CHARACTER_SETS 		array(ZOD_CHARACTERS,CASTLE_CHARACTERS)

	mapname = GetDvarString("mapname");

	if (IsInArray(CHARACTER_SETS_MAPS,mapname))
	{
		if (array.size == 4)
		{
			chars = true;
			for (i = 0; i < 4; i++)
			{
				if (array[i] != i)
				{
					chars = false;
					break;
				}
			}
			if (chars)
			{
				map_id = undefined;
				maps = CHARACTER_SETS_MAPS;
				for (i = 0; i < maps.size; i++)
				{
					if (mapname == maps[i])
					{
						map_id = i;
						break;
					}
				}
				if (isdefined(map_id))
				{
					if (!isdefined(level.n_fixed_characters)) level.n_fixed_characters = 0;
					level.n_fixed_characters++;
					if (level.n_fixed_characters >= GetPlayers().size) level notify("pre_spawn_override_done",CHARACTERS,1);
					return CHARACTER_SETS[map_id];
				}
			}
		}
	}

}

#define BEASTCODE "beastcode"
function beastcode(array)
{
	#define FIXED_BEASTCODE array(0,1,2)

	if (!isdefined(level.fixed_beastcode_set)) level.fixed_beastcode_set = false;
	if (!isdefined(level.fixed_beastcode)) level.fixed_beastcode = FIXED_BEASTCODE;
	if (!level.fixed_beastcode_set)
	{
		if (array.size == 9)
		{
			return array;
		}
		if (array.size == 8)
		{
			return array;
		}
		if (array.size == 7)
		{
			level.fixed_beastcode_set = true;
			level notify("pre_spawn_override_done",BEASTCODE,1);
			return array;
		}
	}
}

#define TRAIN "train"
function fixed_train(array)
{
	// ZOD TRAIN ORDER
	#define FIXED_TRAIN_START array("theater","canal","slums")

	if (array.size == 3)
	{
		thread LOCATION();
		districts = true;
		for (i = 0; i < 3; i++)
		{
			if (array[i] != "slums" && array[i] != "canal" && array[i] != "theater")
			{
				districts = false;
				break;
			}
		}
		if (districts)
		{
			return FIXED_TRAIN_START;
			level notify("pre_spawn_override_done",TRAIN,1);
		}
	}
}

function LOCATION()
{
	wait 0.05;
	self.var_c2e30cf8[self.var_5d231abf].var_bd2282e4 = 0;
}

#define WOLF_PAINTINGS "wolf_paintings"
function wolf_paintings(array)
{
	// CASTLE WOLF PAINTINGS ORDER
	#define UPPER_HALL 0
	#define LIVING_QUARTERS 1
	#define TOWER 2
	#define SUB_TOWER 3

	#define PAINTING_ORDER array(LIVING_QUARTERS,TOWER,SUB_TOWER,UPPER_HALL)

	if (array[0].script_noteworthy == "aq_wh_painting_struct")
	{
		order = PAINTING_ORDER;
		ret = array();
		for (i = 0; i < array.size; i++)
		{
			ret[i] = array[order[i]];
		}
		level notify("pre_spawn_override_done",WOLF_PAINTINGS,1);
		return ret;
	}
}

#define TUBE "tube"
function fixed_tube_puzzle(array)
{
	if (IsInArray(GetEntArray("ee_tube_terminal", "targetname"),array[0]))
	{
		foreach(index, tube in array)
		{
			if (tube.script_label == "command")
			{
				a_temp = array[5];
				array[5] = array[index];
				array[index] = a_temp;
			}
			if (tube.script_label == "store")
			{
				a_temp = array[0];
				array[0] = array[index];
				array[index] = a_temp;
			}
		}
		level notify("pre_spawn_override_done", TUBE, 1);
		return array;
	}
}

function autoexec pre_spawn_overrides()
{
	level.array_random_override = array();
	level.array_randomize_override = array();

	level.array_randomize_override[CHARACTERS] = &characters;

	switch(GetDvarString("mapname"))
	{
		case "zm_zod":
			level.array_random_override[ZOD_INFINITE_POWERUP] = &zod_infinite_powerup;

			level.array_randomize_override[BEASTCODE] = &beastcode;
			level.array_randomize_override[TRAIN] = &fixed_train;
			break;
		case "zm_factory":
			break;
		case "zm_castle":
			level.array_randomize_override[WOLF_PAINTINGS] = &wolf_paintings;
			break;
		case "zm_island":
			break;
		case "zm_stalingrad":
			level.array_randomize_override[TUBE] = &fixed_tube_puzzle;
			break;
		case "zm_genesis":
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
			break;
		case "zm_temple":
			break;
		case "zm_moon":
			break;
		case "zm_tomb":
			break;
	}
	
	thread pre_spawn_overrides_think();
}

function pre_spawn_overrides_think()
{
	level endon("initial_blackscreen_passed");
	while(1)
	{
		level waittill("pre_spawn_override_done",name,b_type);
		if (b_type) ArrayRemoveIndex(level.array_randomize_override,name,1);
		else ArrayRemoveIndex(level.array_random_override,name);
	}
}