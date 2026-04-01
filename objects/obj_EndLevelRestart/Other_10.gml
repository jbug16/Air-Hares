// Inherit the parent event
event_inherited();

// Mission Failed: show tips first, then restart on continue
if (instance_exists(obj_GUIMissionFailed)) {
	global.tips_return_room = room;
	global.tips_skip_music = true;  // Music already playing from mission failed screen
	TransitionGoto(rm_StageFail);
	return;
}
// Story clear only: farm SAVING already incremented current_level; rewind to replay. Fail/arcade: leave current_level as-is.
if (global.game_mode == GAMEMODE.STORY && instance_exists(obj_GUIMissionAccomplished)) {
	global.current_level = max(0, global.current_level - 1);
}
room_restart();