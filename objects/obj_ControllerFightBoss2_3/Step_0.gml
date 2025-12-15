/// @desc

if(obj_ControllerFightBoss2_3.alarm[2] > 0 and direction == 270)
{
	target_id = instance_nearest(x, y, obj_PlayerPAR);
	EnemyFaceTarget(target_id);
}

// Tutorial control
switch(state) {
		// ========================= START PHASE =====================================
	case ENEMIES.INIT:
		// Create _screen open
		instance_create_layer(640, 0, "GUI_Top", obj_GUIScreenOpenLeft);
		instance_create_layer(640, 0, "GUI_Top", obj_GUIScreenOpenRight);
		state = ENEMIES.INIT_WAIT;
		break;
	case ENEMIES.INIT_WAIT:
		// Transition
		if instance_exists(obj_PlayerPAR) {
			with(obj_PlayerPAR) {
				can_move = true;
				shoot_ammo_depletion = true;	// Enable ammo depletion
			}
			state = ENEMIES.PHASE_1_TALK;
		}
		break;
	case ENEMIES.PHASE_1_TALK:
		// Action, consists of array for portrait and dialog
		portrait[0] = spr_RabboPortraitConfident;
		dialog[0] = "Red colored bird.. you're up next!";
		// Create textbox
		DialogCreate(portrait, dialog, true);
		
		// Transition
		state = ENEMIES.PHASE_1_TALK_WAIT;
		break;
	case ENEMIES.PHASE_1_TALK_WAIT:
		// Wait until dialog box is over
		ControllerDialogWait(ENEMIES.PHASE_1_SPAWN);
		break;
	case ENEMIES.PHASE_1_SPAWN:
		state = ENEMIES.PHASE_1_COMBAT;
		if !instance_exists(obj_BossBigRed)
		instance_create_layer(room_width/2, room_height*1.5, "Instances", obj_BossBigRed);
		break;
	case ENEMIES.PHASE_1_COMBAT:
		if !instance_exists(obj_BossBigRed) {
			// Create bigred prop
			bigredpos = instance_create_layer(obj_PlayerRabbo.x, obj_PlayerRabbo.y - 0.5*room_height, "Top", obj_BossBigRedProp);
			rabbo_prop = instance_create_layer(obj_PlayerRabbo.x, obj_PlayerRabbo.y, "Top", obj_PlayerRabboProp);
			rabbo_prop.can_control = false;
			if(instance_number(obj_PlayerRabbo) > 1)
			{
				var _inst = noone;
				with(obj_PlayerRabbo) if(character == CHARACTER.DIRK) _inst = id;
				dirk_prop = instance_create_layer(_inst.x, _inst.y, "Top", obj_PlayerRabboProp);
				dirk_prop.character = CHARACTER.DIRK;
				dirk_prop.can_control = false;
				with(dirk_prop) PlayerAssignSprite(character);
			}
			instance_destroy(obj_PlayerRabbo);
			state = ENEMIES.PHASE_ENDING_INIT;		
		}
		break;
	// ============================= END PHASE ===================================
	case ENEMIES.PHASE_ENDING_INIT:
		// Action
		dialog[0] = "";
		portrait[0] = 0;
		array_resize(portrait, 1);
		array_resize(dialog, 1);
		portrait[0] = spr_RabboPortraitSpeaking;
		dialog[0] = "Eat this, you big, red, fluffy, feather!";
		
		// Create textbox
		DialogCreate(portrait, dialog, true);
		
		state = ENEMIES.PHASE_ENDING_PREP;
		break;
	case ENEMIES.PHASE_ENDING_PREP:
		// Wait until dialog box is over and player in position
		var _inpos = false;
		if abs(rabbo_prop.x - bigredpos.x) > 4 {
			rabbo_prop.x += sign(bigredpos.x - rabbo_prop.x) * 3;
		} else _inpos = true;
		
		if !instance_exists(obj_Dialogue) and _inpos {
			// Increase rabbo speed
			with(rabbo_prop){
				TweenStart("speed", 0, 15, 1.5*GAMESPD);
				direction = 90;
			}
			with(dirk_prop){
				TweenStart("speed", 0, 15, 1.5*GAMESPD)
				direction = 90;
			}
			instance_create_layer(0, 0, "GUI_Top", obj_WhiteCloser);
			state = ENEMIES.PHASE_ENDING;
			//state = ENEMIES.PHASE_CLOSING;
		}
		break;
	case ENEMIES.PHASE_ENDING:
		var _hit = false;
		with(rabbo_prop){
			if place_meeting(x, y, obj_BossBigRedProp) {
				_hit = true;
				break;
			}
		}
		if _hit state = ENEMIES.PHASE_CLOSING;
		break;
		
	case ENEMIES.PHASE_CLOSING:
	//if (global.game_mode == GAMEMODE.FREE) TransitionGoto(rm_MainMenu);
	if (global.game_mode == GAMEMODE.FREE) 
	{
		var _text = instance_create_layer(room_width*0.9, room_height*0.9, "GUI_Top", obj_EndLevelMenu);
		_text.depth -= 1;
	}
	else 
	{
		var _text = instance_create_layer(room_width/2, room_height*0.9, "GUI_Top", obj_EndLevelMenu);
		_text.depth -= 1;
		_text = instance_create_layer(room_width*0.9, room_height*0.9, "GUI_Top", obj_EndLevelNext);
		_text.depth -= 1;
		
		// Advance level, save progress.
		AdvanceLevel();
	}
	// Create the mission complete
	var _text = instance_create_layer(room_width/2, 216, "GUI_Top", obj_GUIMissionAccomplished);
	_text.depth -= 1;
	// Score
	_text = instance_create_layer(room_width/2, room_height/2 + 64, "GUI_Top", obj_GUIMissionAccomplishedScore);
	_text.depth -= 1;
	// buttons - restart
	_text = instance_create_layer(room_width*0.1, room_height*0.9, "GUI_Top", obj_EndLevelRestart);
	_text.depth -= 1;
	
		state = ENEMIES.PHASE_CLOSING_WAIT;
	break;
	
	case ENEMIES.PHASE_CLOSING_WAIT:
	break;
}	

// Lerping the score
var _next_score = lerp(global.score_current, global.score_base, 0.15);
if (round(_next_score) != round(global.score_current)) {
	if (!audio_is_playing(snd_ScoreTick)) audio_play_sound(snd_ScoreTick, 1, false);
}
global.score_current = _next_score;