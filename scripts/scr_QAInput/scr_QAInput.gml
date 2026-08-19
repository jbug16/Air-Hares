/// @desc QA gamepad face-button overlay for Switch Lotcheck / control mapping.
/// Toggle: F5 or F2 (Windows) / hold L+R and press D-pad Down (Switch or gamepad on PC).
/// On Windows you can also press 1-4 / Q E A D / Enter / Backspace to simulate buttons.

#macro QA_INPUT_LOG_MAX 6
#macro QA_INPUT_HOLD_FRAMES 45

/// @desc One-time init (called from obj_CRTController Create).
function QAInputInit() {
	global.qa_input_overlay = false;
	global.qa_input_toggle_cd = 0;
	global.qa_input_log = [];
	global.qa_input_hold = {};
	global.qa_input_pad = noone;
	global.qa_input_source = "none";
	show_debug_message("[QA Input] Ready. Toggle: F5 or F2 (PC) / L+R+D-pad Down (pad). Keys 1-0 simulate buttons.");
}

/// @desc Face-button catalogue used by the overlay (order = draw order).
/// SWITCH / XBOX strings include physical position next to the letter.
/// QA confirmed Switch exports fire gp_face1 when the A button is pressed (label mapping).
function QAInputFaceCatalog() {
	return [
		{ btn: gp_face1, gm: "face1", nsw: "A (RIGHT)",  xbox: "A (BOTTOM)", key: ord("1") },
		{ btn: gp_face2, gm: "face2", nsw: "B (BOTTOM)", xbox: "B (RIGHT)",  key: ord("2") },
		{ btn: gp_face3, gm: "face3", nsw: "X (TOP)",    xbox: "X (LEFT)",   key: ord("3") },
		{ btn: gp_face4, gm: "face4", nsw: "Y (LEFT)",   xbox: "Y (TOP)",    key: ord("4") },
		{ btn: gp_shoulderl,  gm: "L",  nsw: "L (LEFT)",  xbox: "LB (LEFT)",  key: ord("5") },
		{ btn: gp_shoulderr,  gm: "R",  nsw: "R (RIGHT)", xbox: "RB (RIGHT)", key: ord("6") },
		{ btn: gp_shoulderlb, gm: "ZL", nsw: "ZL (LEFT)", xbox: "LT (LEFT)",  key: ord("7") },
		{ btn: gp_shoulderrb, gm: "ZR", nsw: "ZR (RIGHT)",xbox: "RT (RIGHT)", key: ord("8") },
		{ btn: gp_start,  gm: "START",  nsw: "+ (RIGHT)", xbox: "START", key: ord("9") },
		{ btn: gp_select, gm: "SELECT", nsw: "- (LEFT)",  xbox: "BACK",  key: ord("0") }
	];
}

/// @desc Best gamepad slot to sample (Windows: scan XInput 0-3 and DirectInput 4-11).
function QAInputPrimaryPad() {
	if (variable_global_exists("gamepad_connected")
		&& global.gamepad_connected != noone
		&& gamepad_is_connected(global.gamepad_connected)) {
		return global.gamepad_connected;
	}
	var _n = gamepad_get_device_count();
	for (var _g = 0; _g < _n; _g++) {
		if (gamepad_is_connected(_g)) return _g;
	}
	return noone;
}

/// @desc True if this catalog button is held (gamepad and/or Windows keyboard sim).
function QAInputButtonHeld(_pad, _e) {
	if (_pad != noone && gamepad_button_check(_pad, _e.btn)) return true;
	if (keyboard_check(_e.key)) return true;
	return false;
}

/// @desc True if this catalog button was pressed this frame (gamepad and/or Windows keyboard sim).
function QAInputButtonPressed(_pad, _e) {
	if (_pad != noone && gamepad_button_check_pressed(_pad, _e.btn)) return true;
	if (keyboard_check_pressed(_e.key)) return true;
	return false;
}

/// @desc Which gameplay/menu actions currently bind to this GM button constant.
function QAInputActionsForButton(_btn) {
	var _out = [];
	if (!variable_global_exists("gpmap") || !ds_exists(global.gpmap, ds_type_map)) return "-";

	var _checks = [
		[INPUT.SEED, "SEED"],
		[INPUT.WATER, "WATER"],
		[INPUT.PARRY, "PARRY"],
		[INPUT.LOOP_DE_LOOP, "LOOP"],
		[INPUT.MENU_SELECT, "SELECT"],
		[INPUT.PAUSE, "PAUSE"],
		[INPUT.ROLL_LEFT, "ROLL L"],
		[INPUT.ROLL_RIGHT, "ROLL R"],
		[INPUT.TOGGLE_AIM, "AIM"]
	];
	for (var i = 0; i < array_length(_checks); i++) {
		var _key = _checks[i][0];
		if (!ds_map_exists(global.gpmap, _key)) continue;
		var _list = global.gpmap[? _key];
		if (!is_array(_list)) continue;
		for (var j = 0; j < array_length(_list); j++) {
			if (_list[j] == _btn) {
				array_push(_out, _checks[i][1]);
				break;
			}
		}
	}

	if (InputGpMenuConfirm() == _btn) array_push(_out, "CONFIRM");
	if (InputGpMenuCancel() == _btn) array_push(_out, "CANCEL");

	if (array_length(_out) <= 0) return "-";
	var _s = _out[0];
	for (var k = 1; k < array_length(_out); k++) _s += " " + _out[k];
	return _s;
}

/// @desc Short label for Confirm/Cancel constants (avoid raw numbers on screen).
function QAInputFaceName(_btn) {
	if (_btn == gp_face1) return "face1";
	if (_btn == gp_face2) return "face2";
	if (_btn == gp_face3) return "face3";
	if (_btn == gp_face4) return "face4";
	return string(_btn);
}

/// @desc Compact log line (ASCII only for Federo).
function QAInputFormatLog(_e, _src) {
	return _e.gm + "  SWITCH " + _e.nsw + "  XBOX " + _e.xbox
		+ " -> " + QAInputActionsForButton(_e.btn) + "  via " + _src;
}

/// @desc Push a press into the on-screen log + debug console.
function QAInputLogPress(_line) {
	array_insert(global.qa_input_log, 0, _line);
	while (array_length(global.qa_input_log) > QA_INPUT_LOG_MAX) {
		array_pop(global.qa_input_log);
	}
	show_debug_message("[QA Input] " + _line);
}

/// @desc True when the QA input overlay toggle chord was pressed this frame.
function QAInputTogglePressed() {
	if (keyboard_check_pressed(vk_f5)) return true;
	if (keyboard_check_pressed(vk_f2)) return true;

	var _n = gamepad_get_device_count();
	for (var _g = 0; _g < _n; _g++) {
		if (!gamepad_is_connected(_g)) continue;
		if (gamepad_button_check(_g, gp_shoulderl)
			&& gamepad_button_check(_g, gp_shoulderr)
			&& gamepad_button_check_pressed(_g, gp_padd)) {
			return true;
		}
	}
	return false;
}

/// @desc Per-frame sampling + toggle. Call from obj_CRTController Step.
function QAInputStep() {
	if (!variable_global_exists("qa_input_overlay")) QAInputInit();

	if (global.qa_input_toggle_cd > 0) global.qa_input_toggle_cd -= 1;

	if (QAInputTogglePressed() && global.qa_input_toggle_cd <= 0) {
		global.qa_input_overlay = !global.qa_input_overlay;
		global.qa_input_toggle_cd = 20;
		show_debug_message("[QA Input] Overlay " + (global.qa_input_overlay ? "ON" : "OFF")
			+ "  |  Toggle: F5/F2 (PC) or L+R+D-pad Down (pad)"
			+ "  |  PC keys: 1-4 faces, 5-6 bumpers, 7-8 triggers, 9-0 start/select");
	}

	if (!global.qa_input_overlay) return;

	var _pad = QAInputPrimaryPad();
	global.qa_input_pad = _pad;

	var _cat = QAInputFaceCatalog();
	for (var i = 0; i < array_length(_cat); i++) {
		var _e = _cat[i];
		var _held = QAInputButtonHeld(_pad, _e);
		var _pressed = QAInputButtonPressed(_pad, _e);

		if (_pressed) {
			var _src = "kb";
			if (_pad != noone && gamepad_button_check_pressed(_pad, _e.btn)) {
				_src = "pad " + string(_pad);
			}
			global.qa_input_source = _src;
			QAInputLogPress(QAInputFormatLog(_e, _src));
			global.qa_input_hold[$ string(_e.btn)] = QA_INPUT_HOLD_FRAMES;
		} else if (_held) {
			if (!variable_struct_exists(global.qa_input_hold, string(_e.btn))
				|| global.qa_input_hold[$ string(_e.btn)] <= 0) {
				global.qa_input_hold[$ string(_e.btn)] = 1;
			}
		} else if (variable_struct_exists(global.qa_input_hold, string(_e.btn))) {
			var _remain = global.qa_input_hold[$ string(_e.btn)];
			if (_remain > 0) global.qa_input_hold[$ string(_e.btn)] = _remain - 1;
		}
	}
}

/// @desc Draw one column cell (fixed x so rows stay aligned).
function QAInputDrawCell(_x, _y, _text, _col) {
	draw_set_color(_col);
	draw_text(_x, _y, _text);
}

/// @desc Draw the overlay in GUI space. Call from obj_CRTController Draw GUI.
function QAInputDraw() {
	if (!variable_global_exists("qa_input_overlay") || !global.qa_input_overlay) return;

	var _gw = display_get_gui_width();
	var _gh = display_get_gui_height();
	var _x = 8;
	var _y = 8;
	var _lh = 18;
	var _pad = 8;
	var _cat = QAInputFaceCatalog();
	var _log_n = array_length(global.qa_input_log);
	var _rows = 5 + 1 + array_length(_cat) + 2 + max(1, _log_n);
	var _box_w = min(980, _gw - 16);
	var _box_h = min(_gh - 16, _pad * 2 + _lh * _rows);

	draw_set_alpha(0.82);
	draw_set_color(c_black);
	draw_rectangle(_x, _y, _x + _box_w, _y + _box_h, false);
	draw_set_alpha(1);

	draw_set_font(fnt_Federo16);
	draw_set_halign(fa_left);
	draw_set_valign(fa_top);

	var _cy = _y + _pad;
	var _pad_slot = global.qa_input_pad;
	var _col0 = _x + _pad;
	var _col1 = _x + 100;
	var _col2 = _x + 280;
	var _col3 = _x + 460;
	var _col4 = _x + 580;

	draw_set_color(c_aqua);
	draw_text(_col0, _cy, "QA INPUT   F5 or F2 to toggle");
	_cy += _lh;

	draw_set_color(c_white);
	draw_text(_col0, _cy, (SavePlatformIsSwitch() ? "SWITCH" : "PC")
		+ "   pad " + string(_pad_slot)
		+ "   Confirm " + QAInputFaceName(InputGpMenuConfirm())
		+ "   Cancel " + QAInputFaceName(InputGpMenuCancel()));
	_cy += _lh;

	draw_set_color(c_ltgray);
	if (_pad_slot == noone) {
		draw_text(_col0, _cy, "No pad - use keys 1-4 faces  5-6 bump  7-8 trig  9-0 start");
	} else {
		draw_text(_col0, _cy, "Pad found - keys 1-0 also simulate buttons");
	}
	_cy += _lh;

	// Column headers
	draw_set_color(c_yellow);
	QAInputDrawCell(_col0, _cy, "GM", c_yellow);
	QAInputDrawCell(_col1, _cy, "SWITCH", c_yellow);
	QAInputDrawCell(_col2, _cy, "XBOX", c_yellow);
	QAInputDrawCell(_col3, _cy, "STATE", c_yellow);
	QAInputDrawCell(_col4, _cy, "MAP", c_yellow);
	_cy += _lh;

	for (var i = 0; i < array_length(_cat); i++) {
		var _e = _cat[i];
		var _held = QAInputButtonHeld(_pad_slot, _e);
		var _flash = variable_struct_exists(global.qa_input_hold, string(_e.btn))
			&& global.qa_input_hold[$ string(_e.btn)] > 0;
		var _state = _held ? "HELD" : (_flash ? "PRESS" : "");
		var _col = _held ? c_lime : (_flash ? c_yellow : c_gray);

		QAInputDrawCell(_col0, _cy, _e.gm, _col);
		QAInputDrawCell(_col1, _cy, _e.nsw, _col);
		QAInputDrawCell(_col2, _cy, _e.xbox, _col);
		QAInputDrawCell(_col3, _cy, _state, _col);
		QAInputDrawCell(_col4, _cy, QAInputActionsForButton(_e.btn), _col);
		_cy += _lh;
	}

	_cy += 4;
	draw_set_color(c_yellow);
	draw_text(_col0, _cy, "RECENT PRESSES");
	_cy += _lh;

	if (_log_n <= 0) {
		draw_set_color(c_gray);
		draw_text(_col0, _cy, "Press a face button or key 1-4");
	} else {
		for (var j = 0; j < _log_n; j++) {
			draw_set_color(j == 0 ? c_lime : c_white);
			draw_text(_col0, _cy, string(j + 1) + ". " + global.qa_input_log[j]);
			_cy += _lh;
			if (_cy > _y + _box_h - _lh) break;
		}
	}

	DrawReset(fnt_Federo16);
}
