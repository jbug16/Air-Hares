/// @desc Platform save I/O — Windows: INI (save.sav + leaderboard JSON). Switch: JSON (airhares_save.json).

#macro SAVE_WINDOWS_FILENAME "save.sav"
#macro SAVE_WINDOWS_LEADERBOARD_FILENAME "local_leaderboard_story_run.json"
#macro SAVE_SWITCH_FILENAME "airhares_save.json"
#macro SAVE_SWITCH_LB_KEY "leaderboard_story_run"

function SavePlatformIsWindows() {
	return os_type == os_windows;
}

function SavePlatformIsSwitch() {
	return os_type == os_switch;
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
		return true;
	}
	if (SavePlatformIsSwitch()) {
		if (variable_global_exists("save_switch_open") && global.save_switch_open) {
			SaveSwitchFlush();
		}
		SaveSwitchEnsureLoaded();
		global.save_switch_open = true;
		return true;
	}
	return false;
}

function SaveIniClose() {
	if (SavePlatformIsWindows()) {
		ini_close();
	} else if (SavePlatformIsSwitch() && variable_global_exists("save_switch_open") && global.save_switch_open) {
		SaveSwitchFlush();
		global.save_switch_open = false;
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
	} else if (SavePlatformIsSwitch()) {
		SaveSwitchWriteReal(_section, _key, _value);
	}
}

function SaveIniWriteString(_section, _key, _value) {
	if (SavePlatformIsWindows()) {
		ini_write_string(_section, _key, _value);
	} else if (SavePlatformIsSwitch()) {
		SaveSwitchWriteString(_section, _key, _value);
	}
}

// --- Switch JSON backend ----------------------------------------------------

function SaveSwitchEnsureLoaded() {
	if (!variable_global_exists("save_switch_cache") || !is_struct(global.save_switch_cache)) {
		global.save_switch_cache = SaveSwitchLoadFromDisk();
	}
}

function SaveSwitchLoadFromDisk() {
	var _empty_sp = [];
	var _empty_co = [];
	if (!file_exists(SAVE_SWITCH_FILENAME)) {
		return {
			leaderboard_story_run: { singleplayer: _empty_sp, coop: _empty_co }
		};
	}
	var _f = file_text_open_read(SAVE_SWITCH_FILENAME);
	if (_f == -1) {
		return {
			leaderboard_story_run: { singleplayer: _empty_sp, coop: _empty_co }
		};
	}
	var _s = "";
	while (!file_text_eof(_f)) {
		_s += file_text_read_string(_f);
		file_text_readln(_f);
	}
	file_text_close(_f);
	if (string_length(_s) == 0) {
		return {
			leaderboard_story_run: { singleplayer: _empty_sp, coop: _empty_co }
		};
	}
	var _root = undefined;
	try {
		_root = json_parse(_s);
	} catch (_e) {
		_root = undefined;
	}
	if (!is_struct(_root)) {
		return {
			leaderboard_story_run: { singleplayer: _empty_sp, coop: _empty_co }
		};
	}
	if (!variable_struct_exists(_root, SAVE_SWITCH_LB_KEY) || !is_struct(_root[$ SAVE_SWITCH_LB_KEY])) {
		_root[$ SAVE_SWITCH_LB_KEY] = { singleplayer: _empty_sp, coop: _empty_co };
	}
	return _root;
}

function SaveSwitchFlush() {
	if (!SavePlatformIsSwitch()) return;
	if (!variable_global_exists("save_switch_cache") || !is_struct(global.save_switch_cache)) return;
	var _j = json_stringify(global.save_switch_cache);
	var _fw = file_text_open_write(SAVE_SWITCH_FILENAME);
	if (_fw == -1) {
		show_debug_message("SaveSwitch: could not write " + SAVE_SWITCH_FILENAME);
		return;
	}
	file_text_write_string(_fw, _j);
	file_text_close(_fw);
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
	}

	return [_removed_save, _removed_lb];
}
