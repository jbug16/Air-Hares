/// @desc
// Count elapsed time
time_elapsed += 1;

// Check for pause
if (InputGet(INPUT.PAUSE) and !instance_exists(obj_EndLevelPAR)) {
	if !instance_exists(obj_Pause) instance_create_depth(x,y,depth,obj_Pause);
	exit;
}

// Combos tweening
if global.combos_multiplier_increase 
{
	global.combos_multiplier_increase = false;
	var _scale = min(global.combos_multiplier, 5);
	TweenStart("image_xscale", 1, _scale, 0.25*GAMESPD, TWEENTYPE.CIRC_OUT,, TWEENREPEAT.PATROL);
	TweenStart("image_yscale", 1, _scale, 0.25*GAMESPD, TWEENTYPE.CIRC_OUT,, TWEENREPEAT.PATROL);
}

// Check frame skip
if frame_skip_duration > 0 frame_skip_duration -= 1;

// Apply _screen shake
if (view_shake_duration > 0) {
	view_shake_duration -= 1;
	camera_set_view_pos(view_camera[0], random_range(-view_shake_range, view_shake_range), random_range(-view_shake_range, view_shake_range));
}

// When no player alive, show tips then restart or go to stage
var _player_alive = instance_number(obj_PlayerPAR) + instance_number(obj_PlayerRabboSpawner);
if _player_alive == 0 {
		if (!level_completed) 
		{
			if (global.game_mode == GAMEMODE.STORY)
				global.lives--;
			global.tips_return_room = room;
			global.tips_skip_music = false;  // Death - music should play
			TransitionGoto(rm_StageFail);
			exit;
		}
	exit;
} else if (_player_alive == 1) { // Check join request
	var _join_requestor = InputGamepadGetJoinRequest();
	if (_join_requestor != noone) {
		var _p1_can_join = multiplayer_status[0][MPPROP.COOLDOWN] <= 0;
		var _p2_can_join = multiplayer_status[1][MPPROP.COOLDOWN] <= 0;
		
		// Create the 1st player, if it's from player 1's control device
		if !PlayerCheckAlive(0) && _p1_can_join && _join_requestor == global.control_device[0] {
			// Create player 1 spawner
			var _player = instance_create_layer(320, 608, "Instances", obj_PlayerRabboSpawner);
			_player.player = 0;
			_player.character = global.character_selected[_player.player]
			_player.sprite_index = global.character_sprite[_player.character][CHARACTER_SPRITE.IDLE];
			global.control_device[0] = _join_requestor;	
		}
		if !PlayerCheckAlive(1) && _p2_can_join && _join_requestor != global.control_device[0] && _join_requestor >= 0 {
			// Create the 2nd player spawner
			var _player = instance_create_layer(960, 608, "Instances", obj_PlayerRabboSpawner);
			_player.player = 1;
			_player.character = global.character_selected[_player.player]
			_player.sprite_index = global.character_sprite[_player.character][CHARACTER_SPRITE.IDLE];
			global.control_device[1] = _join_requestor;
		}
	}
}

// Cooldown
if (multiplayer_status[0][MPPROP.COOLDOWN] > 0) multiplayer_status[0][MPPROP.COOLDOWN] -= 1;
if (multiplayer_status[1][MPPROP.COOLDOWN] > 0) multiplayer_status[1][MPPROP.COOLDOWN] -= 1;