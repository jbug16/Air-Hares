///@desc After slides end?
audio_stop_all();

if(global.menu)
{
	global.menu = false;
	room_goto(rm_MainMenu);
	exit;
}

if (global.game_mode == GAMEMODE.FREE) room_goto(rm_MainMenu);
else room_goto(global.story_mode_level[global.current_level][STORYPROP.ROOM]);