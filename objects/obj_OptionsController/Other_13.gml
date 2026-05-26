/// @desc Right mouse press

switch(menu_selected)
{
	case 0:
		if(menu[0] == "CRT lines")
		{
			global.options_scanline = global.options_scanline xor 1;	
			SaveIniOpen();
			SaveIniWriteReal("options", "scanline", global.options_scanline);
			SaveIniClose();	
			if global.options_scanline menu_status[0] = "ON";
			else menu_status[0] = "OFF";
		}
		break;
	
	case 1:
		if(menu[1] == "Music Volume")
		{
			global.options_music = clamp(global.options_music - 0.1, 0, 1);
			audio_group_set_gain(audiogroup_music, global.options_music, 0);
			SaveIniOpen();
			SaveIniWriteReal("options", "music", global.options_music);
			SaveIniClose();
			menu_status[1] = string(round(global.options_music * 100));
		}
		else if(menu[1] == "Windowed")
		{
			var _win_status = OptionsDisplayToggleWindowed();
			if (_win_status != undefined) menu_status[1] = _win_status;
		}
		break;
		
	case 2:
		if(menu[2] == "SFX Volume")
		{
			global.options_sfx = clamp(global.options_sfx - 0.1, 0, 1);
			audio_group_set_gain(audiogroup_default, global.options_sfx, 0);
			audio_play_sound(snd_ProjSeedShot, 1, false);
			SaveIniOpen();
			SaveIniWriteReal("options", "sfx", global.options_sfx);
			SaveIniClose();
			menu_status[2] = string(round(global.options_sfx * 100));
		}
		else if(menu[2] == "Resolution")
		{
			var _res_label = OptionsDisplayCycleResolution(menu_status[2], -1);
			if (_res_label != undefined) menu_status[2] = _res_label;
		}
		break;
}	