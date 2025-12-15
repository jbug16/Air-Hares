///@desc Pause

// pause menu
if(instance_exists(obj_Pause))
{
	part_system_automatic_update(particle_system, false); //Pause particles 
	audio_pause_sound(snd_DesertWind); //Pause wind sfx
}
else
{
	part_system_automatic_update(particle_system, true);
	audio_resume_sound(snd_DesertWind);
}

// wind blow or not sfx pause
if (wind_blowing != 0) audio_resume_sound(snd_DesertWind);
else audio_pause_sound(snd_DesertWind);