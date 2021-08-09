
#using scripts\zm\_conditions;

#insert scripts\zm\_system_identifiers.gsh;

#define DEFAULT_CONDITION &condition::_default
#define IN_ZONE_FUNC &condition::in_zone
#define NUM_ZOMBIES_LEFT_FUNC &condition::num_zombies_left
#define FLAG_SET_FUNC &condition::is_flag_set
#define NUM_STAFF_PARTS_FUNC &condition::num_staff_parts
#define RITUAL_COMPLETE_FUNC &condition::is_ritual_complete
#define RITUAL_READY_FUNC &condition::is_ritual_ready
#define MEMENTO_FOUND_FUNC &condition::is_memento_found

#define __DROP_IN_ZONE(zone,b_inside) array(IN_ZONE_FUNC,array(zone,b_inside))
#define DROP_INSIDE(zone) __DROP_IN_ZONE(zone,true)
#define DROP_OUTSIDE(zone) __DROP_IN_ZONE(zone,false)

#define __NUM_ZOMBIES_LEFT(num) array(NUM_ZOMBIES_LEFT_FUNC,array(num))
#define NUM_ZOMBIES_LEFT(num) __NUM_ZOMBIES_LEFT(num)

#define __FLAG_SET(str_flag,ent_func,ent_func_arg,b_inverted) array(FLAG_SET_FUNC,array(str_flag,ent_func,ent_func_arg,b_inverted))
#define FLAG_SET(str_flag) __FLAG_SET(str_flag,undefined,undefined,0)
#define FLAG_CLEAR(str_flag) __FLAG_SET(str_flag,undefined,undefined,1)
#define FLAG_SET_ENT(str_flag,ent_func,ent_func_arg) __FLAG_SET(str_flag,ent_func,ent_func_arg,0)
#define FLAG_CLEAR_ENT(str_flag,ent_func,ent_func_arg) __FLAG_SET(str_flag,ent_func,ent_func_arg,1)

#define __NUM_STAFF_PARTS(staff,num) array(NUM_STAFF_PARTS_FUNC,array(staff,num))
#define NUM_STAFF_PARTS(staff,num) __NUM_STAFF_PARTS(staff,num)

#define __RITUAL_COMPLETE(names) array(RITUAL_COMPLETE_FUNC,array(names))
#define RITUAL_COMPLETE(names) __RITUAL_COMPLETE(names)

#define __RITUAL_READY(names) array(RITUAL_READY_FUNC,array(names))
#define RITUAL_READY(names) __RITUAL_READY(names)

#define __MEMENTO_FOUND(names) array(MEMENTO_FOUND_FUNC,array(names))
#define MEMENTO_FOUND(names) __MEMENTO_FOUND(names)