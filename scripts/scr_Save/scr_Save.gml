/// @desc Platform save I/O — Windows: INI (save.sav + leaderboard JSON). Switch: JSON (airhares_save.json) + NAND commit.

#macro SAVE_WINDOWS_FILENAME "save.sav"
#macro SAVE_WINDOWS_LEADERBOARD_FILENAME "local_leaderboard_story_run.json"
#macro SAVE_SWITCH_FILENAME "airhares_save.json"
#macro SAVE_SWITCH_LB_KEY "leaderboard_story_run"

function SavePlatformIsWindows() {
	return os_type == os_windows;
}

function SavePlatformIsSwitch() {
	return os_type == os_switch;
	//return true;
}

function SavePlatformHasPersistence() {
	return SavePlatformIsWindows() || SavePlatformIsSwitch();
}

/// @returns {string} Leaderboard JSON path (Windows only; empty on Switch).
function SaveGetLeaderboardFilename() {
	if (SavePlatformIsWindows()) {
		return SAVE_WINDOWS_LEADERBOARD_FILENAME;
	}
	return "";
}

function SaveIniKeyString(_key) {
	return is_string(_key) ? _key : string(_key);
}

// --- Windows + Switch INI-compatible API ------------------------------------

function SaveIniOpen() {
	if (SavePlatformIsWindows()) {
		ini_open(SAVE_WINDOWS_FILENAME);
		global.save_ini_dirty = false;
		return true;
	}
	if (SavePlatformIsSwitch()) {
		if (variable_global_exists("save_switch_open") && global.save_switch_open) {
			if (variable_global_exists("save_ini_dirty") && global.save_ini_dirty) {
				SaveSwitchFlush();
			}
		}
		SaveSwitchEnsureLoaded();
		global.save_switch_open = true;
		global.save_ini_dirty = false;
		return true;
	}
	return false;
}

function SaveIniClose() {
	if (SavePlatformIsWindows()) {
		ini_close();
		if (variable_global_exists("save_ini_dirty") && global.save_ini_dirty) {
			global.save_ini_dirty = false;
		}
	} else if (SavePlatformIsSwitch() && variable_global_exists("save_switch_open") && global.save_switch_open) {
		// Only flush when something was written — avoids creating empty save data on boot/load.
		if (variable_global_exists("save_ini_dirty") && global.save_ini_dirty) {
			SaveSwitchFlush();
		}
		global.save_switch_open = false;
		global.save_ini_dirty = false;
	}
}

function SaveIniReadReal(_section, _key, _default) {
	if (SavePlatformIsWindows()) {
		return ini_read_real(_section, _key, _default);
	}
	if (SavePlatformIsSwitch()) {
		return SaveSwitchReadReal(_section, _key, _default);
	}
	return _default;
}

function SaveIniReadString(_section, _key, _default) {
	if (SavePlatformIsWindows()) {
		return ini_read_string(_section, _key, _default);
	}
	if (SavePlatformIsSwitch()) {
		return SaveSwitchReadString(_section, _key, _default);
	}
	return _default;
}

function SaveIniWriteReal(_section, _key, _value) {
	if (SavePlatformIsWindows()) {
		ini_write_real(_section, _key, _value);
		global.save_ini_dirty = true;
	} else if (SavePlatformIsSwitch()) {
		SaveSwitchWriteReal(_section, _key, _value);
		global.save_ini_dirty = true;
	}
}

function SaveIniWriteString(_section, _key, _value) {
	if (SavePlatformIsWindows()) {
		ini_write_string(_section, _key, _value);
		global.save_ini_dirty = true;
	} else if (SavePlatformIsSwitch()) {
		SaveSwitchWriteString(_section, _key, _value);
		global.save_ini_dirty = true;
	}
}

// --- Switch JSON backend ----------------------------------------------------

function SaveSwitchEnsureLoaded() {
	if (!variable_global_exists("save_switch_cache") || !is_struct(global.save_switch_cache)) {
		global.save_switch_cache = SaveSwitchLoadFromDisk();
	}
}

function SaveSwitchEmptyRoot() {
	return {
		leaderboard_story_run: { singleplayer: [], coop: [] }
	};
}

/// @desc Read a save file as text (buffer I/O — more reliable on Switch than file_text).
function SaveSwitchReadFileText(_filename) {
	if (!file_exists(_filename)) return "";
	var _buf = buffer_load(_filename);
	if (_buf < 0) return "";
	var _size = buffer_get_size(_buf);
	if (_size <= 0) {
		buffer_delete(_buf);
		return "";
	}
	buffer_seek(_buf, buffer_seek_start, 0);
	var _s = buffer_read(_buf, buffer_text);
	buffer_delete(_buf);
	return is_string(_s) ? _s : "";
}

/// @desc Write save file bytes. Returns true if the file exists afterwards.
function SaveSwitchWriteFileText(_filename, _text) {
	var _bytes = string_byte_length(_text);
	var _buf = buffer_create(max(_bytes, 1), buffer_fixed, 1);
	if (_bytes > 0) {
		buffer_write(_buf, buffer_text, _text);
	}
	buffer_save(_buf, _filename);
	buffer_delete(_buf);
	return file_exists(_filename);
}

/// @desc Copy the mounted Switch save cache to NAND. Without this, writes only last until the process exits.
function SaveSwitchCommitNand() {
	if (os_type != os_switch) return true;
	var _result = switch_save_data_commit();
	show_debug_message("SaveSwitch: nand commit result=" + string(_result));
	return true;
}

function SaveSwitchLoadFromDisk() {
	var _empty = SaveSwitchEmptyRoot();
	if (!file_exists(SAVE_SWITCH_FILENAME)) {
		return _empty;
	}
	var _s = SaveSwitchReadFileText(SAVE_SWITCH_FILENAME);
	if (string_length(_s) == 0) {
		return _empty;
	}
	var _root = undefined;
	try {
		_root = json_parse(_s);
	} catch (_e) {
		_root = undefined;
	}
	if (!is_struct(_root)) {
		return _empty;
	}
	if (!variable_struct_exists(_root, SAVE_SWITCH_LB_KEY) || !is_struct(_root[$ SAVE_SWITCH_LB_KEY])) {
		_root[$ SAVE_SWITCH_LB_KEY] = { singleplayer: [], coop: [] };
	}
	return _root;
}

function SaveSwitchFlush() {
	if (!SavePlatformIsSwitch()) return;
	if (!variable_global_exists("save_switch_cache") || !is_struct(global.save_switch_cache)) {
		return;
	}
	var _j = json_stringify(global.save_switch_cache);
	if (!SaveSwitchWriteFileText(SAVE_SWITCH_FILENAME, _j)) {
		show_debug_message("SaveSwitch: could not write " + SAVE_SWITCH_FILENAME);
		return;
	}
	// file_text / buffer_save only update the mounted cache. NAND persist requires commit.
	SaveSwitchCommitNand();
}

function SaveSwitchSection(_section, _create) {
	SaveSwitchEnsureLoaded();
	if (!variable_struct_exists(global.save_switch_cache, _section)) {
		if (!_create) return undefined;
		global.save_switch_cache[$ _section] = {};
	}
	return global.save_switch_cache[$ _section];
}

function SaveSwitchReadReal(_section, _key, _default) {
	var _sec = SaveSwitchSection(_section, false);
	if (_sec == undefined || !is_struct(_sec)) return _default;
	var _k = SaveIniKeyString(_key);
	if (!variable_struct_exists(_sec, _k)) return _default;
	return real(_sec[$ _k]);
}

function SaveSwitchReadString(_section, _key, _default) {
	var _sec = SaveSwitchSection(_section, false);
	if (_sec == undefined || !is_struct(_sec)) return _default;
	var _k = SaveIniKeyString(_key);
	if (!variable_struct_exists(_sec, _k)) return _default;
	var _v = _sec[$ _k];
	return is_string(_v) ? _v : string(_v);
}

function SaveSwitchWriteReal(_section, _key, _value) {
	var _sec = SaveSwitchSection(_section, true);
	_sec[$ SaveIniKeyString(_key)] = _value;
}

function SaveSwitchWriteString(_section, _key, _value) {
	var _sec = SaveSwitchSection(_section, true);
	_sec[$ SaveIniKeyString(_key)] = _value;
}

/// @returns {Struct} { singleplayer: Array, coop: Array } (Switch: from JSON cache)
function SaveSwitchLeaderboardReadRaw() {
	SaveSwitchEnsureLoaded();
	var _lb = global.save_switch_cache[$ SAVE_SWITCH_LB_KEY];
	var _sp = [];
	var _co = [];
	if (is_struct(_lb)) {
		if (variable_struct_exists(_lb, "singleplayer") && is_array(_lb.singleplayer)) {
			_sp = _lb.singleplayer;
		}
		if (variable_struct_exists(_lb, "coop") && is_array(_lb.coop)) {
			_co = _lb.coop;
		}
	}
	return { singleplayer: _sp, coop: _co };
}

/// @param {Struct} _data { singleplayer, coop }
function SaveSwitchLeaderboardWriteRaw(_data) {
	SaveSwitchEnsureLoaded();
	global.save_switch_cache[$ SAVE_SWITCH_LB_KEY] = {
		singleplayer: _data.singleplayer,
		coop: _data.coop
	};
	SaveSwitchFlush();
}

/// @desc Delete platform save file(s). Returns [save_removed, leaderboard_removed].
function SaveEraseAllFiles() {
	var _removed_save = false;
	var _removed_lb = false;

	if (SavePlatformIsWindows()) {
		var _save_paths = [
			SAVE_WINDOWS_FILENAME,
			program_directory + SAVE_WINDOWS_FILENAME,
			working_directory + SAVE_WINDOWS_FILENAME
		];
		var _lb_paths = [
			SAVE_WINDOWS_LEADERBOARD_FILENAME,
			program_directory + SAVE_WINDOWS_LEADERBOARD_FILENAME,
			working_directory + SAVE_WINDOWS_LEADERBOARD_FILENAME
		];
		for (var i = 0; i < array_length(_save_paths); i++) {
			if (file_exists(_save_paths[i])) {
				file_delete(_save_paths[i]);
				_removed_save = true;
			}
		}
		for (var j = 0; j < array_length(_lb_paths); j++) {
			if (file_exists(_lb_paths[j])) {
				file_delete(_lb_paths[j]);
				_removed_lb = true;
			}
		}
	} else if (SavePlatformIsSwitch()) {
		if (file_exists(SAVE_SWITCH_FILENAME)) {
			file_delete(SAVE_SWITCH_FILENAME);
			_removed_save = true;
			_removed_lb = true;
		}
		global.save_switch_cache = undefined;
		global.save_switch_open = false;
		global.save_ini_dirty = false;
		SaveSwitchCommitNand();
	}

	return [_removed_save, _removed_lb];
}

// --- Display / window options (Windows: windowed + resolution; Switch: fixed 1280×720) ---

#macro OPTIONS_DESIGN_W 1280
#macro OPTIONS_DESIGN_H 720

function OptionsDisplayAllowsWindowToggles() {
	return SavePlatformIsWindows();
}

/// @desc Default CRT scanlines for first launch (off on Switch for handheld performance).
function OptionsDefaultScanline() {
	return SavePlatformIsSwitch() ? 0 : 1;
}

function OptionsDisplayResolutionList() {
	return ["1280 x 720", "1920 x 1080", "2560 x 1440", "3840 x 2160"];
}

function OptionsDisplaySyncWindowedStateFromOS() {
	if (!OptionsDisplayAllowsWindowToggles()) return;
	if (global.options_windowed == window_get_fullscreen()) {
		global.options_windowed = !window_get_fullscreen();
	}
}

function OptionsDisplayApply() {
	if (!OptionsDisplayAllowsWindowToggles()) return;
	window_set_fullscreen(!global.options_windowed);
	window_set_size(global.options_res_w, global.options_res_h);
}

/// @desc Load audio/CRT options and platform-appropriate display settings from save.
function OptionsDisplayLoadFromSave() {
	SaveIniOpen();
	global.options_music = SaveIniReadReal("options", "music", 1);
	global.options_sfx = SaveIniReadReal("options", "sfx", 1);
	global.options_scanline = SaveIniReadReal("options", "scanline", OptionsDefaultScanline());
	if (OptionsDisplayAllowsWindowToggles()) {
		global.options_windowed = bool(SaveIniReadReal("options", "windowed", 1));
		global.options_res_h = SaveIniReadReal("options", "resolution height", OPTIONS_DESIGN_H);
		global.options_res_w = SaveIniReadReal("options", "resolution width", OPTIONS_DESIGN_W);
	} else {
		global.options_windowed = false;
		global.options_res_w = OPTIONS_DESIGN_W;
		global.options_res_h = OPTIONS_DESIGN_H;
	}
	SaveIniClose();
	OptionsDisplayApply();
}

/// @returns {Struct} { menu: Array, status: Array, count: Real } for the graphics submenu
function OptionsGraphicsMenuData() {
	OptionsDisplaySyncWindowedStateFromOS();
	var _scan = global.options_scanline ? "ON" : "OFF";
	if (OptionsDisplayAllowsWindowToggles()) {
		var _win = global.options_windowed ? "ON" : "OFF";
		var _res = string(global.options_res_w) + " x " + string(global.options_res_h);
		return {
			menu: ["CRT lines", "Windowed", "Resolution", "Back"],
			status: [_scan, _win, _res, ""],
			count: 4
		};
	}
	return {
		menu: ["CRT lines", "Back"],
		status: [_scan, ""],
		count: 2
	};
}

/// @returns {String|undefined} New ON/OFF label, or undefined if not applicable
function OptionsDisplayToggleWindowed() {
	if (!OptionsDisplayAllowsWindowToggles()) return undefined;
	OptionsDisplaySyncWindowedStateFromOS();
	global.options_windowed = global.options_windowed xor 1;
	OptionsDisplayApply();
	window_center();
	SaveIniOpen();
	SaveIniWriteReal("options", "windowed", global.options_windowed);
	SaveIniClose();
	return global.options_windowed ? "ON" : "OFF";
}

/// @param {Bool} _toggle Non-zero to flip windowed (Step left/right)
/// @returns {String|undefined}
function OptionsDisplayToggleWindowedDirection(_toggle) {
	if (!OptionsDisplayAllowsWindowToggles() || !_toggle) return undefined;
	OptionsDisplaySyncWindowedStateFromOS();
	global.options_windowed = global.options_windowed xor 1;
	OptionsDisplayApply();
	window_center();
	SaveIniOpen();
	SaveIniWriteReal("options", "windowed", global.options_windowed);
	SaveIniClose();
	return global.options_windowed ? "ON" : "OFF";
}

/// @param {String} _current_label e.g. "1920 x 1080"
/// @param {Real} _step -1, 0, or +1
/// @returns {String|undefined} New resolution label
function OptionsDisplayCycleResolution(_current_label, _step) {
	if (!OptionsDisplayAllowsWindowToggles() || _step == 0) return undefined;
	var _resolution = OptionsDisplayResolutionList();
	var _current = -1;
	for (var i = 0; i < array_length(_resolution); i++) {
		if (_resolution[i] == _current_label) {
			_current = i;
			break;
		}
	}
	_current += _step;
	if (_current < 0) _current = array_length(_resolution) - 1;
	else if (_current > array_length(_resolution) - 1) _current = 0;
	var _new_label = _resolution[_current];
	var _parts = string_split(_new_label, " x ");
	global.options_res_w = real(_parts[0]);
	global.options_res_h = real(_parts[1]);
	OptionsDisplayApply();
	SaveIniOpen();
	SaveIniWriteReal("options", "resolution height", global.options_res_h);
	SaveIniWriteReal("options", "resolution width", global.options_res_w);
	SaveIniClose();
	return _new_label;
}
