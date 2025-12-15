/// @desc Level unhovered
if is_disabled exit;

focus = false;

// scale
TweenStart("image_xscale", scale_big, scale_normal, 0.5*GAMESPD, TWEENTYPE.CIRC_OUT);
TweenStart("image_yscale", scale_big, scale_normal, 0.5*GAMESPD, TWEENTYPE.CIRC_OUT);