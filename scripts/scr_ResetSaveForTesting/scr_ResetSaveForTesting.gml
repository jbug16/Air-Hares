function ResetControlsToDefaultMappings() {
	InputInitDefaultMaps();
}

/// @desc Delete save files, reset in-memory save state, return to main menu.
function EraseAllSavedData() {
	SaveIniClose();

	var _erase = SaveEraseAllFiles();
	var _removed_save = _erase[0];
	var _removed_lb = _erase[1];
	
	// Reset save-backed globals immediately so the current runtime reflects the erase now.
	global.currency_cloud = 0;
	global.currency_feather_blue = 0;
	global.currency_feather_brown = 0;
	global.currency_feather_black = 0;
	global.currency_feather_purple = 0;
	global.currency_feather_hightop = 0;
	global.currency_feather_bigred = 0;
	global.currency_feather_goldgrip = 0;
	global.currency_feather_twinhorn = 0;
	
	global.story_mode_progress = 0;
	global.story_peaceful_intro_farm = false;
	global.tutorial_from_options = false;
	global.options_peaceful_practice = false;
	global.peaceful_practice_saved_level = 0;
	global.peaceful_practice_saved_progress = 0;
	global.main_menu_open_options = false;
	global.main_menu_open_options_tutorial_fade = false;
	// Match scr_Globals: full arcade only in dev; release = fresh (story progress reset above).
	global.arcade_max_unlocked = global.dev_mode ? 16 : 0;
	global.player_initials = "---";
	global.story_new_initials = "";
	global.arcade_new_initials = "";
	
	global.highscore = array_create(16, 0);
	global.highscore_initials = array_create(16, "");
	
	global.story_run_active = false;
	global.story_run_score_cumulative = 0;
	global.story_run_level_scores = array_create(16, 0);
	global.story_run_level_scores_set = array_create(16, false);
	global.story_run_initials = "";
	global.story_run_ever_coop = false;
	
	global.achievement_farm100 = array_create(16, false);
	global.achievement_no_damage = array_create(16, false);
	global.achievement_no_aggression = array_create(16, false);
	global.mission_ach_just_earned_farm100 = false;
	global.mission_ach_just_earned_no_damage = false;
	global.mission_ach_just_earned_no_aggression = false;
	global.mission_run_farm100_met = false;
	global.mission_run_no_damage_met = false;
	global.mission_run_no_aggression_met = false;
	
	global.leaderboard_singleplayer = [];
	global.leaderboard_coop = [];
	
	// Restore options defaults and apply immediately.
	global.options_music = 1;
	global.options_sfx = 1;
	global.options_scanline = OptionsDefaultScanline();
	global.options_windowed = true;
	global.options_res_w = OPTIONS_DESIGN_W;
	global.options_res_h = OPTIONS_DESIGN_H;
	if (SavePlatformIsSwitch()) {
		global.options_windowed = false;
	}
	OptionsDisplayApply();
	audio_group_set_gain(audiogroup_default, global.options_sfx, 0);
	audio_group_set_gain(audiogroup_music, global.options_music, 0);
	
	ResetControlsToDefaultMappings();
	
	show_debug_message("EraseAllSavedData: save_removed=" + string(_removed_save) + ", leaderboard_removed=" + string(_removed_lb));
	room_goto(rm_MainMenu);
}

/// Call from the debugger (Execute Code): ResetSaveForTesting();
function ResetSaveForTesting() {
	EraseAllSavedData();
}
