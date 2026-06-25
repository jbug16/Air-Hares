/// @desc Story "New Story Game" screen: initials; open keyboard to edit; Continue/Back when keyboard is closed

if (global.story_popup_screen != 1) exit;

if (VirtualKeyboardIsActive()) exit;

if (InputMenuCancelPressed()) {
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
		VirtualKeyboardOpen("story");
		exit;
	}
}

if (StoryNewGameAnyButtonFocused()) exit;

if (InputGet(INPUT.MENU_SELECT)) {
	VirtualKeyboardOpen("story");
}
