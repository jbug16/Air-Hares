/// @desc Display
var _is_array = is_array(dialog);
if (!_is_array) {
	exit;	
}

// Check skip
var _gp_valid = (global.gamepad_connected != noone && gamepad_is_connected(global.gamepad_connected));
var _skip_press = keyboard_check(ord("F")) || (_gp_valid && gamepad_button_check(global.gamepad_connected, gp_face1));
if (global.gamepad_debug && _gp_valid && gamepad_button_check(global.gamepad_connected, gp_face1)) {
	show_debug_message("[Dialogue] Skip pressed via gamepad button (gp_face1) on index " + string(global.gamepad_connected));
}

if _skip_press {
	skip += 1;	
} else if skip > 0 {
	skip -= 1;	
}

// On trigger
if skip > skip_max {
	instance_destroy();
	exit;	
}

// Check max length
dialog_counter_max = string_length(dialog[dialog_current]);
// Add the counter
dialog_counter += dialog_speed;

// Change the display
dialog_display = string_copy(dialog[dialog_current], 0, floor(dialog_counter));

var _keypress = keyboard_check_released(vk_anykey);
var _gppress = false;
if (global.gamepad_connected != noone) {
	_gppress = InputGamepadCheckAny(global.gamepad_connected);
	if (global.gamepad_debug && _gppress) {
		show_debug_message("[Dialogue] Any gamepad button pressed - advancing dialog");
	}
} else {
	if (global.gamepad_debug) {
		show_debug_message("[Dialogue] No gamepad connected, skipping gamepad check");
	}
}

// Advance to next dialog_current
if (dialog_counter > dialog_counter_max) {
	dialog_current_ended = true;
} else if (((_keypress || _gppress) && dialog_counter > 4) && !dialog_auto) {
	dialog_counter = dialog_counter_max;	
}

// Check if reaching end of dialog array
if (dialog_current_ended && dialog_current + 1 >= array_length(dialog)) {
	dialog_ended = true;
	if (_keypress || _gppress && dialog_ended) && !dialog_auto {
		instance_destroy();
	} else if (dialog_auto && dialog_counter > (dialog_counter_max + dialog_auto_wait)) {
		instance_destroy();
	}
} else if (dialog_current_ended && dialog_current + 1 < array_length(dialog)) {
	// Advance on keypress
	if (_keypress || _gppress) && !dialog_auto {
		dialog_counter = 0;
		dialog_current_ended = false;
		dialog_current += 1;
		sound_end_is_played = false;
	} else if (dialog_auto && dialog_counter > (dialog_counter_max + dialog_auto_wait)) {
		dialog_counter = 0;
		dialog_current_ended = false;
		dialog_current += 1;
		sound_end_is_played = false;
	}
}

// Play sound
if (dialog_counter < dialog_counter_max) {
	if (!audio_is_playing(sound_typing)) {
		audio_play_sound(sound_typing, 1, false);	
	}
} else {
	if (audio_is_playing(sound_typing)) {
		audio_stop_sound(sound_typing);
	}
	if (!sound_end_is_played) {
		sound_end_is_played = true;
		audio_play_sound(sound_typing_end, 1, false);
	}
}