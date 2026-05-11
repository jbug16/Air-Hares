/// @desc Fade

if (global.main_menu_open_options_tutorial_fade) {
	global.main_menu_open_options_tutorial_fade = false;
	MainMenuOpenOptionsWithTutorialFade();
} else if (global.main_menu_open_options) {
	global.main_menu_open_options = false;
	with (all) {
		if (!persistent) instance_deactivate_object(id);
	}
	layer_set_visible("Background_Options", true);
	instance_create_layer(0.3 * room_width, 0.5 * room_height, "Instances", obj_OptionsController);
	instance_create_layer(0.5 * room_width, 0.1 * room_height, "Instances", obj_OptionsTitle);
}

// fade-in effect
if (fade_alpha > 0) fade_alpha -= 0.03;