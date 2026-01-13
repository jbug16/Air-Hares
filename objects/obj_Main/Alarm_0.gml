///@desc Check gamepads periodically
alarm[0] = GAMESPD;

// Reset gamepad_connected first - will be set if one is found
var _previous_gamepad = global.gamepad_connected;
global.gamepad_connected = noone;

// Get all connected gamepads
var _gp_num = gamepad_get_device_count();
if (global.gamepad_debug) {
	show_debug_message("===== GAMEPAD DETECTION CYCLE =====");
	show_debug_message("Total gamepad slots available: " + string(_gp_num));
	if (_previous_gamepad == noone) {
		show_debug_message("Previous gamepad index: noone");
	} else {
		show_debug_message("Previous gamepad index: " + string(_previous_gamepad));
	}
}

var _found_count = 0;
for (var _gp = 0; _gp < _gp_num; _gp++) 
{
	if gamepad_is_connected(_gp) 
	{
	    global.gp[_gp] = true;
		_found_count++;
		
		var _gp_name = gamepad_get_description(_gp);
		if (global.gamepad_debug) {
			show_debug_message("  ✓ Gamepad slot " + string(_gp) + " connected: " + _gp_name);
		}
		
		// Set to FIRST connected gamepad (not last)
		if (global.gamepad_connected == noone) {
			global.gamepad_connected = _gp;
			if (global.gamepad_debug) {
				show_debug_message("  → Selected gamepad slot " + string(_gp) + " as primary gamepad");
				
				if (_previous_gamepad != noone && _previous_gamepad != _gp) {
					show_debug_message("  ⚠ WARNING: Gamepad index changed from " + string(_previous_gamepad) + " to " + string(_gp));
				}
			}
		} else {
			if (global.gamepad_debug) {
				show_debug_message("  ⊘ Gamepad slot " + string(_gp) + " ignored (not first connected)");
			}
		}
		
		gamepad_set_axis_deadzone(_gp, 0.1);
	} 
	else {
		global.gp[_gp] = false;
		if (_previous_gamepad == _gp && global.gamepad_debug) {
			show_debug_message("  ✗ Gamepad slot " + string(_gp) + " DISCONNECTED (was previously active)");
		}
	}
}

if (global.gamepad_debug) {
	if (_found_count == 0) {
		show_debug_message("  ✗ No gamepads detected!");
		if (_previous_gamepad != noone) {
			show_debug_message("  ⚠ WARNING: Gamepad was connected, now disconnected. global.gamepad_connected reset to noone");
		}
	} else {
		show_debug_message("Total gamepads found: " + string(_found_count));
		show_debug_message("Active gamepad index: " + string(global.gamepad_connected));
		show_debug_message("Active gamepad name: " + gamepad_get_description(global.gamepad_connected));
	}
	show_debug_message("===== END GAMEPAD DETECTION =====");
}