/// @desc Local leaderboard (Windows: JSON file; Switch: embedded in airhares_save.json)

/// @param {Array<Struct>} entries
function LeaderboardSortEntriesDesc(entries) {
	var n = array_length(entries);
	for (var i = 0; i < n; i++) {
		for (var j = i + 1; j < n; j++) {
			if (entries[j].score > entries[i].score) {
				var t = entries[i];
				entries[i] = entries[j];
				entries[j] = t;
			}
		}
	}
}

/// @param {Array} raw
/// @returns {Array<Struct>} entries: [{ name: String, score: Real }]
/// Supports both the new format (struct entries) and legacy format (numbers only).
function LeaderboardValidateEntryArray(raw) {
	if (!is_array(raw)) return [];
	var out = [];

	for (var i = 0; i < array_length(raw); i++) {
		var v = raw[i];

		// Legacy: plain score number
		if (is_numeric(v)) {
			array_push(out, { name: "---", score: real(v) });
			continue;
		}

		// New: struct entry
		if (is_struct(v)) {
			if (variable_struct_exists(v, "score") && is_numeric(v.score)) {
				var _name = (variable_struct_exists(v, "name") && is_string(v.name)) ? v.name : "---";
				array_push(out, { name: _name, score: real(v.score) });
			}
		}
	}

	return out;
}

/// @param {Array<Struct>} entries_sorted_any_order
/// @returns {Array<Struct>} sorted descending, length <= max
function LeaderboardCapSortedEntries(entries_sorted_any_order, max_entries) {
	var arr = [];
	for (var i = 0; i < array_length(entries_sorted_any_order); i++) {
		array_push(arr, entries_sorted_any_order[i]);
	}
	LeaderboardSortEntriesDesc(arr);
	var n = min(max_entries, array_length(arr));
	var out = [];
	for (var i = 0; i < n; i++) {
		array_push(out, arr[i]);
	}
	return out;
}

/// @param {Array<Struct>} capped_sorted
/// @returns {Array<Struct>} display entries: [{ rank, name, score }]
function LeaderboardEntriesToDisplayEntries(capped_sorted) {
	var out = [];
	for (var i = 0; i < array_length(capped_sorted); i++) {
		array_push(out, { rank: i + 1, name: capped_sorted[i].name, score: capped_sorted[i].score });
	}
	return out;
}

/// @returns {Struct} { singleplayer: Array<Struct>, coop: Array<Struct> }
function LeaderboardReadRawData() {
	var empty_sp = [];
	var empty_co = [];

	if (SavePlatformIsSwitch()) {
		return SaveSwitchLeaderboardReadRaw();
	}

	if (!SavePlatformIsWindows()) {
		return { singleplayer: empty_sp, coop: empty_co };
	}

	var fn = global.leaderboard_json_filename;
	if (fn == "" || !file_exists(fn)) {
		return { singleplayer: empty_sp, coop: empty_co };
	}
	var f = file_text_open_read(fn);
	if (f == -1) {
		return { singleplayer: empty_sp, coop: empty_co };
	}
	var s = "";
	while (!file_text_eof(f)) {
		s += file_text_read_string(f);
		file_text_readln(f);
	}
	file_text_close(f);
	if (string_length(s) == 0) {
		return { singleplayer: empty_sp, coop: empty_co };
	}
	var root = undefined;
	try {
		root = json_parse(s);
	} catch (_e) {
		root = undefined;
	}
	if (!is_struct(root)) {
		return { singleplayer: empty_sp, coop: empty_co };
	}
	var sp = [];
	var co = [];
	if (variable_struct_exists(root, "singleplayer")) {
		sp = LeaderboardValidateEntryArray(root.singleplayer);
	}
	if (variable_struct_exists(root, "coop")) {
		co = LeaderboardValidateEntryArray(root.coop);
	}
	return { singleplayer: sp, coop: co };
}

/// @param {Struct} data { singleplayer, coop } arrays of real
function LeaderboardWriteRawData(data) {
	if (SavePlatformIsSwitch()) {
		SaveSwitchLeaderboardWriteRaw(data);
		return;
	}

	if (!SavePlatformIsWindows()) {
		return;
	}

	var fn = global.leaderboard_json_filename;
	var payload = {
		singleplayer: data.singleplayer,
		coop: data.coop
	};
	var j = json_stringify(payload);
	var fw = file_text_open_write(fn);
	if (fw == -1) {
		show_debug_message("Leaderboard: could not open " + fn + " for write");
		return;
	}
	file_text_write_string(fw, j);
	file_text_close(fw);
}

/// @desc Load from disk into global display arrays (rank + name + score)
function LeaderboardDownloadTopScores() {
	if (!SavePlatformHasPersistence()) {
		global.leaderboard_singleplayer = [];
		global.leaderboard_coop = [];
		return;
	}
	var data = LeaderboardReadRawData();
	var max_n = global.leaderboard_max_entries;
	var sp = LeaderboardCapSortedEntries(data.singleplayer, max_n);
	var co = LeaderboardCapSortedEntries(data.coop, max_n);
	global.leaderboard_singleplayer = LeaderboardEntriesToDisplayEntries(sp);
	global.leaderboard_coop = LeaderboardEntriesToDisplayEntries(co);
}

/// @desc Append a run score, persist, refresh globals
/// @param {Real} score
/// @param {Bool} is_coop
/// @param {String} name
function LeaderboardUploadScore(score, is_coop, name) {
	if (!SavePlatformHasPersistence()) {
		return;
	}
	var data = LeaderboardReadRawData();
	var max_n = global.leaderboard_max_entries;
	var v = round(score);

	// Allow legacy call-sites that don't pass a name.
	if (argument_count < 3) name = "---";
	if (!is_string(name) or string_length(name) == 0) name = "---";

	if (is_coop) {
		array_push(data.coop, { name: name, score: v });
		data.coop = LeaderboardCapSortedEntries(data.coop, max_n);
	} else {
		array_push(data.singleplayer, { name: name, score: v });
		data.singleplayer = LeaderboardCapSortedEntries(data.singleplayer, max_n);
	}
	LeaderboardWriteRawData(data);
	global.leaderboard_singleplayer = LeaderboardEntriesToDisplayEntries(data.singleplayer);
	global.leaderboard_coop = LeaderboardEntriesToDisplayEntries(data.coop);
}

/// @param {Bool} is_coop
/// @returns {Bool}
function LeaderboardHasData(is_coop) {
	var entries = is_coop ? global.leaderboard_coop : global.leaderboard_singleplayer;
	return array_length(entries) > 0;
}
