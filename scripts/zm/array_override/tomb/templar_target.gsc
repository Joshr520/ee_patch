#using scripts\shared\array_shared;
#using scripts\shared\flag_shared;
#using scripts\zm\array_override\array_override_common;

#insert scripts\zm\array_override\array_override_common.gsh;

#namespace templar_target;

//level.zone_capture.zones[self.script_noteworthy].script_noteworthy

/*
#define GEN_1 0
#define GEN_2 1
#define GEN_3 2
#define GEN_4 3
#define GEN_5 4
#define GEN_6 5
*/

#define TEMPLAR_TARGETS array(3)

#define SYSTEM_NAME "templar_target"
function init()
{
	if (GetDvarString("mapname") == "zm_tomb")
	{
		thread main();
	}
}

function random_override(array)
{
	if (array[GetArrayKeys(array)[0]] flag::exists("player_controlled"))
	{
		ret = undefined;
		for (i = 0; i < level.next_target_zone.size;i++)
		{
			foreach (key,val in array)
			{
				if (key == level.next_target_zone[i])
				{
					level notify("fixed_templar_target");
					ret = val;
					break;
				}
			}
		}
		return ret;
	}
}

function main()
{
	while (!isdefined(level.zone_capture.zones))
	{
		wait .1;
	} 

	REGISTER_OVERRIDE(SYSTEM_NAME,ARRAY_RANDOM,&random_override);

	level.fixed_templar_targets = TEMPLAR_TARGETS;

	level.fixed_templar_target_index = 0;

	keys = GetArrayKeys(level.zone_capture.zones);

	while (level.fixed_templar_target_index < level.fixed_templar_targets.size)
	{
		level.next_target_zone = array();

		desired_zones = level.fixed_templar_targets[level.fixed_templar_target_index];
		if (!IsArray(desired_zones)) desired_zones = array(desired_zones);
		foreach (val in desired_zones) array::add(level.next_target_zone,keys[val]);
		//level.next_target_zone = keys[level.fixed_templar_targets[level.fixed_templar_target_index]];
		level waittill("fixed_templar_target");
		level.fixed_templar_target_index++;
	}

	UNREGISTER_OVERRIDE(SYSTEM_NAME,ARRAY_RANDOM);
}