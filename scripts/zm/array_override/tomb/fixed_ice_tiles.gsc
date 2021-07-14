#using scripts\shared\array_shared;
#using scripts\zm\array_override\array_override_common;

#insert scripts\zm\array_override\array_override_common.gsh;

#namespace fixed_ice_tiles;

#define SYSTEM_NAME "fixed_ice_tiles"
function init()
{
	if (GetDvarString("mapname") == "zm_tomb")
	{
		thread main();
	}
}

function random_override(array)
{
	if (IsInArray(level.a_original_positions, array[0]))
	{
		if(array[0] == level.a_original_positions[level.a_original_positions.size]) level notify("Ice Positions Done");
		return array[0];
	}

	if(IsInArray(level.a_ceiling_tile_brushes, array[0]))
	{
		if(array[0] == level.a_ceiling_tile_brushes[level.a_ceiling_tile_brushes.size]) level notify("Ice Ceiling Done");
		return array[0];
	}
}

function main()
{
	REGISTER_OVERRIDE(SYSTEM_NAME,ARRAY_RANDOM,&random_override);

	level.a_original_tiles = GetEntArray("ice_tile_original", "targetname");
	level.a_original_tiles = Array::sort_by_script_int(level.a_original_tiles, 1);
	level.a_original_positions = [];
	foreach(e_tile in level.a_original_tiles)
	{
		level.a_original_positions[level.a_original_positions.size] = e_tile.origin;
	}

	level.a_ceiling_tile_brushes = GetEntArray("ice_ceiling_tile", "script_noteworthy");

	level waittill("Ice Positions Done");
	level waittill("Ice Ceiling Done");

	UNREGISTER_OVERRIDE(SYSTEM_NAME,ARRAY_RANDOM);
}