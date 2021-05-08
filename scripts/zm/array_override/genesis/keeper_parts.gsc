#using scripts\codescripts\struct;
#using scripts\shared\array_shared;
#using scripts\shared\util_shared;
#using scripts\shared\flag_shared;
#using scripts\zm\array_override\array_override_common;

#insert scripts\zm\array_override\array_override_common.gsh;

#namespace genesis_keeper_parts;

#define SYSTEM_NAME "keeper_parts"
function init()
{
	if (GetDvarString("mapname") == "zm_genesis")
	{
		REGISTER_OVERRIDE(SYSTEM_NAME,ARRAY_RANDOM,&random_override);
		thread main();
	}
}

#define TRENCHES_GEN3 0
#define TRENCHES_MOUND 1
#define TRENCHES_PRISON 2

#define TOTEM TRENCHES_GEN3

#define VERRUCKT_TABLE 0
#define VERRUCKT_WHEELCHAIR 1
#define VERRUCKT_SHELF 2

#define HEAD VERRUCKT_TABLE

#define DE_SHANG 0
#define DE_KINO 1
#define DE_UNDERCROFT 2

#define GEM DE_KINO


function random_override(array)
{
	if (array[0].targetname == "companion_totem_part")
	{
		level notify("fixed_keeper_totem");
		return array[TOTEM];
	}
	if (array[0].targetname == "companion_head_part")
	{
		level notify("fixed_keeper_head");
		return array[HEAD];
	}
	if (array[0].targetname == "companion_gem_part")
	{
		level notify("fixed_keeper_gem");
		return array[GEM];
	}
}

function main()
{
	util::waittill_multiple("fixed_keeper_totem","fixed_keeper_head","fixed_keeper_gem");

	wait .05;

	UNREGISTER_OVERRIDE(SYSTEM_NAME,ARRAY_RANDOM);
}