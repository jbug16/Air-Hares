// Transition lengths
delay = 1*GAMESPD;
fade_in = 3*GAMESPD;
fade_out = 2*GAMESPD;
start_fadeout = 5*GAMESPD;
scale_in = 2*GAMESPD;

tween_in = TWEENTYPE.CUBIC_OUT;

image_alpha = 0;

alarm[0] = start_fadeout;	// fade out

// scale up and fade in after delay
TweenStart("image_xscale", 1, 1.1, scale_in, tween_in, delay);
TweenStart("image_yscale", 1, 1.1, scale_in, tween_in, delay);
TweenStart("image_alpha", 0, 1, fade_in, tween_in, delay);