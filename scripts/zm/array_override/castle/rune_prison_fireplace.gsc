
#using scripts\shared\flag_shared;

#using scripts\zm\array_override\array_override_common;
#insert scripts\zm\array_override\array_override_common.gsh;


#namespace rune_prison_fireplace;

#define SYSTEM_NAME "rune_prison_fireplace"
function init()
{
	if (GetDvarString("mapname") == "zm_castle")
	{
		thread main();
	}
}

// script_int of each fireplace struct
#define LIVING_QUARTERS 1
#define LOWER_COURTYARD 3
#define HALL 2

#define DESIRED_FIREPLACE HALL

function random_override(array)
{
	if (array[0].targetname == "aq_rp_fireplace_struct")
	{
		foreach (fireplace in array)
		{
			if (fireplace.script_int == DESIRED_FIREPLACE)
			{
				return fireplace;
			}
		}
	}
}

function main()
{
	level flag::wait_till("rune_prison_magma_ball");

	REGISTER_OVERRIDE(SYSTEM_NAME,ARRAY_RANDOM,&random_override);

	level flag::wait_till("rune_prison_golf");

	UNREGISTER_OVERRIDE(SYSTEM_NAME,ARRAY_RANDOM);
}