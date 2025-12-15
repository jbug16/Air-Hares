///@desc Phase 1 -> 2

// Next phase and position...
phase = 2;
TweenStop(,"y");
x = room_width/2;
y = room_height/2;

// Enlarge, fade-in
TweenStart("image_alpha", 0, 1, 2*GAMESPD);
TweenStart("image_xscale", 0.24, 0.66, 6*GAMESPD, TWEENTYPE.CIRC_OUT);
TweenStart("image_yscale", 0.24, 0.66, 6*GAMESPD, TWEENTYPE.CIRC_OUT);
alarm[0] = 8*GAMESPD;