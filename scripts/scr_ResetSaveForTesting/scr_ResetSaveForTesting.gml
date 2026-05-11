function ResetControlsToDefaultMappings() {
	if (variable_global_exists("keymap") && ds_exists(global.keymap, ds_type_map)) {
		ds_map_destroy(global.keymap);
	}
	if (variable_global_exists("gpmap") && ds_exists(global.gpmap, ds_type_map)) {
		ds_map_destroy(global.gpmap);
	}
	
	// Keyboard defaults
	global.keymap = ds_map_create();
	global.keymap[? INPUT.ANY] = [vk_anykey];
	global.keymap[? INPUT.DOWN] = [vk_down];
	global.keymap[? INPUT.LEFT] = [vk_left];
	global.keymap[? INPUT.PARRY] = [ord("Q")];
	global.keymap[? INPUT.RIGHT] = [vk_right];
	global.keymap[? INPUT.SEED] = [vk_space];
	global.keymap[? INPUT.UP] = [vk_up];
	global.keymap[? INPUT.SHIFT] = [vk_shift];
	global.keymap[? INPUT.WATER] = [ord("E")];
	global.keymap[? INPUT.PAUSE] = [vk_escape];
	global.keymap[? INPUT.LOOP_DE_LOOP] = [ord("Q"), vk_shift];
	global.keymap[? INPUT.ROLL_LEFT] = [vk_left, vk_shift];
	global.keymap[? INPUT.ROLL_RIGHT] = [vk_right, vk_shift];
	global.keymap[? INPUT.MENU_SELECT] = [vk_enter, vk_space];
	global.keymap[? INPUT.MENU_UP] = [vk_up];
	global.keymap[? INPUT.MENU_DOWN] = [vk_down];
	global.keymap[? INPUT.MENU_LEFT] = [vk_left];
	global.keymap[? INPUT.MENU_RIGHT] = [vk_right];
	global.keymap[? INPUT.TOGGLE_AIM] = [vk_enter];
	
	// Gamepad defaults
	global.gpmap = ds_map_create();
	global.gpmap[? INPUT.SEED] = [gp_face1];
	global.gpmap[? INPUT.WATER] = [gp_face2];
	global.gpmap[? INPUT.PARRY] = [gp_face3];
	global.gpmap[? INPUT.UP] = [gp_padu];
	global.gpmap[? INPUT.DOWN] = [gp_padd];
	global.gpmap[? INPUT.LEFT] = [gp_padl];
	global.gpmap[? INPUT.RIGHT] = [gp_padr];
	global.gpmap[? INPUT.PAUSE] = [gp_start, gp_face2];
	global.gpmap[? INPUT.LOOP_DE_LOOP] = [gp_face4];
	global.gpmap[? INPUT.MENU_SELECT] = [gp_face1];
	global.gpmap[? INPUT.MENU_UP] = [gp_padu];
	global.gpmap[? INPUT.MENU_DOWN] = [gp_padd];
	global.gpmap[? INPUT.MENU_LEFT] = [gp_padl];
	global.gpmap[? INPUT.MENU_RIGHT] = [gp_padr];
	global.gpmap[? INPUT.ROLL_RIGHT] = [gp_shoulderrb];
	global.gpmap[? INPUT.ROLL_LEFT] = [gp_shoulderlb];
	global.gpmap[? INPUT.TOGGLE_AIM] = [gp_shoulderr];
}

/// @desc Delete save files, reset in-memory save state, return to main menu.
function EraseAllSavedData() {
	ini_close();
	
	var _save_name = "save.sav";
	var _lb_name = variable_global_exists("leaderboard_json_filename")
		? global.leaderboard_json_filename
		: "local_leaderboard_story_run.json";
	
	// Try safe built-in locations used by desktop runtimes.
	var _save_paths = [
		_save_name,
		program_directory + _save_name,
		working_directory + _save_name
	];
	var _lb_paths = [
		_lb_name,
		program_directory + _lb_name,
		working_directory + _lb_name
	];
	
	var _removed_save = false;
	for (var i = 0; i < array_length(_save_paths); i++) {
		if (file_exists(_save_paths[i])) {
			file_delete(_save_paths[i]);
			_removed_save = true;
		}
	}
	
	var _removed_lb = false;
	for (var j = 0; j < array_length(_lb_paths); j++) {
		if (file_exists(_lb_paths[j])) {
			file_delete(_lb_paths[j]);
			_removed_lb = true;
		}
	}
	
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
	global.arcade_max_unlocked = 16;
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
	global.options_scanline = 1;
	global.options_windowed = true;
	global.options_res_w = 1280;
	global.options_res_h = 720;
	window_set_fullscreen(false);
	window_set_size(global.options_res_w, global.options_res_h);
	audio_group_set_gain(audiogroup_default, global.options_sfx, 0);
	audio_group_set_gain(audiogroup_music, global.options_music, 0);
	
	// Ensure keyboard/gamepad input maps are valid after erase.
	ResetControlsToDefaultMappings();
	
	show_debug_message("EraseAllSavedData: save_removed=" + string(_removed_save) + ", leaderboard_removed=" + string(_removed_lb));
	room_goto(rm_MainMenu);
}

/// Call from the debugger (Execute Code): ResetSaveForTesting();
function ResetSaveForTesting() {
	EraseAllSavedData();
}
