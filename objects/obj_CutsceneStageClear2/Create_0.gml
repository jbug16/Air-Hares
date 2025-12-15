event_inherited();

zoom_img[0] = [1,1.35];

text[0] = "Ever against the odds, the Air Hares use the wind to their\nadvantage and drop Bull Hog snoring to the canvas.";
fadein_img = [3*GAMESPD];
fadein_txt = [3.5*GAMESPD];
timings_ends = [6*GAMESPD];
timings_txt = GAMESPD;

// Tween types
tween_fadein_img = TWEENTYPE.QUAD_OUT;		// image fadein
tween_fadein_txt = TWEENTYPE.QUAD_OUT;

music_bg = snd_CutsceneStageClear;

txt_position = 0.97*room_height;
hold_end = true;

event_user(0);