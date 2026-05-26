/// @desc Change keymap

if(!in_controls) exit;

if(alarm[10] > 0)
{
	keyboard_lastkey = vk_nokey;
	exit;
}

if(alarm[1] > 0)
{
	// Keyboard change
	if(keyboard_lastkey != vk_nokey and !input_captured)
	{
		var _key = [];
		//array_push(_key, keyboard_lastkey);
			
		var _all_keys = ds_map_keys_to_array(global.key_names);
		
		for(var i = 0; i < array_length(_all_keys); i++)
		{
			// If any other keys pressed (except escape)
			if(keyboard_check(_all_keys[i]) and _all_keys[i] != vk_escape)// and _all_keys[i] != vk_anykey)
			{
				array_push(_key, _all_keys[i]);
				if(array_length(_key) == 2) break;
			}
		}
		
		if(array_length(_key) == 2 or array_length(_key) == 0 or keyboard_check_released(_key[0])) input_captured = true;
		
		if(array_length(_key) > 0)
		{
			global.keymap[? input[menu_selected]] = _key;
			key_keyboard[menu_selected] = "";
			for(var i = 0; i < array_length(_key); i++)
			{
				key_keyboard[menu_selected] += global.key_names[? _key[i]];
				if(i < array_length(_key) - 1) key_keyboard[menu_selected] += " + ";
			}
		}
	}	
	// Gamepad change
	else if(!input_captured)
	{
		var _gp_valid = (global.gamepad_connected != noone && gamepad_is_connected(global.gamepad_connected));
		if (global.gamepad_debug && !_gp_valid && global.gamepad_connected != noone) {
			show_debug_message("[OptionsController] WARNING: global.gamepad_connected=" + string(global.gamepad_connected) + " but not connected!");
		}
		if(InputGamepadCheckAny(global.gamepad_connected))
		{
			if (global.gamepad_debug) {
				show_debug_message("[OptionsController] Gamepad input detected on index " + string(global.gamepad_connected));
			}
			var _key = -1;
			_key[0] = InputGamepadButton();
			_key[1] = InputGamepadButton(_key[0]);
				
			for(var i = array_length(_key) - 1; i >= 0; i--)
			{
				if(_key[i] == -1) array_delete(_key, i, 1);
			}
			
			if(array_length(_key) == 2 or array_length(_key) == 0) {
				input_captured = true;
			} else if(_key[0] != -1) {
				// Re-check gamepad validity (it may have changed)
				if (!gamepad_is_connected(global.gamepad_connected)) {
					_gp_valid = false;
				}
				if (_gp_valid) {
					if (gamepad_button_check_released(global.gamepad_connected, _key[0])) {
						if (global.gamepad_debug) {
							show_debug_message("[OptionsController] Button " + string(_key[0]) + " released - capturing input");
						}
						input_captured = true;
					}
				} else {
					if (global.gamepad_debug) {
						show_debug_message("[OptionsController] FAIL: Cannot check button release - invalid gamepad index " + string(global.gamepad_connected));
					}
				}
			}
		
			if(array_length(_key) > 0)
			{
				global.gpmap[? input[menu_selected]] = _key;
				key_joypad[menu_selected] = "";
				for(var i = 0; i < array_length(_key); i++)
				{
					key_joypad[menu_selected] += global.key_names[? _key[i]];
					if(i < array_length(_key) - 1) key_joypad[menu_selected] += " + ";
				}
			}	
		}
		else
		{
			var _gp_valid = (global.gamepad_connected != noone && gamepad_is_connected(global.gamepad_connected));
			if (!_gp_valid) {
				if (global.gamepad_debug) {
					show_debug_message("[OptionsController] FAIL: Cannot check button release - invalid gamepad index " + string(global.gamepad_connected));
				}
			} else {
				var _keys = global.gpmap[? input[menu_selected]];
				for(var i = 0; i < array_length(_keys); i++)
				{
					if(gamepad_button_check_released(global.gamepad_connected, _keys[i]))
					{
						if (global.gamepad_debug) {
							show_debug_message("[OptionsController] Button " + string(_keys[i]) + " released - capturing input");
						}
						input_captured = true;
						break;
					}
				}
			}
		}
	}
	// Input captured - save to ini, stop change
	else if(input_captured)
	{
		var _released = true;
		// Keyboard release
		var _keys = global.keymap[? input[menu_selected]];
		for(var i = 0; i < array_length(_keys); i++)
		{
			if(keyboard_check(_keys[i])) _released = false;
		}
		
		// Gamepad release
		var _gp_valid = (global.gamepad_connected != noone && gamepad_is_connected(global.gamepad_connected));
		if (!_gp_valid) {
			if (global.gamepad_debug) {
				show_debug_message("[OptionsController] FAIL: Cannot check gamepad buttons - invalid gamepad index " + string(global.gamepad_connected));
			}
		} else {
			_keys = global.gpmap[? input[menu_selected]];
			for(var i = 0; i < array_length(_keys); i++)
			{
				if(gamepad_button_check(global.gamepad_connected, _keys[i])) {
					if (global.gamepad_debug) {
						show_debug_message("[OptionsController] Button " + string(_keys[i]) + " still held");
					}
					_released = false;
				}
			}
		}
		
		// All keys released - stop change
		if(_released)
		{
			var _current_keymap = global.keymap[? input[menu_selected]];
			var _current_gpmap = global.gpmap[? input[menu_selected]];
					
			// If any other inputs have the same keybiding - delete
			for(var i = 0; i < array_length(input); i++)
			{
				if(i != menu_selected)
				{
					var _check_keymap = global.keymap[? input[i]];
					var _check_gpmap = global.gpmap[? input[i]];
					var _same = true;
					
					// Check keyboard
					if(array_length(_current_keymap) == array_length(_check_keymap))
					{
						for(var j = 0; j < array_length(_current_keymap); j++)
						{
							if(_current_keymap[j] != _check_keymap[j]) _same = false;
						}
					}
					else _same = false;
					
					if(_same)
					{
						global.keymap[? input[i]] = [];
						key_keyboard[i] = "";
					}
					
					// Check gamepad
					_same = true;
					if(array_length(_current_gpmap) == array_length(_check_gpmap))
					{
						for(var j = 0; j < array_length(_current_gpmap); j++)
						{
							if(_current_gpmap[j] != _check_gpmap[j]) _same = false;
						}
					}
					else _same = false;
					
					if(_same)
					{
						global.gpmap[? input[i]] = [];
						key_joypad[i] = "";
					}
				}
			}
			
			// Save to file
			SaveIniOpen();
			
			var _input_string = "";
			for(var i = 0; i < array_length(_current_keymap); i++)
			{
				_input_string += string(_current_keymap[i]);
				_input_string += "-";
			}
			SaveIniWriteString("controls kb", string(input[menu_selected]), _input_string);
			
			_input_string = "";
			for(var i = 0; i < array_length(_current_gpmap); i++)
			{
				_input_string += string(_current_gpmap[i]);
				_input_string += "-";
			}
			SaveIniWriteString("controls gp", string(input[menu_selected]), _input_string);
			
			// Deleted keys
			for(var i = 0; i < array_length(input); i++)
			{
				if(i != menu_selected) 
				{
					if(array_length(global.keymap[? input[i]]) == 0)
						SaveIniWriteString("controls kb", string(input[i]), "-");
				
					if(array_length(global.gpmap[? input[i]]) == 0)
						SaveIniWriteString("controls gp", string(input[i]), "-");
				}
			}
			
			SaveIniClose();
			
			// Reset
			input_captured = false;
			alarm[1] = -1;
			alarm[10] = 2;
		}
	}
}