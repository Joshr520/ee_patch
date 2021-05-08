#using scripts\codescripts\struct;
#using scripts\shared\flag_shared;
#using scripts\zm\craftables\_zm_craftables;

#namespace zod_idgun_pieces;

function init()
{
	if (GetDvarString("mapname") == "zm_zod")
	{
		thread main();
	}
}

function main()
{
	level flag::wait_till("initial_blackscreen_passed");
	level._wasp_death_cb = &wasp_death_cb_override;
}

function wasp_death_cb_override(params)
{
	if(level.round_number < 12)
	{
		return;
	}
	if(self.does_not_count_to_round === 1)
	{
		return;
	}
	if(level flag::get("part_xenomatter_found"))
	{
		return;
	}
	if(isdefined(level.xenomatter_dropped) && level.xenomatter_dropped)
	{
		return;
	}
	if(!IsPlayer(params.eAttacker))
	{
		return;
	}
	level.xenomatter_dropped = 1;
	org = self GetOrigin();
	point_inbounds = GetClosestPointOnNavMesh(org, 500, 0);
	xy_org = (org[0], org[1], 0);
	xy_point_inbounds = (point_inbounds[0], point_inbounds[1], 0);
	if(xy_org == xy_point_inbounds)
	{
		part_spawn(point_inbounds, "part_xenomatter");
	}
	if(!level flag::get("part_xenomatter_found"))
	{
		piece_model = level zm_craftables::get_craftable_piece_model("idgun", "part_xenomatter");
		place = struct::get("safe_place_for_items", "targetname");
		piece_model.origin = place.origin;
		level.xenomatter_dropped = 0;
	}
}

function part_spawn(v_origin, str_part)
{
	level endon(str_part + "_found");

	piece_model = level zm_craftables::get_craftable_piece_model("idgun", str_part);
	piece_model.origin = v_origin;
	playable_area = GetEntArray("player_volume", "script_noteworthy");
	valid_drop = 0;
	for(i = 0; i < playable_area.size; i++)
	{
		if(piece_model IsTouching(playable_area[i]))
		{
			valid_drop = 1;
		}
	}
	if(!valid_drop)
	{
		piece_model SetInvisibleToAll();
		return;
	}
	piece_model SetVisibleToAll();

	wait(10);
	level thread model_despawn_blinking(piece_model,str_part);
	wait(10);
	piece_model SetInvisibleToAll();
	level notify("part_stop_blinking");
}

function model_despawn_blinking(piece_model,str_part)
{
	level endon(str_part + "_found");
	level endon("part_stop_blinking");
	while(1)
	{
		piece_model SetInvisibleToAll();
		wait(0.5);
		piece_model SetVisibleToAll();
		wait(0.5);
	}
}