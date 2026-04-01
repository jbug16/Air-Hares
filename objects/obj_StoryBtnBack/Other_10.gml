///@desc Click

// From New Story Game screen: return to Continue / New / Back (do not close Story menu)
if (global.story_popup_screen == 1) {
	audio_play_sound(snd_PlaneRabboRoll, 10, false);
	StoryPopupExitNewGameScreen();
	exit;
}

// Inherit the parent event
event_inherited();

instance_destroy(obj_StoryModeFrame);
while (instance_exists(obj_ModesBtnPAR)) instance_destroy(obj_ModesBtnPAR);
with (obj_StoryBtnContinue) instance_destroy();
with (obj_StoryBtnPlay) instance_destroy();
with (obj_StoryBtnBack) instance_destroy();

with(obj_TitlebBtnGeneralPAR){
	alarm[2] = 20;
	mode_on = false;
	
	if (button_id == 1) event_user(1);
	else focus = false;
}
