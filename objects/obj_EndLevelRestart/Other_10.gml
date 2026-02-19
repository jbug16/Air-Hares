// Inherit the parent event
event_inherited();

// Mission Failed: show tips first, then restart on continue
if (instance_exists(obj_GUIMissionFailed)) {
	global.after_tips_action = "retry";
	if (global.game_mode == GAMEMODE.STORY)
		global.after_tips_restart_level = global.story_mode_progress - 1;
	// Remove Mission Failed screen so Tips draws on top and buttons can't be clicked again
	instance_destroy(obj_GUIMissionFailed);
	instance_destroy(obj_EndLevelRestart);
	instance_destroy(obj_EndLevelMenu);
	global.tips_skip_music = true;  // same music already playing; avoid replay
	var _tips = instance_create_layer(room_width/2, room_height/2, "GUI_Top", obj_TipsAndTricks);
	_tips.depth = -10000;  // ensure Tips draws on top of any leftover GUI
	return;
}
if (global.game_mode == GAMEMODE.STORY) global.current_level = global.story_mode_progress - 1;
room_restart();