/// @desc Arcade popup screen 1: initials in the center; left/right moves Play — initials — Back

if (global.arcade_popup_screen != 1) exit;

if (keyboard_check_pressed(vk_escape) || InputGet(INPUT.PAUSE)) {
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
		// Center: initials field
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
	}
}

if (ArcadePopupAnyButtonFocused()) exit;

if (keyboard_check_pressed(vk_backspace) && string_length(global.arcade_new_initials) > 0) {
	global.arcade_new_initials = string_copy(global.arcade_new_initials, 1, string_length(global.arcade_new_initials) - 1);
}

if (string_length(global.arcade_new_initials) < 3) {
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
	if (_c > 0) global.arcade_new_initials += string_copy(_alpha, _c, 1);
}
