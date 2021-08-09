#using scripts\codescripts\struct;
#using scripts\shared\array_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\math_shared;

#using scripts\shared\ai\zombie_utility;

#using scripts\zm\_zm_zonemgr;

#insert scripts\shared\shared.gsh;

#insert scripts\zm\_system_identifiers.gsh;

#namespace condition;

function _default(a_arg){return true;}

#define PARAMS a_arg, system_name , system_arg

#define GET_ARGS MAKE_ARRAY(a_arg) MAKE_ARRAY(system_arg)

// forced_drops will use this a lot, shouldn't be used by fixed_spawns
function in_zone(PARAMS)
{
	GET_ARGS
	a_zone = VAL(a_arg[0],"zone_start");
	b_drop_in_zone = VAL(a_arg[1],true);
	switch (system_name)
	{
		case ZM_MAGICBOX:
		case ZM_POWERUPS:
			v_point = system_arg[0];
			break;
	}
	zone = zm_zonemgr::get_zone_from_position(v_point + (0,0,32), 1);
	MAKE_ARRAY(a_zone)
	b_ret = false;
	foreach (str_zone in a_zone)
	{
		if ( (zone != str_zone && !b_drop_in_zone) || (zone == str_zone && b_drop_in_zone) )
		{
			b_ret = true;
			break;
		}
	}
	return b_ret;
}

function num_zombies_left(PARAMS)
{
	GET_ARGS
	switch(system_name)
	{
		case ZM_POWERUPS:
			n_add = 1;
			break;
	}

	DEFAULT(n_add,0);
	
	num = a_arg[0];
	count = level.zombie_total + n_add + zombie_utility::get_current_zombie_count();
	if (isdefined(num) && count > num) return false;
	return true;
}

function is_flag_set(PARAMS) //untested
{
	GET_ARGS
	str_flag = a_arg[0];
	//MAKE_ARRAY(str_flag)
	if (!isdefined(str_flag)) return undefined;

	ent_function = a_arg[1];
	ent_function_args = a_arg[2];
	b_inverted = VAL(a_arg[3],false);
	if (IsFunctionPtr(ent_function)) ent = [[ent_function]](ent_function_args);
	else ent = level;

	if (!ent flag::exists(str_flag)) return false;

	b_ret = ent flag::get(str_flag);

	if (b_ret && !b_inverted || !b_ret && b_inverted) return true;
	else return false;
}

function num_staff_parts(PARAMS)
{
	GET_ARGS
	staffName = a_arg[0];
	numParts = a_arg[1];
	return level.num_staffpieces_picked_up[staffName] >= numParts;
}

// complete flag: "ritual_" + name +"_complete", names - femme, detective, boxer, magician, pap
// ready flag: "ritual_" + name + "_ready"
// item found flag: "memento_" + name + "_found"
#define RITUAL_FLAG_CHECK(__event,__state) character = a_arg[0];MAKE_ARRAY(character) \
	foreach (name in character){\
		str_flag = __event + "_" + name + "_" + __state;\
		if (!level flag::exists(str_flag)) continue;\
		if (!level flag::get(str_flag)) return 0;}\
		return 1;
function is_ritual_complete(PARAMS)
{
	GET_ARGS
	RITUAL_FLAG_CHECK("ritual","complete")
}

function is_ritual_ready(PARAMS)
{
	GET_ARGS
	RITUAL_FLAG_CHECK("ritual","ready")
}

function is_memento_found(PARAMS)
{
	GET_ARGS
	RITUAL_FLAG_CHECK("memento","found")
}