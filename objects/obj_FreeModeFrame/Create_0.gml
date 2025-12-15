with obj_FreeModeSelect is_disabled = true;

// scale in
TweenStart("image_xscale", 0.1, 1.8, 0.5*GAMESPD, TWEENTYPE.CIRC_OUT);
TweenStart("image_yscale", 0.1, 1.8, 0.5*GAMESPD, TWEENTYPE.CIRC_OUT);

fade_alpha = 1;
prev_up = false;
prev_down = false;
prev_left = false;
prev_right = false;

instance_create_depth(x - 125, y + 25, depth -1, obj_FreeModeBtnPlay);
instance_create_depth(x + 125, y + 25, depth -1, obj_FreeModeBtnBack);
