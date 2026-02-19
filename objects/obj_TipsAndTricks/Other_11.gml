/// @desc Continue from tips: retry (mission failed) or death flow
audio_stop_all();
if (variable_struct_exists(global, "after_tips_action") && global.after_tips_action == "retry") {
	global.after_tips_action = undefined;
	if (global.game_mode == GAMEMODE.STORY && variable_struct_exists(global, "after_tips_restart_level"))
		global.current_level = global.after_tips_restart_level;
	room_restart();
} else if (global.lives <= 0) {
	var _stage_start = (global.current_level div 4) * 4;
	global.current_level = _stage_start;
	global.story_mode_progress = _stage_start;
	global.lives = 4;
	global.overworld_progress = global.story_mode_level[global.current_level][STORYPROP.OVERWORLD];
	global.weather = global.story_mode_level[global.current_level][STORYPROP.WEATHER];
	global.level_highscore = global.current_level;
	room_goto(global.story_mode_level[global.current_level][STORYPROP.ROOM]);
} else {
	room_restart();
}
