#using scripts\shared\array_shared;
#using scripts\shared\callbacks_shared;
#using scripts\shared\flag_shared;
#insert scripts\shared\shared.gsh;
#insert scripts\zm\array_override\array_override_common.gsh;

#namespace array_override;

#define NOTIFY_LEVEL(n_add) self notify("override_state_change",n_type,str_name,n_add,IsInArray(self.override_notif_exclude,str_name))

function register(str_name,n_type,func)
{
	switch(n_type)
	{
		case ARRAY_RANDOM:
			self.array_random_override[str_name] = func;
			break;
		case ARRAY_RANDOMIZE:
			self.array_randomize_override[str_name] = func;
			break;
	}
	NOTIFY_LEVEL(1);
}

function unregister(str_name,n_type)
{
	switch(n_type)
	{
		case ARRAY_RANDOM:
			ArrayRemoveIndex(self.array_random_override,str_name,1);
			break;
		case ARRAY_RANDOMIZE:
			ArrayRemoveIndex(self.array_randomize_override,str_name,1);
			break;
	}
	NOTIFY_LEVEL(-1);
}

function exclude_from_notif(name)
{
	if (!isdefined(self.override_notif_exclude)) self.override_notif_exclude = array();
	self.override_notif_exclude[self.override_notif_exclude.size] = name;
}

function remove_exlude_from_notif(name)
{
	ArrayRemoveValue(self.override_notif_exclude,name);
}

function autoexec init_player_overrides()
{
	callback::on_connect(&on_player_connect);
}

function private on_player_connect()
{
	self.array_random_override = array();
	self.array_randomize_override = array();
}

function register_recursive(str_name,n_type,func,b_ex_notif = false)
{
	switch(n_type)
	{
		case ARRAY_RANDOM:
			DEFAULT(level.recursive_random_override,array());
			level.recursive_random_override[str_name] = SpawnStruct();
			struct = level.recursive_random_override[str_name];
			break;
		case ARRAY_RANDOMIZE:
			DEFAULT(level.recursive_randomize_override,array());
			level.recursive_randomize_override[str_name] = SpawnStruct();
			struct = level.recursive_randomize_override[str_name];
			break;
	}
	struct.func = func;
	struct.b_ex_notif = b_ex_notif;
	struct.count = 0;
}

#define RECURSIVE_SWITCHBLOCK switch(n_type){\
	case ARRAY_RANDOM: struct = level.recursive_random_override[str_name];break;\
	case ARRAY_RANDOMIZE: struct = level.recursive_randomize_override[str_name];break;}\
	if (!isdefined(struct)) return;

function increment_register(str_name,n_type)
{
	RECURSIVE_SWITCHBLOCK
	if (struct.count <= 0)
	{
		struct.count = 0;
		if (struct.b_ex_notif) level exclude_from_notif(str_name);
		level register(str_name,n_type,struct.func);
	}
	struct.count++;
	thread update_recursive_flags(struct);
}

function decrement_register(str_name,n_type,b_unregister = false)
{
	RECURSIVE_SWITCHBLOCK
	struct.count--;
	thread update_recursive_flags(struct);
	if (b_unregister || struct.count <= 0)
	{
		level unregister(str_name,n_type);
		struct.count = 0;
		return;
	}
}

function run_recursive_override_instance(str_name,n_type,func)
{
	increment_register(str_name,n_type);
	[[func]]();
	decrement_register(str_name,n_type);
}

function add_recursive_override_flag(str_name,n_type,a_flags)
{
	RECURSIVE_SWITCHBLOCK
	DEFAULT(struct.a_flag,array());
	foreach (flag in a_flags)
	{
		if (!IsArray(flag)) flag_array = array(flag);
		else flag_array = flag;
		str_flag = flag_array[0];
		if (!isdefined(str_flag) || !IsString(str_flag)) continue;
		n_count = flag_array[1];
		DEFAULT(n_count,0);
		flag_struct = SpawnStruct();
		flag_struct.flag = str_flag;
		flag_struct.required_count = n_count;
		flag_struct.comparison = flag_array[2];
		struct.a_flag[struct.a_flag.size] = flag_struct;
		level flag::init(str_flag);
		update_specific_flag(flag_struct,struct.count);
		//if (struct.count == flag_struct.required_count) level flag::set(str_flag);
	}
}

function update_recursive_flags(struct)
{
	foreach (flag_struct in struct.a_flag)
	{
		update_specific_flag(flag_struct,struct.count);
	}
}

function update_specific_flag(flag_struct,n_count)
{
	if (IsFunctionPtr(flag_struct.required_count)) required_count = [[flag_struct.required_count]]();
	else required_count = flag_struct.required_count;
	if (isdefined(flag_struct.comparison))
	{
		b_val = [[flag_struct.comparison]](n_count,required_count);
	}
	else b_val = n_count === required_count;
	if (IS_TRUE(b_val))
	{
		level flag::set(flag_struct.flag);
		IPrintLnBold("set " + flag_struct.flag);
	}
	else
	{
		level flag::clear(flag_struct.flag);
		IPrintLnBold("cleared " + flag_struct.flag);
	}
}