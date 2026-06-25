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

// Confirm selection (gamepad confirm or keyboard; mouse only when cursor enabled)
if (InputGet(INPUT.MENU_SELECT)) {
	if (menu_selected == 0) with(obj_PauseButtonResume) event_user(2);
	else if (menu_selected == 1) with(obj_PauseButtonMMenu) event_user(2);
	else if (menu_selected == 2) with(obj_PauseButtonExit) event_user(2);
}