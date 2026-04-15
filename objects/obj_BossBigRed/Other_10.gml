///@desc Create the falcons

//==========================================================
// Before boss appears
//==========================================================
if (sequence == 0)
{
	if (seq_phase <= array_length(falcon_positions) - 1)
	{
		prep_wave_took_hp_hit = false;
		var _num = array_length(falcon_positions[seq_phase]);	// how many to spawn
		
		falcon_ids = array_create(_num, noone);	// reset falcon IDs
		for (var i = 0; i < _num; i++)
		{
			falcon_ids[i] = instance_create_layer(falcon_positions[seq_phase][i], room_height + 500, "Top", 
				obj_FalconBigRed);
		}
	}
	else	// go to next sequence (fly into from bottom)
	{
		falcon_ids = array_create(4, noone);
		sequence = 1;
		seq_phase = -1;
		direction = 90;
		speed = fly_in_spd;
		with(obj_ControllerFightBoss2_3) event_user(0);
	}
}
//==========================================================
// After boss appears
//==========================================================
else				
{
	if(hp == 0) exit;
	if (falcon_ids[0] == noone or falcon_ids[1] == noone or falcon_ids[2] == noone or falcon_ids[3] == noone)
	{
		state = BOSS.ROOST;
		TweenStop();
		TweenStart("y", y, sprite_height, 0.5*GAMESPD, TWEENTYPE.SINE_OUT);
	
		audio_play_sound(snd_EnemyFalconAttackScream, 1, false);
	}
	else alarm[1] = 2*GAMESPD;
}