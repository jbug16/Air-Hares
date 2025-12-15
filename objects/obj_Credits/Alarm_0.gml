///@desc Phase 0: fade out

// Fade 
TweenStart("image_alpha", image_alpha, 0, 2*GAMESPD);
if (phase == 0) 
{
	alarm[1] = 2*GAMESPD;
	if audio_is_playing(snd_CutsceneOutro) audio_sound_gain(snd_CutsceneOutro, 0, 20*GAMESPD);
	if !audio_is_playing(snd_Credits) music = audio_play_sound(snd_Credits, 1, false);
	audio_sound_gain(music, 0, 0);
	audio_sound_gain(music, 1, 30*GAMESPD);
}
else if (phase == 2) 
{
	alarm[3] = 2*GAMESPD;
	audio_sound_gain(music, 0, 20*GAMESPD);
}

