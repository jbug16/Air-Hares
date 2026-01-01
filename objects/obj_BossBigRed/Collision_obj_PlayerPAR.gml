if (state != BOSS.DIVE) exit;

// Being hurt - if wind in the correct direction and player rolling in the same dir.
if (hp_lost_during_dive == 0 and obj_WindParticles.wind_blowing != 0
	and ((other.state == PLAYERSTATE.ROLL_LEFT and obj_WindParticles.wind_dir == 180) 
	or (other.state == PLAYERSTATE.ROLL_RIGHT and obj_WindParticles.wind_dir == 0)))
{
	// stop movement and change state
	speed = 0;
	image_index = 0;
	state = BOSS.HURT;
	VfxShake(3, 15);
	
	// Tween shot back - changed to match Twin Horn behavior
	TweenStop();
	TweenStart("y", y, y - 128, GAMESPD, TWEENTYPE.CUBIC_OUT);
			
	// damage and score
	CombosAddHit(50);
	PropsFeatherSpecialSpawn(obj_PropFeatherBigRed);
	hp_lost_during_dive = 1;
	hp--;
	// Start transition music
	if(seq_phase == 1)
	{
		with(obj_ControllerFightBoss1_3)
		{
			audio_stop_sound(music_bg);
			music_bg = audio_play_sound(snd_BossTransition, 1, false);
		}
	}
	exit; // Prevent event_inherited when boss is hurt
}
// Dodge the attack
if (hp_lost_during_dive == 0 and (other.state == PLAYERSTATE.ROLL_LEFT or other.state == PLAYERSTATE.ROLL_RIGHT))
{
	hp_lost_during_dive = -1;
	
	// stop movement and change state
	state_prev = state;
	speed_prev = speed;
	
	speed = 0;
	image_index = 0;
	state = BOSS.DODGE;
	
	// Tween shot back - changed to match Twin Horn behavior
	TweenStop();
	TweenStart("y", y, y - 128, GAMESPD, TWEENTYPE.CUBIC_OUT);
	exit; // Prevent event_inherited when boss dodges (player is rolling, invincible anyway)
}

// Player is not rolling - they should take damage
event_inherited();