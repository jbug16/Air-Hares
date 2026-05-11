
// Inherit the parent event
event_inherited();

if (global.options_peaceful_practice) {
	OptionsPeacefulPracticeAbortToMenu();
	TransitionGoto(rm_MainMenu);
	exit;
}

if (global.story_peaceful_intro_farm) {
	global.story_peaceful_intro_farm = false;
}

if(global.current_level == 4) room_goto(rm_StageClear1);
else if(global.current_level == 8) room_goto(rm_StageClear2);
else if(global.current_level == 12) room_goto(rm_StageClear3);
else room_goto(global.story_mode_level[global.current_level][STORYPROP.ROOM]);