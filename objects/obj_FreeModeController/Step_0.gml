/// @desc KB/GP Input

// Selection
var _left = InputGet(INPUT.MENU_LEFT);
var _right = InputGet(INPUT.MENU_RIGHT);
var _up = InputGet(INPUT.MENU_UP);
var _down = InputGet(INPUT.MENU_DOWN);
var _select = InputGet(INPUT.MENU_SELECT);

var _movement = _left or _right or _up or _down or _select;
if ((_movement) and !instance_exists(obj_FreeModeFrame) and !instance_exists(obj_StoryModeFrame))
{
	selected_prev = selected;
	var _max = level_count - 1;
	switch(_movement){
		case _left:
			if (selected >= 4) selected -= 4;
			else if (selected > 0) selected -= 1;
			else selected = _max;
			break;
		case _right:
			if (selected + 4 <= _max) selected += 4;
			else if (selected < _max) selected += 1;
			else selected = 0;
			break;
		case _up:
			if (selected > 0) selected -= 1;
			else selected = _max;
			break;
		case _down:
			if (selected < _max) selected += 1;
			else selected = 0;
			break;
		case _select:
			with(obj_FreeModeSelect){
				if(tgt_level == other.selected) event_user(0);
			}
			break;
	}
	selected = clamp(selected, 0, _max);

	if(instance_exists(obj_FreeModeSelect))
		with(obj_FreeModeSelect){
			if(tgt_level == other.selected) event_user(1);
			else if(tgt_level == other.selected_prev) event_user(2);
		}
}

// Back
if(instance_exists(obj_FreeModeFrame))
{
	// Back to unselected levels
	var _to_levels = false;
	var _to_mmenu = false;
	
	if(keyboard_check_pressed(vk_escape)) _to_levels = true;
	for(var i = 0; i < gamepad_get_device_count(); i++)
	{
		if(gamepad_is_connected(i))
		{
			if(gamepad_button_check_pressed(i, gp_face2)) _to_levels = true;
			if(gamepad_button_check_pressed(i, gp_start)) _to_mmenu = true;
		}
	}
	
	if(_to_levels) with(obj_FreeModeBtnBack){ event_user(0); }
	// Back to main menu
	else if(_to_mmenu) event_user(0);
}
// Back to main menu
else if (InputGet(INPUT.PAUSE)) event_user(0);
