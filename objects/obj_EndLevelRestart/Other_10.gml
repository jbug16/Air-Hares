// Inherit the parent event
event_inherited();

// Mission Failed: show tips first, then restart on continue
if (instance_exists(obj_GUIMissionFailed)) {
	global.tips_return_room = room;
	global.tips_skip_music = true;  // Music already playing from mission failed screen
	room_goto(rm_StageFail);
	return;
}
if (global.game_mode == GAMEMODE.STORY) global.current_level = global.story_mode_progress - 1;
room_restart();