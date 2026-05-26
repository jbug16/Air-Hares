 //////////////////////////////////   Gameplay   ////////////////////////////////////

// check if alive
function PlayerCheckAlive(_player){
	with(obj_PlayerRabboSpawner){
		if player == _player {
			return true;	
		}
	}
	with(obj_PlayerPAR){
		if player == _player {
			return true;
		}
	}
	return false;
}

/// spr_Targets: subimages 0–4 match CHARACTER; 5 = both players on same crop/shrine
function TargetReticleSpriteIndex(_player_slot, _both_players_on_same_target) {
	if (_both_players_on_same_target) return 5;
	var _c = CHARACTER.RABBO;
	with (obj_PlayerPAR) {
		if (player == _player_slot) _c = character;
	}
	return clamp(_c, 0, 4);
}

/// @desc HP fill colors by character [minColor, maxColor]
function PlayerHpFillColors(_character) {
	switch (_character) {
		case CHARACTER.RABBO: return [c_aqua, c_blue];
		case CHARACTER.DIRK: return [c_lime, c_green];
		case CHARACTER.LINNIE: return [c_yellow, c_orange];
		case CHARACTER.BETTY: return [c_aqua, c_teal];
		case CHARACTER.CANDIE: return [c_fuchsia, c_purple];
	}
	return [c_aqua, c_blue];
}

/// @desc Target background tint by player slot using character colors
/// Uses the lighter variant in BUSTING, darker/primary otherwise.
function PlayerTargetTintColor(_player_slot) {
	var _c = CHARACTER.RABBO;
	with (obj_PlayerPAR) {
		if (player == _player_slot) _c = character;
	}
	var _hp_col = PlayerHpFillColors(_c);
	if (global.overworld_progress == PLOTSTATE.BUSTING) return _hp_col[0];
	return _hp_col[1];
}


//@func PlayerAssignSprite(_character)
// Assign sprite set to curretn player class
function PlayerAssignSprite(_character){
	s_idle = global.character_sprite[_character][CHARACTER_SPRITE.IDLE];
	s_bank_left = global.character_sprite[_character][CHARACTER_SPRITE.BANK_LEFT]
	s_bank_left_max = global.character_sprite[_character][CHARACTER_SPRITE.BANK_LEFT_MAX]
	s_bank_right= global.character_sprite[_character][CHARACTER_SPRITE.BANK_RIGHT]
	s_bank_right_max = global.character_sprite[_character][CHARACTER_SPRITE.BANK_RIGHT_MAX]
	s_roll_left = global.character_sprite[_character][CHARACTER_SPRITE.ROLL_LEFT]
	s_roll_right= global.character_sprite[_character][CHARACTER_SPRITE.ROLL_RIGHT]
	s_parry = global.character_sprite[_character][CHARACTER_SPRITE.PARRY]; 
	s_loop = global.character_sprite[_character][CHARACTER_SPRITE.LOOP];
	s_death = global.character_sprite[_character][CHARACTER_SPRITE.DEATH];
}

function PlayerCreateBossEndingProp(_player_inst) {
	if (!instance_exists(_player_inst)) return noone;

	var _prop = instance_create_layer(_player_inst.x, _player_inst.y, "Top", obj_PlayerRabboProp);
	_prop.player = _player_inst.player;
	_prop.character = _player_inst.character;
	_prop.can_control = false;

	with (_prop) {
		PlayerAssignSprite(character);
		sprite_index = s_idle;
	}
	return _prop;
}

function PlayerSpriteSet(s_index){
	if (sprite_index != s_index) {
		sprite_index = s_index;
		trig_anim_end = false;
	}
}

function PlayerParryCheck(_in_parry){
	if (_in_parry and global.movement_parry > 0) { // Check if input is true, and parry is enabled
		state = PLAYERSTATE.PARRY;
		return true;
	}
	return false;
}

function PlayerLoopCheck(_in_loop){
	if (_in_loop and global.movement_loop > 0) { // Check if input is true, and can loop.
		
		var _dist = loop_parallax_target;
		
		// Only save the previous speed if we're not already in a loop state
		if (global.speed_parallax != _dist) parallax_speed_prev = global.speed_parallax;
		state = PLAYERSTATE.LOOP;
		image_index = 0;
				
		// Trigger loop for the other player in co-op mode
		with(obj_PlayerPAR) {
			if (id != other.id && state != PLAYERSTATE.LOOP && state != PLAYERSTATE.DEATH) {
				if (global.speed_parallax != _dist) parallax_speed_prev = global.speed_parallax;
				state = PLAYERSTATE.LOOP;
				
				PlayerSpriteSet(s_loop);
				trig_anim_end = false;
				image_index = 0;
			}
		}
		
		return true;
	}
	return false;
}

function PlayerRollCooldown(){
	if global.movement_barrel_roll_temp > 0 {
		global.movement_barrel_roll_temp = max(global.movement_barrel_roll_temp - global.movement_barrel_roll_temp_cooling, 0);
	}
}

function PlayerRollCheck(_roll_state){
	// Check if player can roll
	if (global.movement_barrel_roll > 0) {
		if ((global.movement_barrel_roll_temp + global.movement_barrel_roll_temp_increase) <= global.movement_barrel_roll) {
			// Consume the roll temp
			// global.movement_barrel_roll_temp += global.movement_barrel_roll_temp_increase;
			// Disabled barrel roll cooldown
			audio_play_sound(sound_roll, 1, false);
			state = _roll_state;	
		}
	}
}

function PlayerRemoveFraction(){
	// Recover fraction
	x += x_stored;
	x_stored = 0;
	y += y_stored;
	y_stored = 0;
	
	// Store fraction
	var x_rounded = round(x);
	x_stored = x - x_rounded;
	x = x_rounded;
	var y_rounded = round(y);
	y_stored = y - y_rounded;
	y = y_rounded;
}

function PlayerSpeedChange(_key_up, _key_down){
	if _key_up global.speed_parallax = clamp(global.speed_parallax + 0.05, 0.75, 3);
	if _key_down global.speed_parallax = clamp(global.speed_parallax - 0.05, 0.75, 3);
}

function PlayerStatsArmorLoad(){
	// Base armor + adjustment according to stage
	return global.armor_strength + global.current_level div 4;
}

function GetAmmo(){
	// Load default ammo
	var _base = global.ammo_max;
	// Load adjustment from world
	if (global.current_level mod 4 >= 2) _base += 40;
	else if (global.current_level mod 4 >= 1) _base += 20;
	
	// Return ammo load
	return _base;
}



// Add combos. Return applied score
function CombosAddHit(_score_add){
	if (StoryPeacefulIntroFarmActive()) return 0;
	// Apply hit to current combos
	global.combos_count += 1;
	// Apply multiplier
	var _prev_mul = global.combos_multiplier;
	global.combos_multiplier = min(1 + floor(global.combos_count / 5), 5);
	if (_prev_mul != global.combos_multiplier) global.combos_multiplier_increase = true;
	// Apply to score
	var _score_apply = (_score_add * global.combos_multiplier);
	global.score_base += _score_apply;
	
	//switch(global.combos_multiplier){
	//	case 1:
	//		global.combos_pronoun = "Settlin'";
	//		break;
	//	case 2:
	//		global.combos_pronoun = "Strollin'";
	//		break;
	//	case 3:
	//		global.combos_pronoun = "Skiddin'";
	//		break;
	//	case 4:
	//		global.combos_pronoun = "Sprintin'";
	//		break;
	//	case 5:
	//		global.combos_pronoun = "Soarin'";
	//		break;
	//	default:
	//		global.combos_pronoun = "Soarin'";
	//		break;
	//}
	
	return _score_apply;
}

// Add combos. Return applied score
function CombosAddHitNoMultiply(_score_add){
	if (StoryPeacefulIntroFarmActive()) return 0;
	// Apply hit to current combos

	// Apply to score
	var _score_apply = (_score_add * global.combos_multiplier);
	global.score_base += _score_apply;
	
	//switch(global.combos_multiplier){
	//	case 1:
	//		global.combos_pronoun = "Settlin'";
	//		break;
	//	case 2:
	//		global.combos_pronoun = "Strollin'";
	//		break;
	//	case 3:
	//		global.combos_pronoun = "Skiddin'";
	//		break;
	//	case 4:
	//		global.combos_pronoun = "Sprintin'";
	//		break;
	//	case 5:
	//		global.combos_pronoun = "Soarin'";
	//		break;
	//	default:
	//		global.combos_pronoun = "Soarin'";
	//		break;
	//}
	
	return _score_apply;
}

// Reset comboss.
function CombosAddMiss(_score_add){
	if (StoryPeacefulIntroFarmActive()) return 0;
	// Apply miss to current combos
	global.combos_count = 0;
	// Reset multiplier
	global.combos_multiplier = 1;
	// Apply to score
	global.score_base += _score_add;
	global.combos_pronoun = "Slippin'";
	
	return _score_add;
}



//////////////////////////////////   Stats   ////////////////////////////////////
function StatsFortuneUpgrade(){
	if obj_Main.profile.stat.fortune < 6 && global.currency_cloud > 1 {
		obj_Main.profile.stat.fortune += 1;
		global.currency_cloud -= 1;
		if obj_Main.profile.stat.fortune == 6 {
			text = "MAX FORTUNE";	
		}
		obj_Main.profile.stat_save();
		audio_play_sound(snd_ProjSeedShot, 1, false);
		return true;
	} else {
		return false;	
	}
}

function StatsFortuneRoll(){
	// Returns true or false based on fortune stats. True means fortune is activated
	var _fortune_chance = obj_Main.profile.stat.fortune * 0.05;
	if random(1) < _fortune_chance {
		return true;	
	} else {
		return false;	
	}
}

function StatsForesightUpgrade(){
	if obj_Main.profile.stat.foresight < 6 && global.currency_cloud > 1  {
		obj_Main.profile.stat.foresight += 1;
		global.currency_cloud -= 1;
		if obj_Main.profile.stat.foresight == 6 {
			text = "MAX FORESIGHT";	
		}
		obj_Main.profile.stat_save();
		audio_play_sound(snd_ProjSeedShot, 1, false);
		return true;
	} else {
		return false;	
	}
}

function StatsForesightRoll(){
	// Returns true or false based on fortune stats. True means fortune is activated
	var _fortune_chance = obj_Main.profile.stat.foresight * (0.17);
	if random(1) < _fortune_chance {
		return true;	
	} else {
		return false;	
	}
}

function StatsFortitudeUpgrade(){
	if obj_Main.profile.stat.fortitude < 6 && global.currency_cloud > 1  {
		obj_Main.profile.stat.fortitude += 1;
		global.currency_cloud -= 1;
		if obj_Main.profile.stat.fortitude == 6 {
			text = "MAX FORTITUDE";	
		}
		obj_Main.profile.stat_save();
		audio_play_sound(snd_ProjSeedShot, 1, false);
		return true;
	} else {
		return false;	
	}
}

function StatsFortitudeRoll(){
	// Returns true or false based on fortune stats. True means fortune is activated
	var _fortune_chance = obj_Main.profile.stat.fortitude * (0.17);
	if random(1) < _fortune_chance {
		return true;	
	} else {
		return false;	
	}
}


function CurrencySave(){
	SaveIniOpen();
	SaveIniWriteReal("currency", "cloud", global.currency_cloud);
	SaveIniWriteReal("currency", "blue", global.currency_feather_blue);
	SaveIniWriteReal("currency", "brown", global.currency_feather_brown);
	SaveIniWriteReal("currency", "black", global.currency_feather_black);
	SaveIniWriteReal("currency", "purple", global.currency_feather_purple);
	SaveIniWriteReal("currency", "hightop", global.currency_feather_hightop);
	SaveIniWriteReal("currency", "bigred", global.currency_feather_bigred);
	SaveIniWriteReal("currency", "goldgrip", global.currency_feather_goldgrip);
	SaveIniWriteReal("currency", "twinhorn", global.currency_feather_twinhorn);
	SaveIniClose();
}