/// @desc On press, execute _script
if(global.mouse_disable) exit;
if can_press 
{
	// Set everything to unpressable
	with(obj_PauseButtonPAR)
	{
		can_press = false;	
	}
}