/// @desc

event_inherited();

with(obj_PauseButtonPAR)
{
	instance_destroy();	
}
instance_activate_all();
instance_destroy(obj_Pause);
room_goto(rm_MainMenu);