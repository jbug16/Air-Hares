#macro VK_LETTERS "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
#macro VK_MAX_INITIALS 3
#macro VK_COLS 26
#macro VK_ROWS 1

// Panel layout tuning — distances in image_yscale units (× frame.image_yscale).
// One anchor: panel center + VK_LAYOUT_START_Y → title; each section steps down by its spacing.
#macro VK_LAYOUT_START_Y -20
#macro VK_SP_TITLE_TO_INPUT 16
#macro VK_SP_INPUT_TO_KEYBOARD 14
#macro VK_SP_KEYBOARD_ROW 10
#macro VK_SP_KEYBOARD_TO_ACTION 22
#macro VK_GRID_WIDTH 500

// Navigation feel — frames at 60fps
#macro VK_NAV_INITIAL_DELAY 28
#macro VK_NAV_REPEAT_DELAY 7
#macro VK_ACTION_INITIAL_DELAY 50
#macro VK_ACTION_REPEAT_DELAY 10

#macro VK_LETTER_COUNT 26

enum VK_FOCUS {
	LETTER,
	BACKSPACE,
	OK,
	CANCEL,
}

enum VK_NAV_DIR {
	NONE = -1,
	LEFT,
	RIGHT,
	UP,
	DOWN,
}

/// @desc True while the on-screen keyboard is open and owns input.
function VirtualKeyboardIsActive() {
	return global.virtual_keyboard_active && instance_exists(obj_VirtualKeyboard);
}

function VirtualKeyboardRowWidth(_row) {
	return VK_COLS;
}

function VirtualKeyboardIndexToRowCol(_index) {
	if (_index < VK_COLS) return [0, _index];
	return [1, _index - VK_COLS];
}

function VirtualKeyboardRowColToIndex(_row, _col) {
	return _row * VK_COLS + _col;
}

function VirtualKeyboardSelectedLetter(_index) {
	return string_char_at(VK_LETTERS, _index + 1);
}

function VirtualKeyboardGetBuffer() {
	if (global.virtual_keyboard_context == "arcade") return global.arcade_new_initials;
	return global.story_new_initials;
}

function VirtualKeyboardSetBuffer(_text) {
	if (global.virtual_keyboard_context == "arcade") global.arcade_new_initials = _text;
	else global.story_new_initials = _text;
}

function VirtualKeyboardSetPopupButtonsVisible(_visible) {
	if (global.virtual_keyboard_context == "arcade") {
		with (obj_FreeModeBtnPlay) visible = _visible;
		with (obj_FreeModeBtnBack) visible = _visible;
	} else {
		with (obj_StoryBtnContinue) visible = _visible;
		with (obj_StoryBtnBack) visible = _visible;
	}
}

function VirtualKeyboardGetFrameInst() {
	if (global.virtual_keyboard_context == "arcade") {
		if (instance_exists(obj_FreeModeFrame)) return obj_FreeModeFrame;
	} else if (instance_exists(obj_StoryModeFrame)) {
		return obj_StoryModeFrame;
	}
	return noone;
}

function VirtualKeyboardSetFrameVisible(_visible) {
	if (global.virtual_keyboard_context == "arcade") {
		with (obj_FreeModeFrame) visible = _visible;
	} else {
		with (obj_StoryModeFrame) visible = _visible;
	}
}

/// @desc Open letter keyboard for arcade or story initials (_context: "arcade" | "story").
function VirtualKeyboardOpen(_context) {
	if (_context != "arcade" && _context != "story") return;
	if (VirtualKeyboardIsActive()) return;

	global.virtual_keyboard_context = _context;
	global.virtual_keyboard_saved = VirtualKeyboardGetBuffer();
	global.virtual_keyboard_active = true;

	VirtualKeyboardSetPopupButtonsVisible(false);
	VirtualKeyboardSetFrameVisible(false);

	var _frame = VirtualKeyboardGetFrameInst();
	var _x = room_width * 0.5;
	var _y = room_height * 0.5;
	var _depth = -1;
	if (_frame != noone) {
		_x = _frame.x;
		_y = _frame.y;
		_depth = _frame.depth;
	}
	instance_create_depth(_x, _y, _depth, obj_VirtualKeyboard);
}

/// @desc Close keyboard; restore buffer on cancel.
function VirtualKeyboardClose(_accepted) {
	if (!VirtualKeyboardIsActive()) {
		global.virtual_keyboard_active = false;
		global.virtual_keyboard_context = "";
		return;
	}

	if (!_accepted) VirtualKeyboardSetBuffer(global.virtual_keyboard_saved);

	with (obj_VirtualKeyboard) instance_destroy();
	VirtualKeyboardSetPopupButtonsVisible(true);
	VirtualKeyboardSetFrameVisible(true);

	global.virtual_keyboard_active = false;
	global.virtual_keyboard_context = "";
}

/// @desc Close without applying (leaving initials screen).
function VirtualKeyboardForceClose() {
	if (!instance_exists(obj_VirtualKeyboard)) {
		global.virtual_keyboard_active = false;
		global.virtual_keyboard_context = "";
		return;
	}
	with (obj_VirtualKeyboard) instance_destroy();
	VirtualKeyboardSetPopupButtonsVisible(true);
	VirtualKeyboardSetFrameVisible(true);
	global.virtual_keyboard_active = false;
	global.virtual_keyboard_context = "";
}

function VirtualKeyboardReset() {
	// no-op
}

/// @desc Full keyboard screen — same panel size/position as the hidden Story/Arcade frame.
function VirtualKeyboardLayout(_inst) {
	var _frame = VirtualKeyboardGetFrameInst();
	var _sc_x = (_frame != noone) ? _frame.image_xscale : 1.8;
	var _sc_y = (_frame != noone) ? _frame.image_yscale : 1.8;
	var _cx = (_frame != noone) ? _frame.x : room_width * 0.5;
	var _cy = (_frame != noone) ? _frame.y : room_height * 0.5;
	var _tsx = _sc_x / 2;
	var _tsy = _sc_y / 2;
	var _ksx = _tsx * 0.85;
	var _ksy = _tsy * 0.85;

	// Stack sections downward from one start Y
	var _y = _cy + VK_LAYOUT_START_Y * _sc_y;
	var _title_y = _y;
	_y += VK_SP_TITLE_TO_INPUT * _sc_y;
	var _initials_y = _y;
	_y += VK_SP_INPUT_TO_KEYBOARD * _sc_y;
	var _grid_top = _y;
	var _key_h = VK_SP_KEYBOARD_ROW * _sc_y;
	_y += VK_SP_KEYBOARD_ROW * _sc_y * (VK_ROWS - 1);
	_y += VK_SP_KEYBOARD_TO_ACTION * _sc_y;
	var _footer_y = _y;
	var _grid_width = VK_GRID_WIDTH * _sc_x / 1.8;

	with (_inst) {
		panel_sc_x = _sc_x;
		panel_sc_y = _sc_y;
		panel_cx = _cx;
		panel_cy = _cy;
		text_scale_x = _tsx;
		text_scale_y = _tsy;
		key_scale_x = _ksx;
		key_scale_y = _ksy;
		layout_start_y = _cy + VK_LAYOUT_START_Y * _sc_y;
		title_y = _title_y;
		initials_y = _initials_y;
		grid_top = _grid_top;
		key_h = _key_h;
		footer_y = _footer_y;
		grid_width = _grid_width;
		grid_left = _cx - _grid_width * 0.5;
		key_w = _grid_width / VK_COLS;
		footer_x1 = _cx - _grid_width * 0.5;
		footer_btn_w = _grid_width / 3;
	}
}

/// @desc Letter cell center — row 0 at grid_top, each row steps down by key_h.
function VirtualKeyboardLetterCenter(_inst, _index) {
	var _rc = VirtualKeyboardIndexToRowCol(_index);
	var _row = _rc[0];
	var _col = _rc[1];
	var _rw = VirtualKeyboardRowWidth(_row);
	var _col_offset = floor((VK_COLS - _rw) * 0.5);
	var _gc = _col_offset + _col;
	var _cx = _inst.grid_left + (_gc + 0.5) * _inst.key_w;
	var _cy = _inst.grid_top + (_row + 0.5) * _inst.key_h;
	return [_cx, _cy];
}

function VirtualKeyboardFooterRect(_inst, _focus) {
	var _i = 0;
	if (_focus == VK_FOCUS.CANCEL) _i = 0;
	else if (_focus == VK_FOCUS.BACKSPACE) _i = 1;
	else _i = 2;
	var _x1 = _inst.footer_x1 + _i * _inst.footer_btn_w;
	var _fh = 8 * _inst.panel_sc_y / 1.8;
	return [_x1, _inst.footer_y - _fh, _x1 + _inst.footer_btn_w, _inst.footer_y + _fh];
}

function VirtualKeyboardDrawLabel(_cx, _cy, _label, _selected, _sx, _sy, _enabled = true) {
	draw_set_halign(fa_center);
	draw_set_valign(fa_middle);
	if (_selected) draw_set_color(c_orange);
	else if (_enabled) draw_set_color(c_white);
	else draw_set_color(c_gray);
	draw_text_transformed(_cx, _cy, _label, _sx, _sy, 0);
}

function VirtualKeyboardInitialsDisplay(_buf) {
	var _n = string_length(_buf);
	var _text = "";
	for (var _slot = 0; _slot < VK_MAX_INITIALS; _slot++) {
		if (_slot < _n) _text += string_copy(_buf, _slot + 1, 1);
		else _text += "_";
	}
	return _text;
}

/// @desc Footer action label (same on all platforms).
function VirtualKeyboardFooterLabel(_focus) {
	switch (_focus) {
		case VK_FOCUS.CANCEL: return "CANCEL";
		case VK_FOCUS.BACKSPACE: return "DEL";
		case VK_FOCUS.OK: return "OK";
	}
	return "";
}

/// @desc Draw the full keyboard screen (replaces hidden Story/Arcade initials popup).
function VirtualKeyboardDrawPanel(_inst) {
	var _buf = VirtualKeyboardGetBuffer();
	var _len = string_length(_buf);
	var _sx = _inst.text_scale_x;
	var _sy = _inst.text_scale_y;
	var _ksx = _inst.key_scale_x;
	var _ksy = _inst.key_scale_y;

	draw_sprite_ext(spr_TitleSelectionFrame, 0, _inst.panel_cx, _inst.panel_cy,
		_inst.panel_sc_x, _inst.panel_sc_y, 0, c_white, 1);

	draw_set_halign(fa_center);
	draw_set_valign(fa_middle);
	draw_set_font(fnt_Federo16);
	draw_set_color(c_white);
	draw_text_transformed(_inst.panel_cx, _inst.title_y, "Enter Initials", _sx, _sy, 0);

	draw_set_font(fnt_Federo24);
	draw_set_color(c_orange);
	draw_text_transformed(_inst.panel_cx, _inst.initials_y,
		VirtualKeyboardInitialsDisplay(_buf), _sx, _sy, 0);

	draw_set_font(fnt_Federo16);
	for (var _i = 0; _i < string_length(VK_LETTERS); _i++) {
		var _c = VirtualKeyboardLetterCenter(_inst, _i);
		var _sel = (_inst.focus == VK_FOCUS.LETTER && _inst.letter_index == _i);
		VirtualKeyboardDrawLabel(_c[0], _c[1], VirtualKeyboardSelectedLetter(_i), _sel, _ksx, _ksy);
	}

	var _cancel_r = VirtualKeyboardFooterRect(_inst, VK_FOCUS.CANCEL);
	VirtualKeyboardDrawLabel((_cancel_r[0] + _cancel_r[2]) * 0.5, (_cancel_r[1] + _cancel_r[3]) * 0.5,
		VirtualKeyboardFooterLabel(VK_FOCUS.CANCEL), _inst.focus == VK_FOCUS.CANCEL, _ksx, _ksy);

	var _del_r = VirtualKeyboardFooterRect(_inst, VK_FOCUS.BACKSPACE);
	VirtualKeyboardDrawLabel((_del_r[0] + _del_r[2]) * 0.5, (_del_r[1] + _del_r[3]) * 0.5,
		VirtualKeyboardFooterLabel(VK_FOCUS.BACKSPACE), _inst.focus == VK_FOCUS.BACKSPACE, _ksx, _ksy, _len > 0);

	var _ok_r = VirtualKeyboardFooterRect(_inst, VK_FOCUS.OK);
	VirtualKeyboardDrawLabel((_ok_r[0] + _ok_r[2]) * 0.5, (_ok_r[1] + _ok_r[3]) * 0.5,
		VirtualKeyboardFooterLabel(VK_FOCUS.OK), _inst.focus == VK_FOCUS.OK, _ksx, _ksy, _len > 0);

	DrawReset(fnt_Federo16);
}

/// @desc Poll held direction; fires once immediately, then repeats while held.
function VirtualKeyboardPollNav(_inst) {
	var _left = InputGet(INPUT.MENU_LEFT, false);
	var _right = InputGet(INPUT.MENU_RIGHT, false);
	var _up = InputGet(INPUT.MENU_UP, false);
	var _down = InputGet(INPUT.MENU_DOWN, false);
	var _dir = VK_NAV_DIR.NONE;

	if (_left && !_right && !_up && !_down) _dir = VK_NAV_DIR.LEFT;
	else if (_right && !_left && !_up && !_down) _dir = VK_NAV_DIR.RIGHT;
	else if (_up && !_left && !_right && !_down) _dir = VK_NAV_DIR.UP;
	else if (_down && !_left && !_right && !_up) _dir = VK_NAV_DIR.DOWN;

	if (_dir == VK_NAV_DIR.NONE) {
		_inst.nav_dir = VK_NAV_DIR.NONE;
		_inst.nav_timer = 0;
		return false;
	}

	if (_dir != _inst.nav_dir) {
		_inst.nav_dir = _dir;
		_inst.nav_timer = VK_NAV_INITIAL_DELAY;
		return true;
	}

	_inst.nav_timer--;
	if (_inst.nav_timer <= 0) {
		_inst.nav_timer = VK_NAV_REPEAT_DELAY;
		return true;
	}
	return false;
}

function VirtualKeyboardFooterFromColumn(_col) {
	if (_col < 9) return VK_FOCUS.CANCEL;
	if (_col < 17) return VK_FOCUS.BACKSPACE;
	return VK_FOCUS.OK;
}

function VirtualKeyboardFooterStep(_inst, _delta) {
	var _order = [VK_FOCUS.CANCEL, VK_FOCUS.BACKSPACE, VK_FOCUS.OK];
	var _idx = 0;
	for (var _i = 0; _i < 3; _i++) {
		if (_order[_i] == _inst.focus) {
			_idx = _i;
			break;
		}
	}
	_idx = (_idx + _delta + 3) mod 3;
	_inst.focus = _order[_idx];
}

function VirtualKeyboardWrapLetterIndex(_index, _delta) {
	return (_index + _delta + VK_LETTER_COUNT) mod VK_LETTER_COUNT;
}

function VirtualKeyboardApplyNav(_inst, _dir) {
	switch (_inst.focus) {
		case VK_FOCUS.LETTER:
			VirtualKeyboardNavigateLetter(_inst, _dir);
			break;
		default:
			VirtualKeyboardNavigateFooter(_inst, _dir);
			break;
	}
}

function VirtualKeyboardNavigateLetter(_inst, _dir) {
	var _col = _inst.letter_index;

	switch (_dir) {
		case VK_NAV_DIR.LEFT:
			_inst.letter_index = VirtualKeyboardWrapLetterIndex(_col, -1);
			break;
		case VK_NAV_DIR.RIGHT:
			_inst.letter_index = VirtualKeyboardWrapLetterIndex(_col, 1);
			break;
		case VK_NAV_DIR.UP:
			break;
		case VK_NAV_DIR.DOWN:
			_inst.last_letter_index = _col;
			_inst.focus = VirtualKeyboardFooterFromColumn(_col);
			break;
	}
}

function VirtualKeyboardNavigateFooter(_inst, _dir) {
	switch (_dir) {
		case VK_NAV_DIR.LEFT:
			VirtualKeyboardFooterStep(_inst, -1);
			break;
		case VK_NAV_DIR.RIGHT:
			VirtualKeyboardFooterStep(_inst, 1);
			break;
		case VK_NAV_DIR.UP:
			_inst.focus = VK_FOCUS.LETTER;
			_inst.letter_index = _inst.last_letter_index;
			break;
		case VK_NAV_DIR.DOWN:
			break;
	}
}

function VirtualKeyboardTryDelete(_inst) {
	var _buf = VirtualKeyboardGetBuffer();
	if (string_length(_buf) <= 0) return false;
	VirtualKeyboardSetBuffer(string_copy(_buf, 1, string_length(_buf) - 1));
	return true;
}

function VirtualKeyboardPollDeleteHold(_inst) {
	if (_inst.focus != VK_FOCUS.BACKSPACE) {
		_inst.action_timer = 0;
		_inst.action_armed = true;
		return false;
	}

	var _held = InputGet(INPUT.MENU_SELECT, false);
	if (!_held) {
		_inst.action_timer = 0;
		_inst.action_armed = true;
		return false;
	}

	if (string_length(VirtualKeyboardGetBuffer()) <= 0) {
		_inst.action_timer = 0;
		return false;
	}

	// One delete per tap — only on the initial press edge
	if (InputGet(INPUT.MENU_SELECT, true) && _inst.action_armed) {
		VirtualKeyboardTryDelete(_inst);
		_inst.action_armed = false;
		_inst.action_timer = VK_ACTION_INITIAL_DELAY;
		return true;
	}

	// Hold to repeat — only after the long initial delay, while still holding
	if (_inst.action_armed) return false;

	if (_inst.action_timer > 0) {
		_inst.action_timer--;
		return false;
	}

	VirtualKeyboardTryDelete(_inst);
	_inst.action_timer = VK_ACTION_REPEAT_DELAY;
	return true;
}

/// @desc Step navigation + actions for obj_VirtualKeyboard.
function VirtualKeyboardStepController(_inst) {
	if (InputMenuCancelPressed()) {
		VirtualKeyboardClose(false);
		return;
	}

	if (VirtualKeyboardPollNav(_inst)) {
		VirtualKeyboardApplyNav(_inst, _inst.nav_dir);
	}

	// Hold Select on DEL to keep deleting
	if (VirtualKeyboardPollDeleteHold(_inst)) return;

	if (!InputGet(INPUT.MENU_SELECT, true)) return;

	switch (_inst.focus) {
		case VK_FOCUS.LETTER:
			var _buf = VirtualKeyboardGetBuffer();
			if (string_length(_buf) < VK_MAX_INITIALS) {
				VirtualKeyboardSetBuffer(_buf + VirtualKeyboardSelectedLetter(_inst.letter_index));
			}
			break;
		case VK_FOCUS.BACKSPACE:
			// First press handled by VirtualKeyboardPollDeleteHold while held
			break;
		case VK_FOCUS.OK:
			if (string_length(VirtualKeyboardGetBuffer()) > 0) VirtualKeyboardClose(true);
			break;
		case VK_FOCUS.CANCEL:
			VirtualKeyboardClose(false);
			break;
	}
}
