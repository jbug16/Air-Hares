/// @desc
if(fade_alpha == 1)
{
	image_index++;
	TweenStart("fade_alpha", 1, 0, fade_time, TWEENTYPE.LINEAR);
	alarm[0] = fade_time;
}