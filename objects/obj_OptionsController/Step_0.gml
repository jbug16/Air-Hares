/// @desc Input

if(alarm[10] > 0) exit;

if (InputGet(INPUT.PAUSE)) event_user(2); //go back
// Get menu navigation
var _up = InputGet(INPUT.MENU_UP);
var _down = InputGet(INPUT.MENU_DOWN);
var _left = InputGet(INPUT.MENU_LEFT);
var _right = InputGet(INPUT.MENU_RIGHT);
var _select = InputGet(INPUT.MENU_SELECT);

// If in achievements or leaderboards - cannot do anything but select back (saves: normal 2-row menu)
if(in_achievements or in_leaderboards)
{
	_up = false;
	_down = false;
	_left = false;
	_right = false;
}

//keyboard/gamepad input
if(_up)
{
	if(in_controls and alarm[1] > 0) exit;
	menu_selected -= 1;
}
else if(_down)
{
	if(in_controls and alarm[1] > 0) exit;
	menu_selected += 1;
}
else if(_select)
{
	if(in_controls and alarm[1] > 0) exit;
	if(in_controls and menu[menu_selected] != "Back")
	{
		// Start blinking
		TweenStart("control_alpha", control_alpha, 0, blink_dur, TWEENTYPE.LINEAR);
		alarm[1] = blink_dur;
		alarm[10] = 15;
		if (InputControlsKeyboardRebindEnabled()) keyboard_lastkey = vk_nokey;
	}
	else event_user(0);
	
	exit;
} else if(_left or _right){ 
	if(in_controls and alarm[1] > 0) exit;
	if(menu_selected == 1)
	{ 
		//if manipulating music
		if(menu[1] == "Music Volume")
		{
			global.options_music = clamp(global.options_music + (0.1 * (_right - _left)), 0, 1);
			audio_group_set_gain(audiogroup_music, global.options_music, 0);
			SaveIniOpen();
			SaveIniWriteReal("options", "music", global.options_music);
			SaveIniClose();
			menu_status[1] = string(round(global.options_music * 100));
		}
		// If manipulating windowing (Windows only)
		else if(menu[1] == "Windowed")
		{
			var _win_status = OptionsDisplayToggleWindowedDirection(_left or _right);
			if (_win_status != undefined) menu_status[1] = _win_status;
		}
	} 
	else if(menu_selected == 2)
	{ 
		//if manipulating sfx
		if(menu[2] == "SFX Volume")
		{
			global.options_sfx = clamp(global.options_sfx + (0.1 * (_right - _left)), 0, 1);
			audio_group_set_gain(audiogroup_default, global.options_sfx, 0);
			audio_play_sound(snd_ProjSeedShot, 1, false);
			SaveIniOpen();
			SaveIniWriteReal("options", "sfx", global.options_sfx);
			SaveIniClose();
			menu_status[2] = string(round(global.options_sfx * 100));
		}
		// If manipulating resolution (Windows only)
		if(menu[2] == "Resolution")
		{
			var _res_label = OptionsDisplayCycleResolution(menu_status[2], _right - _left);
			if (_res_label != undefined) menu_status[2] = _res_label;
		}
	} 
	  else if(menu_selected == 0)
	  { 
		 //if manipulating CRT lines
		 if(menu[0] == "CRT lines")
		 {
			global.options_scanline = global.options_scanline xor (_left or _right);	
			SaveIniOpen();
			SaveIniWriteReal("options", "scanline", global.options_scanline);
			SaveIniClose();	
			if global.options_scanline menu_status[0] = "ON";
			else menu_status[0] = "OFF";
		 }
	}
}

if(_up or _down) audio_play_sound(snd_ProjSeedShot, 1, false);

//Loop buttons
if(menu_selected < 0) menu_selected = menu_count - 1;
else if(menu_selected > menu_count - 1) menu_selected = 0;


//----------------------------------------------------------
// Mouse input
//----------------------------------------------------------

if(global.mouse_disable) exit;

// Footer Back for screens that draw it away from the main menu column
if(in_achievements or in_leaderboards)
{
	draw_set_font(fnt_Federo24);
	var _back_y = in_achievements ? room_height * 0.93 : room_height * 0.9;
	var _pad = 16;
	var cx = room_width * 0.5;
	var w = max(string_width(menu[0]), 80);
	var h = max(string_height(menu[0]), 28);
	if(point_in_rectangle(mouse_x, mouse_y, cx - w * 0.5 - _pad, _back_y - h * 0.5 - _pad, cx + w * 0.5 + _pad, _back_y + h * 0.5 + _pad))
	{
		menu_selected = 0;
		if(mouse_check_button_pressed(mb_left))
			event_user(0);
		if(mouse_check_button_pressed(mb_right))
			event_user(3);
	}
	mouse_prev_x = mouse_x;
	mouse_prev_y = mouse_y;
	exit;
}

// Only if mouse moving
if(mouse_prev_x != mouse_x or mouse_prev_y != mouse_y)
{
	var _x_left = room_width * 0.2; //position of the text
	var _y_start = max(room_height * 0.17, 120);
	var _row = in_controls ? 45 : 44;
	if (in_controls)
	{
		_x_left = room_width*0.07;
		_y_start = room_height*0.24;
	}
	var _grouped_opts = (!in_controls && !in_saves && array_length(menu) == 11);
	var _g_blk = _row * 0.5;
	for(var _i = 0; _i < array_length(menu); _i++)
	{
		var _yy = _y_start + _row * _i;
		if (_grouped_opts) {
			if (_i >= 4) _yy += _g_blk;
			if (_i >= 10) _yy += _g_blk;
		}
		if(point_in_rectangle(mouse_x, mouse_y, _x_left, _yy - 0.03*room_height,
			_x_left + string_width(menu[_i]), _yy + 0.03*room_height))
			{
				if(!in_controls or(in_controls and alarm[1] < 0)) menu_selected = _i;
				// Left mouse pressed
				if(mouse_check_button_pressed(mb_left))
				{
					if(in_controls and menu[_i] != "Back")
					{
						// Start blinking
						TweenStart("control_alpha", control_alpha, 0, blink_dur, TWEENTYPE.LINEAR);
						alarm[1] = blink_dur;
						alarm[10] = 5;
						if (InputControlsKeyboardRebindEnabled()) keyboard_lastkey = vk_nokey;
						exit;
					}
					else event_user(0);
				}
				// Right mouse pressed
				if(mouse_check_button_pressed(mb_right))
				{
					if(in_controls) alarm[1] = -1;
					else event_user(3);
				}
			}
	}
}
// Can click if already on selected without moving
else
{
	var _x_left = room_width * 0.2; //position of the text
	var _y_start = max(room_height * 0.17, 120);
	var _row = in_controls ? 45 : 44;
	if (in_controls)
	{
		_x_left = room_width*0.07;
		_y_start = room_height*0.24;
	}
	var _grouped_opts = (!in_controls && !in_saves && array_length(menu) == 11);
	var _g_blk = _row * 0.5;
	for(var _i = 0; _i < array_length(menu); _i++)
	{
		var _yy = _y_start + _row * _i;
		if (_grouped_opts) {
			if (_i >= 4) _yy += _g_blk;
			if (_i >= 10) _yy += _g_blk;
		}
		if(point_in_rectangle(mouse_x, mouse_y, _x_left, _yy - 0.03*room_height,
			_x_left + string_width(menu[_i]), _yy + 0.03*room_height))
			{
				if(_i == menu_selected)
				{
					if(mouse_check_button_pressed(mb_left))
					{
						if(in_controls and menu_selected < menu_count - 1)
						{
							// Start blinking
							TweenStart("control_alpha", control_alpha, 0, blink_dur, TWEENTYPE.LINEAR);
							alarm[1] = blink_dur;
							alarm[10] = 5;
							if (InputControlsKeyboardRebindEnabled()) keyboard_lastkey = vk_nokey;
							exit;
						}
						else event_user(0);
					}
					if(mouse_check_button_pressed(mb_right))
					{
						if(in_controls and menu_selected < menu_count - 1) alarm[1] = -1;
						else event_user(3);
					}
				}
			}
	}
}

// Remember previous mouse x/y (for mouse hover)
mouse_prev_x = mouse_x;
mouse_prev_y = mouse_y;