#using scripts\shared\array_shared;
#using scripts\shared\util_shared;

#insert scripts\shared\shared.gsh;
#insert scripts\zm\_conditions.gsh;
#insert scripts\zm\array_override\array_override_common.gsh;
#insert scripts\zm\script_override\forced_drops.gsh;

#namespace forced_drops;

function main()
{
	MAP_ASSIGN_LIST_RETURN(forced_drops_list)
	if (!forced_drops_list.size) return;
	init_fixed_drops(forced_drops_list);
	level.next_powerup_override = &next_powerup_override;
	level.fixed_powerup_index = 0;
	thread missed_drops_cleanup();
}

function next_powerup_override()
{
	// we earned enough points to spawn a drop but its before we want our next forced drop
	b_is_early = level.zombie_vars["zombie_drop_item"] && !IS_TRUE(level.force_drop);
	n = 0;
	next_drop = level.fixed_powerup_array[level.fixed_powerup_index].powerup_name;
	for (i = level.zombie_powerup_index; i < level.zombie_powerup_array.size; i++)
	{
		if (level.zombie_powerup_array[i] === next_drop)
		{
			array::swap(level.zombie_powerup_array,level.zombie_powerup_index + n + b_is_early,i);
			i = level.zombie_powerup_index;
			n++;
			if(isdefined(level.fixed_powerup_array[level.fixed_powerup_index + n]))
				next_drop = level.fixed_powerup_array[level.fixed_powerup_index + n].powerup_name;
			else break;
		}
	}
	if (!b_is_early)
	{
		level notify("fixed_powerup",level.fixed_powerup_array[level.fixed_powerup_index].powerup_name);
		level.fixed_powerup_index++;
		if (level.fixed_powerup_index >= level.fixed_powerup_array.size)
		{
			level util::delay(0.05,undefined,&on_fixed_powerups_complete);
		}
	}
}

function on_fixed_powerups_complete()
{
	level.next_powerup_override = undefined;
	level notify("fixed_powerups_done");
}

function private init_fixed_drops(forced_drops_list)
{
	level.fixed_powerup_array = array();
	foreach (i, item in forced_drops_list)
	{
		struct = SpawnStruct();
		struct.powerup_name = item[DROP_NAME_INDEX];
		struct.desired_round = item[DROP_ROUND_INDEX];
		if (!isdefined(struct.powerup_name) || !isdefined(struct.desired_round)) continue;
		struct.is_persistent = VAL(item[DROP_B_WAIT_INDEX],false);
		struct.condition_function_array = array();
		func_data = VAL(item[DROP_FUNC_INDEX],array());
		foreach (pair in func_data)
		{
			condition = SpawnStruct();
			condition.func = pair[0];
			condition.arg = VAL(pair[1],array());
			array::add(struct.condition_function_array,condition);
		}
		array::add(level.fixed_powerup_array,struct);
	}
}

function private missed_drops_cleanup()
{
	level endon("end_game");
	level endon("fixed_powerups_done");
	while(1)
	{
		level waittill("between_round_over");
		for (i = level.fixed_powerup_index; i < level.fixed_powerup_array.size; i++)
		{
			struct = level.fixed_powerup_array[i];
			if (!IS_TRUE(struct.is_persistent) && struct.desired_round < level.round_number) level.fixed_powerup_index++;
		}
	}
}