/// @desc
// Method

///@func _DiveSetup()
///@desc Start diving
///@arg		dur_accel	{real}		Duration of tween
///@arg		end_speed	{real}		Max speed to achieve
_DiveSetup = function(dur_accel, end_speed){
	TweenStart("speed", 0, end_speed, dur_accel*GAMESPD);
	
	direction = image_angle - 90;
    audio_play_sound(snd_EnemyFalconAttackScream, 1, false);
	audio_play_sound(snd_EnemyFalconAttackFly, 1, false);
}


// Water, seed hit fx
hit_fx_seed = function(_collide_seed = noone) {
	if (_collide_seed == noone) return false;
	LevelRunRegisterAmmoAggressionIfPlayerProjectile(_collide_seed);
	
	var _fx = instance_create_depth(_collide_seed.x, _collide_seed.y, depth, obj_PlayerProjectileSeedFX);
	_fx.z = 0;
	_fx.master = id;
	_fx.depth -= 100;
	audio_play_sound(snd_ProjSeedHit, 1, false);
	
	instance_destroy(_collide_seed);
}

_HitFXWater = function(_collide_water = noone) {
	if (_collide_water == noone) return false;
	LevelRunRegisterAmmoAggressionIfPlayerProjectile(_collide_water);
	
	var _fx = instance_create_depth(_collide_water.x, _collide_water.y, depth, obj_PlayerProjectileWaterFX);
	_fx.z = 0;
	_fx.master = id;
	_fx.depth -= 100;
	audio_play_sound(snd_ProjWaterHit, 1, false);
	
	instance_destroy(_collide_water);
}