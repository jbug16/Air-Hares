/// @desc
y += vsp;

if y < 720 && !flyby_sound_played {
	flyby_sound_played = true;
	audio_play_sound(snd_EnemyFalconFlyBy, 1, false);	
}
if (y < -720) {
	// Spawn falcon	
	var _falcon = instance_create_layer(x, -720, "Middle", obj_EnemyFalconPurple);
	if(random(1) < 0.5) with(_falcon) TweenStart("y", y, 0.2*sprite_height, GAMESPD, TWEENTYPE.LINEAR);
	if timer_prepare != noone {
		_falcon.timer_prepare = timer_prepare;	
	}
	instance_destroy();
}