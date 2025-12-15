/// @desc
if(global.mouse_disable) exit;
if focus {
	focus = false;

	// scale
	TweenStart("image_xscale", image_xscale, 1, 0.5*GAMESPD, TWEENTYPE.CIRC_OUT);
	TweenStart("image_yscale", image_yscale, 1, 0.5*GAMESPD, TWEENTYPE.CIRC_OUT);
	
	color = c_white;
}