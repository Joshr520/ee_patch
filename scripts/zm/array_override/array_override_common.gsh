#define ARRAY_RANDOM 0
#define ARRAY_RANDOMIZE 1

#define REGISTER_OVERRIDE(str_name,n_type,func) array_override::register(str_name,n_type,func)

#define UNREGISTER_OVERRIDE(str_name,n_type) array_override::unregister(str_name,n_type)