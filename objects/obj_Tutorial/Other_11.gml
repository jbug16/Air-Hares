/// @desc After slides end

if (global.tutorial_from_options) {
	global.tutorial_from_options = false;
	global.options_peaceful_practice = true;
	global.peaceful_practice_saved_level = global.current_level;
	global.peaceful_practice_saved_progress = global.story_mode_progress;
	global.current_level = 0;
	global.game_mode = GAMEMODE.STORY;
	global.story_peaceful_intro_farm = true;
	// P1 may still be on keyboard default after Options; bind active pad before farm practice.
	if (global.control_device[0] == -1 && global.gamepad_connected != noone && gamepad_is_connected(global.gamepad_connected)) {
		global.control_device[0] = global.gamepad_connected;
	}
	global.control_device[1] = noone;
	instance_destroy();
	room_goto(rm_LevelX1Farm);
	exit;
}

instance_activate_object(obj_OptionsController);
instance_activate_object(obj_OptionsTitle);

// Fade in options UI (matches exit-to-black duration so the handoff reads as one transition)
var _in_d = ceil(tutorial_exit_fade_dur);
with (obj_OptionsController)
{
	image_alpha = 0;
	TweenStart("image_alpha", 0, 1, _in_d, TWEENTYPE.LINEAR);
}
with (obj_OptionsTitle)
{
	image_alpha = 0;
	TweenStart("image_alpha", 0, 1, _in_d, TWEENTYPE.LINEAR);
}

instance_destroy();

if(!instance_exists(obj_OptionsController)) room_goto(global.story_mode_level[global.current_level][STORYPROP.ROOM]);