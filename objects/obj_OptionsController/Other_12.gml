/// @desc Back pressed

//if(menu_count < 8){ //back from options to menu
if(!in_controls and !in_saves and !in_achievements and !in_graphics and !in_leaderboards and (!in_scores or from_title_menu)) //back from options to menu
{ 
	layer_set_visible("Background_Options", false); //bring back the background

	//destroy option buttons
	instance_destroy(obj_OptionsController);
	instance_destroy(obj_OptionsTitle);

	instance_activate_all(); //bring back main menu buttons
	
	var _from_title = from_title_menu;
	with (obj_TitlebBtnGeneralPAR) {
		if (focus) event_user(2);
	}
	with (obj_TitlebBtnGeneralPAR) {
		if (button_id == (_from_title ? 4 : 3)) event_user(1);
	}
} 
else //back from controls to options
{ 
	array_delete(menu, 0, array_length(menu) - 1);
	array_delete(menu_status, 0, array_length(menu_status) - 1);

	menu = [];
	menu_status = [];
	
	var _return_to_scores = in_achievements or in_leaderboards or in_saves;
	
	if (_return_to_scores)
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
		
		if(in_achievements) menu_selected = 1;
		if(in_leaderboards) menu_selected = 2;
		if(in_saves) menu_selected = 3;
		
		in_scores = true;
	}
	else
	{
		//bring back options buttons
		menu[0] = "Controls";
		menu[1] = "Music Volume";
		menu[2] = "SFX Volume";
		menu[3] = "Graphics";
		menu[4] = "Tutorial";
		menu[5] = "Credits";
		menu[6] = "Back";
		
		//return status bar
		menu_status[0] = "";
		menu_status[1] = string(round(global.options_music * 100));
		menu_status[2] = string(round(global.options_sfx * 100));
		menu_status[3] = "";
		menu_status[4] = "";
		menu_status[5] = "";
		menu_status[6] = "";
		
		menu_count = array_length(menu);
		
		if(in_controls) menu_selected = 0;
		if(in_graphics) menu_selected = 3;
	}
	
	in_controls = false;
	in_graphics = false;
	in_achievements = false;
	in_saves = false;
	in_leaderboards = false;
	
	if (!_return_to_scores) in_scores = false;
	
	//delete keyboard and joypad arrays from controls
	array_delete(key_keyboard, 1, array_length(key_keyboard) - 1);
	array_delete(key_joypad, 1, array_length(key_joypad) - 1);
	key_joypad[0] = "";
	key_keyboard[0] = "";	
}
