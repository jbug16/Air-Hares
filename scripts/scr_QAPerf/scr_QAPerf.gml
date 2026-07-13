/// @desc Lightweight QA performance overlay (FPS, frame time, level-start hitches).
/// Toggle: F3 (keyboard) or hold L+R and press Minus/Select on any gamepad (Switch).

#macro QA_PERF_ROOM_START_FRAMES 120
#macro QA_PERF_HITCH_MS 33
#macro QA_PERF_TARGET_FPS 58

/// @desc One-time init (called from obj_CRTController Create).
function QAPerfInit() {
	global.qa_perf_overlay = false;
	global.qa_perf_toggle_cd = 0;
	global.qa_perf_room_id = -1;
	global.qa_perf_room_frames = 0;
	global.qa_perf_room_worst_ms = 0;
	global.qa_perf_session_worst_ms = 0;
	global.qa_perf_room_hitch = false;
	global.qa_perf_fps_min = 9999;
	global.qa_perf_fps_min_room = 9999;
}

/// @desc Per-frame sampling + toggle. Call from obj_CRTController Step.
function QAPerfStep() {
	if (global.qa_perf_toggle_cd > 0) global.qa_perf_toggle_cd -= 1;

	var _rid = room;
	if (_rid != global.qa_perf_room_id) {
		global.qa_perf_room_id = _rid;
		global.qa_perf_room_frames = 0;
		global.qa_perf_room_worst_ms = 0;
		global.qa_perf_room_hitch = false;
		global.qa_perf_fps_min_room = 9999;
	}

	global.qa_perf_room_frames += 1;

	var _ms = delta_time * 0.001; // microseconds -> milliseconds
	global.qa_perf_room_worst_ms = max(global.qa_perf_room_worst_ms, _ms);
	global.qa_perf_session_worst_ms = max(global.qa_perf_session_worst_ms, _ms);

	var _fps_now = fps_real;
	global.qa_perf_fps_min = min(global.qa_perf_fps_min, _fps_now);
	global.qa_perf_fps_min_room = min(global.qa_perf_fps_min_room, _fps_now);

	if (global.qa_perf_room_frames <= QA_PERF_ROOM_START_FRAMES && _ms >= QA_PERF_HITCH_MS) {
		global.qa_perf_room_hitch = true;
	}

	if (QAPerfTogglePressed() && global.qa_perf_toggle_cd <= 0) {
		global.qa_perf_overlay = !global.qa_perf_overlay;
		global.qa_perf_toggle_cd = 20;
		show_debug_message("[QA Perf] Overlay " + (global.qa_perf_overlay ? "ON" : "OFF")
			+ "  |  Toggle: F3 (PC) or L+R+Minus (Switch)");
	}
}

/// @desc True when the QA overlay toggle chord was pressed this frame.
function QAPerfTogglePressed() {
	if (keyboard_check_pressed(vk_f3)) return true;

	var _n = gamepad_get_device_count();
	for (var _g = 0; _g < _n; _g++) {
		if (!gamepad_is_connected(_g)) continue;
		if (gamepad_button_check(_g, gp_shoulderl)
			&& gamepad_button_check(_g, gp_shoulderr)
			&& gamepad_button_check_pressed(_g, gp_select)) {
			return true;
		}
	}
	return false;
}

/// @desc Colour-code a metric for quick visual scanning.
/// @param {Real} _value
/// @param {Real} _good
/// @param {Real} _warn
/// @param {Bool} _higher_is_better
function QAPerfColour(_value, _good, _warn, _higher_is_better) {
	if (_higher_is_better) {
		if (_value >= _good) return c_lime;
		if (_value >= _warn) return c_yellow;
		return c_red;
	}
	if (_value <= _good) return c_lime;
	if (_value <= _warn) return c_yellow;
	return c_red;
}

/// @desc Draw the overlay in GUI space. Call from obj_CRTController Draw GUI.
function QAPerfDraw() {
	if (!global.qa_perf_overlay) return;

	var _gw = display_get_gui_width();
	var _gh = display_get_gui_height();
	var _x = 8;
	var _y = 8;
	var _lh = 18;
	var _pad = 6;
	var _lines = 12;
	var _box_w = min(520, _gw - 16);
	var _box_h = _pad * 2 + _lh * _lines;

	// Panel background
	draw_set_alpha(0.72);
	draw_set_color(c_black);
	draw_rectangle(_x, _y, _x + _box_w, _y + _box_h, false);
	draw_set_alpha(1);

	draw_set_font(fnt_Federo16);
	draw_set_halign(fa_left);
	draw_set_valign(fa_top);

	var _cy = _y + _pad;
	var _target_ms = 1000 / max(1, GAMESPD);
	var _frame_ms = delta_time * 0.001;
	var _ww = window_get_width();
	var _wh = window_get_height();
	var _docked = (_ww > 1280 || _wh > 720);

	// Header
	draw_set_color(c_aqua);
	draw_text(_x + _pad, _cy, "QA PERF  (toggle: F3 / L+R+Minus)");
	_cy += _lh;

	draw_set_color(QAPerfColour(fps_real, QA_PERF_TARGET_FPS, 45, true));
	draw_text(_x + _pad, _cy, "FPS: " + string_format(fps, 0, 0) + "  real: " + string_format(fps_real, 0, 1)
		+ "  (room min " + string_format(global.qa_perf_fps_min_room, 0, 1) + ")");
	_cy += _lh;

	draw_set_color(QAPerfColour(_frame_ms, _target_ms, _target_ms * 2, false));
	draw_text(_x + _pad, _cy, "Frame: " + string_format(_frame_ms, 0, 1) + " ms  (target "
		+ string_format(_target_ms, 0, 1) + " @ " + string(GAMESPD) + " fps)");
	_cy += _lh;

	draw_set_color(QAPerfColour(global.qa_perf_room_worst_ms, _target_ms, QA_PERF_HITCH_MS, false));
	draw_text(_x + _pad, _cy, "Room worst: " + string_format(global.qa_perf_room_worst_ms, 0, 1) + " ms  (frame "
		+ string(global.qa_perf_room_frames) + ")");
	_cy += _lh;

	draw_set_color(QAPerfColour(global.qa_perf_session_worst_ms, _target_ms, QA_PERF_HITCH_MS, false));
	draw_text(_x + _pad, _cy, "Session worst: " + string_format(global.qa_perf_session_worst_ms, 0, 1) + " ms");
	_cy += _lh;

	if (global.qa_perf_room_hitch) {
		draw_set_color(c_red);
		draw_text(_x + _pad, _cy, "!! LEVEL-START HITCH (>=" + string(QA_PERF_HITCH_MS) + " ms) !!");
	} else if (global.qa_perf_room_frames <= QA_PERF_ROOM_START_FRAMES) {
		draw_set_color(c_lime);
		draw_text(_x + _pad, _cy, "Level start: OK so far");
	} else {
		draw_set_color(c_white);
		draw_text(_x + _pad, _cy, "Level start: (past sample window)");
	}
	_cy += _lh;

	draw_set_color(c_white);
	draw_text(_x + _pad, _cy, "Room: " + room_get_name(room));
	_cy += _lh;

	draw_set_color(c_white);
	draw_text(_x + _pad, _cy, "Window: " + string(_ww) + "x" + string(_wh) + (_docked ? "  DOCKED" : "  HANDHELD"));
	_cy += _lh;

	var _pref = (variable_global_exists("textures_prefetched") && global.textures_prefetched) ? "YES" : "NO";
	draw_set_color(_pref == "YES" ? c_lime : c_yellow);
	draw_text(_x + _pad, _cy, "Tex prefetch: " + _pref
		+ "  (opt " + string(variable_global_exists("prefetch_textures") ? global.prefetch_textures : "?") + ")");
	_cy += _lh;

	draw_set_color(c_white);
	draw_text(_x + _pad, _cy, "Scanlines: " + string(global.options_scanline)
		+ "  Instances: " + string(instance_count));
	_cy += _lh;

	var _gc = gc_get_stats();
	draw_set_color(c_white);
	draw_text(_x + _pad, _cy, "GC last: touched " + string(_gc.objects_touched)
		+ "  collected " + string(_gc.objects_collected));

	DrawReset(fnt_Federo16);
}
