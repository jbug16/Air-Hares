///@desc
//==========================================================
// Boss card is showing - pause state machine
//==========================================================
if(obj_ControllerFightBoss4_3.alarm[2] > 0 and state == ENEMIES.SPAWN)
{
	// Removed these lines so boss flies upward not looking at player
	//target_id = instance_nearest(x, y, obj_PlayerPAR);
	//EnemyFaceTarget(target_id);
	exit;
}


//==========================================================
// Preparing
//==========================================================
var _collide_seed = instance_place(x, y, obj_PlayerProjectileSeed);
var _collide_water = instance_place(x, y, obj_PlayerProjectileWater);
var _collide_counter = instance_place(x, y, obj_PlayerParry);
var _collide_pellet = instance_place(x, y, obj_EnemyTwinhornPelletPAR);
var _collide_big = instance_place(x, y, obj_EnemyTwinhornPelletBig);


//==========================================================
// Statemachine
//==========================================================
switch(state)
{
//----------------------------------------------------------
// Preparing (repeating) states
//----------------------------------------------------------
	case ENEMIES.SPAWN:
	// After cheap shot
		//if(y < - 480)
		//{
		//	image_angle = 0;
		//	speed = 0;
		//	TweenStart("y", y, 0.2*sprite_height, GAMESPD, TWEENTYPE.LINEAR);
		//	state = ENEMIES.INIT;
		//}
		if(y < -sprite_height)
		{
			TweenStart("y", y, y_base, GAMESPD, TWEENTYPE.QUINT_OUT);
			speed = 0;
			direction = 0;
			image_angle = 0;
			state = ENEMIES.BETWEEN;
			alarm[3] = GAMESPD*(4.5 - hp);
			if (hp > 2) isangry = false;
		}
		else if(y == y_base)
		{
			TweenStop(id, "y");
			trig_anim_end = false;
			state = ENEMIES.INIT;
		}
	break;
	case ENEMIES.BETWEEN:
	break;
//----------------------------------------------------------
// Preparing (repeating) states
//----------------------------------------------------------
#region
	case ENEMIES.INIT:
		target_id = PlayerGetEnemyAggroTarget(x, y, true);
		// Base on remaining HP, go to different prep phase
		if(hp == 4) // phase 1
		{
			prep_counter = prep_period[0] + random_range(-20, 20);
			prep_attack_state = ENEMIES.PREPARING_1;
		}
		else if(hp == 3) // phase 2
		{
			prep_counter = prep_period[1] + random_range(-20, 10);
			prep_attack_state = ENEMIES.PREPARING_2;
			
			// Weather change - clear -> windy
			if(instance_exists(obj_WeatherClear))
			{
				instance_destroy(obj_WeatherClear);
				instance_create_layer(0, 0, "Top_Weather", obj_WindParticles);
			}
		}
		else if(hp == 2) // phase 3
		{
			prep_counter = prep_period[2] + random_range(-10, 5);
			prep_attack_state = ENEMIES.PREPARING_3;
			
			// Weather change - windy -> storm
			if(!instance_exists(obj_WeatherThunderstorm)) 
				with(instance_create_layer(0, 0, "Top_Weather", obj_WeatherThunderstorm)) event_perform(ev_alarm, 4);
			else if(prep_3_phase_repeat)
			{
				with(obj_WeatherThunderstorm) event_perform(ev_alarm, 4);
				prep_3_phase_repeat = false;
			}
		}
		else if(hp == 1) // phase 4
		{
			prep_counter = prep_period[3] + random_range(-10, 5);
			prep_attack_state = ENEMIES.PREPARING_4;
			
			// Lightning strike
			if(target_id.paralysis_counter <= 0 and target_id.confusion_counter <= 0 and prep_4_phase_repeat and !prep_4_panic_passed)
			{
				with(obj_WeatherThunderstorm) event_perform(ev_alarm, 4);
				prep_4_phase_repeat = false;
			}
		}
		// Dying. send coordinates to controller
		else 
		{
			if(phase_4 != true)
			{
				hp = 1;
				exit;
			}
			if(y != 0.45*sprite_height) exit;
			
			array_push(obj_ControllerFightBoss4_3.twinhorn_death_pos, x, y);
			instance_destroy();
		}
		state = ENEMIES.PRE_ATTACK;	
	break;
		
	case ENEMIES.PRE_ATTACK:
		// Wait a duration before going to attack
		EnemyFaceTarget(target_id);
		if(prep_attack_counter-- <= 0) state = prep_attack_state;
	break;
#endregion	
	
		
//----------------------------------------------------------
// Phase 1
//----------------------------------------------------------
#region
	// Prepare for attack
	case ENEMIES.PREPARING_1:
		// Here, twinhorn prepare types of attack it'll launch
		// Face player
		EnemyFaceTarget(target_id);
		prep_counter -= 1;
		isangry = (prep_pellet_countered >= prep_1_pellet_dive);
		
		if((_collide_seed != noone and _collide_seed.target == noone) or 
			(_collide_water != noone and _collide_water.target == noone) or (_collide_pellet != noone and _collide_pellet.countered))
			{
				if(_collide_pellet != noone and (_collide_pellet.object_index == obj_EnemyTwinhornPelletBig 
					and _collide_pellet.countered)) _HitBigPellet(_collide_pellet);
				else _HitEvade(_collide_seed, _collide_water, _collide_pellet);
			} 
		// Prepare attacks
		else if(prep_counter <= 0) _PrepAttack();
	break;
		
	// Attack with pellets (only big ones)
	case ENEMIES.ATTACK_1_SHOT:
		// Face enemy
		EnemyFaceTarget(target_id);
		if(trig_anim_end)
		{
			var _x_pos = x + lengthdir_x(82, image_angle - 90);
			var _y_pos = y + lengthdir_y(82, image_angle - 90);
			
			// All pellets are big
			var _pellet = instance_create_layer(_x_pos, _y_pos, layer, obj_EnemyTwinhornPelletBig); 	
			_pellet.speed = pellet_speed + random_range(-3, 10);
			_pellet.direction = image_angle - 90;
			_pellet.image_angle = _pellet.direction;
			audio_play_sound(snd_SFXPelletLaunch, 1, false);
			state = ENEMIES.INIT;
		}
	break;
#endregion


//----------------------------------------------------------
// Phase 2
//----------------------------------------------------------
#region
	// Here, twinhorn prepare types of attack it'll launch
	case ENEMIES.PREPARING_2:		
		// Face player
		EnemyFaceTarget(target_id);
		prep_counter -= 1;
		isangry = (prep_pellet_countered >= prep_2_pellet_dive);
		
		if((_collide_seed != noone and _collide_seed.target == noone) or 
			(_collide_water != noone and _collide_water.target == noone) or (_collide_pellet != noone and _collide_pellet.countered))
			{
				if(_collide_pellet != noone and (_collide_pellet.object_index == obj_EnemyTwinhornPelletBig 
					and _collide_pellet.countered)) _HitBigPellet(_collide_pellet);
				else _HitEvade(_collide_seed, _collide_water, _collide_pellet);
			} 
		// Prepare attacks
		else if(prep_counter <= 0) _PrepAttack();
	break;
		
	// Attack with pellets (3 small and then 1 big)
	case ENEMIES.ATTACK_2_SHOT:
		// Face enemy
		EnemyFaceTarget(target_id);
		if(trig_anim_end)
		{
			var _x_pos = x + lengthdir_x(82, image_angle - 90);
			var _y_pos = y + lengthdir_y(82, image_angle - 90);
			var _pellet = noone;
		
			// First 3 pellets are small, last one is big
			if(prep_pellet_shot < 4) _pellet = instance_create_layer(_x_pos, _y_pos, layer, obj_EnemyTwinhornPellet);
			else _pellet = instance_create_layer(_x_pos, _y_pos, layer, obj_EnemyTwinhornPelletBig);
			
			_pellet.speed = pellet_speed + random_range(-3, 10);
			_pellet.direction = image_angle - 90;
			_pellet.image_angle = _pellet.direction;
			audio_play_sound(snd_SFXPelletLaunch, 1, false);
			state = ENEMIES.INIT;
		}
	break;
#endregion


//----------------------------------------------------------
// Phase 3
//----------------------------------------------------------
#region	
	// Prepare for attack
	case ENEMIES.PREPARING_3:
		// Face player
		EnemyFaceTarget(target_id);
		prep_counter -= 1;
		// If shot
		if((_collide_seed != noone and _collide_seed.target == noone) or 
			(_collide_water != noone and _collide_water.target == noone) or (_collide_pellet != noone and _collide_pellet.countered))
			{
				// Shot with big pellet
				if(_collide_pellet != noone and (_collide_pellet.object_index == obj_EnemyTwinhornPelletBig 
					and _collide_pellet.countered)) _HitBigPellet(_collide_pellet);
				else _HitEvade(_collide_seed, _collide_water, _collide_pellet);
			} 
		// Attack (dive/shoot)
		else if(prep_counter <= 0) 
		{
			// Opportunity master dive when player is paralyzed
			if(prep_3_psychic_dive)
			{
				if(target_id.paralysis_counter > 0) break;
				TweenStart("speed", 0 , 38, 0.3*GAMESPD);
								
				direction = image_angle - 90;
				// Attack shadow
				VfxShadowFeint(id);
				audio_play_sound(snd_EnemyFalconAttackScream, 1, false);
				audio_play_sound(snd_EnemyFalconAttackFly, 1, false);
				state = ENEMIES.ATTACK_DIVE_MASTER;
				prep_3_psychic_dive = false;
			}
			// Dive
			else if (prep_pellet_shot >= prep_3_pellet_dive)
			{
				prep_pellet_shot = 0;
				// Start calm dive
				TweenStart("speed", 0 , 38, 0.3*GAMESPD);
										
				direction = image_angle - 90;
				// Attack shadow
				VfxShadowFeint(id);
				audio_play_sound(snd_EnemyFalconAttackScream, 1, false);
				audio_play_sound(snd_EnemyFalconAttackFly, 1, false);
				prep_3_phase_repeat = true;
				state = ENEMIES.ATTACK_DIVE_MASTER;
				prep_pellet_countered = 0;
			} 
			// Shoot
			else 
			{
				if(obj_WeatherThunderstorm.alarm[4] < 0 and obj_WeatherThunderstorm.alarm[3] < 0 and
					obj_WeatherThunderstorm.alarm[2] < 0 and alarm[0] < 0)
					{
						prep_pellet_shot += 1;
						state = ENEMIES.ATTACK_3_SHOT_WINDMILL_HOLD;
					}
			}
		}
	break;
		
	// Psychic attack
	case ENEMIES.ATTACK_3_PSYCHIC:
		// Face enemy
		EnemyFaceTarget(target_id);
		if(trig_anim_end and sprite_index == sprite[state]) 
		{
			// Psychic attack - player frozen
			var _attack = instance_create_layer(x, y, layer, obj_EnemyTwinhornAttackPsychic);
			var _dir = image_angle - 90;
			_attack.speed = 22;
			_attack.direction = _dir;
			_attack.sprite_index = sprite[state];
			_attack.image_angle = image_angle;
			audio_play_sound(snd_EnemyFalconAttackScream, 1, false);
			audio_play_sound(snd_EnemyFalconAttackFly, 1, false);
			state = ENEMIES.POST_PSYCHIC;
		}
	break;
	
	// Shooting attack (3 pellets at the time - 1 big mid-placed and 2 small)
	case ENEMIES.ATTACK_3_SHOT_WINDMILL_HOLD:
		// Face enemy
		EnemyFaceTarget(target_id);
		if (trig_anim_end and sprite_index == sprite[state])
		{
			var _x_pos = x + lengthdir_x(82, image_angle - 90);
			var _y_pos = y + lengthdir_y(82, image_angle - 90);
		
			var _player_dir = point_direction(x, y, obj_PlayerPAR.x, obj_PlayerPAR.y)
			var _direction = [_player_dir, _player_dir - 45, _player_dir + 45];
			// Create 3 pellets at the time - 2 small and 1 big (middle position amongst the 3)
			for(var i = 0; i < 3; i++)
			{
				var _obj = obj_EnemyTwinhornPellet;
				if (i == 0) _obj = obj_EnemyTwinhornPelletBig;
				var _pellet = instance_create_layer(_x_pos, _y_pos, layer, _obj);
				_pellet.speed = pellet_speed + random_range(-3, 10);
				_pellet.direction = _direction[i];
				_pellet.image_angle = _pellet.direction;
			
				audio_play_sound(snd_SFXPelletLaunch, 1, false);
				state = ENEMIES.INIT;
			}
		}
	break;
#endregion


//----------------------------------------------------------
// Phase 4
//----------------------------------------------------------
#region
	// Prepare for attack
	case ENEMIES.PREPARING_4:
		// Face player
		EnemyFaceTarget(target_id);
		direction = image_angle - 90;
		prep_counter--;
		
		// If shot
		if((_collide_seed != noone and _collide_seed.target == noone) or 
			(_collide_water != noone and _collide_water.target == noone) or (_collide_pellet != noone and _collide_pellet.countered))
			{
				// Shot with big pellet
				if(_collide_pellet != noone and (_collide_pellet.object_index == obj_EnemyTwinhornPelletBig
					and _collide_pellet.countered)) _HitBigPellet(_collide_pellet);
				// Roll evade direction
				else _HitEvade(_collide_seed, _collide_water, _collide_pellet);
			} 
		// Start attack
		else if(prep_counter <= 0) 
		{
			// Opportunity master dive
			if(prep_4_panic_dive)
			{
				if(target_id.paralysis_counter > 0) break;
				TweenStart("speed", 0 , 38, 0.3*GAMESPD);
								
				// Attack shadow
				VfxShadowFeint(id);
				audio_play_sound(snd_EnemyFalconAttackScream, 1, false);
				audio_play_sound(snd_EnemyFalconAttackFly, 1, false);
				prep_4_panic_passed = true;
				prep_4_panic_dive = false;
				state = ENEMIES.ATTACK_DIVE_MASTER;
			}
			// Shoot
			else 
			{
				if(!prep_4_phase_repeat and prep_4_panic_passed)
				{
					prep_pellet_shot += 1;
					state = ENEMIES.ATTACK_4_SHOT_SPREAD;
				}
				else state = ENEMIES.INIT;
			}
		}
	break;		
		
	// Panic attack
	case ENEMIES.ATTACK_4_PANIC:
		// Face enemy
		EnemyFaceTarget(target_id);
		if(!phase_4) phase_4 = true;
		
		// Panic attack - player frozen and controls reversed
		if(trig_anim_end and sprite_index == sprite[state]) 
		{
			var _attack = instance_create_layer(x, y, layer, obj_EnemyTwinhornAttackPanic);
			var _dir = image_angle - 90;
			_attack.speed = 25;
			_attack.direction = _dir;
			_attack.sprite_index = sprite[state];
			_attack.image_angle = image_angle;
			audio_play_sound(snd_EnemyFalconAttackScream, 1, false);
			audio_play_sound(snd_EnemyFalconAttackFly, 1, false);
			state = ENEMIES.POST_PSYCHIC;
		}
	break;
	
	// Shooting attack (shoot in S-shape)
	case ENEMIES.ATTACK_4_SHOT_SPREAD:
		// Face enemy
		EnemyFaceTarget(target_id);
		if (alarm[2] >= 0) break;
		
		if(attack_4_pellets_shot == 0) 
		{
			attack_4_pellet_angle = point_direction(x, y, 0, 720);
			alarm[2] = 4;
			attack_4_angle_diff = (point_direction(x, y, 1280, 720) - attack_4_pellet_angle)/attack_4_burst;
		}
		
		attack_4_pellets_shot++;	// delay between pellets
		
		// Create the pellets
		if(attack_4_pellets_shot <= attack_4_max_shot)
		{
			var _x_pos = x + lengthdir_x(82, image_angle - 90);
			var _y_pos = y + lengthdir_y(82, image_angle - 90);
			var _pellet = noone;
			
			// All pellets are small, except the mid one in 2nd pass
			if(attack_4_pellets_shot mod (attack_4_burst div 2) = 0 and attack_4_pellets_shot > attack_4_burst and !attack_4_big_fired) 
				{
					_pellet = instance_create_layer(_x_pos, _y_pos, layer, obj_EnemyTwinhornPelletBig);	
					attack_4_big_fired = true;
				}
			else _pellet = instance_create_layer(_x_pos, _y_pos, layer, obj_EnemyTwinhornPellet);
			
			_pellet.speed = pellet_speed + random_range(-5, 5);
			_pellet.direction = attack_4_pellet_angle;
			_pellet.image_angle = _pellet.direction;
			audio_play_sound(snd_SFXPelletLaunch, 1, false);
			
			alarm[2] = 4;
			if (attack_4_pellet_angle > point_direction(x, y, 1280, 720) or attack_4_pellet_angle < point_direction(x, y, 0, 720))
				attack_4_dir = -attack_4_dir;
			attack_4_pellet_angle += attack_4_dir*attack_4_angle_diff;
		}
		
		// Delay before calm dive (opportunity for big pellet return)
		if(attack_4_dive_delay >= 0)
		{
			if(_collide_big != noone and _collide_big.countered) 
			{
				_HitBigPellet(_collide_big);
				prep_4_phase_repeat = true;
				prep_4_panic_passed = false;			
				attack_4_pellets_shot = 0;
				attack_4_pellet_angle = -1;
				attack_4_dir = 1;	
				attack_4_big_fired = false;	
				attack_4_dive_delay = GAMESPD;
			}
			if (attack_4_pellets_shot > attack_4_max_shot) attack_4_dive_delay--;
		}
		// Reset the shooting
		else
		{
			prep_4_phase_repeat = true;
			prep_4_panic_passed = false;
			state = ENEMIES.INIT;
			
			attack_4_pellets_shot = 0;
			attack_4_pellet_angle = -1;
			attack_4_dir = 1;	
			attack_4_big_fired = false;	
			attack_4_dive_delay = GAMESPD;
		}
	break;
#endregion		


//----------------------------------------------------------
// General (repeating) states
//----------------------------------------------------------
#region
	// Calm dive
	case ENEMIES.ATTACK_DIVE_MASTER:
		// Homing towards enemy
		EnemyHomingTarget(target_id, attack_1_dive_master_homing);
		
		// When countered, hp will deplete (but not during cheap shot before title card)
		if(_collide_counter != noone and !(cheap_shot and !obj_ControllerFightBoss4_3.boss_card))
		{
			CombosAddHit(100);
			VfxShake(3, 15);
			speed = 0;
			direction = 0;
			TweenStart("y", y, y - yhurt_offset, 0.8*GAMESPD, TWEENTYPE.CUBIC_OUT);
					
			hp--;
			audio_play_sound(snd_PlaneParry, 1, false);
			PropsFeatherSpecialSpawn(obj_PropFeatherTwinHorn);
			feather = 1;
			
			state = ENEMIES.HURT;
			break;
		}
		
		// If player try to parry, twinhorn will just feint (stop in place)
		// But not during cheap shot before title card
		if(!(cheap_shot and !obj_ControllerFightBoss4_3.boss_card))
		{
			var _parry = instance_nearest(x, y, obj_PlayerParry);
			if(_parry != noone) 
			{
				var _dist = point_distance(x, y, _parry.x, _parry.y);
				if (_dist < 256)
				{
					TweenStart("speed", speed , 0, 0.05*GAMESPD);
								
					dive_feint_counter = dive_feint_period;
					state = ENEMIES.DIVE_FEINT;
				}
			}
		}
	
		// When out of bound
		if(y > 1280 or x < -384 or x > (room_width + 384))
		{
			if(cheap_shot)
			{
				direction = 90;
				image_angle = 180;
				TweenStart("speed", 0, 15, 2*GAMESPD, TWEENTYPE.QUINT_OUT);
				state = ENEMIES.SPAWN;
				// After cheap shot - show boss card and fly in
				with(obj_ControllerFightBoss4_3) event_user(0); // boss card
				cheap_shot = false;
				break;
			}
			speed = 0;
			direction = 0;
			x = random_range(128, room_width-128)
			image_angle = 0;
			TweenStart("y", -480 , y_base, 2*GAMESPD, TWEENTYPE.QUINT_OUT);
						
			state = ENEMIES.DIVE_RECOVERY;	
			prep_pellet_shot = 0;
			prep_pellet_countered = 0;
		}
	break;
		
	// Angry dive
	case ENEMIES.ATTACK_DIVE:
		// Homing towards enemy
		EnemyHomingTarget(target_id, attack_1_dive_homing);
		
		// When countered, hp will deplete
		if(_collide_counter != noone)
		{
			CombosAddHit(100);
			VfxShake(3, 15);
			speed = 0;
			direction = 0;
			TweenStart("y", y, y - yhurt_offset, 0.8*GAMESPD, TWEENTYPE.CUBIC_OUT);
						
			hp--;
			audio_play_sound(snd_PlaneParry, 1, false);
			PropsFeatherSpecialSpawn(obj_PropFeatherTwinHorn);
			feather = 1;
			// Change music
			if(hp == 2)
			{
				with(obj_ControllerFightBoss4_3)
				{
					audio_stop_sound(music_bg);
					music_bg = audio_play_sound(snd_BossTwinHornPhase2, 1, true);
				}
			}
			state = ENEMIES.HURT;
		}
	
		// When out of bound
		if(y > 1280 or x < -384 or x > (room_width + 384))
		{
			speed = 0;
			direction = 0;
			image_angle = 0;
			TweenStart("y", -480 , y_base, 2*GAMESPD, TWEENTYPE.QUINT_OUT);
						
			x = random_range(128, room_width-128)
			state = ENEMIES.DIVE_RECOVERY;	
			prep_pellet_shot = 0;
			prep_pellet_countered = 0;
		}
	break;

	// Psychic/panic attack recovery
	case ENEMIES.POST_PSYCHIC:
		// Wait until psychic/panic attack ends
		if (!instance_exists(obj_EnemyTwinhornAttackPsychic) and !instance_exists(obj_EnemyTwinhornAttackPanic)) state = ENEMIES.INIT;
	break;
		
	case ENEMIES.DIVE_FOLLOWUP:
		// Homing
		EnemyHomingTarget(target_id, dive_followup_homing);
		// Go to dive recovery
		if(y > 1280 or x < -384 or x > (room_width + 384)) 
		{
			speed = 0;
			direction = 0;
			image_angle = 0;
			TweenStart("y", -480 , y_base, 2*GAMESPD, TWEENTYPE.QUINT_OUT);
						
			x = random_range(128, room_width - 128)
			state = ENEMIES.DIVE_RECOVERY;
			prep_pellet_shot = 0;
			prep_pellet_countered = 0;
		}
	break;
	
	case ENEMIES.DIVE_FEINT:
		// Wait 0.5s
		dive_feint_counter -= 1;
	
		if(dive_feint_counter <= 0) 
		{
			TweenStart("speed", speed, 8, 0.2*GAMESPD);
				
			direction = 90;
			image_angle = 180;
			state = ENEMIES.HURT_RETURN;
		}
	break;
		
	case ENEMIES.DIVE_RECOVERY:
		if(y > (y_base - 2)) state = ENEMIES.INIT;
	break;
		
	// Has been hurt
	case ENEMIES.HURT:
		if(_collide_water != noone)
		{
			TweenStop();
			TweenStart("y", y, y - 96, 0.8*GAMESPD);
			direction = 270;
			speed = 0;
			CombosAddHit(50);
			_HitFXWater(_collide_water);
			VfxShake(3, 10);

			hit_combo_counter++;
			state = ENEMIES.HURT;
			break;
		}
		if(_collide_seed != noone)
		{
			TweenStop();
			TweenStart("y", y, y - 96, 0.8*GAMESPD);
			direction = 270;
			speed = 0;
			CombosAddHit(50);
			hit_fx_seed(_collide_seed);
			VfxShake(3, 10);

			hit_combo_counter++;
			state = ENEMIES.HURT;
			break;
		}
	
		if(trig_anim_end and hurt_delay-- <= 0)
		{
			if(hp == 0) 
			{
				state = ENEMIES.INIT;
				// End music with fadeout
				if (!outro_music_played)
				{
					with(obj_ControllerFightBoss4_3)
					{
						audio_stop_sound(music_bg);
						music_bg = audio_play_sound(snd_BossEnding, 1, false);
					}
					outro_music_played = true;
				}
				
				image_angle = 180;
				TweenStart("y", y, 0.45*sprite_height, 1*GAMESPD, TWEENTYPE.LINEAR);
				state = ENEMIES.INIT;
				break;
			}
			// Spawn feather if combo'ed
			//if (hit_combo_counter >= 3) PropsFeatherSpecialSpawn(obj_PropFeatherTwinHorn);
			hit_combo_counter = 0;
			hurt_delay = 1.5*GAMESPD;
			speed = 12;
			direction = 90;
			image_angle = 180;
			state = ENEMIES.HURT_RETURN;
		}
	break;
	
	// Return to start position
	case ENEMIES.HURT_RETURN:
		if(_collide_seed != noone)
		{
			CombosAddHit(50);
			VfxShake(3, 10);
			hit_fx_seed(_collide_seed);
		}
		if(_collide_water != noone)
		{
			CombosAddHit(50);
			VfxShake(3, 10);
			_HitFXWater(_collide_water);
		}
		if(hp == 0 and y < 0) state = ENEMIES.INIT;
		else if(y < -sprite_height)
		{
			TweenStart("y", y, y_base, GAMESPD);
			speed = 0;
			direction = 0;
			image_angle = 0;
			state = ENEMIES.BETWEEN;
			alarm[3] = GAMESPD*(4.5 - hp);
			if (hp > 2) isangry = false;
		}
		else if(y == y_base)
		{
			TweenStop(id, "y");
			trig_anim_end = false;
			state = ENEMIES.INIT;
		}
	break;
	
	case ENEMIES.EVADE:
		if(trig_anim_end) state = ENEMIES.INIT;
	break;
#endregion
}


//----------------------------------------------------------
// Sprite changes
//----------------------------------------------------------
if(sprite_index != sprite[state])
{
	sprite_index = sprite[state];
	image_index = 0;
	
	if (sprite_index == spr_TwinHornsDeepBreathe or sprite_index == spr_TwinHornsFlashEyes) trig_anim_end = false;
	if(state == ENEMIES.EVADE) image_xscale = sign(evade_direction);
}


//----------------------------------------------------------
// Blinking
//----------------------------------------------------------
isangry_blink_counter --;
if (isangry_blink_counter <= 0) 
{
	isangry_blink = !isangry_blink;
	isangry_blink_counter = isangry_blink_period;
}

ShFlashStep();