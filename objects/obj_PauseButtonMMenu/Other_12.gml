/// @desc

event_inherited();

with(obj_PauseButtonPAR)
{
	instance_destroy();	
}
instance_activate_all();
instance_destroy(obj_Pause);
OptionsPeacefulPracticeAbortToMenu();
global.story_peaceful_intro_farm = false;
room_goto(rm_MainMenu);