/*
	Object used for showing the pre-screen lives etc. Once it fades out, it creates the level controller etc.
*/

//==========================================================
// ADJUSTABLE
//==========================================================
fade_len = GAMESPD*2;
scale_num = 0.22;		// scale numbers


//==========================================================
// BACKEND
//==========================================================
wait_tutorial_choice = false;

// Text position and fade in/out...
x = room_width/2;
y = room_height/2;

if (StoryPeacefulIntroFarmActive() && room == rm_LevelX1Farm) {
	wait_tutorial_choice = true;
	txt = "Tutorial";
	alarm[0] = -1;
	image_alpha = 0;
	TweenStart("image_alpha", 0, 1, fade_len / 2, TWEENTYPE.SINE_OUT, 0, TWEENREPEAT.RETWEEN, 1);
	with (instance_create_layer(room_width * 0.9, room_height * 0.9, "GUI_Top", obj_PreScreenTutorialBtnSkip)) depth -= 1;
	with (instance_create_layer(room_width * 0.1, room_height * 0.9, "GUI_Top", obj_PreScreenTutorialBtnPlay)) depth -= 1;
} else {
	txt = global.story_mode_level[global.current_level][STORYPROP.NAME];
	alarm[0] = fade_len;
	TweenStart("image_alpha", 0, 1, fade_len/2, TWEENTYPE.SINE_OUT, , TWEENREPEAT.PATROL,2);
}

// Audio
audio_stop_all();