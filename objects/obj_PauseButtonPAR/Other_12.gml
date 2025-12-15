/// @desc Pressed - mouse disable

if can_press 
{
	// Set everything to unpressable
	with(obj_PauseButtonPAR)
	{
		can_press = false;	
	}
}