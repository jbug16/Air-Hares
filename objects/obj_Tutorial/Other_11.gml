/// @desc After slides end

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