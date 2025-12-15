/// @desc

//==========================================================
// BACKEND
//==========================================================
state = ENEMIES.INIT;

// Sprite setup
for (var i = 0; i < ENEMIES.length; i++)
{
	sprite[i] = spr_EnemyGoldGripIdle;
}
sprite[ENEMIES.HURT] = spr_EnemyGoldGripHurt;
sprite[ENEMIES.DIVE_1] = spr_EnemyGoldGripDive;
sprite[ENEMIES.DIVE_2] = spr_EnemyGoldGripDive;
sprite[ENEMIES.DIVE_3] = spr_EnemyGoldGripDive;
state = ENEMIES.INIT;

dive_delay = 0;
target_id = noone;



//==========================================================
// Methods
//==========================================================
///@func _DiveSetup()
///@desc Starts diving
///@arg		dur_accel	{real}		Duration of tween (accelaration)
///@arg		end_speed	{real}		Max speed at the end
_DiveSetup = function(dur_accel, end_speed) {
	TweenStart("speed", 0, end_speed, dur_accel);
	
	direction = image_angle - 90;
    audio_play_sound(snd_EnemyFalconAttackScream, 1, false);
	audio_play_sound(snd_EnemyFalconAttackFly, 1, false);
}
