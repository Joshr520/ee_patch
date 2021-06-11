#using scripts\zm\array_override\array_override_common;

#insert scripts\zm\array_override\array_override_common.gsh;

#namespace fixed_specific_powerups;

#define SYSTEM_NAME "fixed_specific_powerups"
function init()
{
	REGISTER_OVERRIDE(SYSTEM_NAME,ARRAY_RANDOM,&random_override);
	//thread main();
}

function random_override(array)
{
	if(IsInArray(array, "double_points") && (isdefined(self.archetype) && self.archetype == "margwa"))
	{
		//IPrintLnBold("Margwa died, giving nuke powerup");
		if(level.round_number == 6) return "minigun";
		return "nuke";
	}
}

function main()
{

}