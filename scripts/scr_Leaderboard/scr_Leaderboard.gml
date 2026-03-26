/// @desc Local leaderboard (JSON file next to save.sav)

/// @param {Array<Real>} arr
function LeaderboardSortScoresDesc(arr) {
	var n = array_length(arr);
	for (var i = 0; i < n; i++) {
		for (var j = i + 1; j < n; j++) {
			if (arr[j] > arr[i]) {
				var t = arr[i];
				arr[i] = arr[j];
				arr[j] = t;
			}
		}
	}
}

/// @param {Array} raw
/// @returns {Array<Real>}
function LeaderboardValidateScoreArray(raw) {
	if (!is_array(raw)) return [];
	var out = [];
	for (var i = 0; i < array_length(raw); i++) {
		var v = raw[i];
		// json_parse often yields int types; is_real alone drops valid scores on reload
		if (is_numeric(v)) {
			array_push(out, real(v));
		}
	}
	return out;
}

/// @param {Array<Real>} scores_sorted_any_order
/// @returns {Array<Real>} sorted descending, length <= max
function LeaderboardCapSortedScores(scores_sorted_any_order, max_entries) {
	var arr = [];
	for (var i = 0; i < array_length(scores_sorted_any_order); i++) {
		array_push(arr, scores_sorted_any_order[i]);
	}
	LeaderboardSortScoresDesc(arr);
	var n = min(max_entries, array_length(arr));
	var out = [];
	for (var i = 0; i < n; i++) {
		array_push(out, arr[i]);
	}
	return out;
}

/// @param {Array<Real>} capped_sorted
/// @returns {Array<Struct>}
function LeaderboardScoresToDisplayEntries(capped_sorted) {
	var out = [];
	for (var i = 0; i < array_length(capped_sorted); i++) {
		array_push(out, { rank: i + 1, score: capped_sorted[i] });
	}
	return out;
}

/// @returns {Struct} { singleplayer: Array<Real>, coop: Array<Real> }
function LeaderboardReadRawData() {
	var empty_sp = [];
	var empty_co = [];
	var fn = global.leaderboard_json_filename;
	if (!file_exists(fn)) {
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
		sp = LeaderboardValidateScoreArray(root.singleplayer);
	}
	if (variable_struct_exists(root, "coop")) {
		co = LeaderboardValidateScoreArray(root.coop);
	}
	return { singleplayer: sp, coop: co };
}

/// @param {Struct} data { singleplayer, coop } arrays of real
function LeaderboardWriteRawData(data) {
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

/// @desc Load from disk into global display arrays (rank + score)
function LeaderboardDownloadTopScores() {
	var data = LeaderboardReadRawData();
	var max_n = global.leaderboard_max_entries;
	var sp = LeaderboardCapSortedScores(data.singleplayer, max_n);
	var co = LeaderboardCapSortedScores(data.coop, max_n);
	global.leaderboard_singleplayer = LeaderboardScoresToDisplayEntries(sp);
	global.leaderboard_coop = LeaderboardScoresToDisplayEntries(co);
}

/// @desc Append a run score, persist, refresh globals
/// @param {Real} score
/// @param {Bool} is_coop
function LeaderboardUploadScore(score, is_coop) {
	var data = LeaderboardReadRawData();
	var max_n = global.leaderboard_max_entries;
	var v = round(score);
	if (is_coop) {
		array_push(data.coop, v);
		data.coop = LeaderboardCapSortedScores(data.coop, max_n);
	} else {
		array_push(data.singleplayer, v);
		data.singleplayer = LeaderboardCapSortedScores(data.singleplayer, max_n);
	}
	LeaderboardWriteRawData(data);
	global.leaderboard_singleplayer = LeaderboardScoresToDisplayEntries(data.singleplayer);
	global.leaderboard_coop = LeaderboardScoresToDisplayEntries(data.coop);
}

/// @param {Bool} is_coop
/// @returns {Bool}
function LeaderboardHasData(is_coop) {
	var entries = is_coop ? global.leaderboard_coop : global.leaderboard_singleplayer;
	return array_length(entries) > 0;
}
