/// @desc
focus = false;
text = "Button";
color = c_white;
tgt_script = noone;

image_xscale = 0.7;
image_yscale = 0.7;

TweenStart("image_xscale", image_xscale, 1, 2*GAMESPD, TWEENTYPE.CIRC_OUT);
TweenStart("image_yscale", image_xscale, 1, 2*GAMESPD, TWEENTYPE.CIRC_OUT);