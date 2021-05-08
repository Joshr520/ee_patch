#insert scripts\zm\array_override\array_override_common.gsh;

#namespace array_override;

function register(str_name,n_type,func)
{
	switch(n_type)
	{
		case ARRAY_RANDOM:
			if (!isdefined(level.array_random_override)) level.array_random_override = array();
			level.array_random_override[str_name] = func;
			break;
		case ARRAY_RANDOMIZE:
			if (!isdefined(level.array_randomize_override)) level.array_randomize_override = array();
			level.array_randomize_override[str_name] = func;
			break;
	}
}

function unregister(str_name,n_type)
{
	switch(n_type)
	{
		case ARRAY_RANDOM:
			ArrayRemoveIndex(level.array_random_override,str_name,1);
			break;
		case ARRAY_RANDOMIZE:
			ArrayRemoveIndex(level.array_randomize_override,str_name,1);
			break;
	}
}