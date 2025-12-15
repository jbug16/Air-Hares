/// @desc
var _sum = feather_blue + feather_black + feather_brown;
_sum += (feather_purple + feather_twinhorn);

if(feather_sum != _sum) 
{
	TweenStart("image_xscale", 1, 2, 0.15*GAMESPD, TWEENTYPE.CIRC_OUT,, TWEENREPEAT.PATROL);
	TweenStart("image_yscale", 1, 2, 0.15*GAMESPD, TWEENTYPE.CIRC_OUT,, TWEENREPEAT.PATROL);
	
}

feather_sum = _sum;