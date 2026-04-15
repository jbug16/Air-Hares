///@desc Statemachine, tiles...

//==========================================================
// Spawning tiles
//==========================================================
var _spawned_tile = false;
if (!position_meeting(0, 0, obj_LevelTile))
{
	// Get the top-most location of tile
	var _pos = 0;
	with obj_LevelTile
	{
		if (bbox_top < _pos) _pos = bbox_top;
	}
	// Spawn
	instance_create_layer(room_width*0.5, _pos + 2, "Ground_Tile", obj_LevelTile);
	_spawned_tile = true;
}



//==========================================================
// Statemachine
//==========================================================
if (room == rm_LevelX1Farm) switch (state)
{
	case LVLFARM.CROP1_SPAWN:
	case LVLFARM.CROP2_SPAWN:
	case LVLFARM.CROP3_SPAWN:
		event_user(11);			// create crops
		state++;
	break;
	
	case LVLFARM.CROP1_PASS:
	case LVLFARM.CROP2_PASS:
	case LVLFARM.CROP3_PASS:
		var _can_next = true;
		with (obj_FarmPlot) if (bbox_bottom <= 0.4*room_height) _can_next = false;
		if (_can_next)
		{
			//with(obj_FarmPlot) if(state == PLOTSTATE.CARROT_FRESH) other.crops_filled++;
			state++;
			//event_user(2);
		}
		else if (!instance_exists(obj_EnemyPAR) and !instance_exists(obj_EnemyFalconSpawnerPAR)) event_user(0);	// spawn enemy
	break;
	
	case LVLFARM.POND1_SPAWN:
	case LVLFARM.POND2_SPAWN:
		// Continue spawning normal enemy for some more time if able to
		if (!_spawned_tile) 
		{
			var _can_spawn = true;
			if (instance_exists(obj_EnemyPAR) or instance_exists(obj_EnemyFalconSpawnerPAR)) _can_spawn = false;
			if (_can_spawn) with (obj_FarmPlot)
			{
				if (bbox_bottom <= 0.8*room_height) _can_spawn = false;
			}
			if (_can_spawn) event_user(0);
			break;
		}
		// Pond spawn + formation
		var _can_next = false;
		with (obj_LevelTile) if (sprite_index == spr_BgPond) _can_next = true;
		if (_can_next) 
		{
			alarm[11] = (3/global.speed_parallax)*formation_spawn_delay;		// spawn enemy formation
			enemy_can_spawn = 0;
			state++;
		}
	break;
	
	case LVLFARM.POND1_PASS:
	case LVLFARM.POND2_PASS:
		var _can_next = true;
		with (obj_LevelTile) if (sprite_index == spr_BgPond and bbox_bottom < room_height) _can_next = false;
		if (_can_next) state++;
	break;
	
	case LVLFARM.SHRINE_SPAWN:
		instance_create_layer(room_width/2, 0, "Ground", obj_EndShrine);
		state++;
	break;
	
	case LVLFARM.SHRINE_PASS:
		if (obj_EndShrine.bbox_bottom < room_height) break;
		state++;	
	break;
	
	case LVLFARM.SHRINE_END:
		if (_spawned_tile)
		{
			level_completed = true;		// remove the player and do the flyout
			with(obj_PlayerPAR) 
			{
				with (instance_create_layer(x, y, "Instances", obj_PlayerRabboDespawner)) sprite_index = other.s_idle;
				instance_destroy();
			}
			state++;
			audio_sound_gain(global.bgm_playing, 0, GAMESPD*50);
		}
	break;
	
	case LVLFARM.FLYOUT:
		if instance_exists(obj_PlayerRabboDespawner) break;
		
		state++;
		// Close the 'curtains'
		instance_create_layer(640, 0, "GUI_Top", obj_GUIScreenCloseLeft);
		instance_create_layer(640, 0, "GUI_Top", obj_GUIScreenCloseRight);
		audio_play_sound(snd_ScoreScreenClose, 1, false);
	break;
	
	case LVLFARM.SAVING:
		if (obj_GUIScreenCloseLeft.x != 640) break;
		// Save progress (only after success — END branch uses same crop threshold for fail UI)
		state++;
		var _level_index = clamp(global.current_level, 0, 15);
		var _ach_save = false;
		if (crops_filled >= crops_available) {
			_ach_save = AchievementMarkUnlocked("farm100", _level_index, "(" + string(crops_filled) + "/" + string(crops_available) + " crops)") || _ach_save;
		}
		if (!global.level_run_any_hp_damage) {
			_ach_save = AchievementMarkUnlocked("no_damage", _level_index, "(farm clear)") || _ach_save;
		}
		if (!global.level_run_ammo_aggression) {
			_ach_save = AchievementMarkUnlocked("no_aggression", _level_index, "(farm clear)") || _ach_save;
		}
		if (_ach_save) AchievementFarm100Save();
		if (crops_filled < crops_available) {
			show_debug_message("[Medal] Farm 100% not achieved this run (" + string(crops_filled) + " / " + string(crops_available) + " crops).");
		}
		if (global.level_run_any_hp_damage) {
			show_debug_message("[Medal] No-damage not awarded this run (took HP damage).");
		}
		if (global.level_run_ammo_aggression) {
			show_debug_message("[Medal] No-aggression not awarded this run (used ammo on enemies).");
		}
		if (global.game_mode == GAMEMODE.STORY && crops_filled >= 0.6 * crops_available) {
			AdvanceLevel();
		}
	break;
	
	case LVLFARM.END:
		// Create the mission complete, score, restart button
		if(crops_filled >= 0.6*crops_available)
		{
			with (instance_create_layer(room_width/2, 152, "GUI_Top", obj_GUIMissionAccomplished)) depth -= 1;
			with instance_create_layer(room_width/2, room_height/2 + 64, "GUI_Top", obj_GUIMissionAccomplishedScore)
			{
				depth -= 1;
				crops_filled = string(100*other.crops_filled/other.crops_available);
			}
			with instance_create_layer(room_width*0.1, room_height*0.9, "GUI_Top", obj_EndLevelRestart) depth -= 1;
			// Buttons - other (menu/next)
			if (global.game_mode == GAMEMODE.STORY)
			{
				with instance_create_layer(room_width/2, room_height*0.9, "GUI_Top", obj_EndLevelMenu) depth -= 1;
				with instance_create_layer(room_width*0.9, room_height*0.9, "GUI_Top", obj_EndLevelNext) depth -= 1;
			}
			else with instance_create_layer(room_width*0.9, room_height*0.9, "GUI_Top", obj_EndLevelMenu) depth -= 1;
			}	
		// Not enough crops filled, mission failed
		else
		{
			with (instance_create_layer(room_width/2, 152, "GUI_Top", obj_GUIMissionFailed))
			{
				depth -= 1;
				crops_filled = string(100*other.crops_filled/other.crops_available);
			}
			with instance_create_layer(room_width*0.9, room_height*0.9, "GUI_Top", obj_EndLevelMenu) depth -= 1;
			with instance_create_layer(room_width*0.1, room_height*0.9, "GUI_Top", obj_EndLevelRestart) depth -= 1;
		}
		
		state++;
	break;
	
}



//==========================================================
// Lerping the score
//==========================================================
var _next_score = lerp(global.score_current, global.score_base, 0.15);
if (round(_next_score) != round(global.score_current))
{
	if (!audio_is_playing(snd_ScoreTick)) audio_play_sound(snd_ScoreTick, 1, false);
}
global.score_current = _next_score;