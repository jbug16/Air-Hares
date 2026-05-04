/// @desc
text = "";
text_time = "";
text_total= "";
text_highscore = "";
color = c_white;
font = fnt_Federo16;
sep = 36;
w = 1280;
y -= 64;
image_yscale = 0;
score_base = global.score_base;
score_time = 14000 - obj_ControllerPAR.time_elapsed;
score_total = score_base + score_time;
crops_filled = "X";

// Track if this run set a new highscore
new_highscore = false;


// Update per-level highscore only in Arcade mode (Story uses cumulative run leaderboard)
if (global.game_mode == GAMEMODE.FREE && score_total > global.highscore[global.level_highscore]) {
	var _lv = global.level_highscore;
	global.highscore[_lv] = score_total;
	var _nm = global.player_initials;
	if (!is_string(_nm) || string_length(_nm) <= 0) _nm = "---";
	_nm = string_upper(_nm);
	if (string_length(_nm) > 3) _nm = string_copy(_nm, 1, 3);
	global.highscore_initials[_lv] = _nm;
	ini_open("save.sav");
	ini_write_real("highscore", string(_lv), global.highscore[_lv]);
	ini_write_string("highscore_initials", string(_lv), _nm);
	ini_close();
	new_highscore = true;
}
score_highscore = global.highscore[global.level_highscore];

// Story Mode cumulative run tracking:
// - Store the latest successful score per level in the current run
// - Maintain a running cumulative total
// - Upload once when the full story completes (initials were set at new-game start)
if (global.game_mode == GAMEMODE.STORY && global.story_run_active) {
	var _level_idx = global.level_highscore;
	var _old = 0;
	if (global.story_run_level_scores_set[_level_idx]) {
		_old = global.story_run_level_scores[_level_idx];
	}

	global.story_run_level_scores[_level_idx] = score_total;
	if (!global.story_run_level_scores_set[_level_idx]) {
		global.story_run_level_scores_set[_level_idx] = true;
	}
	global.story_run_score_cumulative += (score_total - _old);

	// Persist progress so quitting mid-run won't lose the cumulative score
	StoryRunSave();

	// Mission UI "Highscore:" row tracks arcade per-level in FREE mode; in Story it must show run total
	score_highscore = global.story_run_score_cumulative;

	// When the last level is cleared, progress is incremented to 16 before we create this UI.
	if (global.story_mode_progress >= 16) {
		var _is_coop = global.story_run_ever_coop || obj_ControllerPAR.multiplayer_status[1][MPPROP.JOINED];
		var _name = global.story_run_initials;
		if (!is_string(_name) || string_length(_name) <= 0) _name = global.player_initials;
		if (!is_string(_name) || string_length(_name) <= 0) _name = "---";
		if (string_length(_name) > 3) _name = string_copy(_name, 1, 3);

		var _lb_pre = LeaderboardReadRawData();
		var _ent_pre = _is_coop ? _lb_pre.coop : _lb_pre.singleplayer;
		var _best_pre = 0;
		for (var _pi = 0; _pi < array_length(_ent_pre); _pi++) {
			_best_pre = max(_best_pre, _ent_pre[_pi].score);
		}
		new_highscore = (round(global.story_run_score_cumulative) > _best_pre);

		LeaderboardUploadScore(global.story_run_score_cumulative, _is_coop, _name);
		StoryRunReset();
	}
}

display_score = 0;
display_score_time = 0;
display_score_total = 0;
display_highscore = 0;

TweenStart("image_yscale", 0, 1, 0.5*GAMESPD, TWEENTYPE.QUAD_OUT);

// Medal carrots — this clear only (replay shows empty/filled from this run, not save file)
mission_run_met = array_create(3, false);
mission_run_met[0] = global.mission_run_farm100_met;
mission_run_met[1] = global.mission_run_no_damage_met;
mission_run_met[2] = global.mission_run_no_aggression_met;
mission_hide_farm100 = (global.level_highscore mod 4 == 3);
if (mission_hide_farm100) {
	// Boss levels have no crops to fill, so never show the farm medal slot.
	mission_run_met[0] = false;
}
MissionRunMedalClearAfterRead();
MissionAchPopupClearFlags();

mission_ach_phase = array_create(3, 0);
mission_ach_anim = array_create(3, 0);
mission_ach_tally_step = 0;