/// @desc Game End cleanup (guarded for restart safety)
if (SavePlatformIsSwitch()
	&& variable_global_exists("save_switch_open") && global.save_switch_open
	&& variable_global_exists("save_ini_dirty") && global.save_ini_dirty) {
	SaveSwitchFlush();
}

if (variable_global_exists("keymap") && ds_exists(global.keymap, ds_type_map)) {
	ds_map_destroy(global.keymap);
}
if (variable_global_exists("gpmap") && ds_exists(global.gpmap, ds_type_map)) {
	ds_map_destroy(global.gpmap);
}