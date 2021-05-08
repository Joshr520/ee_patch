#namespace craftable_locations;

function init()
{
	thread main();
}

//gravityspike location indexes
#define TOWER_TO_DOUBLE 0
#define DOUBLE_TO_TOWER 1

#define DEATH_RAY_PIECE DOUBLE_TO_TOWER

//fuse location indexes
#define SLUMS_BOX 0
#define SLUMS_BARREL 1
#define SLUMS_RAIL 2
#define CANAL_BOX 0
#define CANAL_RAIL 1
#define CANAL_CART 2
#define THEATER_HVK 0
#define THEATER_RAIL 1
#define THEATER_BARREL 2

#define FUSE_1 SLUMS_BARREL
#define FUSE_2 CANAL_BOX
#define FUSE_3 THEATER_BARREL

//gas mask location indexes
#define GREEN_WATER 0 
#define GREEN_BOX 1
#define GREEN_PERK 2

#define VISOR GREEN_WATER

#define POWER_ROCK 0
#define POWER_ALTER 1
#define POWER_BOX 2

#define FILTER POWER_ALTER

#define PLANE_RIGHT 0
#define PLANE_TRAP 1
#define PLANE_ROCK 2

#define STRAP PLANE_TRAP

//maxis drone location indexes
#define ICE_TUNNEL 0
#define GEN5_PATH 1
#define GEN4_PATH 2

#define DIESELDRONE_BODY ICE_TUNNEL

#define GARAMAPHONE 0
#define STAFFS 1
#define PAP 2

#define DIESELDRONE_ENGINE GARAMAPHONE

//shield part location indexes
//ZOD
#define CANAL_STAIRS 0
#define CANAL_BRIDGE 1
#define CANAL_PERK 2

#define SLUMS_PERK 0
#define SLUMS_STATUE 1
#define SLUMS_STAIRS 2

#define THEATER_STAIRS 0
#define THEATER_PERK 1
#define THEATER_KUDA 2

#define ZOD_DOLLY CANAL_STAIRS
#define ZOD_DOOR SLUMS_STATUE
#define ZOD_CLAMP THEATER_KUDA


//CASTLE
#define UPPER_TOWER 0
#define UPPER_BOXES 1
#define UPPPER_STAIRS 2

#define LOWER_DRAGON 0
#define LOWER_BOXES 1
#define LOWER_ROOF 2

#define UNDER_LAB 0
#define UNDER_BOWS 1
#define UNDER_PAP 2

#define CASTLE_DOLLY UPPER_TOWER
#define CASTLE_DOOR LOWER_DRAGON
#define CASTLE_CLAMP UNDER_LAB


//ISLAND
#define BLUE_KUDA 0
#define BLUE_WALL 1
#define BLUE_CAGE 2

#define GREEN_SKULLS 0
#define GREEN_ROCK 1
#define GREEN_SWAMP 2

#define TURRET_CLOSE 0
#define TURRET_PLANT 1
#define TURRET_SPORE 2

#define ISLAND_DOLLY BLUE_CAGE
#define ISLAND_DOOR GREEN_ROCK
#define ISLAND_CLAMP TURRET_CLOSE


//STALINGRAD
#define INF_BED 0
#define INF_BELOW 1
#define INF_STAMINUP 2

#define COURTYARD_TRUCK 0
#define COURTYARD_SHELF 1
#define COURTYARD_JUG 2

#define ARM_BGB 0
#define ARM_BELOW 1
#define ARM_VALVE 2

#define STALINGRAD_DOLLY INF_BELOW
#define STALINGRAD_DOOR COURTYARD_SHELF
#define STALINGRAD_CLAMP ARM_BGB


//GENESIS
#define TRENCHES_BGB 0
#define TRENCHES_CHAIR 1
#define TRENCHES_BOX 2

#define VERRUCKT_COLUMN 0
#define VERRUCKT_CHAIR 1
#define VERRUCKT_KITCHEN 2

#define DE_PAP 0
#define DE_KUDA 1
#define DE_CHALK 2

#define GENESIS_DOLLY TRENCHES_BGB
#define GENESIS_DOOR VERRUCKT_COLUMN
#define GENESIS_CLAMP DE_CHALK


//TOMB
#define GEN2_SHED 0
#define GEN2_CART 1
#define GEN2_FOOTPRINT 2

#define NML_JUG 0
#define NML_MID 1
#define NML_STAM 2

#define GEN3_FIRE 0
#define GEN3_SHED 1
#define GEN3_SPEED 2

#define TOMB_DOLLY GEN2_SHED
#define TOMB_DOOR NML_JUG
#define TOMB_CLAMP GEN3_SPEED

function main()
{
	level.get_fixed_craftable_location = &get_desired_spawn_index;

	a_arg = array();

	switch(GetDvarString("mapname"))
	{
		case "zm_zod":
			a_arg[0] = ZOD_DOLLY;
			a_arg[1] = ZOD_DOOR;
			a_arg[2] = ZOD_CLAMP;
			break;
		case "zm_castle":
			a_arg[0] = CASTLE_DOLLY;
			a_arg[1] = CASTLE_DOOR;
			a_arg[2] = CASTLE_CLAMP;
			break;
		case "zm_island":
			a_arg[0] = ISLAND_DOLLY;
			a_arg[1] = ISLAND_DOOR;
			a_arg[2] = ISLAND_CLAMP;
			break;
		case "zm_stalingrad":
			a_arg[0] = STALINGRAD_DOLLY;
			a_arg[1] = STALINGRAD_DOOR;
			a_arg[2] = STALINGRAD_CLAMP;
			break;
		case "zm_genesis":
			a_arg[0] = GENESIS_DOLLY;
			a_arg[1] = GENESIS_DOOR;
			a_arg[2] = GENESIS_CLAMP;
			break;
		case "zm_tomb":
			a_arg[0] = TOMB_DOLLY;
			a_arg[1] = TOMB_DOOR;
			a_arg[2] = TOMB_CLAMP;
			break;
	}

	fixed_shield_parts(a_arg);
}

function fixed_shield_parts(a_arg)
{
	level.fixed_shield_parts = array();

	level.fixed_shield_parts["dolly"] = a_arg[0];
	level.fixed_shield_parts["door"] = a_arg[1];
	level.fixed_shield_parts["clamp"] = a_arg[2];
}

function get_desired_spawn_index(craftable_name)
{
	switch (craftable_name)
	{
		case "police_box_fuse_01":
			return FUSE_1;
		case "police_box_fuse_02":
			return FUSE_2;
		case "police_box_fuse_03":
			return FUSE_3;
		case "gasmask_part_visor":
			return VISOR;
		case "gasmask_part_filter":
			return FILTER;
		case "gasmask_part_strap":
			return STRAP;
		case "equip_dieseldrone_body":
			return DIESELDRONE_BODY;
		case "equip_dieseldrone_engine":
			return DIESELDRONE_ENGINE;
		case "craft_shield_zm_dolly":
			return level.fixed_shield_parts["dolly"];
		case "craft_shield_zm_door":
			return level.fixed_shield_parts["door"];
		case "craft_shield_zm_clamp":
			return level.fixed_shield_parts["clamp"];
		case "gravityspike_part_handle":
			return DEATH_RAY_PIECE;
	}
}