/// @desc Disable/enable cursor

switch(async_load[? "event_type"])
{
	// Hide cursor
	case "gamepad discovered": 
		var _slot = async_load[? "pad_index"];
		var _name = "Unknown";
		if (_slot != undefined) {
			_name = gamepad_get_description(_slot);
		}
		if (global.gamepad_debug) {
			show_debug_message("===== ASYNC EVENT: GAMEPAD DISCOVERED =====");
			if (_slot != undefined) {
				show_debug_message("Gamepad discovered at slot: " + string(_slot));
				show_debug_message("Gamepad name: " + _name);
			} else {
				show_debug_message("WARNING: Gamepad discovered but slot index not provided!");
			}
		}
		
		// Immediately re-check all gamepads and update global.gamepad_connected
		event_perform(ev_alarm, 0);
		
		window_set_cursor(cr_none);
		global.mouse_disable = true;
		if (global.gamepad_debug) {
			show_debug_message("Cursor disabled, mouse disabled");
			show_debug_message("===============================================");
		}
		break;
	// Show cursor
	case "gamepad lost":
		var _slot = async_load[? "pad_index"];
		if (global.gamepad_debug) {
			show_debug_message("===== ASYNC EVENT: GAMEPAD LOST =====");
			if (_slot != undefined) {
				show_debug_message("Gamepad lost at slot: " + string(_slot));
				if (global.gamepad_connected == _slot) {
					show_debug_message("WARNING: Lost gamepad was the active gamepad (slot " + string(_slot) + ")");
				}
			} else {
				show_debug_message("WARNING: Gamepad lost but slot index not provided!");
			}
		}
		
		// Immediately re-check all gamepads and update global.gamepad_connected
		event_perform(ev_alarm, 0);
		
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
			if (global.gamepad_debug) {
				show_debug_message("All gamepads disconnected - re-enabling cursor");
			}
			global.mouse_disable = false;
			window_set_cursor(cr_default);
		} else {
			if (global.gamepad_debug) {
				show_debug_message("Other gamepads still connected - keeping cursor disabled");
			}
		}
		if (global.gamepad_debug) {
			show_debug_message("=====================================");
		}
		break;
}