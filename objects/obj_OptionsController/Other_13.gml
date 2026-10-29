/// @desc Right mouse press

var _label = menu[menu_selected];
if (_label == "Music Volume")
{
	global.options_music = clamp(global.options_music - 0.1, 0, 1);
	audio_group_set_gain(audiogroup_music, global.options_music, 0);
	SaveIniOpen();
	SaveIniWriteReal("options", "music", global.options_music);
	SaveIniClose();
	menu_status[menu_selected] = string(round(global.options_music * 100));
}
else if (_label == "SFX Volume")
{
	global.options_sfx = clamp(global.options_sfx - 0.1, 0, 1);
	audio_group_set_gain(audiogroup_default, global.options_sfx, 0);
	audio_play_sound(snd_ProjSeedShot, 1, false);
	SaveIniOpen();
	SaveIniWriteReal("options", "sfx", global.options_sfx);
	SaveIniClose();
	menu_status[menu_selected] = string(round(global.options_sfx * 100));
}
else if (_label == "Windowed")
{
	var _win_status = OptionsDisplayToggleWindowed();
	if (_win_status != undefined) menu_status[menu_selected] = _win_status;
}
else if (_label == "Resolution")
{
	var _res_label = OptionsDisplayCycleResolution(menu_status[menu_selected], -1);
	if (_res_label != undefined) menu_status[menu_selected] = _res_label;
}
