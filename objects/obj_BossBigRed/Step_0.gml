// Boss card - wait
if(obj_ControllerFightBoss2_3.alarm[2] > 0 and state == BOSS.APPEAR)
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
if(hp == 0 and alarm[2] < 0)
{
	_collide_seed = noone;
	_collide_water = noone;
}

var _sidekick_dodge = false;
with(obj_FalconBigRed) if(state == BOSS.DODGE) _sidekick_dodge = true;

// Prolong the alarms
if(_sidekick_dodge)
{
	if(alarm[0] > 0) alarm[0]++;
	if(alarm[1] > 0) alarm[1]++;
}


//==========================================================
// VFX/SFX - water/seed splash
//==========================================================
var _fx = noone;
if (_collide_seed != noone)				// seed shot
{
	hit_fx_seed(_collide_seed);
	_fx = instance_create_depth(x, y, depth-1, obj_PlayerProjectileSeedFX);
	audio_play_sound(snd_ProjSeedHit, 1, false);
}
else if (_collide_water != noone) 
{
	_HitFXWater(_collide_water);	// water shot
	_fx = instance_create_depth(x, y, depth-1, obj_PlayerProjectileWaterFX);
	audio_play_sound(snd_ProjWaterHit, 1, false);
}
else if (!parry_snd and _collide_counter) 
{
	audio_play_sound(snd_ParryHit, 1, false);	// parry hit
	parry_snd = true;
}
if (_fx != noone)
{
	_fx.z = 0;
	_fx.master = id;
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
		// Spawn first falcon wave in 1st sequence
		if (seq_phase == -1 and instance_exists(obj_PlayerPAR) and sequence == 0) 
		{
			seq_phase++;
			alarm[0] = time[0][0];
		}
	
		// Appear from top (2nd sequence)
		if (y < -720)
		{
			// check if next phase needs to start
			if (hp_lost_during_dive and seq_phase < 3)
			{
				seq_phase++;
				if(seq_phase == 2)
				{
					// Stop transition music and start phase 2 loop
					with(obj_ControllerFightBoss2_3)
					{
						audio_stop_sound(music_bg);
						music_bg = audio_play_sound(snd_BossBigRedPhase2, 1, true);
					}
				}
			}
			hp_lost_during_dive = 0;
			x = 0.5*room_width;
			y = -sprite_height;
			TweenStart("y", -sprite_height, 0.3*sprite_height, 3*GAMESPD, TWEENTYPE.QUINT_OUT);
		
			state = BOSS.APPEAR;
			speed = 0;
			direction = 270;
			image_angle = 0;
		
			// Stop the wind
			with (obj_WindParticles)
			{
				wind_blowing = 0;
				alarm[1] = -1;
			}
		}
		break;
	
	//----------------------------------------------------------
	// Sequence	2 -> roost if needed (spawn goons)
	//----------------------------------------------------------
	case BOSS.APPEAR:	// sequence	2 -> roost if needed
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
		target_id = instance_nearest(x, y, obj_PlayerPAR);
		EnemyFaceTarget(target_id);
	
		// falcons are diving and need to wait for their finish
		if (falcons_diving)
		{
			// check if all the dives finished
			var _all_waiting = true;
			with (obj_FalconBigRed)
			{
				if (state != BOSS.APPEAR)
				{
					_all_waiting = false;
					break;
				}
			}
			if !_all_waiting break;
		
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
			TweenStart("y", y, 0.3*sprite_height, 3*GAMESPD, TWEENTYPE.SINE_INOUT);
		
			// spawn the missing falcons
			for (var i = 0; i < 4; i++)
			{
				if((falcon_ids[i] == noone or !instance_exists(falcon_ids[i])) and hp > 0)
				{
					if(!position_meeting(falcon_positions2[i], 0.3*sprite_height, obj_FalconBigRed))
					{
						falcon_ids[i] = instance_create_layer(falcon_positions2[i], -sprite_height, "Middle", obj_FalconBigRed);
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
				}
			}
		}		// Returned to initial position
		else if (y == 0.3*sprite_height and alarm[1] < 0 and 
			!(falcon_ids[0] == noone or falcon_ids[1] == noone or falcon_ids[2] == noone or falcon_ids[3] == noone)) 
		{
			if(image_speed == 0) image_speed = 1;
			alarm[1] = 2*GAMESPD;
			state = BOSS.IDLE;
		}
		break;
	
	//----------------------------------------------------------
	// Diving
	//----------------------------------------------------------
	case BOSS.DIVE:
		if (y > 2*room_height or x < -sprite_width or x > (room_width + sprite_width))
		{
			// go to top
			state = BOSS.INIT;
			image_angle = 180;
			x = room_width*0.5;
			direction = 90;
			speed = fly_in_spd;
		}
		break;
	
	//----------------------------------------------------------
	// Defeated
	//----------------------------------------------------------
	case BOSS.DYING:	// defeated
		if (x <= -500 or x > room_width + 500 or y < -500 or y > room_height + 500) instance_destroy();
		break;
	
	//----------------------------------------------------------
	// Evade shots - perform
	//----------------------------------------------------------
	case BOSS.DODGE:
		break;
		
	//case BOSS.HURT:
	//	if(_collide_seed != noone or _collide_water != noone)
	//	{}
	//	break;
}


//==========================================================
// Animation & remember previous states/speeds
//==========================================================
if (sprite_index != sprite[state])
{
	image_index = 0;
	sprite_index = sprite[state];
	if (state != BOSS.HURT and state != BOSS.DODGE and state != state_prev) 
	{
		state_prev = state;
		speed_prev = speed;
	}
}