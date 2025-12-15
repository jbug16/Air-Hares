// Transition lengths
fade_in = 2*GAMESPD;
fade_out = 2*GAMESPD;
start_fadeout = 3*GAMESPD;

// fade in
TweenStart("image_alpha", 0, 1, fade_in, TWEENTYPE.CIRC_OUT);

alarm[1] = start_fadeout;
alarm[10] = 2;