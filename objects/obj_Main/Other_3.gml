/// @desc Game End cleanup (guarded for restart safety)
if (variable_global_exists("keymap") && ds_exists(global.keymap, ds_type_map)) {
	ds_map_destroy(global.keymap);
}
if (variable_global_exists("gpmap") && ds_exists(global.gpmap, ds_type_map)) {
	ds_map_destroy(global.gpmap);
}