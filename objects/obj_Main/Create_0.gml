// This is Main object that contains global data
profile	= new Profile();

// Controller config
global.control_device[0] = -1;		// keyboard
global.control_device[1] = noone;	// Undecided

event_perform(ev_alarm, 0);	// check the connected gamepads every second

gp_left_axis = array_create(gamepad_get_device_count(), 0);
gp_right_axis = array_create(gamepad_get_device_count(), 0);

randomise();