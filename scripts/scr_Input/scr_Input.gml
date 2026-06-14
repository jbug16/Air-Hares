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
		// During restart/global teardown, keymap can be missing or already destroyed.
		if (!variable_global_exists("keymap")) return false;
		if (!ds_exists(global.keymap, ds_type_map)) return false;
		if (!ds_map_exists(global.keymap, _key)) return false;
		
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
		if(array_contains(_mapped, _key))
		{
			if (!variable_global_exists("gpmap")) return false;
			if (!ds_exists(global.gpmap, ds_type_map)) return false;
			if (!ds_map_exists(global.gpmap, _key)) return false;
			_key_list = global.gpmap[? _key];
		}
		
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
	// Validate device is a valid gamepad index
	if (_device == noone) {
		if (global.gamepad_debug) {
			show_debug_message("[InputGamepadCheckAny] FAIL: _device parameter is noone");
		}
		return false;
	}
	if (!gamepad_is_connected(_device)) {
		if (global.gamepad_debug) {
			show_debug_message("[InputGamepadCheckAny] FAIL: Gamepad index " + string(_device) + " not connected");
		}
		if (global.gamepad_connected == _device) {
			if (global.gamepad_debug) {
				show_debug_message("[InputGamepadCheckAny] WARNING: Resetting global.gamepad_connected from " + string(_device) + " to noone");
			}
			global.gamepad_connected = noone;
		}
		return false;
	}
	
	// Validation successful, check buttons
	for ( var _gp = gp_face1; _gp < gp_axisrv; _gp++ ) {
		if ( gamepad_button_check_pressed( _device, _gp ) ) {
			if (global.gamepad_debug) {
				show_debug_message("[InputGamepadCheckAny] SUCCESS: Button " + string(_gp) + " pressed on gamepad " + string(_device));
			}
			return true;
		}
	}
	
	return false;	
}



// @func InputGamepadGetJoinRequest();
// Return gamepad id if a player is requesting to join
function InputGamepadGetJoinRequest(){
	var _maxpads = gamepad_get_device_count();
	for (var _gp = 0; _gp < _maxpads; _gp++) {
		if (gamepad_is_connected(_gp)) {
			if (gamepad_button_check_pressed(_gp, InputGpMenuConfirm())) {
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
	// Validate gamepad is connected
	if (global.gamepad_connected == noone) {
		if (global.gamepad_debug) {
			show_debug_message("[InputGamepadButton] FAIL: global.gamepad_connected is noone");
		}
		return -1;
	}
	if (!gamepad_is_connected(global.gamepad_connected)) {
		if (global.gamepad_debug) {
			show_debug_message("[InputGamepadButton] FAIL: Gamepad index " + string(global.gamepad_connected) + " not connected (disconnected?)");
		}
		global.gamepad_connected = noone;
		return -1;
	}
	
	// Validation successful
	var _btns = [gp_face1, gp_face2, gp_face3, gp_face4, gp_padu, gp_padd, gp_padl, gp_padr, gp_start, gp_shoulderl, gp_shoulderlb, gp_shoulderr, gp_shoulderrb, gp_stickl, gp_stickr];
	
	for(var i = 0; i < array_length(_btns); i++)
	{
		if(gamepad_button_check(global.gamepad_connected, _btns[i]) and _btns[i] != _key) {
			if (global.gamepad_debug) {
				show_debug_message("[InputGamepadButton] SUCCESS: Button " + string(_btns[i]) + " pressed on gamepad " + string(global.gamepad_connected));
			}
			return _btns[i];
		}
	}
	
	return -1;
}

// --- Platform controls (Switch: gamepad-only UI + Nintendo face labels) -----------------

/// @desc Keyboard column / rebinding in Options → Controls (desktop only).
function InputControlsKeyboardRebindEnabled() {
	return !SavePlatformIsSwitch();
}

/// @desc Options → Controls rebinding (desktop only; Switch is a fixed reference screen).
function InputControlsRebindEnabled() {
	return !SavePlatformIsSwitch();
}

/// @desc Fixed Nintendo labels for Options → Controls on Switch (index matches input[] order).
function InputSwitchControlsScreenLabel(_index) {
	var _labels = [
		"L Stick Left", "L Stick Right", "R Stick Up", "R Stick Down",
		"ZL", "ZR", "Y", "B", "A", "X", "R"
	];
	if (_index < 0 || _index >= array_length(_labels)) return "";
	return _labels[_index];
}

/// @desc If a gamepad confirmed a menu action, assign it as P1's control device (else use connected pad).
function ControlDeviceAssignPrimaryFromGamepad() {
	var _maxpads = gamepad_get_device_count();
	for (var _gp = 0; _gp < _maxpads; _gp++) {
		if (gamepad_is_connected(_gp) && InputGet(INPUT.MENU_SELECT, , _gp)) {
			global.control_device[0] = _gp;
			return;
		}
	}
	if (global.control_device[0] == -1 && global.gamepad_connected != noone && gamepad_is_connected(global.gamepad_connected)) {
		global.control_device[0] = global.gamepad_connected;
	}
}

/// @desc GameMaker gp_face* constant for menu confirm / join (Nintendo A on Switch = gp_face2).
function InputGpMenuConfirm() {
	return SavePlatformIsSwitch() ? gp_face2 : gp_face1;
}

/// @desc GameMaker gp_face* constant for menu back / cancel (Nintendo B on Switch = gp_face1).
function InputGpMenuCancel() {
	return SavePlatformIsSwitch() ? gp_face1 : gp_face2;
}

/// @desc Splash / logo screens: buttons that advance when pressed.
function InputGpSplashAdvanceButtons() {
	if (SavePlatformIsSwitch()) {
		return [gp_face2, gp_face1, gp_start];
	}
	return [gp_face1, gp_face2, gp_start];
}

function InputApplyDefaultKeyboardMap() {
	if (variable_global_exists("keymap") && ds_exists(global.keymap, ds_type_map)) {
		ds_map_destroy(global.keymap);
	}
	global.keymap = ds_map_create();
	global.keymap[? INPUT.ANY] = [vk_anykey];
	global.keymap[? INPUT.DOWN] = [vk_down];
	global.keymap[? INPUT.LEFT] = [vk_left];
	global.keymap[? INPUT.PARRY] = [ord("Q")];
	global.keymap[? INPUT.RIGHT] = [vk_right];
	global.keymap[? INPUT.SEED] = [vk_space];
	global.keymap[? INPUT.UP] = [vk_up];
	global.keymap[? INPUT.SHIFT] = [vk_shift];
	global.keymap[? INPUT.WATER] = [ord("E")];
	global.keymap[? INPUT.PAUSE] = [vk_escape];
	global.keymap[? INPUT.LOOP_DE_LOOP] = [ord("Q"), vk_shift];
	global.keymap[? INPUT.ROLL_LEFT] = [vk_left, vk_shift];
	global.keymap[? INPUT.ROLL_RIGHT] = [vk_right, vk_shift];
	global.keymap[? INPUT.MENU_SELECT] = [vk_enter, vk_space];
	global.keymap[? INPUT.MENU_UP] = [vk_up];
	global.keymap[? INPUT.MENU_DOWN] = [vk_down];
	global.keymap[? INPUT.MENU_LEFT] = [vk_left];
	global.keymap[? INPUT.MENU_RIGHT] = [vk_right];
	global.keymap[? INPUT.TOGGLE_AIM] = [vk_enter];
}

function InputApplyDesktopGamepadMap() {
	global.gpmap[? INPUT.SEED] = [gp_face1];
	global.gpmap[? INPUT.WATER] = [gp_face2];
	global.gpmap[? INPUT.PARRY] = [gp_face3];
	global.gpmap[? INPUT.UP] = [gp_padu];
	global.gpmap[? INPUT.DOWN] = [gp_padd];
	global.gpmap[? INPUT.LEFT] = [gp_padl];
	global.gpmap[? INPUT.RIGHT] = [gp_padr];
	global.gpmap[? INPUT.PAUSE] = [gp_start, gp_face2];
	global.gpmap[? INPUT.LOOP_DE_LOOP] = [gp_face4];
	global.gpmap[? INPUT.MENU_SELECT] = [gp_face1];
	global.gpmap[? INPUT.MENU_UP] = [gp_padu];
	global.gpmap[? INPUT.MENU_DOWN] = [gp_padd];
	global.gpmap[? INPUT.MENU_LEFT] = [gp_padl];
	global.gpmap[? INPUT.MENU_RIGHT] = [gp_padr];
	global.gpmap[? INPUT.ROLL_RIGHT] = [gp_shoulderrb];
	global.gpmap[? INPUT.ROLL_LEFT] = [gp_shoulderlb];
	global.gpmap[? INPUT.TOGGLE_AIM] = [gp_shoulderr];
}

/// @desc Match Xbox layout by physical position on Switch Pro / Joy-Con (GM constants):
/// B=gp_face1, A=gp_face2, Y=gp_face4 (left), X=gp_face3 (top). Face3/face4 differ from desktop gpmap.
function InputApplySwitchGamepadMap() {
	global.gpmap[? INPUT.SEED] = [gp_face1];
	global.gpmap[? INPUT.WATER] = [gp_face2];
	global.gpmap[? INPUT.PARRY] = [gp_face4];
	global.gpmap[? INPUT.UP] = [gp_padu];
	global.gpmap[? INPUT.DOWN] = [gp_padd];
	global.gpmap[? INPUT.LEFT] = [gp_padl];
	global.gpmap[? INPUT.RIGHT] = [gp_padr];
	global.gpmap[? INPUT.PAUSE] = [gp_start, gp_face1];
	global.gpmap[? INPUT.LOOP_DE_LOOP] = [gp_face3];
	global.gpmap[? INPUT.MENU_SELECT] = [gp_face2];
	global.gpmap[? INPUT.MENU_UP] = [gp_padu];
	global.gpmap[? INPUT.MENU_DOWN] = [gp_padd];
	global.gpmap[? INPUT.MENU_LEFT] = [gp_padl];
	global.gpmap[? INPUT.MENU_RIGHT] = [gp_padr];
	global.gpmap[? INPUT.ROLL_RIGHT] = [gp_shoulderrb];
	global.gpmap[? INPUT.ROLL_LEFT] = [gp_shoulderlb];
	global.gpmap[? INPUT.TOGGLE_AIM] = [gp_shoulderr];
}

function InputApplyDefaultGamepadMap() {
	if (variable_global_exists("gpmap") && ds_exists(global.gpmap, ds_type_map)) {
		ds_map_destroy(global.gpmap);
	}
	global.gpmap = ds_map_create();
	if (SavePlatformIsSwitch()) {
		InputApplySwitchGamepadMap();
	} else {
		InputApplyDesktopGamepadMap();
	}
}

function InputInitDefaultMaps() {
	InputApplyDefaultKeyboardMap();
	InputApplyDefaultGamepadMap();
}

/// @desc After global.key_names is populated — use Nintendo labels on Switch.
function InputInitBindingDisplayNames() {
	if (!variable_global_exists("key_names") || !ds_exists(global.key_names, ds_type_map)) return;
	if (!SavePlatformIsSwitch()) return;
	global.key_names[? gp_face1] = "B";
	global.key_names[? gp_face2] = "A";
	global.key_names[? gp_face3] = "X";
	global.key_names[? gp_face4] = "Y";
	global.key_names[? gp_shoulderl] = "L";
	global.key_names[? gp_shoulderlb] = "ZL";
	global.key_names[? gp_shoulderr] = "R";
	global.key_names[? gp_shoulderrb] = "ZR";
	global.key_names[? gp_start] = "+";
	global.key_names[? gp_select] = "-";
}

/// @param {Real} _code Key or gp_* constant
function InputGetBindingDisplayName(_code) {
	if (variable_global_exists("key_names") && ds_exists(global.key_names, ds_type_map) && ds_map_exists(global.key_names, _code)) {
		return global.key_names[? _code];
	}
	return string(_code);
}

/// @param {Array<Real>} _keys
function InputFormatBindingList(_keys) {
	var _out = "";
	for (var i = 0; i < array_length(_keys); i++) {
		_out += InputGetBindingDisplayName(_keys[i]);
		if (i < array_length(_keys) - 1) _out += " + ";
	}
	return _out;
}

function InputRebindableInputList() {
	return [INPUT.LEFT, INPUT.RIGHT, INPUT.UP, INPUT.DOWN, INPUT.ROLL_LEFT, INPUT.ROLL_RIGHT, INPUT.PARRY, INPUT.SEED, INPUT.WATER, INPUT.LOOP_DE_LOOP, INPUT.TOGGLE_AIM];
}

function InputLoadBindingsFromSave() {
	if (!SavePlatformHasPersistence()) return;
	SaveIniOpen();
	var _inputs = InputRebindableInputList();
	for (var i = 0; i < array_length(_inputs); i++) {
		var _inp = _inputs[i];
		if (InputControlsKeyboardRebindEnabled()) {
			var _kb = SaveIniReadString("controls kb", string(_inp), "");
			if (_kb != "") {
				_kb = string_split(_kb, "-");
				var _keys_kb = [];
				for (var j = 0; j < array_length(_kb); j++) {
					if (_kb[j] != "") array_push(_keys_kb, real(_kb[j]));
				}
				global.keymap[? _inp] = _keys_kb;
			}
		}
		// Switch: always use platform gpmap — saved desktop-style face bindings swap X/Y in-game.
		if (!SavePlatformIsSwitch()) {
			var _gp = SaveIniReadString("controls gp", string(_inp), "");
			if (_gp != "") {
				_gp = string_split(_gp, "-");
				var _keys_gp = [];
				for (var j = 0; j < array_length(_gp); j++) {
					if (_gp[j] != "") array_push(_keys_gp, real(_gp[j]));
				}
				global.gpmap[? _inp] = _keys_gp;
			}
		}
	}
	SaveIniClose();
}

// @func InputGamepadButtonReleased();
// Return gamepad button which is being released
function InputGamepadButtonReleased(_key = noone){
	// Validate gamepad is connected
	if (global.gamepad_connected == noone) {
		if (global.gamepad_debug) {
			show_debug_message("[InputGamepadButtonReleased] FAIL: global.gamepad_connected is noone");
		}
		return -1;
	}
	if (!gamepad_is_connected(global.gamepad_connected)) {
		if (global.gamepad_debug) {
			show_debug_message("[InputGamepadButtonReleased] FAIL: Gamepad index " + string(global.gamepad_connected) + " not connected (disconnected?)");
		}
		global.gamepad_connected = noone;
		return -1;
	}
	
	// Validation successful
	var _btns = [gp_face1, gp_face2, gp_face3, gp_face4, gp_padu, gp_padd, gp_padl, gp_padr, gp_start, gp_shoulderl, gp_shoulderlb, gp_shoulderr, gp_shoulderrb];
	
	for(var i = 0; i < array_length(_btns); i++)
	{
		if(gamepad_button_check(global.gamepad_connected, _btns[i]) and _btns[i] != _key) {
			if (global.gamepad_debug) {
				show_debug_message("[InputGamepadButtonReleased] SUCCESS: Button " + string(_btns[i]) + " released on gamepad " + string(global.gamepad_connected));
			}
			return _btns[i];
		}
	}
	
	return -1;
}