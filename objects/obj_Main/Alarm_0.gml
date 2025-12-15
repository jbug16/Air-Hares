///@desc Check gamepads periodically
alarm[0] = GAMESPD;

// Get all connected gamepads
var _gp_num = gamepad_get_device_count();
for (var _gp = 0; _gp < _gp_num; _gp++;) 
{
	if gamepad_is_connected(_gp) 
	{
	    global.gp[_gp] = true;
		global.gamepad_connected = _gp;
		gamepad_set_axis_deadzone(_gp, 0.1);
	} 
	else global.gp[_gp] = false;
}