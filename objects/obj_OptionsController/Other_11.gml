/// @desc New screen create

alarm[10] = 2;

array_delete(menu, 0, array_length(menu) - 1);
array_delete(menu_status, 0, array_length(menu_status) - 1);

menu = [];
menu_status = [];

// Create controls
if(in_controls)
{
	menu_selected = 0;
	
	//Exchange menu buttons for control buttons
	menu[0] = "Move Left";
	menu[1] = "Move Right";
	menu[2] = "Speed Up";
	menu[3] = "Speed Down";
	menu[4] = "Roll left";
	menu[5] = "Roll right";
	menu[6] = "Parry";
	menu[7] = "Shoot Seed";
	menu[8] = "Shoot Water";
	menu[9] = "Loop-de-loop";
	menu[10] = "Toggle Aim";
	menu[11] = "Back";

	menu_count = array_length(menu);
	
	for(var i = 0; i < menu_count - 1; i++)
	{
		// Keyboard
		var _keys = global.keymap[? input[i]];
		key_keyboard[i] = "";
		for(var j = 0; j < array_length(_keys); j++)
		{
			key_keyboard[i] += global.key_names[? _keys[j]];
			if(j < array_length(_keys) - 1) key_keyboard[i] += " + ";
		}
		
		// Gamepad
		_keys = global.gpmap[? input[i]];
		key_joypad[i] = "";
		for(var j = 0; j < array_length(_keys); j++)
		{
			key_joypad[i] += global.key_names[? _keys[j]];
			if(j < array_length(_keys) - 1) key_joypad[i] += " + ";
		}
	}
	
	key_joypad[menu_count - 1] = "";
	key_keyboard[menu_count - 1] = "";

	for(var _i = 0; _i < array_length(menu); _i++)
	{ //set status strings to nothing
		menu_status[_i] = "";
	}
}
// Create graphics
else if(in_graphics)
{
	menu[0] = "CRT lines";
	menu[1] = "Windowed";
	menu[2] = "Resolution";
	menu[3] = "Back";
	
	if(global.options_scanline) menu_status[0] = "ON";
	else menu_status[0] = "OFF";
	
	if(global.options_windowed == window_get_fullscreen()) global.options_windowed = !window_get_fullscreen();
	if(global.options_windowed) menu_status[1] = "ON";
	else menu_status[1] = "OFF";
	
	// Which resolution is currently used
	menu_status[2] = string(global.options_res_w) + " x " + string(global.options_res_h);
	menu_status[3] = "";
	
	for(var i = 4; i <= 8; i++)
	{
		menu[i] = "";
		menu_status[i] = "";
	}
	menu_count = 4;
}
// Create achievements		#TODO
else if(in_achievements)
{
	menu[0] = "Coming soon";
	menu[1] = "Back";
	
	menu_status[0] = "";
	menu_status[1] = "";
	
	for(var i = 2; i <= 8; i++)
	{
		menu[i] = "";
		menu_status[i] = "";
	}
	
	menu_count = 2;
}
// Create saves		#TODO
else if(in_saves)
{
	menu[0] = "Coming soon";
	menu[1] = "Back";
	
	menu_status[0] = "";
	menu_status[1] = "";
	
	for(var i = 2; i <= 8; i++)
	{
		menu[i] = "";
		menu_status[i] = "";
	}
	
	menu_count = 2;
}
// Create leaderboards
else if(in_leaderboards)
{
	menu[0] = "Back";
	
	menu_status[0] = "";
	
	for(var i = 1; i <= 8; i++)
	{
		menu[i] = "";
		menu_status[i] = "";
	}
	
	menu_count = 1;
	
	LeaderboardDownloadTopScores();
}