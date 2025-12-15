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
// When to create the controller
alarm[0] = fade_len;

// Text position and fade in/out...
txt = global.story_mode_level[global.current_level][STORYPROP.NAME];
x = room_width/2;
y = room_height/2;
TweenStart("image_alpha", 0, 1, fade_len/2, TWEENTYPE.SINE_OUT, , TWEENREPEAT.PATROL,2);

// Audio
audio_stop_all();