/// @desc

var _collide_seed = instance_place(x, y, obj_PlayerProjectileSeed)
var _collide_water = instance_place(x, y, obj_PlayerProjectileWater)
var _collide_counter = instance_place(x, y, obj_PlayerParry)

switch(state) {
	case ENEMIES.PREPARING:
		target_id = PlayerGetEnemyAggroTarget(x, y);
		EnemyFaceTarget(target_id);
		
		timer_prepare -= 1;
		// Transition
		if (_collide_seed != noone && _collide_seed.target == noone) { // Evade the first shot
			CombosAddHit(50);
			hit_fx_seed(_collide_seed);
			VfxShake(3, 10);
			
			// Tween shot back
			speed = 0;
			TweenStop();
			TweenStart("y", y, y - 64, GAMESPD, TWEENTYPE.CUBIC_OUT);
			hp -= 1;
			if(hp <= 0) instance_create_depth(x, y - 30, depth, obj_PropFeatherBrown);
			
			state = ENEMIES.HURT;
			
		} else if (_collide_water != noone && _collide_water.target == noone) {
			
			CombosAddHit(50);
			_HitFXWater(_collide_water);
			VfxShake(3, 10);
			hp -= 1;
			if(hp <= 0) instance_create_depth(x, y - 30, depth, obj_PropFeatherBrown);
			
			// Tween shot back
			speed = 0;
			TweenStop();
			TweenStart("y", y, y - 64, GAMESPD, TWEENTYPE.CUBIC_OUT);
			
			state = ENEMIES.HURT;
		} else if (timer_prepare <= 0) {
			// Launch toward enemy
			TweenStart("speed", 0, direct_attack_speed, GAMESPD, TWEENTYPE.CUBIC_OUT);
						
			direction = image_angle - 90;
			state = ENEMIES.DIVE;
			
			// Play sound
			audio_play_sound(snd_EnemyFalconAttackScream, 1, false);
			audio_play_sound(snd_EnemyFalconAttackFly, 1, false);
		}
		break;
	case ENEMIES.DIVE:
		// Transition
		if (_collide_seed != noone && _collide_seed.target == noone) {
			
			CombosAddHit(50);
			hit_fx_seed(_collide_seed);
			VfxShake(3, 10);
			hp -= 1;
			if(hp <= 0) instance_create_depth(x, y - 30, depth, obj_PropFeatherBrown);
			
			// Stop tween
			speed = 0;
			
			// Tween shot back
			TweenStop();
			TweenStart("y", y, y - 128, GAMESPD, TWEENTYPE.CUBIC_OUT);
						
			state = ENEMIES.HURT;
		}
		if (_collide_water != noone && _collide_water.target == noone) {
			
			CombosAddHit(50);
			_HitFXWater(_collide_water);
			VfxShake(3, 10);
			hp -= 1;
			if (hp <= 0) instance_create_depth(x, y - 30, depth, obj_PropFeatherBrown);
			
			// Stop tween
			speed = 0;
			
			// Tween shot back
			TweenStop();
			TweenStart("y", y, y - 128, GAMESPD, TWEENTYPE.CUBIC_OUT);
						
			state = ENEMIES.HURT;
		}
		if (_collide_counter != noone and alarm[0] < 0) 
		{
			CombosAddHit(50);
			hp -= 1;
			audio_play_sound(snd_PlaneParry, 1, false);
			
			VfxShake(3, 15);
			
			// Stop tween
			speed = 0;
			
			// Tween shot back
			TweenStop();
			TweenStart("y", y, y - 128, GAMESPD, TWEENTYPE.CUBIC_OUT);
			alarm[0] = 3;		
			state = ENEMIES.HURT;
		}
		
		// Homing towards player
		EnemyHomingTarget(target_id, direct_attack_homing);
		
		break;
	case ENEMIES.FEINT:
		// Feinting
		feint_wait -= 1;
		if feint_wait <= 0 {
			state = ENEMIES.PREPARING;	
		}
		break;
	case ENEMIES.HURT:
		if (_collide_seed != noone && _collide_seed.target == noone) {
			CombosAddHit(50);
			hit_fx_seed(_collide_seed);
			VfxShake(3, 15);
			hp -= 1;
			if (hp <= 0) instance_create_depth(x, y - 30, depth, obj_PropFeatherBrown);
			
			// Stop tween
			speed = 0;
			
			// Tween shot back
			TweenStop();
			TweenStart("y", y, y - 128, GAMESPD, TWEENTYPE.CUBIC_OUT);
						
			image_index = 0;
			trig_anim_end = false;
		}
		
		if (_collide_water != noone && _collide_water.target == noone) {
			CombosAddHit(50);
			_HitFXWater(_collide_water);
			VfxShake(3, 15);
			hp -= 1;
			if (hp <= 0) instance_create_depth(x, y - 30, depth, obj_PropFeatherBrown);
			
			// Stop tween
			speed = 0;
			
			// Tween shot back
			TweenStop();
			TweenStart("y", y, y - 128, GAMESPD, TWEENTYPE.CUBIC_OUT);
						
			image_index = 0;
			trig_anim_end = false;
		}
	
		if (trig_anim_end) {
			TweenStop();
			if hp <= 0 {
				// Run away
				var _dir = choose(45, 135);
				direction = _dir;
				image_angle = _dir + 90;
				
				// Tween
				TweenStart("speed", 0, direct_attack_speed, GAMESPD, TWEENTYPE.CUBIC_OUT);
				instance_create_depth(x, y - 30, depth, obj_PropFeatherBrown);			
				state = ENEMIES.DYING;
			} else {
				state = ENEMIES.PREPARING;	
			}
		}
		break;
	case ENEMIES.DYING:
		if(hp <= 0 and (_collide_seed != noone or _collide_water != noone)) 
		{
			if(_collide_seed != noone)  hit_fx_seed(_collide_seed);
			if(_collide_water != noone) _HitFXWater(_collide_water);
			VfxShake(3, 10);
			CombosAddHit(50);
			instance_create_depth(x, y - 30, depth, obj_PropFeatherBrown);
		}
		if y < - 320 instance_destroy();
		break;
}

// Play audio of wing flap 
if sprite_index = s_prep && state == ENEMIES.PREPARING {
	// Flap down
	if image_index >= 3 && image_index < 7 && !audio_is_playing(snd_FalconWingsFlap) {
		audio_play_sound(snd_FalconWingsFlap, 1, false);	
	}
}

// Sprite changes
switch(state) {
	case ENEMIES.PREPARING:
		EnemySpriteSet(s_prep);
		break;
	case ENEMIES.DIVE:
		if (y > 32) {
			EnemySpriteSet(s_dive_claw);
		} else {
			EnemySpriteSet(s_dive);
		}
		break;
	case ENEMIES.FEINT:
		EnemySpriteSet(s_prep);
		break;
	case ENEMIES.HURT:
		EnemySpriteSet(s_hurt);
		break;
	case ENEMIES.DYING:
		EnemySpriteSet(s_dive);
		break;
}

if x <= -1280 || x > 3000 instance_destroy();
if y > 1280 instance_destroy();