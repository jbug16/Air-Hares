// instance id of bullet hit
var _collide_bullet = instance_place(x, y, obj_PlayerProjectileSeed);	
if (_collide_bullet == noone) _collide_bullet = instance_place(x, y, obj_PlayerProjectileWater);

// object_index of bullet hit
if (_collide_bullet != noone) var _collide_object = _collide_bullet.object_index;
else var _collide_object = noone;

// parry collide instance id
var _collide_counter = instance_place(x, y, obj_PlayerParry)

// PHASES
switch(state) {
	case ENEMY_STATE.IDLE:
		if !instance_exists(obj_PlayerPAR) target_id = instance_nearest(x, y, obj_PlayerRabboSpawner);
		else target_id = instance_nearest(x, y, obj_PlayerPAR);
		EnemyFaceTarget(target_id);
		timer_prepare--;
	
		// Hit by a seed or water bullet
		if (_collide_bullet != noone and _collide_bullet.target == noone) 
		{
			// damage
			CombosAddHit(50);
			hp--;
			if(hp <= 0) instance_create_layer(x, y, layer, feather_type);
		
			// VFX & SFX
			VfxShake(3, 10);
			if (_collide_bullet.object_index == obj_PlayerProjectileSeed) hit_fx_seed(_collide_bullet);
			else _HitFXWater(_collide_bullet);

			
			// Tween shot back & state
			speed = 0;
			TweenStop();
			TweenStart("y", y, y - 64, GAMESPD, TWEENTYPE.CUBIC_OUT);
			state = ENEMY_STATE.HURT;
		} 
		else if (timer_prepare <= 0)		// end of this phase
		{
			// Launch toward enemy
			TweenStart("speed", 0, direct_attack_speed, GAMESPD, TWEENTYPE.CUBIC_OUT);
		
			direction = image_angle - 90;
			state = ENEMY_STATE.ATTACK;
			
			// Play sound
			audio_play_sound(snd_EnemyFalconAttackScream, 1, false);
			audio_play_sound(snd_EnemyFalconAttackFly, 1, false);
		}
	break;
	
	case ENEMY_STATE.ATTACK:
		// Being hit by projectile
		if (_collide_bullet != noone and _collide_bullet.target == noone) 
		{
			CombosAddHit(50);
			hp--;
			if(hp <= 0) instance_create_layer(x, y, layer, feather_type);
			
			// VFX SFX
			VfxShake(3, 10);
			if (_collide_bullet.object_index == obj_PlayerProjectileSeed) hit_fx_seed(_collide_bullet);
			else _HitFXWater(_collide_bullet);
		
			// Stop tween
			speed = 0;
			TweenStop();
			// Tween shot back
			TweenStart("y", y, y - 128, GAMESPD, TWEENTYPE.CUBIC_OUT);
		
			state = ENEMY_STATE.HURT;
		}
	
		// parry hit
		if (_collide_counter != noone and alarm[0] < 0) 
		{
			CombosAddHit(50);
			hp -= 1;
			if(hp <= 0) instance_create_layer(x, y, layer, feather_type);
			audio_play_sound(snd_PlaneParry, 1, false);
			//
			VfxShake(3, 15);
			
			// Stop tween
			speed = 0;
			TweenStop();
			// Tween shot back
			TweenStart("y", y, y - 128, GAMESPD, TWEENTYPE.CUBIC_OUT);
			alarm[0] = 15;
			state = ENEMY_STATE.HURT;
		}
		
		// Homing to target
		EnemyHomingTarget(target_id, direct_attack_homing);
	break;
	
	case ENEMY_STATE.HURT:
		if (_collide_bullet != noone and _collide_bullet.target == noone) 
		{
			CombosAddHit(50);
			hp --;
			if(hp <= 0) instance_create_layer(x, y, layer, feather_type);
			
			// VFX and SFX
			if (_collide_bullet.object_index == obj_PlayerProjectileSeed) hit_fx_seed(_collide_bullet);
			else _HitFXWater(_collide_bullet);
			VfxShake(3, 15);
			
			// Stop tween
			speed = 0;
			TweenStop();
			// Tween shot back
			TweenStart("y", y, y - 128, GAMESPD, TWEENTYPE.CUBIC_OUT);
			
			image_index = 0;
			trig_anim_end = false;
		}
		
		// end of hurt animation
		if (trig_anim_end) 
		{
			TweenStop();
			if hp <= 0 
			{
				// Run away
				var _dir = choose(45, 135);
				direction = _dir;
				image_angle = _dir + 90;
				
				// Tween
				speed = 0;
				TweenStart("speed", 0, direct_attack_speed, GAMESPD, TWEENTYPE.CUBIC_OUT);
			
				state = ENEMY_STATE.DEFEATED;
			} 
			else state = ENEMY_STATE.IDLE;
		}
	break;
	
	case ENEMY_STATE.DEFEATED:
		// VFX and SFX
		if (_collide_object == obj_PlayerProjectileSeed)
		{
			if(hp <= 0) instance_create_layer(x, y, layer, feather_type);
			CombosAddHit(50);
			hit_fx_seed(_collide_object);
			VfxShake(3, 15);
		}
		else if(_collide_object == obj_PlayerProjectileWater)
		{
			if(hp <= 0) instance_create_layer(x, y, layer, feather_type);
			CombosAddHit(50);
			_HitFXWater(_collide_object);
			VfxShake(3, 15);
		}
	break;
}


// Sprite changes
if (state == ENEMY_STATE.ATTACK and y < 32) EnemySpriteSet(sprite[ENEMY_STATE.IDLE])
else EnemySpriteSet(sprite[state]);


// Play audio of wing flap 
if (state == ENEMY_STATE.IDLE) 
{
	// Flap down
	if (image_index >= 3 and image_index < 7 and !audio_is_playing(snd_FalconWingsFlap))
		audio_play_sound(snd_FalconWingsFlap, 1, false);	
}


// outside room self-destruct (with margins)
if (x < -room_width or x > 2*room_width or y > room_width 
	or (state == ENEMY_STATE.DEFEATED and y < - 320)) instance_destroy();