///@desc Slide change
if (!fade_out)			// fade in
{
	image_index++;
	if (image_index == image_number)  event_user(1);	// end of slides reached
 	else
	{
		//-> Fading
		fade_out = true;
		TweenStart("image_alpha", 0, 1, fadein_img[image_index], tween_fadein_img);
		//-> Scaling and position
		var _time_next = timings_ends[image_index] - timings_ends[image_index-1] + fadeout;
		TweenStart("image_xscale", zoom_img[image_index][0], zoom_img[image_index][1], _time_next, tween_zoom_img);
		TweenStart("x", room_width/2+x_start[image_index], room_width/2+x_stop[image_index], _time_next, tween_pos_img);
		TweenStart("y", y0+y_start[image_index], y0+y_stop[image_index], _time_next, tween_pos_img);
		//-> Text scale/pos
		scale_txt = zoom_txt[0];
		txt_position = txt_pos[0];
		
		//-> Wait for slide end, and wait for text delay if text timing is not array
		if(!hold_end) alarm[0] = timings_ends[image_index] - timings_ends[image_index - 1] - fadeout;
		if !is_array(timings_txt) alarm[1] = timings_txt;
	}
}
else					// fade out
{
	fade_out = false;
	TweenStart("image_alpha", 1, 0, fadeout, tween_end);
	TweenStart("text_alpha", 1, 0, fadeout, tween_end);
	alarm[0] = fadeout;
}