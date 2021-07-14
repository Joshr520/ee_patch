#using scripts\codescripts\struct;
#using scripts\shared\array_shared;
#using scripts\shared\flag_shared;

#namespace tomb_vinyl_locations;


function init()
{
	if (GetDvarString("mapname") == "zm_tomb")
	{
		thread main();
	}
}


#define GEN2_MAGICBOX 0
#define GEN2_SHELF 1
#define GEN2_TABLE 2

#define VINYL_ICE GEN2_SHELF

#define GEN5_BOXES 0
#define GEN5_TUNNEL 1
#define GEN5_STAMINUP 2

#define VINYL_WIND GEN5_STAMINUP

#define GEN4_JUG 0
#define GEN4_TUNNEL 1
#define GEN4_WAGON 2

#define VINYL_LIGHTNING GEN4_TUNNEL

#define GEN6_BOXES 0
#define GEN6_TABLET 1
#define GEN6_TANK 2

#define VINYL_FIRE GEN6_BOXES

#define NML_TRENCHES 0
#define NML_MOUND 1
#define NML_CHURCH 2

#define VINYL_MASTER NML_MOUND

#define UNDER_FAR 0
#define UNDER_CLOSE 1

#define VINYL_PLAYER UNDER_CLOSE

//these must be left alone to not be cheating
#define ICE_ORG (39.0582 , 3858.78, -320.326)
#define ICE_ANG (355.448 , 166.366 , 30.465)
#define WIND_ORG (-2457.9 , -67.1315 , 275.758)
#define WIND_ANG (332.113 , 354.738 , 24.383)
#define LIGHT_ORG (1476.42 , 228.565 , 178.202)
#define LIGHT_ANG (309.321 , 260.91 , -25.5596)
#define FIRE_ORG (611.426 , -2465.38 , 61.922)
#define FIRE_ANG (339.983 , 128.026 , -137.051)
#define MASTER_ORG (-313.98 , -947.25 , 126.92)
#define MASTER_ANG (13.6575 , 280.618 , -16.0643)
#define PLAYER_ORG (-272.93 , 262.39 , 51.32)
#define PLAYER_ANG (84.574 , 239.514 , -14.0374)

function main()
{
	a_randomized_craftables = 	array("gramophone_vinyl_ice", "gramophone_vinyl_air", "gramophone_vinyl_elec", "gramophone_vinyl_fire", "gramophone_vinyl_master", "gramophone_vinyl_player");
	a_indexes = 				array(VINYL_ICE 			, VINYL_WIND			, VINYL_LIGHTNING			, VINYL_FIRE			, VINYL_MASTER 			, VINYL_PLAYER);
	
	a_original_loc = array(ICE_ORG,WIND_ORG,LIGHT_ORG,FIRE_ORG,MASTER_ORG,PLAYER_ORG);
	a_original_angle = array(ICE_ANG,WIND_ANG,LIGHT_ANG,FIRE_ANG,MASTER_ANG,PLAYER_ANG);


	level flag::wait_till("start_zombie_round_logic");

	foreach(index,str_craftable in a_randomized_craftables)
	{
		s_original_pos = struct::get(str_craftable, "targetname");
		a_alt_locations = struct::get_array(str_craftable + "_alt", "targetname");
		n_loc_index = a_indexes[index];
		if(n_loc_index == a_alt_locations.size)
		{
			fixed_loc = a_original_loc[index];
			fixed_angle = a_original_angle[index];
		}
		else
		{
			fixed_loc = a_alt_locations[n_loc_index].origin;
			fixed_angle = a_alt_locations[n_loc_index].angles;
		}
		s_original_pos.origin = fixed_loc;
		s_original_pos.angles = fixed_angle;
	}
}