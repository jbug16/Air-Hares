///@desc
if (instance_exists(obj_TipsAndTricks)) exit;

// Boss card - wait
if(obj_ControllerFightBoss1_3.alarm[2] > 0 and state == BOSS.APPEAR)
{
	target_id = instance_nearest(x, y, obj_PlayerPAR);
	EnemyFaceTarget(target_id);
	exit;
}

//==========================================================
// Preparation - being hit
//==========================================================
// Being hit
var _collide_seed = instance_place(x, y, obj_PlayerProjectileSeed);
var _collide_water = instance_place(x, y, obj_PlayerProjectileWater);
var _collide_counter = instance_place(x, y, obj_PlayerParry);
if (!_collide_counter) parry_snd = false;

// After period of time cannot be hurt again
if(hp == 0 and alarm[2] < 0 or y < 0)
{
	_collide_seed = noone;
	_collide_water = noone;
}

var _sidekick_dodge = false;
with(obj_FalconHighTop) if(state == BOSS.DODGE) _sidekick_dodge = true;

// Prolong the alarms
if(_sidekick_dodge)
{
	if(alarm[0] > 0) alarm[0]++;
	if(alarm[1] > 0) alarm[1]++;
}

// If shot while hurt - allow continuous hits like Twin Horn
if (state == BOSS.HURT and (_collide_seed != noone or _collide_water != noone))
{
	if (_collide_seed != noone)
	{
		hit_fx_seed(_collide_seed);
		CombosAddHit(50);
		_collide_seed = noone;
	}
	if (_collide_water != noone)
	{
		_HitFXWater(_collide_water);
		CombosAddHit(50);
		_collide_water = noone;
	}
	VfxShake(3, 15);
	
	// Apply knockback for continuous hits
	TweenStop();
	TweenStart("y", y, y - 128, GAMESPD, TWEENTYPE.CUBIC_OUT);
}

//==========================================================
// Being hit / evade
//==========================================================
if (state == BOSS.IDLE or state == BOSS.DIVE or (state == BOSS.APPEAR and bbox_bottom > 0)
	or (state == BOSS.DYING and y > sprite_height))
if (_collide_seed or _collide_water or _collide_counter)
{
	//----------------------------------------------------------
	// Managed to hit him
	//----------------------------------------------------------
	if (state == BOSS.DIVE or state == BOSS.DYING or (state == BOSS.INIT and hp_lost_during_dive))
	{
		// Check parry FIRST - if parried, only process parry and ignore seed/water in same step
		// This matches Twin Horn behavior where parry takes priority
		if (_collide_counter)
		{
			CombosAddHit(100);
			if (!parry_snd) 
			{
				audio_play_sound(snd_PlaneParry, 1, false);	// parry hit
				parry_snd = true;
			}
			_collide_counter = noone;
			
			// Clear seed/water collisions to prevent processing them in same step
			_collide_seed = noone;
			_collide_water = noone;
			
			// stop movement and change state
			speed = 0;
			image_index = 0;
			state = BOSS.HURT;
			hurt_delay = 1.5*GAMESPD; // Reset delay to allow multiple hits like Twin Horn
			alarm[2] = hurt_delay;
			VfxShake(3, 15);
			
			// Start transition music
			if(seq_phase == 1)
			{
				with(obj_ControllerFightBoss1_3)
				{
					audio_stop_sound(music_bg);
					music_bg = audio_play_sound(snd_BossTransition, 1, false);
				}
			}
		
			// Tween shot back - changed to match Twin Horn behavior
			TweenStop();
			TweenStart("y", y, y - 128, GAMESPD, TWEENTYPE.CUBIC_OUT);
			
			// Damage - only decrease HP once for parry
			if (!hp_lost_during_dive) 
			{
				PropsFeatherSpecialSpawn(obj_PropFeatherHighTop);
				hp_lost_during_dive = true;
				hp--;
			}
		}
		// Only process seed/water if no parry happened
		else
		{
			// VFX/SFX - water/seed splash
			if (_collide_seed != noone)	
			{
				hit_fx_seed(_collide_seed);			// seed shot
				CombosAddHit(100);
				hp--;
				_collide_seed = noone;
			}
			if (_collide_water != noone) 
			{
				_HitFXWater(_collide_water);
				CombosAddHit(100);
				hp--;
				_collide_water = noone;
			}
			
			// stop movement and change state
			speed = 0;
			image_index = 0;
			state = BOSS.HURT;
			hurt_delay = 1.5*GAMESPD; // Reset delay to allow multiple hits like Twin Horn
			alarm[2] = hurt_delay;
			VfxShake(3, 15);
			
			// Start transition music
			if(seq_phase == 1)
			{
				with(obj_ControllerFightBoss1_3)
				{
					audio_stop_sound(music_bg);
					music_bg = audio_play_sound(snd_BossTransition, 1, false);
				}
			}
		
			// Tween shot back - changed to match Twin Horn behavior
			TweenStop();
			TweenStart("y", y, y - 128, GAMESPD, TWEENTYPE.CUBIC_OUT);
		}
	}
	//----------------------------------------------------------
	// Evade
	//----------------------------------------------------------
	else	
	{
		// where to move with evade
		TweenStop();
		var _col = _collide_seed;
		if (_col == noone) _col = _collide_water;
		if(_col != noone) evade_direction = sign(_col.x - x);
		else evade_direction = 0;
		
		if (evade_direction == 0) evade_direction = 1;
		var _move = clamp(x - 128*evade_direction, 0, room_width);	
		dodge_dist =  x - _move;
		
		// Evasion maneuver
		TweenStart("x", x, _move, 0.5*GAMESPD, TWEENTYPE.SINE_OUT);
		state = BOSS.DODGE;
	}
}



//==========================================================
// STATEMACHINE
//==========================================================
switch (state)
{
	//----------------------------------------------------------
	// Sequence start - spawn goons/self
	//----------------------------------------------------------
	case BOSS.INIT:
		// spawn first falcon wave in 1st sequence
		if (seq_phase == -1 and instance_exists(obj_PlayerPAR) and sequence == 0) 
		{
			seq_phase++;
			alarm[0] = time[0][0];
		}
	
		// appear from top (2nd sequence)
		if (y < -720)
		{
			// check if next phase needs to start
			if (hp_lost_during_dive and seq_phase < 3)
			{
				seq_phase++;
				if(seq_phase == 2)
				{
					// Stop transition music and start phase 2 loop
					with(obj_ControllerFightBoss1_3)
					{
						audio_stop_sound(music_bg);
						music_bg = audio_play_sound(snd_BossHighTopPhase2, 1, true);
					}
				}
			}
			hp_lost_during_dive = false;
			speed = 0;
			direction = 270;
			image_angle = 0;
			x = 0.5*room_width;
			TweenStart("y", y, 0.3*sprite_height, 3*GAMESPD, TWEENTYPE.QUINT_OUT);
			state = BOSS.APPEAR;
		}
	break;
	
	
	//----------------------------------------------------------
	// Sequence	2 -> roost if needed (spawn goons)
	//----------------------------------------------------------
	case BOSS.APPEAR:	
		image_angle = 0;
		if (y == 0.3*sprite_height)
		{
			state = BOSS.IDLE;
			alarm[0] = time[1][0];
			if (seq_phase == -1) seq_phase++;
		} 
	break;
	
	
	//----------------------------------------------------------
	// Waiting for dive etc.
	//----------------------------------------------------------
	case BOSS.IDLE:
		if(y < -sprite_height or y > 0.3*sprite_height)
		{
			state = BOSS.INIT;
			break;
		}
		target_id = instance_nearest(x, y, obj_PlayerPAR);
		EnemyFaceTarget(target_id);
	
		// falcons are diving and need to wait for their finish
		if (falcons_diving)
		{
			// Check if all the dives finished
			var _all_waiting = true;
			with (obj_FalconHighTop)
			{
				if (state != BOSS.APPEAR)
				{
					_all_waiting = false;
					break;
				}
			}
			if (!_all_waiting) break;
		
			// Do the dive - or repeate the phase if player was hit in the meantime
			falcons_diving = false;
			if (can_dive)
			{
				TweenStop();
				TweenStart("speed", 0, dive_spd, 0.2*GAMESPD);
			
				direction = image_angle - 90;
				audio_play_sound(snd_EnemyFalconAttackScream, 1, false);
				audio_play_sound(snd_EnemyFalconAttackFly, 1, false);
				state = BOSS.DIVE;
				hp_lost_during_dive = false;
			}
			else alarm[0] = time[1][0];
		}
	break;
	
	
	//----------------------------------------------------------
	// Spawn goons
	//----------------------------------------------------------
	case BOSS.ROOST:
	if (y == sprite_height)	// need to return to the position + spawn the necessary falcons
	{
		TweenStop();
		TweenStart("y", y, 0.3*sprite_height, 0.4*GAMESPD, TWEENTYPE.SINE_INOUT);
		
		image_index = 0;
		image_speed = 1;
		
		// spawn the missing falcons
		for (var i = 0; i < 4; i++)
		{
			if ((falcon_ids[i] == noone or !instance_exists(falcon_ids[i])))
			{
				if(hp > 0)
				{
				if(!position_meeting(falcon_positions2[i], 0.3*sprite_height, obj_FalconHighTop))
					{
						falcon_ids[i] = instance_create_layer(falcon_positions2[i], -sprite_height, "Middle", obj_FalconHighTop);
						with (falcon_ids[i])
						{
							state = BOSS.APPEAR;
							state_prev = state;
							speed = 0;
							direction = 270;
							image_angle = 0;
							TweenStart("y", -sprite_height, 0.3*sprite_height, 2*GAMESPD, TWEENTYPE.QUINT_OUT);
						}
					}
					else falcon_ids[i] = instance_position(falcon_positions2[i], 0.3*sprite_height, obj_FalconHighTop);
				}
			}
		}
	}		// falcons need to dive
	else if (y == 0.3*sprite_height and alarm[1] < 0 and instance_number(obj_FalconHighTop) == 4 and !_sidekick_dodge)
	{
		alarm[1] = 2*GAMESPD;
		state = BOSS.IDLE;
	}
	else if(y < 0)
	{
		y = -721;
		state = BOSS.INIT;
	}
	break;
	
	
	//----------------------------------------------------------
	// Diving
	//----------------------------------------------------------
	case BOSS.DIVE:
	if (y > room_height + sprite_height or x < -sprite_width or x > (room_width + sprite_width))
	{
		// go to top
		state = BOSS.INIT;
		image_angle = 180;
		x = room_width*0.5;
		direction = 90;
		speed = fly_in_spd;
		TweenStop();
		
		// check if next phase needs to start
		if (hp_lost_during_dive and seq_phase < 3){
			seq_phase++;
			if(seq_phase == 2)
			{
				// Stop transition music and start phase 2 loop
				with(obj_ControllerFightBoss1_3)
				{
					audio_stop_sound(music_bg);
					music_bg = audio_play_sound(snd_BossHighTopPhase2, 1, true);
				}
			}
		}
	}
	break;
	
	
	//----------------------------------------------------------
	// Has been hurt
	//----------------------------------------------------------
	case BOSS.HURT:
		// Stay in HURT state - continuous hits are handled above
		// Only exit when delay counts down (allows multiple hits like Twin Horn)
		if(hurt_delay-- <= 0)
		{
			if(hp <= 0) 
			{
				// Defeated - handled in Other_7
				state = BOSS.DYING;
			}
			else
			{
				// Still alive, fly to the top
				TweenStop();
				TweenStart("speed", speed_prev, dive_spd*1.3, 0.2*GAMESPD);
				state = BOSS.INIT;
				direction = point_direction(x, y, room_width*0.5, -720);
				image_angle = direction + 90;
				hurt_delay = 1.5*GAMESPD; // Reset delay for next time (matches Twin Horn)
			}
		}
	break;
	
	//----------------------------------------------------------
	// Defeated
	//----------------------------------------------------------
	case BOSS.DYING:	
	if (x <= -500 or x > room_width + 500 or y < -500 or y > room_height + 500) instance_destroy();
	break;
	
	
	//----------------------------------------------------------
	// Evade shots - perform
	//----------------------------------------------------------
	case BOSS.DODGE:
	// need to prolong the alarms if any are active
	if (alarm[0] > 0) alarm[0]++;
	if (alarm[1] > 0) alarm[1]++;
	break;
}



//==========================================================
// Animation & remember previous states/speeds
//==========================================================
if (sprite_index != sprite[state])
{
	image_index = 0;
	sprite_index = sprite[state];
	//trig_anim_end = false;
	if (state != BOSS.HURT and state != BOSS.DODGE and state != state_prev) 
	{
		state_prev = state;
		speed_prev = speed;
	}
	if (state == BOSS.DODGE) image_xscale = -evade_direction;
}