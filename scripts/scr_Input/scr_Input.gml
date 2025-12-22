/*
	InputGet
	InputGamepadCheckAny
	InputGamepadGetJoinRequest
	InputGamepadButton
*/

///@func InputGet(key, pressed, device)
///@param	key			{Real} Which key
///@param	pressed		{Bool} check_pressed?
///@param	device		{Real} Which device
///@desc Gets the player input. @device: noone for checking all inputs. -1 for keyboard, >=0 for gamepad slots. @pressed: check with check() functions or check_pressed().
///@desc @key: INPUT enum.
function InputGet(_key = noone, _pressed = true, _device = all){
	if (_key == noone) return false;
	
	if (_device == -1)							// KEYBOARD
	{		
		// Check in keymap
		var _key_list = global.keymap[? _key];
		
		// Menu select works with either space OR enter
		if(_key == INPUT.MENU_SELECT)
		{
			var _select = false;
			for(var i = 0; i < array_length(_key_list); i++)
			{
				if(_pressed and keyboard_check_pressed(_key_list[i])) _select = true;
				else if(!_pressed and keyboard_check(_key_list[i])) _select = true;
			}
			
			return _select;
		}
	
		// Others work with combination of all keys in array
		var _return = true;
		for(var i = 0; i < array_length(_key_list); i++)
		{
			if(_pressed and !keyboard_check_pressed(_key_list[i])) _return = false;
			else if(!_pressed and !keyboard_check(_key_list[i])) _return = false;
		}
		
		return _return;
	}
	else if (_device == all)					// BOTH
	{
		return InputGet(_key, _pressed, -1) or InputGet(_key, _pressed, noone);
	}
	else										// GAMEPAD ONLY
	{
		// find gamepad
		var _gp = [];
		if (_device == noone)		// any gamepad
		{
			var _maxpads = gamepad_get_device_count();
			for (var i = 0; i < _maxpads; i++) 
			{
				if (gamepad_is_connected(i))  array_push(_gp,i);
			}
			if (array_length(_gp) < 1) return false;
		}
		else						// specific gamepad
		{
			if !gamepad_is_connected(_device) return false;
			else array_push(_gp, _device);
		}
		
		// Axis left/right/up/down is hardcoded 
		for (var i = 0; i < array_length(_gp); i++)
		{
			if(_key == INPUT.LEFT or _key == INPUT.MENU_LEFT)
			{
				if(_pressed and (gamepad_axis_value(_gp[i], gp_axislh) < -0.55 and !obj_Main.gp_left_axis[_gp[i]])) return true;
				else if(!_pressed and gamepad_axis_value(_gp[i], gp_axislh) < -0.55) return true;
			}
			else if(_key == INPUT.RIGHT or _key == INPUT.MENU_RIGHT)
			{
				if(_pressed and (gamepad_axis_value(_gp[i], gp_axislh) > 0.55 and !obj_Main.gp_left_axis[_gp[i]])) return true;
				else if(!_pressed and gamepad_axis_value(_gp[i], gp_axislh) > 0.55) return true;
			}
			else if(_key == INPUT.UP or _key == INPUT.MENU_UP)
			{
				if(_pressed and (gamepad_axis_value(_gp[i], gp_axislv) < -0.55) and !obj_Main.gp_left_axis[_gp[i]]) return true;
				else if(!_pressed and gamepad_axis_value(_gp[i], gp_axislv) < -0.55) return true;
			}
			else if(_key == INPUT.DOWN or _key == INPUT.MENU_DOWN)
			{
				if(_pressed and (gamepad_axis_value(_gp[i], gp_axislv) > 0.55) and !obj_Main.gp_left_axis[_gp[i]]) return true;
				else if(!_pressed and gamepad_axis_value(_gp[i], gp_axislv) > 0.55) return true;
			}
		}
		
		// If the input is mapped - can be different keys
		var _mapped = [INPUT.SEED, INPUT.WATER, INPUT.PARRY, INPUT.UP, INPUT.DOWN, INPUT.LEFT, INPUT.RIGHT, INPUT.MENU_DOWN, INPUT.MENU_LEFT, INPUT.MENU_RIGHT, INPUT.MENU_SELECT, 
			INPUT.MENU_UP, INPUT.LOOP_DE_LOOP, INPUT.ROLL_LEFT, INPUT.ROLL_RIGHT, INPUT.TOGGLE_AIM];
			
		// Pause is double keyed only in menus
		if(room == rm_MainMenu or (room != rm_MainMenu and instance_exists(obj_Pause))) _mapped = [INPUT.SEED, INPUT.WATER, INPUT.PARRY, INPUT.UP, INPUT.DOWN, INPUT.LEFT, INPUT.RIGHT, 
			INPUT.PAUSE, INPUT.MENU_DOWN, INPUT.MENU_LEFT, INPUT.MENU_RIGHT, INPUT.MENU_SELECT, INPUT.MENU_UP, INPUT.LOOP_DE_LOOP, INPUT.ROLL_LEFT, INPUT.ROLL_RIGHT, INPUT.TOGGLE_AIM];
		
		var _key_list = -1;
		if(array_contains(_mapped, _key)) _key_list = global.gpmap[? _key];
		
		// check keys
		for (var i = 0; i < array_length(_gp); i++)
		{	
			if(_key_list != -1)
			{
				for(var j = 0; j < array_length(_key_list); j++)
				{
					// Buttons
					if(_key_list[j] != gp_axislh and _key_list[j] != gp_axislv)
					{
						if(!is_array(_key_list[j]))
						{
							if(_pressed and gamepad_button_check_pressed(_gp[i], _key_list[j])) return true;
							if(!_pressed and gamepad_button_check(_gp[i], _key_list[j])) return true;
						}
						// Combination of buttons
						else
						{
							var _return = true;
							for(var k = 0; k < array_length(_key_list[j]); k++)
							{
								if(_pressed and !gamepad_button_check_pressed(_gp[i], _key_list[j][k])) _return = false;
								else if(!_pressed and !gamepad_button_check(_gp[i], _key_list[j][k])) _return = false;
							}
							
							return _return;
						}
					}
					// Axis
					else
					{
						// Vertical move
						if(_key_list[j] == gp_axislv)
						{
							if(_key == INPUT.UP) {
								if(_pressed) return (gamepad_axis_value(_gp[i], _key_list[j]) < -0.55 and !obj_Main.gp_left_axis[_gp[i]]);
								else return (gamepad_axis_value(_gp[i], _key_list[j]) < -0.55);
							}
							else if(_key == INPUT.DOWN) {
								if(_pressed) return (gamepad_axis_value(_gp[i], _key_list[j]) > 0.55 and !obj_Main.gp_left_axis[_gp[i]]);
								else return (gamepad_axis_value(_gp[i], _key_list[j]) > 0.55);
							}
						}
						// Horizontal move
						else
						{
							if(_key == INPUT.LEFT) {
								if(_pressed) return (gamepad_axis_value(_gp[i], gp_axislh) < -0.55 and !obj_Main.gp_left_axis[_gp[i]]);
								else return (gamepad_axis_value(_gp[i], gp_axislh) < -0.55);
							}
							else if(_key == INPUT.RIGHT) {
								if(_pressed) return (gamepad_axis_value(_gp[i], gp_axislh) > 0.55 and !obj_Main.gp_left_axis[_gp[i]]);
								else return (gamepad_axis_value(_gp[i], gp_axislh) > 0.55);
							}
						}
					}
				}
			}
			else
			{
				switch (_key)
				{
					case INPUT.X_KEY:
					if (_pressed and gamepad_button_check_pressed(_gp[i], gp_face4)) return true;
					else if (!_pressed and gamepad_button_check(_gp[i], gp_face4)) return true;
					break;
					case INPUT.L1:
					if (_pressed and gamepad_button_check_pressed(_gp[i], gp_shoulderl)) return true;
					else if (!_pressed and gamepad_button_check(_gp[i], gp_shoulderl)) return true;
					break;
					case INPUT.R1:
					if (_pressed and gamepad_button_check_pressed(_gp[i], gp_shoulderr)) return true;
					else if (!_pressed and gamepad_button_check(_gp[i], gp_shoulderr)) return true;
					break;
					case INPUT.L2:
					if (_pressed and gamepad_button_check_pressed(_gp[i], gp_shoulderlb)) return true;
					else if (!_pressed and gamepad_button_check(_gp[i], gp_shoulderlb)) return true;
					break;
					case INPUT.R2:
					if (_pressed and gamepad_button_check_pressed(_gp[i], gp_shoulderrb)) return true;
					else if (!_pressed and gamepad_button_check(_gp[i], gp_shoulderrb)) return true;
					break;
					case INPUT.PAUSE:
					if (_pressed and gamepad_button_check_pressed(_gp[i], gp_start)) return true;
					else if (!_pressed and gamepad_button_check(_gp[i], gp_start)) return true;
					break;
					case INPUT.RAXIS_UP:
					if (gamepad_axis_value(_gp[i], gp_axisrv) < -0.55) return true;
					break;
					case INPUT.RAXIS_DOWN:
					if (gamepad_axis_value(_gp[i], gp_axisrv) > 0.55) return true;
					break;
					case INPUT.RAXIS_LEFT:
					if (gamepad_axis_value(_gp[i], gp_axisrh) < -0.55) return true;
					break;
					case INPUT.RAXIS_RIGHT:
					if (gamepad_axis_value(_gp[i], gp_axisrh) > 0.55) return true;
					break;
					case INPUT.LAXIS_UP:
					if (gamepad_axis_value(_gp[i], gp_axislv) < -0.55) return true;
					break;
					case INPUT.LAXIS_DOWN:
					if (gamepad_axis_value(_gp[i], gp_axislv) > 0.55) return true;
					break;
					case INPUT.LAXIS_LEFT:
					if (gamepad_axis_value(_gp[i], gp_axislh) < -0.55) return true;
					break;
					case INPUT.LAXIS_RIGHT:
					if (gamepad_axis_value(_gp[i], gp_axislh) > 0.55) return true;
					break;
					case INPUT.ANY:
					for ( var _btn = gp_face1; _btn < gp_axisrv; _btn++ ) 
					{
						if (gamepad_button_check_pressed(_gp[i], _btn)) return true;	// any key (check all)
					}
					break;
				}
			}
		}
	}
	
	return false;
}



// @func InputGamepadCheckAny()
// Return true if any button on gamepad is pressed
function InputGamepadCheckAny(_device){ 
	for ( var _gp = gp_face1; _gp < gp_axisrv; _gp++ ) {
		if ( gamepad_button_check_pressed( _device, _gp ) ) return true;
	}
	return false;	
}



// @func InputGamepadGetJoinRequest();
// Return gamepad id if a player is requesting to join
function InputGamepadGetJoinRequest(){
	var _maxpads = gamepad_get_device_count();
	for (var _gp = 0; _gp < _maxpads; _gp++) {
		if (gamepad_is_connected(_gp)) {
			if gamepad_button_check_pressed(_gp, gp_face1) {
				return _gp;
			}
        }
    }
	// Check for keyboard join request
	if keyboard_check_pressed(vk_space) return -1;	// Keyboard join received
	
	// If not detected, return -4 (noone)
	return noone;
}



// @func InputGamepadButton();
// Return gamepad button which is being pressed
function InputGamepadButton(_key = noone){
	var _btns = [gp_face1, gp_face2, gp_face3, gp_face4, gp_padu, gp_padd, gp_padl, gp_padr, gp_start, gp_shoulderl, gp_shoulderlb, gp_shoulderr, gp_shoulderrb, gp_stickl, gp_stickr];
	
	for(var i = 0; i < array_length(_btns); i++)
	{
		if(gamepad_button_check(global.gamepad_connected, _btns[i]) and _btns[i] != _key) return _btns[i];
	}
	
	return -1;
}

// @func InputGamepadButtonReleased();
// Return gamepad button which is being released
function InputGamepadButtonReleased(_key = noone){
	var _btns = [gp_face1, gp_face2, gp_face3, gp_face4, gp_padu, gp_padd, gp_padl, gp_padr, gp_start, gp_shoulderl, gp_shoulderlb, gp_shoulderr, gp_shoulderrb];
	
	for(var i = 0; i < array_length(_btns); i++)
	{
		if(gamepad_button_check(global.gamepad_connected, _btns[i]) and _btns[i] != _key) return _btns[i];
	}
	
	return -1;
}