can_press = true;
focus = false;
text = "Text";
color = c_white;

image_xscale = 0.7;
image_yscale = 0.7;

TweenStart("image_xscale", image_xscale, 1, 2*GAMESPD, TWEENTYPE.CIRC_OUT);
TweenStart("image_yscale", image_yscale, 1, 2*GAMESPD, TWEENTYPE.CIRC_OUT);