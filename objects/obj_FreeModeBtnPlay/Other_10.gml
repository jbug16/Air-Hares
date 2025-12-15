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


global.current_level = tgt_level;
room_goto(global.story_mode_level[global.current_level][STORYPROP.ROOM]);
audio_play_sound(snd_PlaneRabboRoll, 10, false);