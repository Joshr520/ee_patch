#namespace zod_margwa_rounds;

function init()
{
	if (GetDvarString("mapname") == "zm_zod")
	{
		thread main();
	}
}


function main()
{
	while (!isdefined(level.n_next_margwa_round)) wait 1;
	while (1)
	{
		last_margwa_round = level.n_next_margwa_round;
		while(level.round_number <= last_margwa_round)	level waittill("end_of_round");
		level.n_next_margwa_round = last_margwa_round + 6;
	}
	
}