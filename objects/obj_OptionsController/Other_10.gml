/// @desc Button pressed

switch(menu_selected)
{
	case 0:
		if (in_saves && menu[0] == "Erase all saved data")
		{
			EraseAllSavedData();
			break;
		}
		if(menu[0] == "Controls")
		{
			in_controls = true;
			event_user(1);
		}
		else if(menu[0] == "CRT lines")
		{
			global.options_scanline = global.options_scanline xor 1;	
			SaveIniOpen();
			SaveIniWriteReal("options", "scanline", global.options_scanline);
			SaveIniClose();	
			if global.options_scanline menu_status[0] = "ON";
			else menu_status[0] = "OFF";
		}
		else if(menu[0] == "Back" and (in_leaderboards or in_achievements))
		{
			event_user(2);
		}
		break;
		
	case 1:
		if(menu[1] == "Music Volume")
		{
			global.options_music = clamp(global.options_music + 0.1, 0, 1);
			audio_group_set_gain(audiogroup_music, global.options_music, 0);
			SaveIniOpen();
			SaveIniWriteReal("options", "music", global.options_music);
			SaveIniClose();
			menu_status[1] = string(round(global.options_music * 100));
		}
		else if(menu[1] == "Back" or menu[2] == "BACK") event_user(2);
		else if(menu[1] == "Windowed")
		{
			var _win_status = OptionsDisplayToggleWindowed();
			if (_win_status != undefined) menu_status[1] = _win_status;
		}
		break;
	
	case 2:
		if(menu[2] == "SFX Volume")
		{
			global.options_sfx = clamp(global.options_sfx + 0.1, 0, 1);
			audio_group_set_gain(audiogroup_default, global.options_sfx, 0);
			audio_play_sound(snd_ProjSeedShot, 1, false);
			SaveIniOpen();
			SaveIniWriteReal("options", "sfx", global.options_sfx);
			SaveIniClose();
			menu_status[2] = string(round(global.options_sfx * 100));
		}
		else if(menu[2] == "Back" or menu[2] == "Back") event_user(2);
		else if(menu[2] == "Resolution")
		{
			var _res_label = OptionsDisplayCycleResolution(menu_status[2], 1);
			if (_res_label != undefined) menu_status[2] = _res_label;
		}
		break;
		
	case 3:
		if(menu[3] == "Graphics"){
			in_graphics = true;
			menu_selected = 0;
			event_user(1);
		}
		else if(menu[3] == "Back" or menu[2] == "BACK") event_user(2);
		break;
	
	case 4:
		if(menu[4] == "Tutorial")
		{
			global.tutorial_from_options = true;
			instance_create_depth(0.5*room_width, 0.5*room_height, depth - 100, obj_Tutorial);
			instance_deactivate_object(id);
			instance_deactivate_object(obj_OptionsTitle);
		}
		break;
	
	case 5:
		if(menu[5] == "Squadron")
		{
			instance_create_depth(0.5*room_width, 0.5*room_height, depth - 100, obj_Lore);
			instance_deactivate_object(id);
			instance_deactivate_object(obj_OptionsTitle);
		}
		break;
	
	case 6:
		if(menu[6] == "Achievements")
		{
			in_achievements = true;
			menu_selected = 0;
			event_user(1);
		}
		break;
		
	case 7:
		if(menu[7] == "Leaderboards")
		{
			in_leaderboards = true;
			menu_selected = 0;
			event_user(1);
		}
		break;
	
	case 8:
		if(menu[8] == "Saves")
		{
			in_saves = true;
			menu_selected = 1;
			event_user(1);
		}
		break;
	
	case 9:
		if(menu[9] == "Credits")
		{
			with(instance_create_depth(0.5*room_width, 0.5*room_height, depth - 100, obj_Credits)) 
			{
				from_options = true;
				alarm[1] = 1;
			}
			instance_deactivate_object(id);
			instance_deactivate_object(obj_OptionsTitle);
		}
		break;
		
	case 10:
		if(menu[10] == "Back" or menu[10] == "Back") event_user(2);
		break;
	
	case 11:
		event_user(2);
		break;
	
	default:
		event_user(2);
		break;
}