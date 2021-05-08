#using scripts\shared\flag_shared;

#namespace zombie_timer;

function init()
{
	thread monitor_time();
	//thread monitor_flags();

	//5while(!isdefined(level.n_gameplay_start_time))
	//{
	//	wait 0.1;
	//}
	//thread monitor_ms_time();
}

function monitor_flags()
{
	switch (GetDvarString("mapname"))
	{
		case "zm_zod":
			level.flag_array = array("ee_begin","ee_book","ee_keeper_magician_resurrected","ee_keeper_magician_armed","ee_boss_started","ee_boss_defeated","ee_boss_vulnerable","ee_superworm_present","ee_final_boss_beam_active","ee_final_boss_defeated","ee_final_boss_midattack","ee_final_boss_staggered","ee_complete","ee_ending_flash","ee_ending_fade","totem_placed");
			break;
		case "zm_factory":
			break;
		case "zm_castle":
			break;
		case "zm_island":
			break;
		case "zm_stalingrad":
			break;
		case "zm_genesis":
			break;
		case "zm_prototype":
			break;
		case "zm_asylum":
			break;
		case "zm_sumpf":
			break;
		case "zm_theater":
			break;
		case "zm_cosmodrome":
			break;
		case "zm_temple":
			break;
		case "zm_moon":
			break;
		case "zm_tomb":
			break;
	}
	foreach(flag in level.flag_array)
	{
		thread wait_for_flag(flag);
	}
}

function wait_for_flag(flag)
{
	level flag::wait_till(flag);
	print_time();
	level flag::wait_till_clear(flag);
	wait_for_flag(flag);
}

function monitor_time()
{
	switch (GetDvarString("mapname"))
	{
		case "zm_zod":
			level flag::wait_till("ee_boss_defeated");
			c = print_time();
			break;
		case "zm_factory":
			break;
		case "zm_castle":
			level flag::wait_till("ee_outro");
			c = print_time();
			break;
		case "zm_island":
			level flag::wait_till("flag_play_outro_cutscene");
			c = print_time();
			break;
		case "zm_stalingrad":
			level waittill("hash_9b1cee4c");
			c = print_time();
			break;
		case "zm_genesis":
			level waittill("hash_f468c531");
			c = print_time();
			break;
		case "zm_prototype":
			break;
		case "zm_asylum":
			break;
		case "zm_sumpf":
			break;
		case "zm_theater":
			break;
		case "zm_cosmodrome":
			break;
		case "zm_temple":
			break;
		case "zm_moon":
			break;
		case "zm_tomb":
			break;
	}
}

function print_time()
{
	level endon("end_game");

	clock = NewHudElem();
	clock.alignX = "center";
	clock.alignY = "top";
	clock.horzAlign = "user_center";
	clock.vertAlign = "user_top";
	clock.foreground = 1;
	clock.hidewheninmenu = 0;
	clock.x = 0;
	clock.y = 7.5;
	clock.alpha = 1;
	clock.font = "default";
	clock.fontScale = 2;
	clock.color = (0.5,0.9,0.7);

	time = level.ms_time;

	time_ms = modulo_by_base(time, 1000);
	time = Floor(time / 1000);

	time_s = modulo_by_base(time, 60);
	time = Floor(time / 60);

	time_m = modulo_by_base(time, 60);
	time = Floor(time / 60);

	time_h = Floor(time);

	s_time_h = get_string_hours(time_h);
	s_time_m = get_string_minutes(time_m, time_h);
	s_time_s = get_string_seconds(time_s, time_m);
	s_time_ms = get_string_milliseconds(time_ms);
	s_time = "";

	if(time_h > 0) s_time += s_time_h + ":";
	if(time_m > 0) s_time += s_time_m + ":";
	if(time_s > 0) s_time += s_time_s + ".";
	if(time_ms > 0) s_time += s_time_ms;

	clock SetText(s_time);

	return clock;
}

function monitor_ms_time()
{
	level.ms_time = 0;
	time = GetTime();
	while(1)
	{
		wait 0.05;
		level.ms_time += 0.01666666666666666666666666666667;
		if(level.ms_time >= 4.137) break;
	}
	IPrintLnBold(level.ms_time + level.ms_time + level.ms_time);
	IPrintLnBold(GetTime() - time);
}

function round(num, decimal_places)
{ 
	power = Pow(10, decimal_places);
	num *= power;
 
	return ((num >= 0) ? Int(num + 0.5)/power : Int(num - 0.5)/power);
}

function clear_time()
{
	self.clock Destroy();
}

function modulo_by_base(time, base)
{
	if(Floor(time) == 0) return 0;
	divided = time / base;
 	return Ceil((divided - Floor(divided)) * base);
}

function get_string_hours(time)
{
	if(time == 0) s_time_h = "";
	else if(time < 10) s_time_h = "0" + time;
	else s_time_h = time;
	return s_time_h;
}

function get_string_minutes(time, time_h)
{
	if(time == 0) s_time_m = "";
	else if(time_h > 0 && time < 10) s_time_m = "0" + time;
	else s_time_m = time;
	return s_time_m;
}

function get_string_seconds(time, time_m)
{
	if(time == 0) s_time_s = "";
	else if(time_m > 0 && time < 10) s_time_s = "0" + time;
	else s_time_s = time;
	return s_time_s;
}

function get_string_milliseconds(time)
{
	if(time == 0) s_time_ms = "";
	else if(time < 10) s_time_ms = "00" + time;
	else if(time < 100) s_time_ms = "0" + time;
	else s_time_ms = time;
	return s_time_ms;
}