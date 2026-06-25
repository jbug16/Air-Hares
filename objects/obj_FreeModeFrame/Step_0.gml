/// @desc Arcade popup screen 1: initials; open keyboard to edit; Play/Back when keyboard is closed

if (global.arcade_popup_screen != 1) exit;

if (VirtualKeyboardIsActive()) exit;

if (InputMenuCancelPressed()) {
	ArcadePopupExitInitialsScreen();
	exit;
}

var _left = InputGet(INPUT.MENU_LEFT);
var _right = InputGet(INPUT.MENU_RIGHT);
if (_left || _right) {
	var _on_play = false;
	var _on_back = false;
	with (obj_FreeModeBtnPlay) {
		if (focus) _on_play = true;
	}
	with (obj_FreeModeBtnBack) {
		if (focus) _on_back = true;
	}

	if (!_on_play && !_on_back) {
		if (_left) {
			ArcadePopupFocusPlayButton();
			exit;
		}
		if (_right) {
			ArcadePopupFocusBackButton();
			exit;
		}
	} else if (_on_play) {
		if (_right) {
			ArcadePopupUnfocusButtons();
			exit;
		}
		if (_left) {
			ArcadePopupFocusBackButton();
			exit;
		}
	} else if (_on_back) {
		if (_left) {
			ArcadePopupUnfocusButtons();
			exit;
		}
		if (_right) {
			ArcadePopupFocusPlayButton();
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
		ArcadePopupUnfocusButtons();
		VirtualKeyboardOpen("arcade");
		exit;
	}
}

if (ArcadePopupAnyButtonFocused()) exit;

if (InputGet(INPUT.MENU_SELECT)) {
	VirtualKeyboardOpen("arcade");
}
