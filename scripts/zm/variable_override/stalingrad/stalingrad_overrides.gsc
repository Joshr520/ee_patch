#using scripts\shared\flag_shared;
#using scripts\shared\array_shared;
#using scripts\shared\scene_shared;
#using scripts\shared\util_shared;

#namespace stalingrad_overrides;

function main()
{
	thread modify_valves();

	thread modify_dragon_spit();
	thread monitor_department_top();
	thread monitor_dragon_rounds();

	thread modify_password();

	thread modify_cylinder_rate();
}

// Custom function to modify dragon spit
/*
	When dragon first spits, get the next spit to be 2 rounds after
	Once the round ends after that, it's safe to assume the second spit has been completed
	We then make it so dragon never spits again
	In every function, we're waiting by 1 to make sure our variables don't get overwritten by the game functions
*/
function modify_dragon_spit()
{
	//thread print_spit();
	level waittill("arrival");
	next_spit = level.round_number + 2;
	level waittill("between_round_over");
	wait 1;
	level.var_de98a8ad = 0;
	while (level.round_number != next_spit)
	{
		level waittill("between_round_over");
	}
	wait 1;
	level.var_de98a8ad = 1;
	level waittill("between_round_over");
	while(1)
	{
		wait 1;
		if(level.var_de98a8ad > 0) level.var_de98a8ad = 0;
	}
}

function print_spit()
{
	while(1)
	{
		wait(10);
		IPrintLnBold("Spit Variable: " + level.var_de98a8ad);
	}
}

function monitor_department_top()
{
	level endon("hash_dfaade1d");
	wait 1;
	level.var_a8b674f9 = 0;
	level flag::wait_till("department_store_upper_open");
	if(level.round_number >= 5) return;
	wait 1;
	level.var_a8b674f9 = 1;
	level.var_de98a8ad = 1;
}

function monitor_dragon_rounds()
{
	level endon("hash_dfaade1d");
	wait 1;
	level.var_de98a8ad = 0;
	level flag::wait_till("initial_blackscreen_passed");
	while(level.round_number <= 4)
	{
		level waittill("between_round_over");
	}
	wait 1;
	if (!flag::get("department_store_upper_open")) level.var_de98a8ad = 1;
	//level.var_de98a8ad = 0.35;
}

function modify_cylinder_rate()
{
	level flag::wait_till("power_on");
	while(1)
	{
		if(level.var_583e4a97.var_a43689b5 == 10)
		{
			level.var_583e4a97.var_a43689b5 = 100;
			level flag::wait_till("drop_pod_active");
			level flag::wait_till_clear("drop_pod_active");
		}
		wait 0.1;
	}
}

// DEFAULT POSITIONS
/*
level.var_4c56821d[0].var_92f9e88c = 0;
level.var_4c56821d[1].var_92f9e88c = 6;
level.var_4c56821d[2].var_92f9e88c = 0;
level.var_4c56821d[3].var_92f9e88c = 7;
level.var_4c56821d[4].var_92f9e88c = 6;
level.var_4c56821d[5].var_92f9e88c = 4;
*/
#define LETTER_ARRAY array(7, 6, 0, 7, 6, 4)
function modify_password()
{
	level flag::wait_till("ee_cylinder_acquired");
	while(level.var_4c56821d.size != 6)	wait 0.1;
	foreach(index, letter in level.var_4c56821d)
	{
		letter thread move_letter(index);
	}
}

function move_letter(num_letter)
{
	while(!isdefined(self.var_c957db9f)) wait 0.1;
	while(self.var_c957db9f != LETTER_ARRAY[num_letter])
	{
		self.var_c957db9f++;
		if(self.var_c957db9f == 8)
		{
			self.var_c957db9f = 0;
		}
		self RotateYaw(45, 0.5);
		self waittill("rotatedone");
	}
}

function print_password()
{
	foreach(index, letter in level.var_4c56821d)
	{
		IPrintLnBold("Num: " + index + " Pos: " + letter.var_c957db9f);
	}
}

function modify_valves()
{
	// store, library, armory, barracks, factory, command
	//thread print_valves();
	while(1)
	{
		if(isdefined(level.var_57f8b6c5[0].var_1f3c0ca7)) level.var_57f8b6c5[0].var_1f3c0ca7 = 0;
		if(isdefined(level.var_57f8b6c5[1].var_1f3c0ca7)) level.var_57f8b6c5[1].var_1f3c0ca7 = 2;
		if(isdefined(level.var_57f8b6c5[2].var_1f3c0ca7)) level.var_57f8b6c5[2].var_1f3c0ca7 = 0;
		if(isdefined(level.var_57f8b6c5[3].var_1f3c0ca7)) level.var_57f8b6c5[3].var_1f3c0ca7 = 2;
		if(isdefined(level.var_57f8b6c5[4].var_1f3c0ca7)) level.var_57f8b6c5[4].var_1f3c0ca7 = 0;
		if(isdefined(level.var_57f8b6c5[5].var_1f3c0ca7)) 
		{
			level.var_57f8b6c5[5].var_1f3c0ca7 = 0;
			break;
		}
		wait 0.1;
	}
}

function print_valves()
{
	level flag::wait_till("initial_blackscreen_passed");
	while(1)
	{
		wait 5;
		foreach(var_beb54dbd in level.var_57f8b6c5)
		{
			IPrintLnBold(var_beb54dbd.script_label + " " + var_beb54dbd.var_1f3c0ca7);
			wait 0.3;
		}
	}
}

function function_450d606e()
{
	var_367b15e7 = GetEnt(self.target, "targetname");
	v_origin = self GetTagOrigin("tag_lever");
	v_angles = self GetTagAngles("tag_lever");
	var_367b15e7.origin = v_origin;
	var_367b15e7.angles = v_angles;
	if(self.var_1f3c0ca7 == 0)
	{
		var_367b15e7 RotatePitch(240, 0.1);
	}
	else if(self.var_1f3c0ca7 == 2)
	{
		var_367b15e7 RotatePitch(120, 0.1);
	}
	var_6403853b = function_d6953423(self.var_cd705a9[self.var_1f3c0ca7]);
	var_6403853b.var_59c68a0b++;
}

function function_797708de()
{
	var_a95dc9d9 = level.var_57f8b6c5[0];
	var_70172e4a = [];
	for(i = 0; i < 6; i++)
	{
		Array::add(var_70172e4a, var_a95dc9d9, 0);
		var_a95dc9d9 = function_d6953423(var_a95dc9d9.var_cd705a9[var_a95dc9d9.var_1f3c0ca7]);
	}
	if(var_70172e4a.size != 6)
	{
		return 0;
	}
	if(var_70172e4a[5] != level.var_57f8b6c5[5])
	{
		return 0;
	}
	return 1;
}

function function_d6953423(str_location)
{
	foreach(var_beb54dbd in level.var_57f8b6c5)
	{
		if(var_beb54dbd.script_label == str_location)
		{
			return var_beb54dbd;
		}
	}
}