/// @desc Story "New Story Game" screen: initials in the center; left/right moves Continue — initials — Back

if (global.story_popup_screen != 1) exit;

if (keyboard_check_pressed(vk_escape) || InputGet(INPUT.PAUSE)) {
	StoryPopupExitNewGameScreen();
	exit;
}

var _left = InputGet(INPUT.MENU_LEFT);
var _right = InputGet(INPUT.MENU_RIGHT);
if (_left || _right) {
	var _on_cont = false;
	var _on_back = false;
	with (obj_StoryBtnContinue) {
		if (focus) _on_cont = true;
	}
	with (obj_StoryBtnBack) {
		if (focus) _on_back = true;
	}

	if (!_on_cont && !_on_back) {
		if (_left) {
			StoryNewGameFocusContinue();
			exit;
		}
		if (_right) {
			StoryNewGameFocusBack();
			exit;
		}
	} else if (_on_cont) {
		if (_right) {
			StoryNewGameUnfocusButtons();
			exit;
		}
		if (_left) {
			StoryNewGameFocusBack();
			exit;
		}
	} else if (_on_back) {
		if (_left) {
			StoryNewGameUnfocusButtons();
			exit;
		}
		if (_right) {
			StoryNewGameFocusContinue();
			exit;
		}
	}
}

if (!global.mouse_disable && mouse_check_button_pressed(mb_left)) {
	var _iy = y + 8 * image_yscale;
	var _ix = x;
	var _hw = 100 * image_xscale;
	var _hh = 28 * image_yscale;
	if (point_in_rectangle(mouse_x, mouse_y, _ix - _hw, _iy - _hh, _ix + _hw, _iy + _hh)) {
		StoryNewGameUnfocusButtons();
	}
}

if (StoryNewGameAnyButtonFocused()) exit;

if (keyboard_check_pressed(vk_backspace) && string_length(global.story_new_initials) > 0) {
	global.story_new_initials = string_copy(global.story_new_initials, 1, string_length(global.story_new_initials) - 1);
}

if (string_length(global.story_new_initials) < 3) {
	var _alpha = "ABCDEFGHIJKLMNOPQRSTUVWXYZ";
	var _c = 0;
	for (var _k = ord("A"); _k <= ord("Z"); _k++) {
		if (keyboard_check_pressed(_k)) {
			_c = _k - ord("A") + 1;
			break;
		}
	}
	if (_c == 0) {
		for (var _k2 = ord("a"); _k2 <= ord("z"); _k2++) {
			if (keyboard_check_pressed(_k2)) {
				_c = _k2 - ord("a") + 1;
				break;
			}
		}
	}
	if (_c > 0) global.story_new_initials += string_copy(_alpha, _c, 1);
}
