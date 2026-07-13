// Transition lengths
fade_in = 2.5*GAMESPD;
fade_out = 2*GAMESPD;
start_fadeout = 5*GAMESPD;
scale_in = 4*GAMESPD;


// fade in and enlarge
TweenStart("image_xscale", 0.8, 0.88, scale_in, TWEENTYPE.CIRC_OUT);
TweenStart("image_yscale", 0.8, 0.88, scale_in, TWEENTYPE.CIRC_OUT);
TweenStart("image_alpha", 0, 1, fade_in, TWEENTYPE.CIRC_OUT);

alarm[1] = start_fadeout;
alarm[10] = 2; // also triggers the one-time texture prefetch (see Alarm 10)