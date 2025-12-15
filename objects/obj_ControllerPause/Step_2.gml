// Change selected menu
var _select_up = InputGet(INPUT.MENU_UP);
var _select_down = InputGet(INPUT.MENU_DOWN);

if (_select_up or _select_down) 
{
	var _new_menu_selected = clamp(menu_selected + _select_down - _select_up, 0, menu_selected_max);
	if (_new_menu_selected != menu_selected)
	{
		with(obj_PauseButtonPAR) event_user(1);
		if (_new_menu_selected == 0) with(obj_PauseButtonResume) event_user(0);
		else if (_new_menu_selected == 1) with(obj_PauseButtonMMenu) event_user(0);
		else if (_new_menu_selected == 2) with(obj_PauseButtonExit) event_user(0);
	}
	menu_selected = _new_menu_selected;
}

// Can select menu from mouse, or pressing space, or x on gamepad
if (InputGet(INPUT.PAUSE) or InputGet(INPUT.WATER,, noone)) with(obj_PauseButtonResume) event_perform(ev_mouse, ev_left_press);
else if (InputGet(INPUT.MENU_SELECT))// or InputGet(INPUT.X_KEY)) 
{
	// Check selected menu
	if (menu_selected == 0) with(obj_PauseButtonResume) event_user(2);
	else if (menu_selected == 1) with(obj_PauseButtonMMenu) event_user(2);
	else if (menu_selected == 2) with(obj_PauseButtonExit) event_user(2);
}