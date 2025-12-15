// Get input
var _device = global.control_device[player];
var _key_left = InputGet(INPUT.LEFT, 0, _device);
var _key_right = InputGet(INPUT.RIGHT, 0, _device);
var _b_ltrig = InputGet(INPUT.L2,, _device);
var _b_rtrig = InputGet(INPUT.R2,, _device);
if (_device == -1)
{
	var _key_speed_up = InputGet(INPUT.UP, 0,_device);
	var _key_speed_down = InputGet(INPUT.DOWN, 0,_device);
}
else
{
	var _key_speed_up = InputGet(INPUT.RAXIS_UP, 0,_device);
	var _key_speed_down = InputGet(INPUT.RAXIS_DOWN, 0,_device);
}
var _key_parry_p = InputGet(INPUT.PARRY, _device);
var _key_shift_p = InputGet(INPUT.SHIFT, _device);

if(instance_exists(obj_ControllerPAR) and !can_control)
{
	_key_speed_up = false;
	_key_speed_down = false;
	_key_parry_p = false;
	_key_shift_p = false;
	_key_left = false;
	_key_right = false;
	_b_ltrig = false;
	_b_rtrig = false;
}

// State machine
switch(state) {
	case PLAYERSTATE.IDLE:
		// Action
		if _key_left hsp -= global.movement_bank_speed;
		if _key_right hsp += global.movement_bank_speed;
		if(instance_exists(obj_ControllerFightBoss1_3) and !instance_exists(obj_BossHighTop)) PlayerSpeedChange(_key_speed_up, _key_speed_down);
		PlayerRollCooldown();
		hsp = hsp * (1 - speed_bank_inertia);
		
		// Transition
		if PlayerParryCheck(_key_parry_p){
			// Done by function call
		} else if (_key_shift_p && _key_left) or _b_ltrig {
			PlayerRollCheck(PLAYERSTATE.ROLL_LEFT);
		} else if (_key_shift_p && _key_right) or _b_rtrig {
			PlayerRollCheck(PLAYERSTATE.ROLL_RIGHT);
		} else if (_key_left) {
			state = PLAYERSTATE.BANK_LEFT;	
		} else if (_key_right) {
			state = PLAYERSTATE.BANK_RIGHT;
		}
		break;
	case PLAYERSTATE.BANK_LEFT:
		// Action
		if _key_left hsp -= global.movement_bank_speed;
		if _key_right hsp += global.movement_bank_speed;
		if(instance_exists(obj_ControllerFightBoss1_3) and !instance_exists(obj_BossHighTop)) PlayerSpeedChange(_key_speed_up, _key_speed_down);
		PlayerRollCooldown();
		hsp = hsp * (1 - speed_bank_inertia);
	
		// Transition
		if PlayerParryCheck(_key_parry_p) {
			// Done by function call
		} else if (_key_shift_p && _key_left) or _b_ltrig {
			PlayerRollCheck(PLAYERSTATE.ROLL_LEFT);
		} else if (_key_shift_p && _key_right) or _b_rtrig {
			PlayerRollCheck(PLAYERSTATE.ROLL_RIGHT);
		} else if (!_key_left) {
			state = PLAYERSTATE.IDLE;	
		}
		break;
	case PLAYERSTATE.BANK_RIGHT:
		// Action
		if _key_left hsp -= global.movement_bank_speed;
		if _key_right hsp += global.movement_bank_speed;
		if(instance_exists(obj_ControllerFightBoss1_3) and !instance_exists(obj_BossHighTop)) PlayerSpeedChange(_key_speed_up, _key_speed_down);
		PlayerRollCooldown();
		hsp = hsp * (1 - speed_bank_inertia);
	
		// Transition
		if PlayerParryCheck(_key_parry_p) {
			// Done by function call
		} else if (_key_shift_p && _key_left) or _b_ltrig {
			PlayerRollCheck(PLAYERSTATE.ROLL_LEFT);
		} else if (_key_shift_p && _key_right) or _b_rtrig {
			PlayerRollCheck(PLAYERSTATE.ROLL_RIGHT);
		} else if (!_key_right) {
			state = PLAYERSTATE.IDLE;	
		}
		break;
}

// Perform movement
x += hsp;

// Remove fraction
PlayerRemoveFraction();

// Clamp position
x = clamp(x, BORDER_LEFT, BORDER_RIGHT);

// Change sprite
switch(state) {
	case PLAYERSTATE.IDLE:
	case PLAYERSTATE.BANK_LEFT:
	case PLAYERSTATE.BANK_RIGHT:
		if (hsp <= 0.5 && hsp >= -0.5) {
			PlayerSpriteSet(s_idle);
		} else if (hsp > 3) {
			sprite_index = s_bank_right_max;	
		} else if (hsp < -3) {
			sprite_index = s_bank_left_max;	
		} else if hsp >= 0.5 {
			sprite_index = s_bank_right; 
			image_index = floor(hsp);
		} else if hsp <= -0.5 {
			sprite_index = s_bank_left;
			image_index = abs(ceil(hsp));
		}
		break;
	case PLAYERSTATE.ROLL_LEFT:
		PlayerSpriteSet(s_roll_left);
		break;
	case PLAYERSTATE.ROLL_RIGHT:
		PlayerSpriteSet(s_roll_right);
		break;
	case PLAYERSTATE.PARRY:
		PlayerSpriteSet(s_parry);
		break;
	case PLAYERSTATE.LOOP:
		PlayerSpriteSet(s_loop);
		break;
	case PLAYERSTATE.DEATH:
		PlayerSpriteSet(s_death);
		break;
}

// Tail smoke
if !instance_exists(smoke) smoke = instance_create_depth(x, y + 120, depth, obj_PlayerPlaneSmoke);