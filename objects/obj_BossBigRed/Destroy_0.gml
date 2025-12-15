/// @desc Stop att

// Don't attack when boss dies
with(obj_FalconBigRed)
{
	state = BOSS.INIT;
	sprite_index = sprite[state];
	image_angle = 180;
	direction = 90;
	
	TweenStart("speed", 0, direct_attack_speed, GAMESPD, TWEENTYPE.CUBIC_OUT);
}