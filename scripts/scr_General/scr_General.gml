/*
	ArrayMultiply
*/

///@func ArrayMultiply(array, multiplier)
///@desc Multiplies all numerical members of the array with a multiplier. Members can be arrays as well (function is recursive). Doesn't work on data structure members!
///@arg array		{array} Array to multiply
///@arg multiplier	{num} Value to multiply with
///@return			{bool} If given arguments are not correct.
function ArrayMultiply(_array, _multiplier)
{
	if (!is_array(_array) or !is_numeric(_multiplier)) return false;	// check if array
	// Main multiply loop
	for (var i = array_length(_array) - 1; i >= 0; i--)
	{
		if is_array(_array[i]) ArrayMultiply(_array[i], _multiplier);	
		else if is_numeric(_array[i]) _array[i] *= _multiplier;
	}
	
	return true;
}


////////////////////////////////////////////////////////////////////////////////////
/* Options */

// Save story mode progress
function StoryProgressSave(){
	// Update arcade max if current progress exceeds it
	global.arcade_max_unlocked = max(global.arcade_max_unlocked, global.story_mode_progress);
	
	ini_open("save.sav");
	ini_write_real("story", "progress", global.story_mode_progress);
	ini_write_real("arcade", "max_unlocked", global.arcade_max_unlocked); // Save arcade max
	ini_close();
}

// Story Mode run tracking (cumulative full-run score for leaderboards)

/// @desc cumulative must equal sum of per-level scores in this run (fixes orphaned values in old saves)
function StoryRunReconcileCumulative() {
	var _sum = 0;
	for (var _i = 0; _i <= 15; _i++) {
		if (global.story_run_level_scores_set[_i]) {
			_sum += global.story_run_level_scores[_i];
		}
	}
	global.story_run_score_cumulative = _sum;
}

function StoryRunSave(){
	StoryRunReconcileCumulative();
	ini_open("save.sav");
	ini_write_real("story_run", "active", global.story_run_active ? 1 : 0);
	ini_write_real("story_run", "cumulative", global.story_run_score_cumulative);
	if (!is_string(global.story_run_initials)) global.story_run_initials = "";
	ini_write_string("story_run", "initials", global.story_run_initials);
	ini_write_real("story_run", "ever_coop", global.story_run_ever_coop ? 1 : 0);
	for (var i = 0; i <= 15; i += 1) {
		ini_write_real("story_run", "level_score_" + string(i), global.story_run_level_scores[i]);
		ini_write_real("story_run", "level_score_set_" + string(i), global.story_run_level_scores_set[i] ? 1 : 0);
	}
	ini_close();
}

function StoryRunReset(){
	global.story_run_active = false;
	global.story_run_score_cumulative = 0;
	global.story_run_initials = "";
	global.story_run_ever_coop = false;
	for (var i = 0; i <= 15; i += 1) {
		global.story_run_level_scores[i] = 0;
		global.story_run_level_scores_set[i] = false;
	}
	StoryRunSave();
}

function StoryRunStartNew(){
	global.story_run_active = true;
	global.story_run_ever_coop = false;
	global.story_run_score_cumulative = 0;
	for (var i = 0; i <= 15; i += 1) {
		global.story_run_level_scores[i] = 0;
		global.story_run_level_scores_set[i] = false;
	}
	StoryRunSave();
}

/// @desc Full story clear: push each level's story score into arcade high tables (with initials) so Free Mode shows the same bests / names.
function StoryRunPromoteScoresToArcade() {
	var _nm = global.story_run_initials;
	if (!is_string(_nm) || string_length(_nm) <= 0) _nm = global.player_initials;
	if (!is_string(_nm) || string_length(_nm) <= 0) _nm = "---";
	_nm = string_upper(_nm);
	if (string_length(_nm) > 3) _nm = string_copy(_nm, 1, 3);

	var _need_write = false;
	for (var i = 0; i <= 15; i++) {
		if (!global.story_run_level_scores_set[i]) continue;
		var _sc = global.story_run_level_scores[i];
		var _hs = global.highscore[i];
		var _cur = global.highscore_initials[i];
		var _blank = (!is_string(_cur) || string_length(_cur) <= 0);
		if (_sc > _hs || (_sc == _hs && _blank)) {
			global.highscore[i] = _sc;
			global.highscore_initials[i] = _nm;
			_need_write = true;
		}
	}
	if (!_need_write) return;
	ini_open("save.sav");
	for (var j = 0; j <= 15; j++) {
		ini_write_real("highscore", string(j), global.highscore[j]);
		ini_write_string("highscore_initials", string(j), global.highscore_initials[j]);
	}
	ini_close();
}

/// @desc Leave "New Story Game" initials screen; return to Continue/New/Back popup
function StoryPopupExitNewGameScreen() {
	global.story_popup_screen = 0;
	global.story_new_initials = "";
	with (obj_StoryBtnPlay) visible = true;
	ModesBtnPopupSetAlarm2(-1);
}

/// @desc obj_ModesBtnPAR has no instances; story/arcade buttons are subclasses. with(ModesBtnPAR) skips them.
function ModesBtnPopupUnhoverAll() {
	with (obj_StoryBtnContinue) {
		if (focus) event_user(2);
	}
	with (obj_StoryBtnPlay) {
		if (focus) event_user(2);
	}
	with (obj_StoryBtnBack) {
		if (focus) event_user(2);
	}
	with (obj_FreeModeBtnPlay) {
		if (focus) event_user(2);
	}
	with (obj_FreeModeBtnBack) {
		if (focus) event_user(2);
	}
	with (obj_ModesBtnPAR) {
		if (focus) event_user(2);
	}
}

function ModesBtnPopupButtonCount() {
	return instance_number(obj_StoryBtnContinue) + instance_number(obj_StoryBtnPlay) + instance_number(obj_StoryBtnBack)
		+ instance_number(obj_FreeModeBtnPlay) + instance_number(obj_FreeModeBtnBack) + instance_number(obj_ModesBtnPAR);
}

/// @param {real} _except_inst Instance id to skip (keyboard nav: current button)
function ModesBtnPopupFocusByButtonId(_sel, _except_inst) {
	with (obj_StoryBtnContinue) {
		if (id != _except_inst && button_id == _sel) event_user(1);
	}
	with (obj_StoryBtnPlay) {
		if (id != _except_inst && button_id == _sel) event_user(1);
	}
	with (obj_StoryBtnBack) {
		if (id != _except_inst && button_id == _sel) event_user(1);
	}
	with (obj_FreeModeBtnPlay) {
		if (id != _except_inst && button_id == _sel) event_user(1);
	}
	with (obj_FreeModeBtnBack) {
		if (id != _except_inst && button_id == _sel) event_user(1);
	}
	with (obj_ModesBtnPAR) {
		if (id != _except_inst && button_id == _sel) event_user(1);
	}
}

function ModesBtnPopupSetAlarm2(_val) {
	with (obj_StoryBtnContinue) alarm[2] = _val;
	with (obj_StoryBtnPlay) alarm[2] = _val;
	with (obj_StoryBtnBack) alarm[2] = _val;
	with (obj_FreeModeBtnPlay) alarm[2] = _val;
	with (obj_FreeModeBtnBack) alarm[2] = _val;
	with (obj_ModesBtnPAR) alarm[2] = _val;
}

function ArcadePopupUnfocusButtons() {
	with (obj_FreeModeBtnPlay) {
		if (focus) event_user(2);
	}
	with (obj_FreeModeBtnBack) {
		if (focus) event_user(2);
	}
}

/// @desc True when Play/Back have menu focus (blocks initials typing on arcade screen 1)
function ArcadePopupAnyButtonFocused() {
	if (global.arcade_popup_screen != 1) return false;
	var _f = false;
	with (obj_FreeModeBtnPlay) {
		if (focus) _f = true;
	}
	with (obj_FreeModeBtnBack) {
		if (focus) _f = true;
	}
	return _f;
}

function ArcadePopupFocusPlayButton() {
	ArcadePopupUnfocusButtons();
	with (obj_FreeModeBtnPlay) {
		event_user(1);
	}
	ModesBtnPopupSetAlarm2(1);
}

function ArcadePopupFocusBackButton() {
	ArcadePopupUnfocusButtons();
	with (obj_FreeModeBtnBack) {
		event_user(1);
	}
	ModesBtnPopupSetAlarm2(1);
}

function StoryNewGameUnfocusButtons() {
	with (obj_StoryBtnContinue) {
		if (focus) event_user(2);
	}
	with (obj_StoryBtnBack) {
		if (focus) event_user(2);
	}
	// NEW is hidden on initials screen but can still hold focus from the click that opened it; Enter would re-fire Other_10.
	with (obj_StoryBtnPlay) {
		if (focus) event_user(2);
	}
}

function StoryNewGameAnyButtonFocused() {
	if (global.story_popup_screen != 1) return false;
	var _f = false;
	with (obj_StoryBtnContinue) {
		if (focus) _f = true;
	}
	with (obj_StoryBtnBack) {
		if (focus) _f = true;
	}
	return _f;
}

function StoryNewGameFocusContinue() {
	StoryNewGameUnfocusButtons();
	with (obj_StoryBtnContinue) {
		event_user(1);
	}
	ModesBtnPopupSetAlarm2(1);
}

function StoryNewGameFocusBack() {
	StoryNewGameUnfocusButtons();
	with (obj_StoryBtnBack) {
		event_user(1);
	}
	ModesBtnPopupSetAlarm2(1);
}

/// @desc Leave arcade initials step; return to level summary + Play/Back
function ArcadePopupExitInitialsScreen() {
	global.arcade_popup_screen = 0;
	global.arcade_new_initials = "";
	with (obj_FreeModeBtnPlay) text = "PLAY";
	ArcadePopupFocusPlayButton();
}

// Advance level, save progress.
function AdvanceLevel() {
	// Increment current level
	global.current_level++;
	
	// Update story progress (only if we've progressed further than before)
	global.story_mode_progress = max(global.story_mode_progress, global.current_level);
	
	// Save to file
	StoryProgressSave();
	
	return true;
}

/* Transition with art */
function TransitionGoto(_target){
	// Go to transition art room
	
	prst_Transition.trans_target = _target;
	prst_Transition.trans_trigger = true;
}

// BGM change function
function AudioBgmChange(_bgm){
	// No bgm selected. Return false
	if (_bgm == noone) 
	{	
		audio_stop_sound(global.bgm_playing);
		global.bgm_playing = _bgm;
		return false;
	}
	
	// If bgm selected. Will return true.
	if (global.bgm_playing != noone) audio_stop_sound(global.bgm_playing);	// When a bgm is already playing
	audio_play_sound(_bgm, 1, true);
	global.bgm_playing = _bgm;
	return true;
}

// Data structure
function Profile() constructor{
	stat = {
		fortune		: 0,
		foresight	: 0,
		fortitude	: 0,
		
		fortitude_roll : function(){
			if random(1) < fortitude * (0.17) return true;	
			return false;
		}
	}
	
	stat_load		= function(){
		ini_open("save.sav");
		stat.fortune = ini_read_real("stats", "fortune", 0);
		stat.foresight = ini_read_real("stats", "foresight", 0);
		stat.fortitude = ini_read_real("stats", "fortitude", 0);
		ini_close();
	}
	stat_save		= function(){
		ini_open("save.sav");
		ini_write_real("stats", "fortune", stat.fortune);
		ini_write_real("stats", "foresight", stat.foresight);
		ini_write_real("stats", "fortitude", stat.fortitude);
		ini_close();
	}
	stat_reset		= function(){
		stat.fortune	= 0;
		stat.foresight	= 0;
		stat.fortitude	= 0;
		stat_save();
	}
}