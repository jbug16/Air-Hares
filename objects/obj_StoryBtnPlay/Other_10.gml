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
// Replace main story popup with New Story Game (initials) screen; same frame, hide center NEW button
global.story_popup_screen = 1;
global.story_new_initials = "";
StoryNewGameUnfocusButtons();
visible = false;
with (obj_StoryBtnContinue) visible = true;
