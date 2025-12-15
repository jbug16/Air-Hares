///@desc Time between phases

//==========================================================
// Before boss appears
//==========================================================
if (sequence == 0)
{
	if (seq_phase <= array_length(falcon_positions) - 1)
	{
		var _num = array_length(falcon_positions[seq_phase]);	// how many to spawn
		
		falcon_ids = array_create(_num, noone);	// reset falcon IDs
		for (var i = 0; i < _num; i++)
		{
			falcon_ids[i] = instance_create_layer(falcon_positions[seq_phase][i], room_height + 500, "Top", 
				obj_FalconGoldGrip);
		}
	}
	else	// go to next sequence (with boss)
	{
		falcon_ids = array_create(4, noone);
		sequence = 1;
		seq_phase = -1;
		obj_ControllerPAR.env_weather.lightning_fx_create(1, 1);
		visible = true;
		alarm[3] = audio_sound_length(snd_BossAnnouncement)*GAMESPD*1.5;
		with(obj_ControllerFightBoss3_3) event_user(0);
	}
}