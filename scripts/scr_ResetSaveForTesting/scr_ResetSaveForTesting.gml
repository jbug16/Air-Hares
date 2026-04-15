/// @desc Delete save.sav + local story leaderboard JSON, then restart the game (re-runs scr_Globals).
function EraseAllSavedData() {
	ini_close();
	if (file_exists("save.sav")) {
		file_delete("save.sav");
	}
	var _lb = variable_global_exists("leaderboard_json_filename")
		? global.leaderboard_json_filename
		: "local_leaderboard_story_run.json";
	if (file_exists(_lb)) {
		file_delete(_lb);
	}
	show_debug_message("EraseAllSavedData: removed save files; game_restart()");
	game_restart();
}

/// Call from the debugger (Execute Code): ResetSaveForTesting();
function ResetSaveForTesting() {
	EraseAllSavedData();
}
