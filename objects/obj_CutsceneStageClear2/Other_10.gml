///@desc After-child init
image_xscale = img_scale;
image_yscale = img_scale;
ArrayMultiply(zoom_img, img_scale);
y0 = 0.5*sprite_height;						// initial y position
y = y0;
x = room_width/2;

// Background overlay - over image, so zooming/movement doesn't distrupt drawn image size
border_left = x - 0.5*sprite_width;
border_right = x + 0.5*sprite_width;
border_bot = y0*2;

// Transition lengths
if(image_number > 1 or !hold_end) alarm[0] = timings_ends[0];			// wait until fadeout
if is_array(timings_txt) alarm[1] = timings_txt[0];			// wait until showing 1st txt
else alarm[1] = timings_txt;


// Tweening
TweenStart("image_alpha", 0, 1, fadein_img[0], tween_fadein_img);
var _time_next = timings_ends[0] + fadeout;			// time until end of slide
TweenStart("image_xscale", zoom_img[image_index][0], zoom_img[image_index][1], _time_next, tween_zoom_img);
TweenStart("x", x + x_start[image_index], x + x_stop[image_index], _time_next, tween_pos_img);
TweenStart("y", y0 + y_start[image_index], y0 + y_stop[image_index], _time_next, tween_pos_img);

// Sounds
music_bg = audio_play_sound(music_bg, 1, true);