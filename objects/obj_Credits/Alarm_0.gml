///@desc Phase 0: fade out

// Fade
TweenStart("image_alpha", image_alpha, 0, 2*GAMESPD);
if (phase == 0)
{
	alarm[1] = 2*GAMESPD;
	// Music handoff lives in Step. Fading snd_CutsceneOutro here used the
	// asset index, which left the asset gain at 0 for every later play.
}
else if (phase == 2)
{
	alarm[3] = 2*GAMESPD;
	if (music != noone && audio_is_playing(music)) audio_sound_gain(music, 0, 2500);
}

