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


audio_play_sound(snd_PlaneRabboRoll, 10, false);
// Assign current progress to current run. Progress 14 will repeat level 13
global.current_level = min(global.story_mode_progress, 15);	
room_goto(global.story_mode_level[global.current_level][STORYPROP.ROOM]);