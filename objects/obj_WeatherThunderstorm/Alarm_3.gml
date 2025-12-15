///@desc End lightning
lightning_phase = "NONE";
image_speed = 0;
sprite_index = noone;
player_hit = false;

// Special cases for last bossfight
if(instance_exists(obj_EnemyTwinhorn))
{
	if(obj_EnemyTwinhorn.hp == 2) obj_EnemyTwinhorn.alarm[0] = 1*GAMESPD;
	else if(obj_EnemyTwinhorn.hp == 1)
	{
		obj_EnemyTwinhorn.trig_anim_end = true;
		// Panic attack with Twinhorn, unless it's in attack alreadx
		obj_EnemyTwinhorn.alarm[0] = 1.5*GAMESPD;
		if(obj_EnemyTwinhorn.prep_4_phase_repeat) obj_EnemyTwinhorn.prep_4_phase_repeat = false;
	}
}