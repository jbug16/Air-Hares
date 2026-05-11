/// @desc Complete field

with (obj_FarmPlot)
{
	if (other.id == id) continue;

	// Update state
	if(state != PLOTSTATE.CARROT_FRESH) state = PLOTSTATE.CARROT_FRESH;

	// VFX
	with (instance_create_layer(x, y, "Ground", obj_FarmPlotRevitalizeFX))
	{
		master = other.id;
		depth -= 1;
	}
}

// Add score globally and visual feedback
if (!StoryPeacefulIntroFarmActive()) {
	with (instance_create_layer(x + 50, y, "GUI", obj_GUITextFlying))
	{
		z = 100;
		text = "+1000";
	}
	global.score_base += 1000;
}

audio_play_sound(snd_FarmTransform, 1, false);	// SFX