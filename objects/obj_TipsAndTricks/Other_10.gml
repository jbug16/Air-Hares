/// @desc After-child init (override parent to center image vertically)
event_inherited();

// Parent uses y0 = 0.5*sprite_height which places image high; center it instead
y0 = room_height / 2;
y = y0;

// Restart y tween with centered position
TweenStop(id, "y");
TweenStart("y", y0 + y_start[image_index], y0 + y_stop[image_index], timings_ends[1] + fadeout, tween_pos_img);

// Mission Failed Retry: music already playing, don't restart it
if (variable_struct_exists(global, "tips_skip_music") && global.tips_skip_music) {
	audio_stop_sound(music_bg);
	global.tips_skip_music = false;
}