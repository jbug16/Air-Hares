/// @desc QA save-data overlay for Switch Lotcheck / persistence debugging.
/// Toggle: F4 (keyboard) or hold L+R and press Plus/Start on any gamepad (Switch).
/// Shows whether the save file exists, last flush result, live globals, and a disk probe.

#macro QA_SAVE_PROBE_INTERVAL 30

/// @desc One-time init (called from obj_CRTController Create).
/// Preserves flush counters if SaveSwitchFlush already ran during globals boot.
function QASaveInit() {
	global.qa_save_overlay = false;
	global.qa_save_toggle_cd = 0;
	global.qa_save_probe_cd = 0;

	if (!variable_global_exists("qa_save_flush_ok_count")) global.qa_save_flush_ok_count = 0;
	if (!variable_global_exists("qa_save_flush_fail_count")) global.qa_save_flush_fail_count = 0;
	if (!variable_global_exists("qa_save_last_flush_ok")) global.qa_save_last_flush_ok = false;
	if (!variable_global_exists("qa_save_last_flush_time")) global.qa_save_last_flush_time = -1;
	if (!variable_global_exists("qa_save_last_error")) global.qa_save_last_error = "";
	if (!variable_global_exists("qa_save_last_bytes")) global.qa_save_last_bytes = 0;

	global.qa_save_probe = {
		exists: false,
		bytes: 0,
		parse_ok: false,
		music: -1,
		sfx: -1,
		scanline: -1,
		story: -1,
		arcade: -1,
		run_active: -1,
		initials: "?",
		age_frames: 0
	};
}

/// @desc Record a Switch flush attempt (safe before QASaveInit).
/// @param {Bool} _ok
/// @param {String} _error
/// @param {Real} _bytes
function QASaveNoteFlush(_ok, _error = "", _bytes = 0) {
	if (!variable_global_exists("qa_save_flush_ok_count")) {
		global.qa_save_flush_ok_count = 0;
		global.qa_save_flush_fail_count = 0;
		global.qa_save_last_flush_ok = false;
		global.qa_save_last_flush_time = -1;
		global.qa_save_last_error = "";
		global.qa_save_last_bytes = 0;
	}
	global.qa_save_last_flush_ok = _ok;
	global.qa_save_last_flush_time = current_time;
	global.qa_save_last_error = string(_error);
	global.qa_save_last_bytes = _bytes;
	if (_ok) {
		global.qa_save_flush_ok_count += 1;
	} else {
		global.qa_save_flush_fail_count += 1;
	}
	show_debug_message("[QA Save] Flush " + (_ok ? "OK" : "FAIL")
		+ " bytes=" + string(_bytes)
		+ (_error != "" ? (" err=" + _error) : ""));
}

/// @desc True when the QA save overlay toggle chord was pressed this frame.
function QASaveTogglePressed() {
	if (keyboard_check_pressed(vk_f4)) return true;

	var _n = gamepad_get_device_count();
	for (var _g = 0; _g < _n; _g++) {
		if (!gamepad_is_connected(_g)) continue;
		if (gamepad_button_check(_g, gp_shoulderl)
			&& gamepad_button_check(_g, gp_shoulderr)
			&& gamepad_button_check_pressed(_g, gp_start)) {
			return true;
		}
	}
	return false;
}

/// @desc Read key fields straight from disk (does not mutate Switch cache).
function QASaveProbeDisk() {
	var _p = {
		exists: false,
		bytes: 0,
		parse_ok: false,
		music: -1,
		sfx: -1,
		scanline: -1,
		story: -1,
		arcade: -1,
		run_active: -1,
		initials: "?",
		age_frames: 0
	};

	if (SavePlatformIsSwitch()) {
		_p.exists = file_exists(SAVE_SWITCH_FILENAME);
		if (!_p.exists) return _p;

		var _f = file_text_open_read(SAVE_SWITCH_FILENAME);
		if (_f == -1) {
			_p.exists = true;
			return _p;
		}
		var _s = "";
		while (!file_text_eof(_f)) {
			_s += file_text_read_string(_f);
			file_text_readln(_f);
		}
		file_text_close(_f);
		_p.bytes = string_byte_length(_s);
		if (string_length(_s) <= 0) return _p;

		var _root = undefined;
		try {
			_root = json_parse(_s);
		} catch (_e) {
			_root = undefined;
		}
		if (!is_struct(_root)) return _p;
		_p.parse_ok = true;

		if (variable_struct_exists(_root, "options") && is_struct(_root.options)) {
			var _opt = _root.options;
			if (variable_struct_exists(_opt, "music")) _p.music = real(_opt.music);
			if (variable_struct_exists(_opt, "sfx")) _p.sfx = real(_opt.sfx);
			if (variable_struct_exists(_opt, "scanline")) _p.scanline = real(_opt.scanline);
		}
		if (variable_struct_exists(_root, "story") && is_struct(_root.story)) {
			if (variable_struct_exists(_root.story, "progress")) _p.story = real(_root.story.progress);
		}
		if (variable_struct_exists(_root, "arcade") && is_struct(_root.arcade)) {
			if (variable_struct_exists(_root.arcade, "max_unlocked")) _p.arcade = real(_root.arcade.max_unlocked);
		}
		if (variable_struct_exists(_root, "story_run") && is_struct(_root.story_run)) {
			if (variable_struct_exists(_root.story_run, "active")) _p.run_active = real(_root.story_run.active);
		}
		if (variable_struct_exists(_root, "leaderboard") && is_struct(_root.leaderboard)) {
			if (variable_struct_exists(_root.leaderboard, "initials")) {
				_p.initials = string(_root.leaderboard.initials);
			}
		}
		return _p;
	}

	if (SavePlatformIsWindows()) {
		_p.exists = file_exists(SAVE_WINDOWS_FILENAME);
		if (!_p.exists) return _p;

		ini_open(SAVE_WINDOWS_FILENAME);
		_p.parse_ok = true;
		_p.music = ini_read_real("options", "music", -1);
		_p.sfx = ini_read_real("options", "sfx", -1);
		_p.scanline = ini_read_real("options", "scanline", -1);
		_p.story = ini_read_real("story", "progress", -1);
		_p.arcade = ini_read_real("arcade", "max_unlocked", -1);
		_p.run_active = ini_read_real("story_run", "active", -1);
		_p.initials = ini_read_string("leaderboard", "initials", "?");
		ini_close();
		return _p;
	}

	return _p;
}

/// @desc Per-frame toggle + periodic disk probe. Call from obj_CRTController Step.
function QASaveStep() {
	if (!variable_global_exists("qa_save_overlay")) QASaveInit();

	if (global.qa_save_toggle_cd > 0) global.qa_save_toggle_cd -= 1;

	if (QASaveTogglePressed() && global.qa_save_toggle_cd <= 0) {
		global.qa_save_overlay = !global.qa_save_overlay;
		global.qa_save_toggle_cd = 20;
		if (global.qa_save_overlay) {
			global.qa_save_probe = QASaveProbeDisk();
			global.qa_save_probe_cd = QA_SAVE_PROBE_INTERVAL;
		}
		show_debug_message("[QA Save] Overlay " + (global.qa_save_overlay ? "ON" : "OFF")
			+ "  |  Toggle: F4 (PC) or L+R+Plus (Switch)");
	}

	if (!global.qa_save_overlay) return;

	if (global.qa_save_probe_cd > 0) {
		global.qa_save_probe_cd -= 1;
	} else {
		global.qa_save_probe = QASaveProbeDisk();
		global.qa_save_probe_cd = QA_SAVE_PROBE_INTERVAL;
	}
	if (is_struct(global.qa_save_probe)) {
		global.qa_save_probe.age_frames = QA_SAVE_PROBE_INTERVAL - global.qa_save_probe_cd;
	}
}

/// @desc Colour helper: match / mismatch / unknown.
function QASaveMatchColour(_mem, _disk) {
	if (_disk == -1 || _disk == "?" ) return c_yellow;
	if (is_string(_mem) || is_string(_disk)) {
		return (string(_mem) == string(_disk)) ? c_lime : c_red;
	}
	return (real(_mem) == real(_disk)) ? c_lime : c_red;
}

/// @desc Draw the overlay in GUI space. Call from obj_CRTController Draw GUI.
function QASaveDraw() {
	if (!variable_global_exists("qa_save_overlay") || !global.qa_save_overlay) return;

	var _gw = display_get_gui_width();
	var _gh = display_get_gui_height();
	var _x = 8;
	var _y = 8;
	var _lh = 16;
	var _pad = 6;
	var _lines = 16;
	var _box_w = min(560, _gw - 16);
	var _box_h = _pad * 2 + _lh * _lines;

	draw_set_alpha(0.78);
	draw_set_color(c_black);
	draw_rectangle(_x, _y, _x + _box_w, _y + _box_h, false);
	draw_set_alpha(1);

	draw_set_font(fnt_Federo16);
	draw_set_halign(fa_left);
	draw_set_valign(fa_top);

	var _cy = _y + _pad;
	var _p = global.qa_save_probe;
	if (!is_struct(_p)) _p = QASaveProbeDisk();

	var _plat = "other";
	if (SavePlatformIsSwitch()) _plat = "switch";
	else if (SavePlatformIsWindows()) _plat = "windows";

	var _fname = SavePlatformIsSwitch() ? SAVE_SWITCH_FILENAME
		: (SavePlatformIsWindows() ? SAVE_WINDOWS_FILENAME : "(none)");

	draw_set_color(c_aqua);
	draw_text(_x + _pad, _cy, "QA SAVE  (toggle: F4 / L+R+Plus)");
	_cy += _lh;

	draw_set_color(c_white);
	draw_text(_x + _pad, _cy, "Platform: " + _plat
		+ "  persist=" + (SavePlatformHasPersistence() ? "YES" : "NO"));
	_cy += _lh;

	draw_set_color(_p.exists ? c_lime : c_yellow);
	draw_text(_x + _pad, _cy, "File: " + _fname
		+ "  exists=" + (_p.exists ? "YES" : "NO")
		+ "  bytes=" + string(_p.bytes)
		+ (_p.parse_ok ? "  parse=OK" : "  parse=?"));
	_cy += _lh;

	var _flush_col = c_yellow;
	var _flush_txt = "never";
	if (global.qa_save_last_flush_time >= 0) {
		_flush_col = global.qa_save_last_flush_ok ? c_lime : c_red;
		var _ago = max(0, current_time - global.qa_save_last_flush_time);
		_flush_txt = (global.qa_save_last_flush_ok ? "OK" : "FAIL")
			+ "  " + string(_ago) + "ms ago"
			+ "  wrote=" + string(global.qa_save_last_bytes);
		if (!global.qa_save_last_flush_ok && global.qa_save_last_error != "") {
			_flush_txt += "  " + global.qa_save_last_error;
		}
	}
	draw_set_color(_flush_col);
	draw_text(_x + _pad, _cy, "Last flush: " + _flush_txt);
	_cy += _lh;

	draw_set_color(global.qa_save_flush_fail_count > 0 ? c_red : c_white);
	draw_text(_x + _pad, _cy, "Flush counts: ok=" + string(global.qa_save_flush_ok_count)
		+ "  fail=" + string(global.qa_save_flush_fail_count));
	_cy += _lh;

	var _mem_music = variable_global_exists("options_music") ? global.options_music : -1;
	var _mem_sfx = variable_global_exists("options_sfx") ? global.options_sfx : -1;
	var _mem_scan = variable_global_exists("options_scanline") ? global.options_scanline : -1;
	var _mem_story = variable_global_exists("story_mode_progress") ? global.story_mode_progress : -1;
	var _mem_arcade = variable_global_exists("arcade_max_unlocked") ? global.arcade_max_unlocked : -1;
	var _mem_run = variable_global_exists("story_run_active") ? (global.story_run_active ? 1 : 0) : -1;
	var _mem_init = variable_global_exists("player_initials") ? string(global.player_initials) : "?";

	draw_set_color(c_white);
	draw_text(_x + _pad, _cy, "--- mem vs disk (green=match) ---");
	_cy += _lh;

	draw_set_color(QASaveMatchColour(_mem_music, _p.music));
	draw_text(_x + _pad, _cy, "Music:    mem=" + string(_mem_music) + "  disk=" + string(_p.music));
	_cy += _lh;

	draw_set_color(QASaveMatchColour(_mem_sfx, _p.sfx));
	draw_text(_x + _pad, _cy, "SFX:      mem=" + string(_mem_sfx) + "  disk=" + string(_p.sfx));
	_cy += _lh;

	draw_set_color(QASaveMatchColour(_mem_scan, _p.scanline));
	draw_text(_x + _pad, _cy, "Scanline: mem=" + string(_mem_scan) + "  disk=" + string(_p.scanline));
	_cy += _lh;

	draw_set_color(QASaveMatchColour(_mem_story, _p.story));
	draw_text(_x + _pad, _cy, "Story:    mem=" + string(_mem_story) + "  disk=" + string(_p.story));
	_cy += _lh;

	draw_set_color(QASaveMatchColour(_mem_arcade, _p.arcade));
	draw_text(_x + _pad, _cy, "Arcade:   mem=" + string(_mem_arcade) + "  disk=" + string(_p.arcade));
	_cy += _lh;

	draw_set_color(QASaveMatchColour(_mem_run, _p.run_active));
	draw_text(_x + _pad, _cy, "RunActive: mem=" + string(_mem_run) + "  disk=" + string(_p.run_active));
	_cy += _lh;

	draw_set_color(QASaveMatchColour(_mem_init, _p.initials));
	draw_text(_x + _pad, _cy, "Initials: mem=" + _mem_init + "  disk=" + string(_p.initials));
	_cy += _lh;

	draw_set_color(c_white);
	draw_text(_x + _pad, _cy, "Continue UI: "
		+ ((variable_global_exists("story_mode_progress") && StoryHasMainMenuContinue()) ? "YES" : "NO")
		+ "  room=" + room_get_name(room));
	_cy += _lh;


	DrawReset(fnt_Federo16);
}
