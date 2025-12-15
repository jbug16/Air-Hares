/// @desc Lightning strike

alarm[0] = 60;

// Special cases for last bossfight
if(instance_exists(obj_EnemyTwinhorn))
{
	lightning_alpha = 0.5;
	var _sound_delay = 1 + irandom(15);
	alarm[1] = _sound_delay;
	
	if(obj_EnemyTwinhorn.hp == 2) alarm[0] = -1;
	else if(obj_EnemyTwinhorn.hp == 1)
	{
		alarm[0] = 10*GAMESPD;
		obj_EnemyTwinhorn.trig_anim_end = true;
		// Panic attack with Twinhorn, unless it's in attack alreadx
		if(obj_EnemyTwinhorn.state != ENEMIES.ATTACK_DIVE and obj_EnemyTwinhorn.state != ENEMIES.ATTACK_DIVE_MASTER
			and obj_EnemyTwinhorn.state != ENEMIES.ATTACK_4_SHOT_SPREAD)
				obj_EnemyTwinhorn.state = ENEMIES.ATTACK_4_PANIC;
	}
}

if (random(1) < lightning_chance) {
	lightning_alpha = 0.5;
	var _sound_delay = 1 + irandom(15);
	alarm[1] = _sound_delay;
}