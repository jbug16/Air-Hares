/// @desc
text = "";
vsp = -1;
alarm[0] = GAMESPD * 0.8;
color = c_white;
font = fnt_Federo37;
sep = 36;
w = 1280;

z = 0;
peaceful_intro_ok = false;
image_xscale = 0;

TweenStart("image_xscale", 0, 1, 0.2*GAMESPD, TWEENTYPE.CIRC_OUT);
TweenStart("image_yscale", 0, 1, 0.2*GAMESPD, TWEENTYPE.CIRC_OUT);