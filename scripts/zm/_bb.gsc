#using scripts\codescripts\struct;
#using scripts\shared\bb_shared;
#using scripts\shared\callbacks_shared;
#using scripts\shared\system_shared;

#namespace bb;

/*
	Name: __init__sytem__
	Namespace: bb
	Checksum: 0xBEE79C6C
	Offset: 0x698
	Size: 0x33
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("bb", &__init__, undefined, undefined);
}

/*
	Name: __init__
	Namespace: bb
	Checksum: 0x6E8779F7
	Offset: 0x6D8
	Size: 0x13
	Parameters: 0
	Flags: None
*/
function __init__()
{
	init_shared();
}

/*
	Name: function_2aa586aa
	Namespace: bb
	Checksum: 0x9FF373F7
	Offset: 0x6F8
	Size: 0x533
	Parameters: 8
	Flags: None
*/
function function_2aa586aa(attacker, victim, weapon, damage, damageType, hitlocation, var_a56ab5fa, var_935fe30e)
{
	var_14ac1c86 = -1;
	var_d3117c75 = "";
	victimOrigin = (0, 0, 0);
	var_4c26f55 = 0;
	var_99e7469c = 0;
	var_f4bca593 = 0;
	var_cb683866 = 0;
	var_38d64c0f = "";
	victimName = "";
	var_8daf73c8 = 0;
	var_2f4e1ee3 = -1;
	var_2746427c = "";
	attackerOrigin = (0, 0, 0);
	var_6ecba8dc = 0;
	var_33f13d47 = 0;
	var_b8bd32a2 = 0;
	var_ad96a70b = 0;
	var_cd3a2efe = "";
	attackerName = "";
	var_e5f9350b = "";
	var_b8b49851 = "";
	var_b1989306 = "";
	var_c46938ee = "";
	var_5833b024 = "";
	var_2b383b77 = "";
	if(isdefined(attacker))
	{
		if(isPlayer(attacker))
		{
			var_2f4e1ee3 = getplayerspawnid(attacker);
			var_2746427c = "_player";
			attackerName = attacker.name;
		}
		else if(isai(attacker))
		{
			var_2746427c = "_ai";
			var_2b383b77 = attacker.combatmode;
			var_2f4e1ee3 = attacker.var_d6a02814;
		}
		else
		{
			var_2746427c = "_other";
		}
		attackerOrigin = attacker.origin;
		var_6ecba8dc = attacker.ignoreme;
		var_b8bd32a2 = attacker.fovcosine;
		var_ad96a70b = attacker.maxsightdistsqrd;
		if(isdefined(attacker.animName))
		{
			var_cd3a2efe = attacker.animName;
		}
	}
	if(isdefined(victim))
	{
		if(isPlayer(victim))
		{
			var_14ac1c86 = getplayerspawnid(victim);
			var_d3117c75 = "_player";
			victimName = victim.name;
			var_8daf73c8 = victim.downs;
		}
		else if(isai(victim))
		{
			var_d3117c75 = "_ai";
			var_b1989306 = victim.combatmode;
			var_14ac1c86 = victim.var_d6a02814;
		}
		else
		{
			var_d3117c75 = "_other";
		}
		victimOrigin = victim.origin;
		var_4c26f55 = victim.ignoreme;
		var_f4bca593 = victim.fovcosine;
		var_cb683866 = victim.maxsightdistsqrd;
		if(isdefined(victim.animName))
		{
			var_38d64c0f = victim.animName;
		}
	}
	bbPrint("zmattacks", "gametime %d roundnumber %d attackerid %d attackername %s attackertype %s attackerweapon %s attackerx %d attackery %d attackerz %d aiattckercombatmode %s attackerignoreme %d attackerignoreall %d attackerfovcos %d attackermaxsightdistsqrd %d attackeranimname %s victimid %d victimname %s victimtype %s victimx %d victimy %d victimz %d aivictimcombatmode %s victimignoreme %d victimignoreall %d victimfovcos %d victimmaxsightdistsqrd %d victimanimname %s damage %d damagetype %s damagelocation %s death %d downed %d downs %d", GetTime(), level.round_number, var_2f4e1ee3, attackerName, var_2746427c, weapon.name, attackerOrigin, var_2b383b77, var_6ecba8dc, var_33f13d47, var_b8bd32a2, var_ad96a70b, var_cd3a2efe, var_14ac1c86, victimName, var_d3117c75, victimOrigin, var_b1989306, var_4c26f55, var_99e7469c, var_f4bca593, var_cb683866, var_38d64c0f, damage, damageType, hitlocation, var_a56ab5fa, var_935fe30e, var_8daf73c8);
}

/*
	Name: function_a96d8fec
	Namespace: bb
	Checksum: 0xFFA916FC
	Offset: 0xC38
	Size: 0xBB
	Parameters: 2
	Flags: None
*/
function function_a96d8fec(var_4ad207ea, spawner)
{
	bbPrint("zmaispawn", "gametime %d actorid %d aitype %s archetype %s airank %s accuracy %d originx %d originy %d originz %d weapon %s melee_weapon %s health %d roundNum %d", GetTime(), var_4ad207ea.var_d6a02814, var_4ad207ea.aitype, var_4ad207ea.archetype, var_4ad207ea.airank, var_4ad207ea.accuracy, var_4ad207ea.origin, var_4ad207ea.primaryWeapon.name, var_4ad207ea.meleeWeapon.name, var_4ad207ea.health, level.round_number);
}

/*
	Name: function_e367a93e
	Namespace: bb
	Checksum: 0xB437D062
	Offset: 0xD00
	Size: 0x143
	Parameters: 2
	Flags: None
*/
function function_e367a93e(player, eventName)
{
	currentWeapon = "";
	var_647bcc61 = 0;
	if(isdefined(player.currentWeapon))
	{
		currentWeapon = player.currentWeapon.name;
	}
	if(isdefined(player.beastmode))
	{
		var_647bcc61 = player.beastmode;
	}
	bbPrint("zmplayerevents", "gametime %d roundnumber %d eventname %s spawnid %d username %s originx %d originy %d originz %d health %d beastlives %d currentweapon %s kills %d zone_name %s sessionstate %s currentscore %d totalscore %d beastmodeon %d", GetTime(), level.round_number, eventName, getplayerspawnid(player), player.name, player.origin, player.health, player.var_5e82a563, currentWeapon, player.kills, player.zone_name, player.sessionstate, player.score, player.score_total, var_647bcc61);
}

/*
	Name: function_2c248b75
	Namespace: bb
	Checksum: 0x5493D249
	Offset: 0xE50
	Size: 0xC9
	Parameters: 1
	Flags: None
*/
function function_2c248b75(eventName)
{
	bbPrint("zmroundevents", "gametime %d roundnumber %d eventname %s", GetTime(), level.round_number, eventName);
	foreach(player in level.players)
	{
		function_e367a93e(player, eventName);
	}
}

/*
	Name: function_91f32a58
	Namespace: bb
	Checksum: 0x7CEF30F4
	Offset: 0xF28
	Size: 0xEB
	Parameters: 7
	Flags: None
*/
function function_91f32a58(player, var_dc36f44f, cost, itemName, var_c643f760, itemType, eventName)
{
	bbPrint("zmpurchases", "gametime %d roundnumber %d playerspawnid %d username %s itemname %s isupgraded %d itemtype %s purchasecost %d playeroriginx %d playeroriginy %d playeroriginz %d selleroriginx %d selleroriginy %d selleroriginz %d playerkills %d playerhealth %d playercurrentscore %d playertotalscore %d zone_name %s", GetTime(), level.round_number, getplayerspawnid(player), player.name, itemName, var_c643f760, itemType, cost, player.origin, var_dc36f44f.origin, player.kills, player.health, player.score, player.score_total, player.zone_name);
}

/*
	Name: function_9e0ebd5
	Namespace: bb
	Checksum: 0x5792FC11
	Offset: 0x1020
	Size: 0x189
	Parameters: 3
	Flags: None
*/
function function_9e0ebd5(powerup, var_aa8e75f3, eventName)
{
	var_34214b08 = -1;
	playerName = "";
	if(isdefined(var_aa8e75f3) && isPlayer(var_aa8e75f3))
	{
		var_34214b08 = getplayerspawnid(var_aa8e75f3);
		playerName = var_aa8e75f3.name;
	}
	bbPrint("zmpowerups", "gametime %d roundnumber %d powerupname %s powerupx %d powerupy %d powerupz %d, eventname %s playerspawnid %d playername %s", GetTime(), level.round_number, powerup.powerup_name, powerup.origin, eventName, var_34214b08, playerName);
	foreach(player in level.players)
	{
		function_e367a93e(player, "powerup_" + powerup.powerup_name + "_" + eventName);
	}
}

