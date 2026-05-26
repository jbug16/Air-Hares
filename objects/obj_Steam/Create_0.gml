/// @desc Steam init (desktop/Steam targets only)

if (os_type == os_switch) {
	instance_destroy();
	exit;
}

if (steam_initialised()) {
	show_debug_message("Steam Initialized!")
} else {
	show_debug_message("Steam not initialized.")
}
