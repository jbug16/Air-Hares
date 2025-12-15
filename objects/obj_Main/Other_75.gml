/// @desc Disable/enable cursor

switch(async_load[? "event_type"])
{
	// Hide cursor
	case "gamepad discovered": 
		window_set_cursor(cr_none);
		global.mouse_disable = true;
		break;
	// Show cursor
	case "gamepad lost":
		var _connected = false;
		for(var i = 0; i < gamepad_get_device_count(); i++)
		{
			if(gamepad_is_connected(i))
			{
				_connected = true;
				break;
			}
		}
		
		// All gamepads disconnected
		if(!_connected) 
		{
			global.mouse_disable = false;
			window_set_cursor(cr_default);
		}
		break;
}