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
		key_keyboard[i] = "";
		if (InputControlsKeyboardRebindEnabled()) {
			key_keyboard[i] = InputFormatBindingList(global.keymap[? input[i]]);
		}
		key_joypad[i] = InputFormatBindingList(global.gpmap[? input[i]]);
	}
	
	key_joypad[menu_count - 1] = "";
	key_keyboard[menu_count - 1] = "";

	for(var _i = 0; _i < array_length(menu); _i++)
	{ //set status strings to nothing
		menu_status[_i] = "";
	}
}
// Create graphics (Switch: CRT + Back only; Windows: + Windowed + Resolution)
else if(in_graphics)
{
	var _gfx = OptionsGraphicsMenuData();
	menu = _gfx.menu;
	menu_status = _gfx.status;
	menu_count = _gfx.count;
	for (var i = menu_count; i <= 8; i++) {
		menu[i] = "";
		menu_status[i] = "";
	}
}
// Create scores submenu
else if(in_scores)
{
	menu[0] = "Squadron";
	menu[1] = "Achievements";
	menu[2] = "Leaderboards";
	menu[3] = "Saves";
	menu[4] = "Back";
	
	menu_status[0] = "";
	menu_status[1] = "";
	menu_status[2] = "";
	menu_status[3] = "";
	menu_status[4] = "";
	
	menu_count = 5;
}
// Create achievements (custom draw; menu is Back only)
else if(in_achievements)
{
	AchievementsLoadFromSave();
	menu[0] = "Back";
	
	menu_status[0] = "";
	
	for(var i = 1; i <= 8; i++)
	{
		menu[i] = "";
		menu_status[i] = "";
	}
	
	menu_count = 1;
}
// Create saves
else if(in_saves)
{
	menu[0] = "Erase all saved data";
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