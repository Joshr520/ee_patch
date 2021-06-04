#using scripts\shared\lui_shared;
#using scripts\shared\flag_shared;

#namespace rocket_test_timer;

function main()
{
	if(GetDvarString("mapname") != "zm_castle") return;
	level flag::wait_till("initial_blackscreen_passed");
	rocket_timer = NewHudElem();
	rocket_timer.hidewheninmenu = 1;
	rocket_timer.horzAlign = "user_left";
	rocket_timer.vertAlign = "user_top";
	rocket_timer.alignX = "left";
	rocket_timer.alignY = "top";
	rocket_timer.x = 15;
	rocket_timer.y = 2.5;
	rocket_timer.foreground = 1;
	rocket_timer.font = "default";
	rocket_timer.fontscale = 1.5;
	rocket_timer.color = (1, 1, 1);
	rocket_timer.alpha = 1;
	
	level waittill("zone_v10_pad");

	rocket_timer SetTimer(60);
	wait(60);
	rocket_timer SetText("");

	level flag::wait_till("rocket_firing");
	level flag::wait_till_clear("rocket_firing");

	rocket_timer SetTimer(120);
	wait(120);
	rocket_timer SetText("");
}