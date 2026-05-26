/// @desc

image_xscale = 0.45
image_yscale = 0;
TweenStart("image_yscale", 0, 0.45, 0.5*GAMESPD, TWEENTYPE.QUAD_OUT);

// Fade out/in audio
AudioBgmChange(noone);
sound = audio_play_sound(snd_MissionFailed, 1, false);
text = "";
text_time = "";
text_total= "";
text_highscore = "";
color = c_white;
font = fnt_Federo16;
sep = 36;
w = 1280;

y_draw = 0.5*room_height + 24;

txt_yscale = 0;
score_base = global.score_base;
score_time = 14000 - obj_ControllerPAR.time_elapsed;
score_total = score_base + score_time;
crops_filled = 0;

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
	SaveIniOpen();
	SaveIniWriteReal("highscore", string(_lv), global.highscore[_lv]);
	SaveIniWriteString("highscore_initials", string(_lv), _nm);
	SaveIniClose();
	new_highscore = true;
}
score_highscore = global.highscore[global.level_highscore];
if (global.game_mode == GAMEMODE.STORY) {
	score_highscore = global.story_run_score_cumulative;
}

display_score = 0;
display_score_time = 0;
display_score_total = 0;
display_highscore = 0;

TweenStart("txt_yscale", 0, 1, 0.5*GAMESPD, TWEENTYPE.QUAD_OUT);

peaceful_intro_mission = StoryPeacefulIntroFarmActive();