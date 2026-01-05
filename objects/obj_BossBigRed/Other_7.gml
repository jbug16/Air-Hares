///@desc Roost/hurt/dodge

// Roost
if(state == BOSS.ROOST)	
{
	image_speed = 0;
	image_index = image_number - 1;
}
// HURT
else if (state == BOSS.HURT)
{
	var _collide_seed = instance_place(x, y, obj_PlayerProjectileSeed);
	var _collide_water = instance_place(x, y, obj_PlayerProjectileWater);
	if(_collide_seed != noone or _collide_water != noone and hp <= 0)
	{
		VfxShake(3, 15);
		exit;
	}
	
	TweenStop();
	
	if (hp <= 0)	// Defeated
	{	
		array_push(obj_ControllerFightBoss2_3.bigred_deathpos, x, y);
		// End music with fadeout - only play once
		if(!outro_music_played)
		{
			with(obj_ControllerFightBoss2_3)
			{
				audio_stop_sound(music_bg);
				music_bg = audio_play_sound(snd_BossEnding, 1, false);
				//audio_sound_gain(music_bg, 0, 40*GAMESPD);
			}
			outro_music_played = true;
		}
		state = BOSS.DYING;
		// Run away
		direction = choose(45, 135);
		image_angle = direction + 90;
		speed = 0;
		TweenStart("speed", 0, 16, 2*GAMESPD, TWEENTYPE.CUBIC_OUT);
	}
	else			// still alive
	{
		TweenStart("speed", speed_prev, 1.3*dive_spd, 0.2*GAMESPD);
		
		state = BOSS.INIT;
		direction = point_direction(x,y, room_width*0.5, -720)
		image_angle = direction + 90;
	}
}
else if (state == BOSS.DODGE)	// continue going down
{
	TweenStop();
	state = BOSS.DIVE;
	direction = point_direction(x,y, x, y + 10)
	image_angle = direction + 90;
	speed = dive_spd;
}