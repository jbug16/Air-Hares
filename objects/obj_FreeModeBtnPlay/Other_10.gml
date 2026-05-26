///@desc Click

// Inherit the parent event
event_inherited();

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

// Screen 0: go to initials entry on this frame
if (global.arcade_popup_screen == 0) {
	global.arcade_popup_screen = 1;
	global.arcade_new_initials = "";
	ArcadePopupUnfocusButtons();
	text = "CONTINUE";
	audio_play_sound(snd_PlaneRabboRoll, 10, false);
	exit;
}

if (string_length(global.arcade_new_initials) <= 0) exit;

audio_play_sound(snd_PlaneRabboRoll, 10, false);
var _name = string_copy(global.arcade_new_initials, 1, min(3, string_length(global.arcade_new_initials)));
_name = string_upper(_name);
global.player_initials = _name;
SaveIniOpen();
SaveIniWriteString("leaderboard", "initials", _name);
SaveIniClose();

global.arcade_popup_screen = 0;
global.arcade_new_initials = "";

global.current_level = tgt_level;
room_goto(global.story_mode_level[global.current_level][STORYPROP.ROOM]);