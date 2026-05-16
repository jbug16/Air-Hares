/// @desc Interaction and easeInOut
if (parent_index == obj_TitlebBtnGeneralPAR and mode_on) exit;


// MOUSE hover-in
if (!global.mouse_disable and !focus and (mouse_prev_x != mouse_x or mouse_prev_y != mouse_y)) 
{
	var _scale = scale_big/image_xscale;	// check relative to original btn size
	if (mouse_x > x - 0.5*sprite_width*_scale and mouse_x < x + 0.5*sprite_width*_scale)
	if (mouse_y > y - 0.5*sprite_height*_scale and mouse_y < y + 0.5*sprite_height*_scale)
	{
		if (parent_index == obj_ModesBtnPAR) ModesBtnPopupUnhoverAll();
		else with (parent_index) {
			if (focus) event_user(2);
		}
		event_user(1);					// hover into the current one
	}
}


// KEYBOARD
if (alarm[2] < 0 and focus) {
	// Initials sub-screen: only obj_ModesBtnPAR children (Continue/New/Back, Play/Back). obj_FreeModeFrame Step owns
	// MENU_LEFT/RIGHT for the center field. End-level buttons (obj_EndLevelPAR) and main title rows must keep full nav.
	if ((global.story_popup_screen == 1 || global.arcade_popup_screen == 1) && parent_index == obj_ModesBtnPAR) {
		// Subclass buttons (e.g. hidden NEW) must not activate on Enter — only visible rows.
		if (InputGet(INPUT.MENU_SELECT) && visible) event_user(0);
	} else {
		var _movement = InputGet(INPUT.MENU_RIGHT) - InputGet(INPUT.MENU_LEFT);
		
		if (InputGet(INPUT.MENU_SELECT)) event_user(0);
		else if (_movement != 0) {
			var _sel = button_id + _movement;
			if (parent_index == obj_ModesBtnPAR) {
				var _n = ModesBtnPopupButtonCount();
				if (_sel < 1) _sel = _n;
				else if (_sel > _n) _sel = 1;
			} else {
				if (_sel < 1) _sel = instance_number(parent_index);
				else if (_sel > instance_number(parent_index)) _sel = 1;
			}
			if (button_id != _sel) {
				event_user(2);
				if (parent_index == obj_ModesBtnPAR) ModesBtnPopupFocusByButtonId(_sel, id);
				else with (parent_index) {
					if (id == other.id) continue;
					if (button_id == _sel) {
						event_user(1);
						break;
					}
				}
			}
			if (parent_index == obj_ModesBtnPAR) ModesBtnPopupSetAlarm2(1);
			else parent_index.alarm[2] = 1;
		}
	}
}


image_yscale = image_xscale;	// tweeining is done only on xscale, so this ensures the same scaling

// Remember previous mouse x/y (for mouse hover)
mouse_prev_x = mouse_x;
mouse_prev_y = mouse_y;