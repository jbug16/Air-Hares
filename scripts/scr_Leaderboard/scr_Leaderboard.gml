/// @desc Leaderboard Management Script
/// Centralized functions for managing Steam leaderboards

/// @desc Get the current player's Steam username
/// @returns {String} The Steam persona name, or "Player" if Steam is not available
function LeaderboardGetPlayerName() {
	if (steam_initialised()) {
		return steam_get_persona_name();
	}
	return "Player";
}

/// @desc Upload a score to the appropriate leaderboard based on game mode
/// @param {Real} score The score to upload
/// @param {Bool} is_coop Whether this is a co-op game (true) or singleplayer (false)
/// @returns {Real} The async request ID, or -1 if Steam is not initialized
function LeaderboardUploadScore(score, is_coop) {
	// Test mode: simulate upload
	if (global.dev_mode && !steam_initialised()) {
		show_debug_message("Leaderboard [DEV MODE]: Simulating upload of score " + string(round(score)) + " to " + (is_coop ? "co-op" : "singleplayer"));
		
		// Simulate async callback with mock data as ds_map
		var _mock_post_id = 9999 + irandom(1000);
		var _mock_async = ds_map_create();
		ds_map_add(_mock_async, "event_type", "leaderboard_upload");
		ds_map_add(_mock_async, "post_id", _mock_post_id);
		ds_map_add(_mock_async, "lb_name", is_coop ? global.leaderboard_name_coop : global.leaderboard_name_singleplayer);
		ds_map_add(_mock_async, "success", true);
		ds_map_add(_mock_async, "updated", true);
		ds_map_add(_mock_async, "score", round(score));
		
		// Store mock upload ID for tracking
		if (is_coop) {
			global.leaderboard_upload_id_coop = _mock_post_id;
		} else {
			global.leaderboard_upload_id_singleplayer = _mock_post_id;
		}
		
		// Process the mock callback immediately
		LeaderboardProcessUploadCallback(_mock_async);
		
		// Clean up the ds_map
		ds_map_destroy(_mock_async);
		
		return _mock_post_id;
	}
	
	// Real Steam mode: check if initialized
	if (!steam_initialised()) {
		show_debug_message("Leaderboard: Steam not initialized, cannot upload score");
		return -1;
	}
	
	var _lb_name = is_coop ? global.leaderboard_name_coop : global.leaderboard_name_singleplayer;
	var _score_int = round(score);
	
	show_debug_message("Leaderboard: Uploading score " + string(_score_int) + " to " + _lb_name);
	
	var _upload_id = steam_upload_score(_lb_name, _score_int);
	
	// Store the upload ID for tracking
	if (is_coop) {
		global.leaderboard_upload_id_coop = _upload_id;
	} else {
		global.leaderboard_upload_id_singleplayer = _upload_id;
	}
	
	return _upload_id;
}

/// @desc Download scores from a leaderboard
/// @param {String} leaderboard_name The name of the leaderboard to download from
/// @param {Real} start_idx The starting rank (1-based)
/// @param {Real} end_idx The ending rank (1-based)
/// @returns {Real} The async request ID, or -1 if Steam is not initialized
function LeaderboardDownloadScores(leaderboard_name, start_idx, end_idx) {
	// Test mode: return mock data
	if (global.dev_mode && !steam_initialised()) {
		show_debug_message("Leaderboard [DEV MODE]: Simulating download from " + leaderboard_name);
		
		// Generate mock entries
		var _mock_entries = [];
		var _base_score = leaderboard_name == global.leaderboard_name_coop ? 60000 : 50000;
		var _score_decrement = leaderboard_name == global.leaderboard_name_coop ? 3500 : 3000;
		
		for (var i = start_idx; i <= end_idx && i <= 10; i++) {
			var _entry = {
				rank: i,
				user: "TestPlayer" + string(i),
				score: _base_score - ((i - 1) * _score_decrement)
			};
			array_push(_mock_entries, _entry);
		}
		
		// Create mock async response as ds_map
		var _mock_id = 8888 + irandom(1000);
		var _mock_async = ds_map_create();
		ds_map_add(_mock_async, "event_type", "leaderboard_download");
		ds_map_add(_mock_async, "id", _mock_id);
		ds_map_add(_mock_async, "status", 1); // Success
		ds_map_add(_mock_async, "entries", json_stringify({entries: _mock_entries}));
		
		// Store mock download ID for tracking
		if (leaderboard_name == global.leaderboard_name_singleplayer) {
			global.leaderboard_download_id_singleplayer = _mock_id;
		} else if (leaderboard_name == global.leaderboard_name_coop) {
			global.leaderboard_download_id_coop = _mock_id;
		}
		
		// Process immediately
		LeaderboardProcessDownloadCallback(_mock_async);
		
		// Clean up the ds_map
		ds_map_destroy(_mock_async);
		
		return _mock_id;
	}
	
	// Real Steam mode: check if initialized
	if (!steam_initialised()) {
		show_debug_message("Leaderboard: Steam not initialized, cannot download scores");
		return -1;
	}
	
	show_debug_message("Leaderboard: Downloading scores from " + leaderboard_name + " (ranks " + string(start_idx) + "-" + string(end_idx) + ")");
	
	var _download_id = steam_download_scores(leaderboard_name, start_idx, end_idx);
	
	// Store the download ID for tracking
	if (leaderboard_name == global.leaderboard_name_singleplayer) {
		global.leaderboard_download_id_singleplayer = _download_id;
	} else if (leaderboard_name == global.leaderboard_name_coop) {
		global.leaderboard_download_id_coop = _download_id;
	}
	
	return _download_id;
}

/// @desc Download top scores for both leaderboards
/// Downloads top 10 entries from both singleplayer and co-op leaderboards
function LeaderboardDownloadTopScores() {
	LeaderboardDownloadScores(global.leaderboard_name_singleplayer, 1, 10);
	LeaderboardDownloadScores(global.leaderboard_name_coop, 1, 10);
}

/// @desc Process leaderboard upload callback from Steam async event
/// @param {Struct} async_data The async_load map from Steam async event
/// @returns {Bool} True if this callback was handled, false otherwise
function LeaderboardProcessUploadCallback(async_data) {
	var _event_type = async_data[? "event_type"];
	if (_event_type != "leaderboard_upload") {
		return false;
	}
	
	var _post_id = async_data[? "post_id"];
	var _lb_name = async_data[? "lb_name"];
	var _success = async_data[? "success"];
	var _updated = async_data[? "updated"];
	var _score = async_data[? "score"];
	
	// Check if this is one of our tracked uploads
	var _is_our_upload = false;
	var _is_coop = false;
	
	if (_post_id == global.leaderboard_upload_id_singleplayer && _lb_name == global.leaderboard_name_singleplayer) {
		_is_our_upload = true;
		_is_coop = false;
		global.leaderboard_upload_id_singleplayer = -1; // Clear the ID
	} else if (_post_id == global.leaderboard_upload_id_coop && _lb_name == global.leaderboard_name_coop) {
		_is_our_upload = true;
		_is_coop = true;
		global.leaderboard_upload_id_coop = -1; // Clear the ID
	}
	
	if (!_is_our_upload) {
		return false;
	}
	
	// Handle the upload result
	if (_success) {
		if (_updated) {
			show_debug_message("Leaderboard: Score " + string(_score) + " uploaded successfully to " + _lb_name + " (updated leaderboard)");
		} else {
			show_debug_message("Leaderboard: Score " + string(_score) + " uploaded to " + _lb_name + " (not better than previous)");
		}
	} else {
		show_debug_message("Leaderboard: Failed to upload score to " + _lb_name);
	}
	
	return true;
}

/// @desc Process leaderboard download callback from Steam async event
/// @param {Struct} async_data The async_load map from Steam async event
/// @returns {Bool} True if this callback was handled, false otherwise
function LeaderboardProcessDownloadCallback(async_data) {
	var _event_type = async_data[? "event_type"];
	if (_event_type != "leaderboard_download") {
		return false;
	}
	
	var _async_id = async_data[? "id"];
	var _status = async_data[? "status"];
	
	// Check if this is one of our tracked downloads
	var _is_our_download = false;
	var _is_coop = false;
	
	if (_async_id == global.leaderboard_download_id_singleplayer) {
		_is_our_download = true;
		_is_coop = false;
		global.leaderboard_download_id_singleplayer = -1; // Clear the ID
	} else if (_async_id == global.leaderboard_download_id_coop) {
		_is_our_download = true;
		_is_coop = true;
		global.leaderboard_download_id_coop = -1; // Clear the ID
	}
	
	if (!_is_our_download) {
		return false;
	}
	
	// Check if download was successful
	if (_status == 0) {
		show_debug_message("Leaderboard: Failed to download scores");
		// Clear the leaderboard array
		if (_is_coop) {
			global.leaderboard_coop = [];
		} else {
			global.leaderboard_singleplayer = [];
		}
		return true;
	}
	
	// Parse the entries
	var _entries_json = async_data[? "entries"];
	if (is_undefined(_entries_json)) {
		show_debug_message("Leaderboard: No entries in download response");
		if (_is_coop) {
			global.leaderboard_coop = [];
		} else {
			global.leaderboard_singleplayer = [];
		}
		return true;
	}
	
	var _entries_struct = json_parse(_entries_json);
	var _entries_array = _entries_struct.entries;
	
	// Process entries into our format
	var _processed_entries = [];
	for (var i = 0; i < array_length(_entries_array); i++) {
		var _entry = _entries_array[i];
		var _processed_entry = {
			rank: _entry.rank,
			name: _entry.user, // Steam username
			score: _entry.score
		};
		array_push(_processed_entries, _processed_entry);
	}
	
	// Store in appropriate global array
	if (_is_coop) {
		global.leaderboard_coop = _processed_entries;
		show_debug_message("Leaderboard: Downloaded " + string(array_length(_processed_entries)) + " co-op entries");
	} else {
		global.leaderboard_singleplayer = _processed_entries;
		show_debug_message("Leaderboard: Downloaded " + string(array_length(_processed_entries)) + " singleplayer entries");
	}
	
	return true;
}

/// @desc Initialize leaderboards (create if they don't exist)
/// This should be called once when Steam is initialized
function LeaderboardInitialize() {
	// Skip initialization in dev mode if Steam is not initialized
	if (global.dev_mode && !steam_initialised()) {
		show_debug_message("Leaderboard [DEV MODE]: Skipping initialization (test mode active)");
		return;
	}
	
	if (!steam_initialised()) {
		show_debug_message("Leaderboard: Cannot initialize - Steam not initialized");
		return;
	}
	
	// Create leaderboards if they don't exist
	// Note: If they already exist, Steam will just return the existing ones
	steam_create_leaderboard(global.leaderboard_name_singleplayer, lb_sort_descending, lb_disp_numeric);
	steam_create_leaderboard(global.leaderboard_name_coop, lb_sort_descending, lb_disp_numeric);
	
	show_debug_message("Leaderboard: Initialized leaderboards");
}

/// @desc Check if leaderboard data is available
/// @param {Bool} is_coop Whether to check co-op (true) or singleplayer (false)
/// @returns {Bool} True if leaderboard data exists and has entries
function LeaderboardHasData(is_coop) {
	var _entries = is_coop ? global.leaderboard_coop : global.leaderboard_singleplayer;
	return array_length(_entries) > 0;
}