// Inherit the parent event

event_inherited();
image_xscale /= 1.5;
image_yscale /= 1.5;
mode_on = true;
scale_big = image_xscale*1.5;
scale_normal = image_xscale;


TweenStart("y", y, y + 30, 0.5*GAMESPD, TWEENTYPE.CIRC_OUT, 0.2*GAMESPD);