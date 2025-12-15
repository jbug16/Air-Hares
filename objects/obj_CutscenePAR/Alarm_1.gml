///@desc Text appear delay

// Fade in
TweenStart("text_alpha", 0, 1, fadein_txt[image_index], tween_fadein_txt);

// Scale and move
if zoom_txt[0] != zoom_txt[1] TweenStart("scale_txt", zoom_txt[0], zoom_txt[1], fadein_txt[image_index], tween_zoom_txt);
if zoom_txt[0] != zoom_txt[1] TweenStart("txt_position", txt_pos[0], txt_pos[1], fadein_txt[image_index], tween_zoom_txt);

if (image_index < image_number-1 and is_array(timings_txt))
alarm[1] = timings_txt[image_index + 1] - timings_txt[image_index];