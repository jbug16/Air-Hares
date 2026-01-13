// This is Main object that contains global data
profile	= new Profile();

// Controller config
global.control_device[0] = -1;		// keyboard
global.control_device[1] = noone;	// Undecided

event_perform(ev_alarm, 0);	// check the connected gamepads every second

// Initial gamepad status after first detection
if (global.gamepad_debug) {
	show_debug_message("===== INITIAL GAMEPAD SETUP =====");
	show_debug_message("Game initialized - checking for gamepads...");
	if (global.gamepad_connected != noone) {
		show_debug_message("SUCCESS: Gamepad detected on startup at index " + string(global.gamepad_connected));
		show_debug_message("Gamepad name: " + gamepad_get_description(global.gamepad_connected));
		if (gamepad_is_connected(global.gamepad_connected)) {
			show_debug_message("Validation: Gamepad connection confirmed");
		} else {
			show_debug_message("ERROR: Gamepad index " + string(global.gamepad_connected) + " set but not actually connected!");
		}
	} else {
		show_debug_message("INFO: No gamepad connected on startup (will check periodically)");
	}
	show_debug_message("===================================");
}

gp_left_axis = array_create(gamepad_get_device_count(), 0);
gp_right_axis = array_create(gamepad_get_device_count(), 0);

randomise();