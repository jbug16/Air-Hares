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

/// @desc Last story level index included in the demo (1-B).
function DemoMaxLevelIndex() {
	return 3;
}

/// @desc Story progress after clearing all demo levels (level indices stay 0..DemoMaxLevelIndex).
function DemoMaxProgress() {
	return 4;
}

/// @desc Clamp saved/unlocked progress for demo builds.
function DemoApplyProgressCaps() {
	if (!global.demo) return;
	global.story_mode_progress = clamp(global.story_mode_progress, 0, DemoMaxProgress());
	global.arcade_max_unlocked = clamp(global.arcade_max_unlocked, 0, DemoMaxProgress());
	// Arcade unlocks follow story progress (same as full game), capped at stage 1.
	global.arcade_max_unlocked = min(global.arcade_max_unlocked, global.story_mode_progress);
}

/// @desc Clamp a level index to demo playable range.
function DemoClampLevelIndex(_level_index) {
	if (!global.demo) return _level_index;
	return clamp(_level_index, 0, DemoMaxLevelIndex());
}

/// @desc Co-op portrait slot (0 = Dirk) selectable in demo builds.
function CoopPortraitSelectSlotAvailable(_slot) {
	if (!global.demo) return true;
	return _slot == 0;
}

/// @desc Main menu: Story..Exit (1-4) then social icons (5-7), left-to-right wrap order.
function TitleMainVisibleButtonIds() {
	return [1, 2, 3, 4, 5, 6, 7];
}

// Save story mode progress
function StoryProgressSave(){
	// Update arcade max if current progress exceeds it
	global.arcade_max_unlocked = max(global.arcade_max_unlocked, global.story_mode_progress);
	if (global.demo) DemoApplyProgressCaps();
	
	SaveIniOpen();
	SaveIniWriteReal("story", "progress", global.story_mode_progress);
	SaveIniWriteReal("arcade", "max_unlocked", global.arcade_max_unlocked); // Save arcade max
	// Keep medal section in the same write pass (avoids INI merge issues with separate opens)
	for (var _m = 0; _m <= 15; _m += 1) {
		SaveIniWriteReal("achievements", "farm100_" + string(_m), global.achievement_farm100[_m] ? 1 : 0);
		SaveIniWriteReal("achievements", "nodamage_" + string(_m), global.achievement_no_damage[_m] ? 1 : 0);
		SaveIniWriteReal("achievements", "noaggro_" + string(_m), global.achievement_no_aggression[_m] ? 1 : 0);
	}
	SaveIniClose();
}

/// @desc Reset per-run flags for level-based medals (call at level start)
function LevelRunMedalsReset() {
	global.level_run_any_hp_damage = false;
	global.level_run_ammo_aggression = false;
}

/// @desc Clear "new medal this clear" flags before awarding medals for a stage (mission UI reads them after)
function MissionAchPopupClearFlags() {
	global.mission_ach_just_earned_farm100 = false;
	global.mission_ach_just_earned_no_damage = false;
	global.mission_ach_just_earned_no_aggression = false;
}

/// @desc Snapshot this clear’s challenge results for the mission score UI (replay-safe; not save state)
function MissionRunMedalSet(_farm100, _no_damage, _no_aggression) {
	global.mission_run_farm100_met = _farm100;
	global.mission_run_no_damage_met = _no_damage;
	global.mission_run_no_aggression_met = _no_aggression;
}

function MissionRunMedalClearAfterRead() {
	global.mission_run_farm100_met = false;
	global.mission_run_no_damage_met = false;
	global.mission_run_no_aggression_met = false;
}

/// @desc During boss intro (sequence 0 falcon waves, before boss flies in), register an HP hit for wave-repeat logic.
function BossIntroPrepWaveRegisterPlayerHit() {
	if (instance_exists(obj_BossHighTop) && obj_BossHighTop.sequence == 0)
		obj_BossHighTop.prep_wave_took_hp_hit = true;
	if (instance_exists(obj_BossBigRed) && obj_BossBigRed.sequence == 0)
		obj_BossBigRed.prep_wave_took_hp_hit = true;
	if (instance_exists(obj_EnemyGoldGripSpawner) && obj_EnemyGoldGripSpawner.sequence == 0)
		obj_EnemyGoldGripSpawner.prep_wave_took_hp_hit = true;
	if (instance_exists(obj_EnemyTwinhornSpawner) && obj_EnemyTwinhornSpawner.sequence == 0)
		obj_EnemyTwinhornSpawner.prep_wave_took_hp_hit = true;
}

/// @desc Mark no-aggression medal failed if instance is player seed or water projectile
function LevelRunRegisterAmmoAggressionIfPlayerProjectile(_inst) {
	if (!instance_exists(_inst)) return;
	if (variable_instance_exists(_inst, "from_parry") && _inst.from_parry) return;
	var _oi = _inst.object_index;
	if (_oi == obj_PlayerProjectileSeed || _oi == obj_PlayerProjectileWater) {
		global.level_run_ammo_aggression = true;
		show_debug_message("[Medal] No-aggression challenge failed (seed/water hit combat target).");
	}
}

/// @desc Persist per-level medal flags (100% farm, no damage, no aggression) to save.sav
function AchievementFarm100Save() {
	SaveIniOpen();
	for (var _i = 0; _i <= 15; _i += 1) {
		SaveIniWriteReal("achievements", "farm100_" + string(_i), global.achievement_farm100[_i] ? 1 : 0);
		SaveIniWriteReal("achievements", "nodamage_" + string(_i), global.achievement_no_damage[_i] ? 1 : 0);
		SaveIniWriteReal("achievements", "noaggro_" + string(_i), global.achievement_no_aggression[_i] ? 1 : 0);
	}
	SaveIniClose();
}

/// @desc Reload per-level medal flags from save.sav into globals (e.g. before drawing Achievements UI)
function AchievementsLoadFromSave() {
	SaveIniOpen();
	for (var _af = 0; _af <= 15; _af += 1) {
		global.achievement_farm100[_af] = bool(SaveIniReadReal("achievements", "farm100_" + string(_af), 0));
		global.achievement_no_damage[_af] = bool(SaveIniReadReal("achievements", "nodamage_" + string(_af), 0));
		global.achievement_no_aggression[_af] = bool(SaveIniReadReal("achievements", "noaggro_" + string(_af), 0));
	}
	SaveIniClose();
}

/// @desc Mark a medal unlocked for a story level and print a debug line.
/// @param {string} _medal_key "farm100", "no_damage", or "no_aggression"
/// @param {real} _level_index Story level index (0-15)
/// @param {string} _context Optional debug suffix (e.g. "(boss clear)")
/// @return {bool} True only when this call newly unlocked the medal
function AchievementMarkUnlocked(_medal_key, _level_index, _context) {
	var _idx = clamp(_level_index, 0, 15);
	var _context_txt = "";
	if (is_string(_context) && string_length(_context) > 0) {
		_context_txt = " " + _context;
	}
	var _changed = false;
	var _label = "";
	switch (_medal_key) {
		case "farm100":
			_label = "Farm 100%";
			if (!global.achievement_farm100[_idx]) {
				global.achievement_farm100[_idx] = true;
				_changed = true;
				global.mission_ach_just_earned_farm100 = true;
			}
		break;
		
		case "no_damage":
			_label = "No-damage";
			if (!global.achievement_no_damage[_idx]) {
				global.achievement_no_damage[_idx] = true;
				_changed = true;
				global.mission_ach_just_earned_no_damage = true;
			}
		break;
		
		case "no_aggression":
			_label = "No-aggression";
			if (!global.achievement_no_aggression[_idx]) {
				global.achievement_no_aggression[_idx] = true;
				_changed = true;
				global.mission_ach_just_earned_no_aggression = true;
			}
		break;
		
		default:
			show_debug_message("[Medal] Unknown medal key '" + string(_medal_key) + "' at level index " + string(_idx) + _context_txt + ".");
			return false;
	}
	
	if (_changed) {
		show_debug_message("[Medal] " + _label + " earned for level index " + string(_idx) + _context_txt + ".");
	} else {
		show_debug_message("[Medal] " + _label + " already unlocked for level index " + string(_idx) + _context_txt + ".");
	}
	return _changed;
}

/// @desc Display name for story/arcade popups: e.g. "Barren Bunlands 1-1" or "Hopeful Hareway 2-B"
function StoryLevelPopupTitle(_level_index) {
	if (_level_index < 0 || _level_index > 15) return "";
	var _name = global.story_mode_level[_level_index][STORYPROP.NAME];
	var _stage = (_level_index div 4) + 1;
	var _col = _level_index mod 4;
	var _sub = (_col == 3) ? "B" : string(_col + 1);
	return _name + " " + string(_stage) + "-" + _sub;
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
	SaveIniOpen();
	SaveIniWriteReal("story_run", "active", global.story_run_active ? 1 : 0);
	SaveIniWriteReal("story_run", "cumulative", global.story_run_score_cumulative);
	if (!is_string(global.story_run_initials)) global.story_run_initials = "";
	SaveIniWriteString("story_run", "initials", global.story_run_initials);
	SaveIniWriteReal("story_run", "ever_coop", global.story_run_ever_coop ? 1 : 0);
	for (var i = 0; i <= 15; i += 1) {
		SaveIniWriteReal("story_run", "level_score_" + string(i), global.story_run_level_scores[i]);
		SaveIniWriteReal("story_run", "level_score_set_" + string(i), global.story_run_level_scores_set[i] ? 1 : 0);
	}
	SaveIniClose();
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

/// @desc True when Story main menu should offer Continue (persisted progress, active run, or mid-new-game intro).
function StoryHasMainMenuContinue() {
	return global.story_mode_progress > 0 || global.story_run_active || global.story_peaceful_intro_farm;
}

/// @desc Left-to-right visible popup buttons for the active story/arcade frame only.
function ModesBtnPopupVisibleOrderedIds() {
	var _a = [];
	if (instance_exists(obj_StoryModeFrame)) {
		with (obj_StoryBtnContinue) {
			if (visible) array_push(_a, button_id);
		}
		with (obj_StoryBtnPlay) {
			if (visible) array_push(_a, button_id);
		}
		with (obj_StoryBtnBack) {
			if (visible) array_push(_a, button_id);
		}
	}
	if (instance_exists(obj_FreeModeFrame)) {
		with (obj_FreeModeBtnPlay) {
			if (visible) array_push(_a, button_id);
		}
		with (obj_FreeModeBtnBack) {
			if (visible) array_push(_a, button_id);
		}
	}
	return _a;
}

/// @desc Left-to-right: visible story popup row (Continue=1, New=2, Back=3).
function ModesBtnPopupStoryMainVisibleOrderedIds() {
	return ModesBtnPopupVisibleOrderedIds();
}

/// @param {array} _ids
/// @param {real} _cur button_id
/// @param {real} _dir -1 or +1
function ModesBtnPopupStoryMainNavWrap(_ids, _cur, _dir) {
	var _len = array_length(_ids);
	if (_len <= 0) return _cur;
	var _idx = 0;
	for (var _i = 0; _i < _len; _i++) {
		if (_ids[_i] == _cur) {
			_idx = _i;
			break;
		}
	}
	var _next = _idx + _dir;
	while (_next < 0) _next += _len;
	while (_next >= _len) _next -= _len;
	return _ids[_next];
}

/// @desc Leave "New Story Game" initials screen; return to Continue/New/Back popup
function StoryPopupExitNewGameScreen() {
	global.story_popup_screen = 0;
	global.story_new_initials = "";
	with (obj_StoryBtnPlay) visible = true;
	with (obj_StoryBtnContinue) visible = StoryHasMainMenuContinue();
	
	ModesBtnPopupUnhoverAll();
	if (StoryHasMainMenuContinue()) {
		with (obj_StoryBtnContinue) event_user(1);
	} else {
		with (obj_StoryBtnPlay) event_user(1);
	}
	ModesBtnPopupSetAlarm2(1);
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
		if (id != _except_inst && button_id == _sel && visible && instance_exists(obj_StoryModeFrame)) event_user(1);
	}
	with (obj_StoryBtnPlay) {
		if (id != _except_inst && button_id == _sel && visible && instance_exists(obj_StoryModeFrame)) event_user(1);
	}
	with (obj_StoryBtnBack) {
		if (id != _except_inst && button_id == _sel && visible && instance_exists(obj_StoryModeFrame)) event_user(1);
	}
	with (obj_FreeModeBtnPlay) {
		if (id != _except_inst && button_id == _sel && visible && instance_exists(obj_FreeModeFrame)) event_user(1);
	}
	with (obj_FreeModeBtnBack) {
		if (id != _except_inst && button_id == _sel && visible && instance_exists(obj_FreeModeFrame)) event_user(1);
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

/// @desc First farm mission after story tutorial: teach crops only (no falcons, score, or medals).
function StoryPeacefulIntroFarmActive() {
	return global.game_mode == GAMEMODE.STORY && global.story_peaceful_intro_farm;
}

/// @desc Leaving options tutorial practice mid-run or via Main Menu: restore story indices and reopen Options.
function OptionsPeacefulPracticeAbortToMenu() {
	if (!global.options_peaceful_practice) return;
	global.current_level = global.peaceful_practice_saved_level;
	global.story_mode_progress = global.peaceful_practice_saved_progress;
	global.options_peaceful_practice = false;
	global.story_peaceful_intro_farm = false;
	global.main_menu_open_options = true;
}

/// @desc Options practice: SKIP on pre-screen — same return as finishing tutorial cards (fade into Options), not Title Back.
function OptionsPeacefulPracticeAbortFromPreScreenSkip() {
	if (!global.options_peaceful_practice) return;
	global.current_level = global.peaceful_practice_saved_level;
	global.story_mode_progress = global.peaceful_practice_saved_progress;
	global.options_peaceful_practice = false;
	global.story_peaceful_intro_farm = false;
	global.main_menu_open_options_tutorial_fade = true;
}

/// @desc Match obj_Tutorial/Other_11 when reopening Options on rm_MainMenu (dim title, fade in Options UI).
function MainMenuOpenOptionsWithTutorialFade() {
	with (all) {
		if (!persistent) instance_deactivate_object(id);
	}
	layer_set_visible("Background_Options", true);
	// Match obj_Tutorial Create: tutorial_exit_fade_dur = 1 * GAMESPD
	var _in_d = ceil(1 * GAMESPD);
	var _oc = instance_create_layer(0.3 * room_width, 0.5 * room_height, "Instances", obj_OptionsController);
	with (_oc) {
		image_alpha = 0;
		TweenStart("image_alpha", 0, 1, _in_d, TWEENTYPE.LINEAR);
	}
	var _ot = instance_create_layer(0.5 * room_width, 0.1 * room_height, "Instances", obj_OptionsTitle);
	with (_ot) {
		image_alpha = 0;
		TweenStart("image_alpha", 0, 1, _in_d, TWEENTYPE.LINEAR);
	}
}

/// @param _skip_peaceful_tutorial true = SKIP (normal combat 1-1); false = PLAY tutorial farm
function PreScreenBeginLevelFromChoice(_skip_peaceful_tutorial) {
	if (_skip_peaceful_tutorial) global.story_peaceful_intro_farm = false;
	with (obj_PreScreen) {
		if (room == rm_LevelX1Farm) instance_create_layer(0, 0, layer, obj_ControllerFarm);
		else if (room == rm_Level1_3FightBoss) instance_create_layer(0, 0, layer, obj_ControllerFightBoss1_3);
		else if (room == rm_Level2_3FightBoss) instance_create_layer(0, 0, layer, obj_ControllerFightBoss2_3);
		else if (room == rm_Level3_3FightBoss) instance_create_layer(0, 0, layer, obj_ControllerFightBoss3_3);
		else if (room == rm_Level4_3FightBoss) instance_create_layer(0, 0, layer, obj_ControllerFightBoss4_3);
		if (room != rm_Level4_3FightBoss) instance_create_layer(0, 0, "Top_Weather", obj_WindParticles);
		instance_create_layer(x, 608, "Instances", obj_PlayerRabboSpawner);
		LevelRunMedalsReset();
		instance_destroy();
	}
}

/// @desc After tutorial PLAY/SKIP: PLAY = fade out then peaceful farm; SKIP = normal pre-screen patrol + real 1-1 (options practice SKIP = same return as tutorial cards → Options).
function PreScreenArmDelayedStart(_clear_peaceful_first) {
	if (_clear_peaceful_first && global.options_peaceful_practice) {
		OptionsPeacefulPracticeAbortFromPreScreenSkip();
		with (obj_PreScreenTutorialBtnPlay) instance_destroy();
		with (obj_PreScreenTutorialBtnSkip) instance_destroy();
		with (obj_PreScreen) instance_destroy();
		room_goto(rm_MainMenu);
		return;
	}
	if (_clear_peaceful_first) global.story_peaceful_intro_farm = false;
	with (obj_PreScreen) {
		wait_tutorial_choice = false;
		if (_clear_peaceful_first) {
			txt = global.story_mode_level[global.current_level][STORYPROP.NAME];
		}
		with (obj_PreScreenTutorialBtnPlay) instance_destroy();
		with (obj_PreScreenTutorialBtnSkip) instance_destroy();
		TweenStop(id, "image_alpha");
		if (_clear_peaceful_first) {
			alarm[0] = fade_len;
			image_alpha = 0;
			TweenStart("image_alpha", 0, 1, fade_len / 2, TWEENTYPE.SINE_OUT, 0, TWEENREPEAT.PATROL, 2);
		} else {
			var _fade_out = ceil(fade_len / 2);
			TweenStart("image_alpha", image_alpha, 0, _fade_out, TWEENTYPE.SINE_OUT, 0, TWEENREPEAT.RETWEEN, 1);
			alarm[0] = _fade_out;
		}
	}
}

// Advance level, save progress.
function AdvanceLevel() {
	// Increment current level
	global.current_level++;
	
	// Update story progress (only if we've progressed further than before)
	global.story_mode_progress = max(global.story_mode_progress, global.current_level);
	if (global.demo) {
		global.story_mode_progress = min(global.story_mode_progress, DemoMaxProgress());
	}
	
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
		SaveIniOpen();
		stat.fortune = SaveIniReadReal("stats", "fortune", 0);
		stat.foresight = SaveIniReadReal("stats", "foresight", 0);
		stat.fortitude = SaveIniReadReal("stats", "fortitude", 0);
		SaveIniClose();
	}
	stat_save		= function(){
		SaveIniOpen();
		SaveIniWriteReal("stats", "fortune", stat.fortune);
		SaveIniWriteReal("stats", "foresight", stat.foresight);
		SaveIniWriteReal("stats", "fortitude", stat.fortitude);
		SaveIniClose();
	}
	stat_reset		= function(){
		stat.fortune	= 0;
		stat.foresight	= 0;
		stat.fortitude	= 0;
		stat_save();
	}
}