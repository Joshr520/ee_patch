#define TRY_TOKEN ";"
#define TRY(zone) TRY_TOKEN+zone
#define ZONE_NAME_INDEX 0

#define EMPTY array(array(),array(),array(),array())

// Possible ABH locations by zone on SOE
/* 
"zone_start" 			- starting area
"zone_theater_B" 		- theater outside train
"zone_theater_high_A"	- theater by perk machine
"zone_theater_junction" - theater district entrance
"zone_slums_D" 			- slums down by the HVK
"zone_slums_high_B" 	- slums by perk machine/egg statue
"zone_slums_junction"	- slums district entrance
"zone_canal_D"			- canal by train outside ruby rabbit
"zone_canal_high_A"		- canal by perk machine
"zone_canal_junction"	- canal district entrance
"zone_subway_central"	- underground by the sword locker
"zone_subway_pap_ritual"- pap room by ritual table
*/

#define ZOD_P0_ABH_ZONES_C array("zone_canal_D","zone_subway_central","zone_start","zone_theater_high_A","zone_slums_D","zone_start","zone_canal_junction","zone_theater_high_A","zone_subway_central")
#define ZOD_P0_ABH_ZONES_M array("zone_canal_D","zone_subway_central","zone_start","zone_theater_high_A","zone_slums_D","zone_start","zone_canal_junction","zone_theater_high_A","zone_subway_central")

#define ZOD_P1_ABH_ZONES_C array()
#define ZOD_P1_ABH_ZONES_M array()

#define ZOD_P2_ABH_ZONES_C array()
#define ZOD_P2_ABH_ZONES_M array()

#define ZOD_P3_ABH_ZONES_C array()
#define ZOD_P3_ABH_ZONES_M array()

#define ZOD array(ZOD_P0_ABH_ZONES_C,ZOD_P1_ABH_ZONES_C,ZOD_P2_ABH_ZONES_C,ZOD_P3_ABH_ZONES_C)
#define ZOD_2 array(ZOD_P0_ABH_ZONES_M,ZOD_P1_ABH_ZONES_M,ZOD_P2_ABH_ZONES_M,ZOD_P3_ABH_ZONES_M)

// Possible ABH locations by zone on DE
/*
"zone_start"					- starting area
"zone_tram_to_gatehouse"		- outside spawn behind gatehouse
"zone_lower_gatehouse"			- gatehouse next to doubletap
"zone_lower_courtyard"			- lower courtyard in front of gatehouse
"zone_lower_courtyard_upper"	- lower courtyard on the bridge
"zone_gatehouse"				- top gatehouse by wundersphere
"zone_rooftop"					- next to pap by death ray
"zone_clocktower"				- in the clocktower
"zone_courtyard_edge"			- next to gumball machine outside clocktower
"zone_great_hall_upper_left"	- great hall staircase behind speedcola
"zone_great_hall_upper"			- great hall door leading to power
"zone_courtyard"				- staircase leading to great hall
"zone_tram_to_subclocktower"	- path leading from mulekick to courtyard
"zone_undercroft_pap_hall"		- undercroft door leading to lower corutyard
"zone_undercroft"				- in front of undercroft dragon
"zone_v10_pad"					- next to teleporter at rocket test
"zone_v10_pad_door"				- outside rocket test
*/

#define CASTLE_P0_ABH_ZONES_C array("zone_rooftop","zone_undercroft","zone_gatehouse","zone_undercroft","zone_rooftop","zone_clocktower")
#define CASTLE_P0_ABH_ZONES_M array("zone_rooftop","zone_undercroft","zone_gatehouse","zone_undercroft","zone_rooftop","zone_clocktower")

#define CASTLE_P1_ABH_ZONES_C array("zone_v10_pad","zone_tram_to_subclocktower","zone_tram_to_subclocktower")
#define CASTLE_P1_ABH_ZONES_M array("zone_v10_pad","zone_tram_to_subclocktower","zone_tram_to_subclocktower")

#define CASTLE_P2_ABH_ZONES_C array()
#define CASTLE_P2_ABH_ZONES_M array()

#define CASTLE_P3_ABH_ZONES_C array()
#define CASTLE_P3_ABH_ZONES_M array()

#define CASTLE array(CASTLE_P0_ABH_ZONES_C,CASTLE_P1_ABH_ZONES_C,CASTLE_P2_ABH_ZONES_C,CASTLE_P3_ABH_ZONES_C)
#define CASTLE_2 array(CASTLE_P0_ABH_ZONES_M,CASTLE_P1_ABH_ZONES_M,CASTLE_P2_ABH_ZONES_M,CASTLE_P3_ABH_ZONES_M)

// Possible ABH locations by zone on GK
/*
"start_A_zone"						- first half of starting area
"department_store_floor2_A_zone"	- second floor of department store by the stairs leading up
"bunker_zone"						- bunker by shield craftable
"judicial_A_zone"					- dragon commmand by sophia
"factory_C_zone"					- tank factory by double tap
"library_B_zone"					- supply by the gumball machine
"pavlovs_B_zone"					- hatchery by pap
*/

#define STALINGRAD_P0_ABH_ZONES_C array("pavlovs_B_zone", "bunker_zone", "pavlovs_B_zone", "start_A_zone", "judicial_A_zone", "department_store_floor2_A_zone", "factory_C_zone", "start_A_zone", "pavlovs_B_zone","judicial_A_zone","start_A_zone")
#define STALINGRAD_P0_ABH_ZONES_M array("pavlovs_B_zone", "bunker_zone", "pavlovs_B_zone", "start_A_zone", "judicial_A_zone", "department_store_floor2_A_zone", "factory_C_zone", "start_A_zone", "pavlovs_B_zone","judicial_A_zone","start_A_zone")

#define STALINGRAD_P1_ABH_ZONES_C array()
#define STALINGRAD_P1_ABH_ZONES_M array()

#define STALINGRAD_P2_ABH_ZONES_C array()
#define STALINGRAD_P2_ABH_ZONES_M array()

#define STALINGRAD_P3_ABH_ZONES_C array()
#define STALINGRAD_P3_ABH_ZONES_M array()

#define STALINGRAD array(STALINGRAD_P0_ABH_ZONES_C,STALINGRAD_P1_ABH_ZONES_C,STALINGRAD_P3_ABH_ZONES_C,STALINGRAD_P3_ABH_ZONES_C)
#define STALINGRAD_2 array(STALINGRAD_P0_ABH_ZONES_M,STALINGRAD_P1_ABH_ZONES_M,STALINGRAD_P2_ABH_ZONES_M,STALINGRAD_P3_ABH_ZONES_M)

#define TOMB_P0_ABH_ZONES_C array("zone_start_a", "zone_start_a","zone_nml_5","zone_nml_16","zone_nml_5","zone_nml_16")
#define TOMB_P0_ABH_ZONES_M array("zone_start_a", "zone_start_a","zone_nml_5","zone_nml_16","zone_nml_5","zone_nml_16")

#define TOMB_P1_ABH_ZONES_C array()
#define TOMB_P1_ABH_ZONES_M array()

#define TOMB_P2_ABH_ZONES_C array()
#define TOMB_P2_ABH_ZONES_M array()

#define TOMB_P3_ABH_ZONES_C array()
#define TOMB_P3_ABH_ZONES_M array()

#define TOMB array(TOMB_P0_ABH_ZONES_C,TOMB_P1_ABH_ZONES_C,TOMB_P3_ABH_ZONES_C,TOMB_P3_ABH_ZONES_C)
#define TOMB_2 array(TOMB_P0_ABH_ZONES_M,TOMB_P1_ABH_ZONES_M,TOMB_P2_ABH_ZONES_M,TOMB_P3_ABH_ZONES_M)

// ISLAND

#define ISLAND_R0_ABH_ZONES_M array()
#define ISLAND_R0_ABH_ZONES_C array()

#define ISLAND_R1_ABH_ZONES_M ISLAND_R0_ABH_ZONES_M
#define ISLAND_R1_ABH_ZONES_C ISLAND_R0_ABH_ZONES_C

#define ISLAND_R2_ABH_ZONES_M ISLAND_R0_ABH_ZONES_M
#define ISLAND_R2_ABH_ZONES_C ISLAND_R0_ABH_ZONES_C

#define ISLAND_R3_ABH_ZONES_M ISLAND_R0_ABH_ZONES_M
#define ISLAND_R3_ABH_ZONES_C ISLAND_R0_ABH_ZONES_C

#define ISLAND array(ISLAND_R0_ABH_ZONES_M,ISLAND_R1_ABH_ZONES_M,ISLAND_R2_ABH_ZONES_M,ISLAND_R3_ABH_ZONES_M)
#define ISLAND_2 array(ISLAND_R0_ABH_ZONES_C,ISLAND_R1_ABH_ZONES_C,ISLAND_R2_ABH_ZONES_C,ISLAND_R3_ABH_ZONES_C)

// MOON

#define MOON_R0_ABH_ZONES_M array()
#define MOON_R0_ABH_ZONES_C array()

#define MOON_R1_ABH_ZONES_M MOON_R0_ABH_ZONES_M
#define MOON_R1_ABH_ZONES_C MOON_R0_ABH_ZONES_C

#define MOON_R2_ABH_ZONES_M MOON_R0_ABH_ZONES_M
#define MOON_R2_ABH_ZONES_C MOON_R0_ABH_ZONES_C

#define MOON_R3_ABH_ZONES_M MOON_R0_ABH_ZONES_M
#define MOON_R3_ABH_ZONES_C MOON_R0_ABH_ZONES_C

#define MOON array(MOON_R0_ABH_ZONES_M,MOON_R1_ABH_ZONES_M,MOON_R2_ABH_ZONES_M,MOON_R3_ABH_ZONES_M)
#define MOON_2 array(MOON_R0_ABH_ZONES_C,MOON_R1_ABH_ZONES_C,MOON_R2_ABH_ZONES_C,MOON_R3_ABH_ZONES_C)

// GENESIS 

#define GENESIS_R0_ABH_ZONES_M array()
#define GENESIS_R0_ABH_ZONES_C array()

#define GENESIS_R1_ABH_ZONES_M GENESIS_R0_ABH_ZONES_M
#define GENESIS_R1_ABH_ZONES_C GENESIS_R0_ABH_ZONES_C

#define GENESIS_R2_ABH_ZONES_M GENESIS_R0_ABH_ZONES_M
#define GENESIS_R2_ABH_ZONES_C GENESIS_R0_ABH_ZONES_C

#define GENESIS_R3_ABH_ZONES_M GENESIS_R0_ABH_ZONES_M
#define GENESIS_R3_ABH_ZONES_C GENESIS_R0_ABH_ZONES_C

#define GENESIS array(GENESIS_R0_ABH_ZONES_M,GENESIS_R1_ABH_ZONES_M,GENESIS_R2_ABH_ZONES_M,GENESIS_R3_ABH_ZONES_M)
#define GENESIS_2 array(GENESIS_R0_ABH_ZONES_C,GENESIS_R1_ABH_ZONES_C,GENESIS_R2_ABH_ZONES_C,GENESIS_R3_ABH_ZONES_C)

#define FACTORY EMPTY
#define FACTORY_2 EMPTY

#define PROTOTYPE EMPTY
#define PROTOTYPE_2 EMPTY
#define ASYLUM EMPTY
#define ASYLUM_2 EMPTY
#define SUMPF EMPTY
#define SUMPF_2 EMPTY
#define THEATER EMPTY
#define THEATER_2 EMPTY
#define COSMODROME EMPTY
#define COSMODROME_2 EMPTY
#define TEMPLE EMPTY
#define TEMPLE_2 EMPTY

#define ZOD_FUNC &zod_validation
#define FACTORY_FUNC &factory_validation
#define CASTLE_FUNC &castle_validation
#define ISLAND_FUNC &island_validation
#define STALINGRAD_FUNC &stalingrad_validation
#define GENESIS_FUNC &genesis_validation
#define PROTOTYPE_FUNC &default_validation
#define ASYLUM_FUNC &default_validation
#define SUMPF_FUNC &default_validation
#define THEATER_FUNC &default_validation
#define COSMODROME_FUNC &default_validation
#define TEMPLE_FUNC &default_validation
#define MOON_FUNC &default_validation
#define TOMB_FUNC &tomb_validation