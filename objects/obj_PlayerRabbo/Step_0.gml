// Get device for toggle check
var _device = global.control_device[player];
var _key_toggle = InputGet(INPUT.TOGGLE_AIM, true, _device);

// Toggle to aim at crops or enemy
if (!instance_exists(obj_Pause) && !instance_exists(obj_ControllerPause)) {
	if (_key_toggle) {
		aim_at_crops = !aim_at_crops;
		audio_play_sound(snd_ToggleSwitch, 1, false);
	}
}

// Check if can move
if(alarm[2] > 0 or !can_move) exit;

// Check for damaged status
if (hp_invincibility > 0) 
{
	hp_invincibility -= 1;
	trig_damaged = false;
	trig_damaged_breaker = false;
} 
else if (trig_damaged or trig_damaged_breaker)
{
	if StatsFortuneRoll() 
	{
		// Augment defense (fortune check)
		trig_damaged = false;
		trig_damaged_breaker = false;
		trig_fortune = true;
		// Did not break combos. Did not clear status
		hp_invincibility = 60;	// Invincible for 60 step;
	} else if (state == PLAYERSTATE.ROLL_LEFT or state == PLAYERSTATE.ROLL_RIGHT) {
		// Rolling makes player invincible of all source of damage (during roll only)
		trig_damaged = false;
		trig_damaged_breaker = false;
	} else if state == PLAYERSTATE.PARRY or state == PLAYERSTATE.LOOP {
		// Parrying makes player invincible from normal damage but not breaker damage
		if trig_damaged_breaker {
			damage_apply();
			damage_fx.apply();
			hp_invincibility = 50;
			// Damaged will reset paralysis, but not confusion
			status_paralysis_clear();
		}
		trig_damaged = false;
		trig_damaged_breaker = false;
	} else {
		// Apply damage
		damage_apply();
		damage_fx.apply();
		// Reset paralysis
		status_paralysis_clear();
	}	
}

if trig_fortune {
	trig_fortune = false;
	var _scr = instance_create_layer(x, y - 62, "GUI", obj_GUITextFlying);
	_scr.z = 0;
	_scr.color = c_black;
	_scr.text = "FORTUNATE!";
	_scr = instance_create_layer(x, y - 64, "GUI", obj_GUITextFlying);
	_scr.depth -= 1;
	_scr.z = 0;
	_scr.color = c_white;
	_scr.text = "FORTUNATE!";
}

if trig_foresight {
	trig_foresight = false;
	if StatsForesightRoll() {
		// If foresight permit, show message
		var _scr = instance_create_layer(x, y - 62, "GUI", obj_GUITextFlying);
		_scr.z = 0;
		_scr.color = c_black;
		_scr.text = "FORESIGHT!";
		_scr = instance_create_layer(x, y - 64, "GUI", obj_GUITextFlying);
		_scr.depth -= 1;
		_scr.z = 0;
		_scr.color = c_white;
		_scr.text = "FORESIGHT!";
	}
}

if trig_paralyzed {
	// Check for fortitude activation, can't be paralyzed if rolling sideways
	trig_paralyzed = false;
	trig_fortitude = true;
	if (state != PLAYERSTATE.ROLL_LEFT and state != PLAYERSTATE.ROLL_RIGHT) paralysis_counter = 4*GAMESPD;
}
if trig_confused {
	// Check for fortitude activation
	trig_confused = false;
	trig_fortitude = true;
	if (state != PLAYERSTATE.ROLL_LEFT and state != PLAYERSTATE.ROLL_RIGHT) confusion_counter = 10*GAMESPD;
}
if trig_fortitude {		// Disabled (old) - StatsFortitudeRoll will always return 0
	// Fortitude only triggered by paralysis
	trig_fortitude = false;
	if StatsFortitudeRoll() {
		// If foresight permit, reset paralysis adn confusion, and show message
		paralysis_counter = 0;
		confusion_counter = 0;
		var _scr = instance_create_layer(x, y - 62, "GUI", obj_GUITextFlying);
		_scr.z = 0;
		_scr.color = c_black;
		_scr.text = "FORTITUDE!";
		_scr = instance_create_layer(x, y - 64, "GUI", obj_GUITextFlying);
		_scr.depth -= 1;
		_scr.z = 0;
		_scr.color = c_white;
		_scr.text = "FORTITUDE!";
	} else {
		// When unsuccessful, reduce paralysis duration
		paralysis_counter = paralysis_counter * (1 - (obj_Main.profile.stat.fortitude * 0.125));
		confusion_counter = confusion_counter * (1 - (obj_Main.profile.stat.fortitude * 0.125));
	}
}

// Effect of paralysis
if (paralysis_counter > 0)
{
	paralysis_counter --;
	can_control = false;
} else can_control = true;
// Effect of confusion
if (confusion_counter > 0) confusion_counter--;

// Check for death
if trig_death {
	trig_death = false;
	TweenStart("y", y, y + 720, 3*GAMESPD, TWEENTYPE.CUBIC_IN);
	state = PLAYERSTATE.DEATH;
}
// Get input
var _device = global.control_device[player];
// loop-de-loop
var _in_loop = InputGet(INPUT.LOOP_DE_LOOP, 1, _device);
if (alarm[0] > 0) _in_loop = false;

// Confusion exchanges input
if confusion_counter > 0 {
	var _key_right = InputGet(INPUT.LEFT, 0,_device);
	var _key_left = InputGet(INPUT.RIGHT, 0,_device);
	var _key_action_p = InputGet(INPUT.SEED, 0,_device);
	var _key_space_p = InputGet(INPUT.WATER, 0,_device);
	var _roll_right = InputGet(INPUT.ROLL_LEFT, 0, _device);
	var _roll_left = InputGet(INPUT.ROLL_RIGHT, 0, _device);
	_in_loop = false; 
}
else
{
	var _key_left = InputGet(INPUT.LEFT, 0,_device);
	var _key_right = InputGet(INPUT.RIGHT, 0,_device);
	var _key_action_p = InputGet(INPUT.WATER, 0,_device);
	var _key_space_p = InputGet(INPUT.SEED, 0,_device);
	var _roll_left = InputGet(INPUT.ROLL_LEFT, 0,_device);
	var _roll_right = InputGet(INPUT.ROLL_RIGHT, 0,_device);
}

// other input
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
var _key_shift_p = InputGet(INPUT.SHIFT,,_device);
var _key_parry_p = InputGet(INPUT.PARRY,,_device);
var _b_ltrig = InputGet(INPUT.L2,,_device);
var _b_rtrig = InputGet(INPUT.R2,,_device);

// Check to disable input
if !can_control 
{
	_key_left = false;
	_key_right = false;
	_key_action_p = false;
	_key_space_p = false;
	_key_speed_down = false;
	_key_shift_p = false;
	_key_parry_p = false;
	_b_ltrig = false;
	_b_rtrig = false;
	_roll_right = false;
	_roll_left = false;
	_key_toggle = false;
}

// State machine
switch(state) {
	case PLAYERSTATE.IDLE:
		// Action
		if (_key_left) hsp -= global.movement_bank_speed;
		if (_key_right) hsp += global.movement_bank_speed;
		PlayerSpeedChange(_key_speed_up, _key_speed_down);
		PlayerRollCooldown();
		hsp = hsp * (1 - speed_bank_inertia);
		// Transition
		if PlayerLoopCheck(_in_loop){
			show_debug_message("loop-de-loop triggered."); 
			alarm[0] = loop_de_loop_cd;
			// Done by function call	
		} else if PlayerParryCheck(_key_parry_p){
			// Done by function call
		} else if _roll_left {
			PlayerRollCheck(PLAYERSTATE.ROLL_LEFT);
		} else if _roll_right {
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
		PlayerSpeedChange(_key_speed_up, _key_speed_down);
		PlayerRollCooldown();
		hsp = hsp * (1 - speed_bank_inertia);
		// Transition
		if PlayerParryCheck(_key_parry_p) {
			// Done by function call
		//} else if (_key_shift_p && _key_left) || _b_ltrig {
		} else if(_roll_left){
			PlayerRollCheck(PLAYERSTATE.ROLL_LEFT);
		//} else if (_key_shift_p && _key_right) || _b_rtrig {
		} else if (_roll_right) {
			PlayerRollCheck(PLAYERSTATE.ROLL_RIGHT);
		} else if (!_key_left) {
			state = PLAYERSTATE.IDLE;	
		}
		break;
	case PLAYERSTATE.BANK_RIGHT:
		// Action
		if _key_left hsp -= global.movement_bank_speed;
		if _key_right hsp += global.movement_bank_speed;
		PlayerSpeedChange(_key_speed_up, _key_speed_down);
		PlayerRollCooldown();
		hsp = hsp * (1 - speed_bank_inertia);
		// Transition
		if PlayerParryCheck(_key_parry_p) {
			// Done by function call
		} 
		//else if (_key_shift_p && _key_left) || _b_ltrig {
		else if(_roll_left)
		{
			PlayerRollCheck(PLAYERSTATE.ROLL_LEFT);
		//} else if (_key_shift_p && _key_right) || _b_rtrig {
		} else if (_roll_right) {
			PlayerRollCheck(PLAYERSTATE.ROLL_RIGHT);
		} else if (!_key_right) {
			state = PLAYERSTATE.IDLE;	
		}
		break;
	case PLAYERSTATE.ROLL_LEFT:
		hsp -= speed_roll_multiplier * global.movement_bank_speed;
		// Allow small control
		if _key_right hsp += global.movement_bank_speed;
		hsp = hsp * (1 - speed_bank_inertia);
		// Create shadow
		var _shadow = instance_create_layer(x, y, layer, obj_PlayerShadow);
		_shadow.sprite_index = sprite_index;
		_shadow.image_index = image_index;
		_shadow.image_speed = 0;
	
		// Transition
		if trig_anim_end {
			state = PLAYERSTATE.IDLE;	
		}
		break;
	case PLAYERSTATE.ROLL_RIGHT:
		hsp += speed_roll_multiplier * global.movement_bank_speed;
		// Allow small control
		if _key_left hsp -= global.movement_bank_speed;
		hsp = hsp * (1 - speed_bank_inertia);
		// Create shadow
		var _shadow = instance_create_layer(x, y, layer, obj_PlayerShadow);
		_shadow.sprite_index = sprite_index;
		_shadow.image_index = image_index;
		_shadow.image_speed = 0;
		
		// Transition
		if trig_anim_end {
			state = PLAYERSTATE.IDLE;	
		}
		break;
	case PLAYERSTATE.PARRY:
		// Create parry hitbox
		if parry_hitbox == noone {
			parry_hitbox = instance_create_layer(x, y, layer, obj_PlayerParry);
			parry_hitbox.depth -= 1;
			parry_hitbox.master = id;
			if hsp != 0 parry_hitbox.image_xscale = sign(-hsp);
		}
		
		// Change parry direction
		if (hsp != 0) image_xscale = sign(-hsp);
		
		// Transition
		if trig_anim_end {
			image_xscale = 1;
			instance_destroy(parry_hitbox);
			parry_hitbox = noone;
			state = PLAYERSTATE.IDLE;
			PlayerParryCheck(_key_parry_p);
		}
		break;
	case PLAYERSTATE.DEATH:
		death_counter -= 1;

		if death_counter <= 0 {
			obj_ControllerPAR.multiplayer_status[player][MPPROP.COOLDOWN] = 600; // Cooldown for 10 seconds
			instance_destroy();
		}
		break;
	case PLAYERSTATE.LOOP:
		// Action
		if _key_left hsp -= global.movement_bank_speed;
		if _key_right hsp += global.movement_bank_speed;
		PlayerRollCooldown();
		hsp = hsp * (1 - speed_bank_inertia);
		
		global.speed_parallax = -6;
		
		// Transition
		if trig_anim_end {
			// Only restore if no other player is in LOOP state
			var _other_player_looping = false;
			with(obj_PlayerPAR) {
				if (id != other.id && state == PLAYERSTATE.LOOP) {
					_other_player_looping = true;
				}
			}
			
			if (!_other_player_looping) {
				global.speed_parallax = parallax_speed_prev;
			}
			state = PLAYERSTATE.IDLE;	
		}
		break;
}

// Aim shooting
var _target_y = -1000;
var _aim_plot = false;
if (aim_at_crops) {
	var i = shoot_target_acquisition_minimum;	// Min acquisition range
	var _aim_success = false;
	repeat(shoot_target_acquisition_range)		// Aim for 1280 pixel
	{ 
		var _plot = instance_position(x, y - i, obj_FarmPlot);
		if (_plot != noone and (_plot.state == PLOTSTATE.EMPTY or _plot.state == PLOTSTATE.SEEDED or _plot.state == PLOTSTATE.WATERED)) 
		{
			if (shoot_target != noone and shoot_target.targeted != noone) 
			{
				var _index = -1;
				for (var i = 0; i < array_length(shoot_target.targeted); i++) 
					if (shoot_target.targeted[i] == player) _index = i;
				if (_index > -1) array_delete(shoot_target.targeted, _index, 1);
				//shoot_target.targeted = [];
			}
			shoot_target = _plot;
			var _target = true;
			for (var i = 0; i < array_length(shoot_target.targeted); i++) 
			{
				if (shoot_target.targeted[i] == player) _target = false;
			}
			if (_target) array_push(shoot_target.targeted, player);
			_aim_success = true;
			break;
		}
		i++;
	}
	_aim_plot = _aim_success;
	// No valid crop in the aim cone — drop crop targeting (shrine handled below when aim is on)
	if (!_aim_success && shoot_target != noone && shoot_target.object_index == obj_FarmPlot)
	{
		var _index = -1;
		for (var i = 0; i < array_length(shoot_target.targeted); i++) 
			if (shoot_target.targeted[i] == player) _index = i;
		if (_index > -1) array_delete(shoot_target.targeted, _index, 1);
		shoot_target = noone;
	}
}
else {
	// Aim off: free-fire — clear crop or shrine lock and untarget
	if (shoot_target != noone && instance_exists(shoot_target)
		&& (shoot_target.object_index == obj_FarmPlot || shoot_target.object_index == obj_EndShrine))
	{
		var _index = -1;
		for (var i = 0; i < array_length(shoot_target.targeted); i++) 
			if (shoot_target.targeted[i] == player) _index = i;
		if (_index > -1) array_delete(shoot_target.targeted, _index, 1);
		shoot_target = noone;
	}
}

// Crop row takes priority over the end shrine when both could apply
if (_aim_plot && instance_exists(obj_EndShrine))
{
	var _si = -1;
	for (var _ti = 0; _ti < array_length(obj_EndShrine.targeted); _ti++)
		if (obj_EndShrine.targeted[_ti] == player) _si = _ti;
	if (_si > -1) array_delete(obj_EndShrine.targeted, _si, 1);
}

// End shrine: only while crop reticle mode is on; wider horizontal band than raw bbox; never steals an active crop lock
if (aim_at_crops && !_aim_plot && instance_exists(obj_EndShrine))
{
	var _shr = obj_EndShrine.id;
	var _x_lo = _shr.bbox_left - shoot_target_shrine_horizontal_extra;
	var _x_hi = _shr.bbox_right + shoot_target_shrine_horizontal_extra;
	if (_shr.bbox_bottom < y && _x_lo < x && _x_hi > x)
	{
		if (shoot_target != noone && shoot_target != _shr && shoot_target.targeted != noone)
		{
			var _index = -1;
			for (var i = 0; i < array_length(shoot_target.targeted); i++) 
				if (shoot_target.targeted[i] == player) _index = i;
			if (_index > -1) array_delete(shoot_target.targeted, _index, 1);
		}
		shoot_target = _shr;
		var _target = true;
		for (var i = 0; i < array_length(shoot_target.targeted); i++) 
		{
			if (shoot_target.targeted[i] == player) _target = false;
		}
		if (_target) array_push(shoot_target.targeted, player);
		var _count = 50;
		do
		{
			_target_y = irandom_range(_shr.bbox_top, _shr.bbox_bottom);
			_count--;
		}
		until (collision_point(x, _target_y, obj_EndShrine, true, false) or _count < 0);
	}
	else if (shoot_target == _shr)
	{
		var _index = -1;
		for (var i = 0; i < array_length(shoot_target.targeted); i++) 
			if (shoot_target.targeted[i] == player) _index = i;
		if (_index > -1) array_delete(shoot_target.targeted, _index, 1);
		shoot_target = noone;
		_target_y = -1000;
	}
}

var _aiming_shrine = instance_exists(obj_EndShrine) && shoot_target == obj_EndShrine.id;

// Perform shooting
if (shoot_cooldown_seed > 0) {
	shoot_cooldown_seed -= 1;
} else if (_key_space_p && can_shoot) {
	var _have_ammo = !shoot_ammo_depletion || (shoot_ammo_depletion && shoot_ammo_seed > 0);
	if _have_ammo {
		shoot_cooldown_seed = shoot_cooldown_period_seed;
		if (shoot_target != noone) {
			// Create targeted projectile
			var _proj = instance_create_layer(x, y, "Instances", obj_PlayerProjectileSeed);
			if (!_aiming_shrine) 
			{
				_proj.hsp = (shoot_target.x - x) / ((y - shoot_target.y)/speed_projectile_seed);
				_proj.zsp = (shoot_target.z) / ((y - shoot_target.y)/speed_projectile_seed);
			}
			else 
			{
				_proj.zsp = (shoot_target.z) / ((y - _target_y)/speed_projectile_seed);
				_proj.target_y = _target_y;
				_proj.pos_y = _target_y;
			}
			_proj.vsp = -speed_projectile_seed;
			_proj.target = shoot_target;
		} else {
			// Create a normal seed projectile
			var _proj = instance_create_layer(x, y, "Top", obj_PlayerProjectileSeed);
			_proj.vsp = -speed_projectile_seed;
		}
		// Reduce ammo
		if (shoot_ammo_depletion) shoot_ammo_seed -= 1;
		audio_play_sound(snd_ProjSeedShot, 1, false);
	}
}
if (shoot_cooldown_water > 0) {
	shoot_cooldown_water -= 1;
} else if (_key_action_p && can_shoot) {
	
	// If in the boss fight with 1st boss, check for phase
	if(instance_exists(obj_FalconHighTop))
	{
		var _phase1 = [ENEMIES.INIT, ENEMIES.INIT_WAIT, ENEMIES.PHASE_1_TALK, ENEMIES.PHASE_1_TALK_WAIT,
			ENEMIES.PHASE_1_SPAWN, ENEMIES.PHASE_1_COMBAT];
		
		// In phase 2, falcons dodge the shooting if not diving
		if(!array_contains(_phase1, obj_ControllerFightBoss1_3.state))
		{
			with(obj_FalconHighTop) if(state != BOSS.DIVE) state = BOSS.DODGE;
		}
	}
	
	shoot_cooldown_water = shoot_cooldown_period_water;
	var _have_ammo = !shoot_ammo_depletion || (shoot_ammo_depletion && shoot_ammo_water > 0);
	if _have_ammo {
		if (shoot_target != noone) {
			// Create targeted projectile
			var _proj = instance_create_layer(x, y, "Instances", obj_PlayerProjectileWater);
			if (!_aiming_shrine) 
			{
				_proj.hsp = (shoot_target.x - x) / ((y - shoot_target.y)/speed_projectile_seed);
				_proj.zsp = (shoot_target.z) / ((y - shoot_target.y)/speed_projectile_seed);
			}
			else 
			{
				_proj.zsp = (shoot_target.z) / ((y - _target_y)/speed_projectile_seed);
				_proj.target_y = _target_y;
				_proj.pos_y = _target_y;
			}
			_proj.vsp = -speed_projectile_water;
			_proj.target = shoot_target;
		} else {
			// Create a normal water projectile
			var _proj = instance_create_layer(x, y, "Top", obj_PlayerProjectileWater);
			_proj.vsp = -speed_projectile_water;
		}
		// Reduce ammo
		if shoot_ammo_depletion shoot_ammo_water -= 1;
		audio_play_sound(snd_ProjWaterShot, 1, false);
	}
}
// Perform auto shooting
if trig_shoot_auto {
	trig_shoot_auto = false;
	// Create a normal seed projectile
	var _proj = instance_create_layer(x, y, "Top", obj_PlayerProjectileSeed);
	_proj.vsp = -speed_projectile_seed;
	_proj.have_shadow = true;
}

// Apply wind draft based on weather. Only active when wind blows
//if(instance_exists(obj_WindParticles)){
//	if(obj_WindParticles.wind_blowing != 0 and state != PLAYERSTATE.LOOP)
//	{
//		var _wind_dir = -1;	// -1 because WeatherGetWindDraft returns negative val;
//		if(obj_WindParticles.wind_dir == 180) _wind_dir = 1;				
//		hsp += WeatherGetWindDraft() * _wind_dir * 2;
//	}
//}
if (state != PLAYERSTATE.LOOP and state != PLAYERSTATE.PARRY) hsp += WeatherGetWindDraft();

// Perform movement
if(state != PLAYERSTATE.PARRY) x += hsp;

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
