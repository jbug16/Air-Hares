
// Inherit the parent event
event_inherited();

global.story_peaceful_intro_farm = false;

// If menu after bossfight - first cutscene, then menu
if(instance_exists(obj_ControllerFightBoss1_3))
{
	global.menu = true;
	TransitionGoto(rm_StageClear1);
	exit;
}

if(instance_exists(obj_ControllerFightBoss2_3))
{
	global.menu = true;
	TransitionGoto(rm_StageClear2);
	exit;
}

if(instance_exists(obj_ControllerFightBoss3_3))
{
	global.menu = true;
	TransitionGoto(rm_StageClear3);
	exit;
}

if(instance_exists(obj_ControllerFightBoss4_3))
{
	global.menu = true;
	TransitionGoto(rm_OutroScreen);
	exit;
}

// Leaving gameplay for main menu: clear popup state so title / end-level buttons are not stuck in "initials" input mode.
global.arcade_popup_screen = 0;
global.story_popup_screen = 0;
global.arcade_new_initials = "";
global.story_new_initials = "";

OptionsPeacefulPracticeAbortToMenu();
TransitionGoto(rm_MainMenu);