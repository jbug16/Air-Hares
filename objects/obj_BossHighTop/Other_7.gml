///@desc Roost/hurt/dodge

// Roost
if (state == BOSS.ROOST and instance_number(obj_FalconHighTop) < 4)
{
	image_speed = 0;
}
// HURT
// HURT state is now handled in Step event state machine to allow multiple continuous hits
// Only handle death here when HP reaches 0
else if (state == BOSS.HURT and hp <= 0)
{
	array_push(obj_ControllerFightBoss1_3.hightop_death_pos, x, y);
	state = BOSS.DYING;
	
	// Boss end music with fadeout
	with(obj_ControllerFightBoss1_3)
	{
		audio_stop_sound(music_bg);
		music_bg = audio_play_sound(snd_BossEnding, 1, false);
	}
	// Run away
	direction = choose(45, 135);
	image_angle = direction + 90;
	speed = 0;
	TweenStop();
	TweenStart("speed", 0, fly_in_spd, GAMESPD, TWEENTYPE.CUBIC_OUT);
	alarm[2] = hurt_delay;
}
// DODGE
else if (state == BOSS.DODGE)
{
	if (dodge_dist != 0)	// if need to return to original position (where dodge started)
	{
		TweenStop();
		TweenStart("x", x, x + dodge_dist, 0.5*GAMESPD, TWEENTYPE.SINE_OUT);
		dodge_dist = 0;
		image_xscale = evade_direction;
	}
	else					// returned to original position
	{
		state = state_prev;
		speed = speed_prev;
		
		// Tween to needed height for continuation
		if(state == BOSS.APPEAR and y != 0.3*sprite_height)
			TweenStart("y", y, 0.3*sprite_height, GAMESPD, TWEENTYPE.QUINT_OUT);
	}
}