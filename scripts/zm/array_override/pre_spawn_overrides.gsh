//helper "functions"
#define IS_MAP(map) (!level flag::get("initial_blackscreen_passed") && GetDvarString("mapname") == map)

#define FIX_BEASTCODE_INDEX(index) if (array[0] == level.fixed_beastcode[index]){ return array;}\
	else{for (i = 1; i < array.size; i++){\
			if (array[i] == level.fixed_beastcode[index]){\
				swap(array,0,i);return array;}}}

#define PRE_SPAWN_RANDOM \
ZOD_INFINITE_POWERUP


//ZOD INFINITE POWERUP
#define ZOD_FIXED_POWERUP "double_points"

#define ZOD_INFINITE_POWERUP if IS_MAP("zm_zod")\
	if (array.size == 3){\
			powerups = true;\
			for (i = 0; i < 3; i++){\
				if (array[i] != "double_points" && array[i] != "insta_kill" && array[i] != "full_ammo"){\
					powerups = false;\
					break;}}\
			if (powerups){return ZOD_FIXED_POWERUP;}}

#define PRE_SPAWN_RANDOMIZE \
CHARACTERS \
BEASTCODE \
TRAIN \
WOLF_PAINTINGS \
TUBE_PUZZLE \

//CHARACTERS
#define ZOD_CHARACTERS array(3,1,2,0)
#define CASTLE_CHARACTERS array(2,3,1,0)

#define MAPS_APPLIED array("zm_zod","zm_castle")
#define CHARACTER_SETS array(ZOD_CHARACTERS,CASTLE_CHARACTERS)

#define CHARACTERS if (IsInArray(MAPS_APPLIED,GetDvarString("mapname")) && !level flag::get("initial_blackscreen_passed")){\
	chars = 1;\
	if (array.size == 4){\
		for (i = 0; i < 4; i++){if (array[i] != i) chars = 0;break;}\
		if (chars){map_id = 0;maps = MAPS_APPLIED;\
			for (i = 0; i < maps.size; i++){\
				if (GetDvarString("mapname") == maps[i]){map_id = i;break;}}\
				return CHARACTER_SETS[map_id];}}}


// BEAST CODE
#define FIXED_CODE array(0,1,2)

#define BEASTCODE if IS_MAP("zm_zod"){\
	if (!isdefined(level.fixed_beastcode_set)) level.fixed_beastcode_set = false;\
	if (!isdefined(level.fixed_beastcode)) level.fixed_beastcode = FIXED_CODE;\
	if (!level.fixed_beastcode_set) {\
		if (array.size == 9) {\
			return array;}\
		else if (array.size == 8) {\
			return array;}\
		else if (array.size == 7) {\
			level.fixed_beastcode_set = true;\
			return array;}}}



// ZOD TRAIN
#define FIXED_TRAIN_START array("theater","canal","slums")

#define TRAIN if IS_MAP("zm_zod"){\
	if (array.size == 3){\
		thread LOCATION();\
		districts = true;\
		for (i = 0; i < 3; i++){\
			if ( array[i] != "slums" && array[i] != "canal" && array[i] != "theater" ){\
				districts = false;\
				break;}}\
		if (districts){return FIXED_TRAIN_START;}}}

function LOCATION()
{
	wait 0.05;
	self.var_c2e30cf8[self.var_5d231abf].var_bd2282e4 = 0;
}

// CASTLE WOLF PAINTINGS ORDER
#define UPPER_HALL 0
#define LIVING_QUARTERS 1
#define TOWER 2
#define SUB_TOWER 3

#define PAINTING_ORDER array(LIVING_QUARTERS,TOWER,SUB_TOWER,UPPER_HALL)

#define WOLF_PAINTINGS if IS_MAP("zm_castle"){\
	if (array[0].script_noteworthy == "aq_wh_painting_struct"){\
		ret = ArrayCopy(array);\
		for (i = 0; i < array.size; i++){ret[i] = array[PAINTING_ORDER[i]];}\
		return ret;}}

// STALINGRAD TUBE PUZZLE
#define TUBE_PUZZLE if IS_MAP("zm_stalingrad"){\
	if (IsInArray(GetEntArray("ee_tube_terminal", "targetname"),array[0])){\
		foreach(index, tube in array){\
			if (tube.script_label == "command"){\
				a_temp = array[5];\
				array[5] = array[index];\
				array[index] = a_temp;}\
			if (tube.script_label == "store"){\
				a_temp = array[0];\
				array[0] = array[index];\
				array[index] = a_temp;}}\
		level notify("tube_done");\
		return array;}}

#define ISLAND_SKULL_ORDER if IS_MAP("zm_island"){\
	if (array.size == 4){\
		skull = true;\
		for (i = 1; i <= array.size; i++){\
			if (array[i - 1] != i){\
				skull = false;\
				break;}}\
		if (skull){\
			a_temp = array;\
			for (i = 0; i < array.size; i++){\
				a_temp = array[0];\
				array[0] = array[1];\
				array[1] = a_temp;\
				a_temp = array[2];\
				array[2] = array[3];\
				array[3] = a_temp;}\
			return array;}}}