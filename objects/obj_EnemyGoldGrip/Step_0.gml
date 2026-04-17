/// @desc
//==========================================================
// Preparation - being hit
//==========================================================
// Being hit
var _collide_seed = instance_place(x, y, obj_PlayerProjectileSeed)
var _collide_water = instance_place(x, y, obj_PlayerProjectileWater)
var _collide_counter = instance_place(x, y, obj_PlayerParry)
	
// Hurt in last 0.5 s	
if(state == ENEMIES.HURT and hp == 0 and hurt_delay > 0) hurt_delay--;

//----------------------------------------------------------
// Evade the seed/water
//----------------------------------------------------------
var _waiting = [ENEMIES.IDLE, ENEMIES.INIT, ENEMIES.INIT_WAIT, ENEMIES.PREP, ENEMIES.PREP_1, ENEMIES.PREP_2,
	ENEMIES.PREP_3, ENEMIES.PREP_4];
if(array_contains(_waiting, state) and (_collide_water != noone or _collide_counter != noone or _collide_seed != noone))
{
	state_prev = state
	state = ENEMIES.EVADE;
}


//==========================================================
// STATEMACHINE
//==========================================================
switch(state) {
	//----------------------------------------------------------
	// Sequence start - prepare for the attack
	//----------------------------------------------------------
	case ENEMIES.INIT:
		target_id = PlayerGetEnemyAggroTarget(x, y);
		if(prep_duration != 60) prep_duration = 60;
		state = ENEMIES.INIT_WAIT;
		break;
		
	case ENEMIES.INIT_WAIT:
		if hp == 4
		{
			prep_counter = prep_duration;
			state = ENEMIES.PREP_1;
		}
		else if hp == 3 
		{
			prep_counter = prep_duration;
			state = ENEMIES.PREP_2;
		} 
		else if hp == 2
		{
			prep_counter = prep_duration;
			state = ENEMIES.PREP_4;
		}
		else if hp > 0 
		{
			prep_counter = prep_duration;
			state = ENEMIES.PREP_3;
		} 
		else state = ENEMIES.DESTROY;	
		break;
		
	//----------------------------------------------------------
	// Phase 1 - one shadow + real boss
	//----------------------------------------------------------
	case ENEMIES.PREP_1:
		EnemyFaceTarget(target_id);		
		if((_collide_seed != noone and _collide_seed.target == noone) or 
			(_collide_water != noone and _collide_water.target == noone))
				linblur_fx.trigger_once([64, 0]);
			
		// Flash then lightning
		if(instance_exists(obj_PlayerPAR) and !instance_exists(obj_GoldGripLightningPAR) and obj_WeatherThunderstorm.alarm[4] < 0 and alarm[0] < 0) obj_WeatherThunderstorm.alarm[4] = 1;

		
		if(prep_counter > 0)
		{
			prep_counter--;
			if (prep_counter <= 0) _AttackPrepSetup(1);
		}
		break;
		
	//===================== Diving =======================
	case ENEMIES.DIVE_1_BASE:
		EnemyFaceTarget(target_id);
		_AttackBaseSetup(1);
		// Go to dive prep
		state = ENEMIES.DIVE_1_PREP;
		break;
		
	case ENEMIES.DIVE_1_PREP:
		// Wait until launch counter elapsed
		EnemyFaceTarget(target_id);
		dive_delay--;
		if((_collide_seed != noone and _collide_seed.target == noone) or 
			(_collide_water != noone and _collide_water.target == noone))
				linblur_fx.trigger_once([64, 0]);
		
		if dive_delay <= 0
		{
			_DiveSetup(0.3, 20);
			state = ENEMIES.DIVE_1;
		}
		break;
		
	case ENEMIES.DIVE_1:
		if((_collide_seed != noone and _collide_seed.target == noone) or 
			(_collide_water != noone and _collide_water.target == noone))
				linblur_fx.trigger_once([64, 0]);
		
		if(_collide_counter != noone and !invincible)
		{
			with(obj_EnemyGoldGripShadow) instance_destroy();	
			_HurtSetup();
		}
	
		if(y > 1280 or x < -384 or x > (room_width + 384))  _DiveRecoverySetup();	
		break;
		
	//----------------------------------------------------------
	// Phase 2 - two shadows + real boss
	//----------------------------------------------------------
	case ENEMIES.PREP_2:
		EnemyFaceTarget(target_id);
		if((_collide_seed != noone and _collide_seed.target == noone) or 
			(_collide_water != noone and _collide_water.target == noone))
				linblur_fx.trigger_once([64, 0]);
		
		if(prep_counter > 0)
		{
			// Flash then lightning
			if(prep_counter <= 0.5*prep_duration and instance_exists(obj_PlayerPAR) and !instance_exists(obj_GoldGripLightningPAR)
				and obj_WeatherThunderstorm.alarm[4] < 0 and alarm[0] < 0)
					obj_WeatherThunderstorm.alarm[4] = 1;
			prep_counter--;
			if(prep_counter <= 0) _AttackPrepSetup(2);
		}
		break;
		
	//===================== Diving =======================
	case ENEMIES.DIVE_2_BASE:
		EnemyFaceTarget(target_id);
		_AttackBaseSetup(2);
		state = ENEMIES.DIVE_2_PREP;
		break;
		
	case ENEMIES.DIVE_2_PREP:
		// Wait until launch counter elapsed
		EnemyFaceTarget(target_id);
		dive_delay--;		
		if((_collide_seed != noone and _collide_seed.target == noone) or 
			(_collide_water != noone and _collide_water.target == noone))
				linblur_fx.trigger_once([64, 0]);
		
		if dive_delay <= 0
		{
			_DiveSetup(0.25, 25);
			state = ENEMIES.DIVE_2;
		}
		break;
		
	case ENEMIES.DIVE_2:
		if((_collide_seed != noone and _collide_seed.target == noone) or 
			(_collide_water != noone and _collide_water.target == noone))
				linblur_fx.trigger_once([64, 0]);

		if(_collide_counter != noone and !invincible)
		{
			with(obj_EnemyGoldGripShadow) instance_destroy();	
			_HurtSetup();
		}
		if(y > 1280 or x < -384 or x > (room_width + 384)) _DiveRecoverySetup();	
		break;
		
	//----------------------------------------------------------
	// Phase 3 - three shadows + real boss
	//----------------------------------------------------------
	case ENEMIES.PREP_3:
		EnemyFaceTarget(target_id);		
		if((_collide_seed != noone and _collide_seed.target == noone) or 
			(_collide_water != noone and _collide_water.target == noone))
				linblur_fx.trigger_once([64, 0]);
		
		if(prep_counter > 0)
		{
			// Flash then lightning
			if(prep_counter <= 0.5*prep_duration and instance_exists(obj_PlayerPAR) and !instance_exists(obj_GoldGripLightningPAR)
				and obj_WeatherThunderstorm.alarm[4] < 0 and alarm[0] < 0) 
					obj_WeatherThunderstorm.alarm[4] = 1;
			prep_counter--;
			if (prep_counter <= 0) _AttackPrepSetup(4);
		}
		break;
	//===================== Diving =======================
	case ENEMIES.DIVE_3_BASE:
		EnemyFaceTarget(target_id);
		_AttackBaseSetup(4);
		state = ENEMIES.DIVE_3_PREP;
		break;
		
	case ENEMIES.DIVE_3_PREP:
		// Wait until launch counter elapsed
		EnemyFaceTarget(target_id);
		dive_delay--;
		
		if((_collide_seed != noone and _collide_seed.target == noone) or 
			(_collide_water != noone and _collide_water.target == noone))
				linblur_fx.trigger_once([64, 0]);
		
		if dive_delay <= 0
		{
			_DiveSetup(0.2, 28);
			state = ENEMIES.DIVE_3;
		}
		break;
		
	case ENEMIES.DIVE_3:
		if((_collide_seed != noone and _collide_seed.target == noone) or 
			(_collide_water != noone and _collide_water.target == noone))
				linblur_fx.trigger_once([64, 0]);

		if(_collide_counter != noone and !invincible)
		{
			with(obj_EnemyGoldGripShadow) instance_destroy();	
			_HurtSetup();
		}
		if(y > 1280 or x < -384 or x > (room_width + 384))  _DiveRecoverySetup();	
		break;
		
	//----------------------------------------------------------
	// Phase 4 - four shadows + real boss
	//----------------------------------------------------------
	case ENEMIES.PREP_4:
		EnemyFaceTarget(target_id);		
		if((_collide_seed != noone and _collide_seed.target == noone) or 
			(_collide_water != noone and _collide_water.target == noone))
				linblur_fx.trigger_once([64, 0]);
		
		if(prep_counter > 0)
		{
			// Flash then lightning
			if(prep_counter <= 0.5*prep_duration and instance_exists(obj_PlayerPAR) and !instance_exists(obj_GoldGripLightningPAR)
				and obj_WeatherThunderstorm.alarm[4] < 0 and alarm[0] < 0)
					obj_WeatherThunderstorm.alarm[4] = 1;
	
			prep_counter--;
			if (prep_counter <= 0) _AttackPrepSetup(3);
		}
		break;
	
	//===================== Diving =======================
	case ENEMIES.DIVE_4_BASE:
		EnemyFaceTarget(target_id);
		_AttackBaseSetup(3);
		// Go to dive prep
		state = ENEMIES.DIVE_4_PREP;
		break;
		
	case ENEMIES.DIVE_4_PREP:
		// Wait until launch counter elapsed
		EnemyFaceTarget(target_id);
		dive_delay--;
		if((_collide_seed != noone and _collide_seed.target == noone) or 
			(_collide_water != noone and _collide_water.target == noone))
				linblur_fx.trigger_once([64, 0]);
		
		if dive_delay <= 0
		{
			_DiveSetup(0.3, 20);
			state = ENEMIES.DIVE_4;
		}
		break;
		
	case ENEMIES.DIVE_4:
		if((_collide_seed != noone and _collide_seed.target == noone) or 
			(_collide_water != noone and _collide_water.target == noone))
				linblur_fx.trigger_once([64, 0]);
		
		if(_collide_counter != noone and !invincible)
		{
			with(obj_EnemyGoldGripShadow) instance_destroy();	
			_HurtSetup();
		}
	
		if(y > 1280 or x < -384 or x > (room_width + 384))  _DiveRecoverySetup();	
		break;
		
	case ENEMIES.DIVE_RECOVERY:
		if(abs(y - y_base) < 1) state = ENEMIES.INIT;	
		break;
		
	//----------------------------------------------------------
	// Repeating states
	//----------------------------------------------------------
	
	//===================== Hurt and recovery from hurt =======================
	case ENEMIES.HURT:
		// When hurt, player can counter or shoot at it
		image_angle = 0;
		if(_collide_seed != noone and _collide_seed.target == noone)
		{
			CombosAddHit(50);
			VfxShake(3, 10);
			hurt_counter += 0.075*GAMESPD;
			hit_fx_seed(_collide_seed);
			TweenStop();
			TweenStart("y", y, y - 128, GAMESPD);
		}
		if(_collide_water != noone and _collide_water.target == noone)
		{
			CombosAddHit(50);
			VfxShake(3, 10);
			hurt_counter += 0.075*GAMESPD;
			_HitFXWater(_collide_water);
			TweenStop();
			TweenStart("y", y, y - 128, GAMESPD);
		}
		
		if((hurt_counter--) < 0 or alarm[1] < 0)
		{
			hurt_counter = hurt_duration;
			TweenStop();
			if(hp == 0) 
			{
				// End music with fadeout - only play once
				if(!outro_music_played)
				{
					with(obj_ControllerFightBoss3_3)
					{
						audio_stop_sound(music_bg);
						music_bg = audio_play_sound(snd_BossEnding, 1, false);
						//audio_sound_gain(music_bg, 0, 40*GAMESPD);
					}
					outro_music_played = true;
				}
				TweenStart("y", y, -sprite_height, 1.2*GAMESPD, TWEENTYPE.SINE_INOUT);
			}
			else TweenStart("y", y, y_base, 0.8*GAMESPD, TWEENTYPE.SINE_INOUT);
			image_angle = 180;
			state = ENEMIES.HURT_RETURN;
		}
		break;
		
	case ENEMIES.HURT_RETURN:
		if(_collide_seed != noone and _collide_seed.target == noone)
		{
			CombosAddHit(50);
			VfxShake(3, 10);
			hit_fx_seed(_collide_seed);
		}
		if(_collide_water != noone and _collide_water.target == noone)
		{
			CombosAddHit(50);
			VfxShake(3, 10);
			_HitFXWater(_collide_water);
		}
		if((hp == 0 and y < 0) or abs(y_base - y) < 1)
		{
			TweenStop();
			speed = 0;
			direction = 0;
			image_angle = 0;
			state = ENEMIES.INIT;
			return true;
		}
		break;
	
	//===================== Dying =======================
	case ENEMIES.DESTROY:
		obj_ControllerPAR.goldgrip_deathpos = {
			x: x,
			y: y
		}
		instance_destroy();
		break;
}

//==========================================================
// Animation
//==========================================================
if(sprite_index != sprite[state]) sprite_index = sprite[state];

// Apply fx
linblur_fx.update();
