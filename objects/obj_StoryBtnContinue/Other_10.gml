///@desc Click

// set to gamepad control if clicked with gamepad
var _maxpads = gamepad_get_device_count();
for (var _gp = 0; _gp < _maxpads; _gp++) 
{
	if (gamepad_is_connected(_gp)) 
	{
		if InputGet(INPUT.MENU_SELECT, , _gp)
		 {
			global.control_device[0] = _gp;
			break;
		}
    }
}

// New Story Game screen: CONTINUE saves initials and starts a new run + tutorial
if (global.story_popup_screen == 1) {
	if (string_length(global.story_new_initials) <= 0) exit;
	
	audio_play_sound(snd_PlaneRabboRoll, 10, false);
	
	var _name = string_copy(global.story_new_initials, 0, min(3, string_length(global.story_new_initials)));
	global.player_initials = _name;
	global.story_run_initials = _name;
	
	ini_open("save.sav");
	ini_write_string("leaderboard", "initials", _name);
	ini_close();
	
	global.lives = 4;
	global.story_mode_progress = 0;
	global.current_level = 0;
	StoryRunStartNew();
	
	global.story_popup_screen = 0;
	global.story_new_initials = "";
	
	instance_destroy(obj_StoryModeFrame);
	with (obj_StoryBtnContinue) instance_destroy();
	with (obj_StoryBtnPlay) instance_destroy();
	with (obj_StoryBtnBack) instance_destroy();
	
	with(obj_TitlebBtnGeneralPAR){
	var _name = string_copy(global.story_new_initials, 1, min(3, string_length(global.story_new_initials)));
		mode_on = false;
		
		if (button_id == 1) event_user(1);
		else focus = false;
	}
	
	instance_create_depth(0.5 * room_width, 0.5 * room_height, -150, obj_Tutorial);
	exit;
}

audio_play_sound(snd_PlaneRabboRoll, 10, false);
// Assign current progress to current run. Progress 14 will repeat level 13
global.current_level = min(global.story_mode_progress, 15);	
room_goto(global.story_mode_level[global.current_level][STORYPROP.ROOM]);
