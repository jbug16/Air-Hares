/// @desc

if cloud_prev != cloud_current 
{
	TweenStart("image_xscale", 1, 2, 0.15*GAMESPD, TWEENTYPE.CIRC_OUT,, TWEENREPEAT.PATROL);
	TweenStart("image_yscale", 1, 2, 0.15*GAMESPD, TWEENTYPE.CIRC_OUT,, TWEENREPEAT.PATROL);
}
cloud_prev = cloud_current;
cloud_display = lerp(cloud_display, cloud_current, 0.15);