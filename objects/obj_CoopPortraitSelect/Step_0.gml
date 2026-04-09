/// @desc P2 portrait picker input (gamepad only)
if (!global.pause_coop_portrait_select || !instance_exists(obj_Pause)) {
	instance_destroy();
	exit;
}

var _dev = global.coop_portrait_select_device;

if (gamepad_is_connected(_dev) && gamepad_button_check_pressed(_dev, gp_face2)) {
	global.pause_coop_portrait_select = false;
	global.coop_portrait_select_ignore_confirm = 0;
	instance_activate_all();
	instance_destroy(obj_Pause);
	with (obj_PlayerRabbo) alarm[2] = 10;
	instance_destroy();
	exit;
}

if (global.coop_portrait_select_ignore_confirm > 0) {
	global.coop_portrait_select_ignore_confirm -= 1;
} else if (gamepad_is_connected(_dev)) {
	var _n = array_length(global.coop_portrait_sprite);
	if (InputGet(INPUT.MENU_LEFT, true, _dev)) {
		global.coop_portrait_select_index--;
		if (global.coop_portrait_select_index < 0) global.coop_portrait_select_index = _n - 1;
	}
	if (InputGet(INPUT.MENU_RIGHT, true, _dev)) {
		global.coop_portrait_select_index++;
		if (global.coop_portrait_select_index >= _n) global.coop_portrait_select_index = 0;
	}
	if (InputGet(INPUT.MENU_SELECT, true, _dev)) {
		global.character_selected[1] = CHARACTER.DIRK + global.coop_portrait_select_index;
		var _player = instance_create_layer(960, 608, "Instances", obj_PlayerRabboSpawner);
		_player.player = 1;
		_player.character = global.character_selected[_player.player];
		_player.sprite_index = global.character_sprite[_player.character][CHARACTER_SPRITE.IDLE];
		global.control_device[1] = _dev;
		with (obj_ControllerPAR) {
			multiplayer_status[1][MPPROP.JOINED] = true;
		}
		if (global.game_mode == GAMEMODE.STORY && global.story_run_active) {
			global.story_run_ever_coop = true;
			StoryRunSave();
		}
		global.pause_coop_portrait_select = false;
		global.coop_portrait_select_ignore_confirm = 0;
		instance_activate_all();
		instance_destroy(obj_Pause);
		with (obj_PlayerRabbo) alarm[2] = 10;
		instance_destroy();
		exit;
	}
}
