/// @desc
event_inherited();

//==========================================================
// ADJUSTABLE
//==========================================================
//----------------------------------------------------------
// Attacks and states in phases
//----------------------------------------------------------
prep_attack_counter = 0;		// Alarm between prep and attack
prep_attack_duration = 100;		// Period between prep and attack
prep_attack_state = noone;		// State for preparing (based on phases 1-4)
prep_counter = -1;
prep_period = [1.5*GAMESPD, 2*GAMESPD, 2.5*GAMESPD, 3*GAMESPD];	// phases 1/2/3/4 of sequence 2 - wait next phase & between shots
prep_pellet_shot = 0;					// Number of shots taken by twinhorn
prep_pellet_countered = 0;				// Count number of pellets not countered by player
dive_followup_homing = 0.45;			// Hoiming speed
dive_feint_period = 10;					// Period between dive and recovery
dive_feint_counter = dive_feint_period;
hurt_delay = 1.5*GAMESPD;

//===================== Phase 1 =======================
prep_1_pellet_dive = 4;				// Max number of pellets uncountered to trigger master dive
attack_1_dive_homing = 0.45;		// Homing ability
attack_1_dive_master_homing = 0.65;	// Homing ability

//===================== Phase 2 =======================
prep_2_pellet_dive = 4;				// Number of shots before dive

//===================== Phase 3 =======================
prep_3_pellet_dive = 4;
prep_3_initial_psychic = false;		// Initial psychic attack on 3rd phase
prep_3_phase_repeat = false;		// Flag if it is phase repeat (for lightning)
//===================== Phase 4 =======================
prep_4_pellet_dive = 72;			// How many pellets should be shot in one time
attack_4_angle_diff = 0				// spread
attack_4_burst = 8;					// one burst - side direction pellets
attack_4_pellets_shot = 0;			// How many pellets have been shot
attack_4_pellet_angle = -1;			// Angle changes for pellets
attack_4_max_shot = attack_4_burst*3;				// Max shots shot in a phase
attack_4_dive_delay = GAMESPD;		// Delay between phase repeat
attack_4_dir = 1;					// angle change direction
attack_4_big_fired = false;			// if big pellet fired
prep_4_phase_repeat = true;			// Flag if it is phase repeat (for lightning)
prep_4_panic_passed = false;		// Has panic attack passed (for shooting)
prep_4_panic_dive = false;			// Should there be opportunity dive after panic
prep_3_psychic_dive = false;		// Should there be opportunity dive after psychic


hp = 4;				// 4 phases - 1 hp per phase
pellet_speed = 22;	// speed of pellet movement
feather = 1;


//==========================================================
// BACKEND
//==========================================================

// General
cheap_shot = true;				// cheap shot should be done flag
y_base = 80;					// Base y position
yhurt_offset = 64;				// Amount pulled back after being hurt
target_id = noone;				// Closest player instance (target)
isangry = false;				// If angry flag (hit with big pellet)
isangry_blink = false;			// Angry blink flag
isangry_blink_period = 8;		// Period between blinks when angry
isangry_blink_counter = isangry_blink_period;
evade_direction = noone;		// Evade direction, is -1 or 1
hit_combo_counter = 0;
phase_4 = false;				// if in the last phase

// Sprite setup
sprite = [];
for(var i = 0; i < ENEMIES.length; i++)
{
	sprite[i] = spr_TwinHornsIdle;
}
sprite[ENEMIES.ATTACK_1_SHOT] = spr_TwinHornsDeepBreathe;
sprite[ENEMIES.ATTACK_2_SHOT] = spr_TwinHornsDeepBreathe;
sprite[ENEMIES.ATTACK_3_PSYCHIC] = spr_TwinHornsFlashEyes;
sprite[ENEMIES.ATTACK_3_SHOT_WINDMILL_HOLD] = spr_TwinHornsDeepBreathe;
sprite[ENEMIES.ATTACK_4_PANIC] = spr_TwinHornsFlashEyes;
sprite[ENEMIES.ATTACK_4_SHOT_SPREAD] = spr_TwinHornsDeepBreathe;
sprite[ENEMIES.ATTACK_DIVE] = spr_TwinHornsDive;
sprite[ENEMIES.ATTACK_DIVE_MASTER] = spr_TwinHornsDive;
sprite[ENEMIES.HURT] = spr_TwinHornsHurt;
sprite[ENEMIES.EVADE] = spr_TwinHornsDodge;		
sprite[ENEMIES.DIVE_PREP] = spr_TwinHornsHurt;		
sprite[ENEMIES.BETWEEN] = spr_TwinHornsRot;		// between phases - turns head and invincible
sprite[ENEMIES.SPAWN] = spr_TwinHornsSpawn;

state = ENEMIES.INIT;

trig_anim_end = false; // trigger

// Sprite
VfxShadow(id);

// Twinhorn start first attack with master dive (cheap shot)
// Start master dive
y = -480;
TweenStart("speed", 0, 32, 0.3*GAMESPD);
direction = image_angle - 90;

// Attack shadow
VfxShadowFeint(id);
audio_play_sound(snd_EnemyFalconAttackScream, 1, false);
audio_play_sound(snd_EnemyFalconAttackFly, 1, false);
state = ENEMIES.ATTACK_DIVE_MASTER;

ShFlashInit();

//==========================================================
// METHODS
//==========================================================
///@func _HitBigPellet()
///@desc When big pellet countered, register a hit - start angry dive
///@arg		pellet	{instance}		Instance of pellet returned
_HitBigPellet = function(_pellet){
	//instance_destroy(_pellet);
	hit_fx_seed(_pellet);
	CombosAddHit(50);
	VfxShake(2, 10);
	
	isangry = true;
	
	if(hp == 4) prep_pellet_shot = prep_1_pellet_dive;
	if(hp == 3) prep_pellet_shot = prep_2_pellet_dive;
	if(hp == 2) prep_pellet_shot = prep_3_pellet_dive;
	if(hp == 1) obj_WeatherThunderstorm.alarm[0] = -1;
	
	// Hurt animation then attack
	state = ENEMIES.DIVE_PREP;
}



///@func _HitEvade()
///@desc Evade a pellet
///@arg		collide_seed	{instance}		Instance of seed in collision
///@arg		collide_water	{instance}		Instance of water in collision
///@arg		collide_pellet	{instance}		Instance of pellet in collision
_HitEvade = function(_collide_seed, _collide_water, _collide_pellet){
	var _dir_coming = 1;
	
	// Find direction of pellet that is send to the boss
	if(_collide_seed != noone and _collide_seed.target == noone) _dir_coming = sign(_collide_seed.x - x);
	if(_collide_water != noone and _collide_water.target == noone) _dir_coming = sign(_collide_water.x - x);
	if(_collide_pellet != noone) _dir_coming = sign(_collide_pellet.x - x);
	
	if(_dir_coming == 0) _dir_coming = 1;
	
	// Find direction to move to
	var _ev_x = x + (_dir_coming * 128);
	evade_direction = sign(_dir_coming);
	if(_ev_x < 128 or _ev_x > room_width - 128) 
	{
		_ev_x = x + (-_dir_coming * 128);
		evade_direction = sign(-_dir_coming);
	}

	// Evasion manuver
	TweenStart("x", x, _ev_x, GAMESPD, TWEENTYPE.SINE_OUT);
	
	trig_anim_end = false;
	state = ENEMIES.EVADE;
}



///@func _PrepAttack()
///@desc Prepare attack
_PrepAttack = function(){
	// Should be diving - dependent on the phase
	var _pellet_attack = -1;
	if(hp == 4) _pellet_attack = prep_1_pellet_dive;
	if(hp == 3) _pellet_attack = prep_2_pellet_dive;
	if(hp == 2) _pellet_attack = prep_3_pellet_dive;
	if(hp == 1) _pellet_attack = -1;
	
	// Should be doing dive
    if(prep_pellet_shot >= _pellet_attack)
	{
		// Took a dive and reset shot count
		prep_pellet_shot = 0;
		
		// Start angry dive
		if(isangry)
		{
			TweenStart("speed", 0, 23, 0.3*GAMESPD);
			direction = image_angle - 90;
			audio_play_sound(snd_EnemyFalconAttackScream, 1, false);
			audio_play_sound(snd_EnemyFalconAttackFly, 1, false);
			state = ENEMIES.ATTACK_DIVE;
			if(hp == 2) prep_3_phase_repeat = true;
		}
		// Perform master dive
		else
		{
			TweenStart("speed", 0, 25, 0.3*GAMESPD);
			direction = image_angle - 90;
			// Attack shadow
			VfxShadowFeint(id);
			audio_play_sound(snd_EnemyFalconAttackScream, 1, false);
			audio_play_sound(snd_EnemyFalconAttackFly, 1, false);
			state = ENEMIES.ATTACK_DIVE_MASTER;
			if(hp == 2) prep_3_phase_repeat = true;
		}
		
		prep_pellet_countered = 0;
	}
	// Take a new shot (no dive)
	else 
	{
		prep_pellet_shot += 1;
		if(hp == 4) state = ENEMIES.ATTACK_1_SHOT;
		if(hp == 3) state = ENEMIES.ATTACK_2_SHOT;
		if(hp == 2) state = ENEMIES.ATTACK_3_SHOT_WINDMILL_HOLD;
		if(hp == 1) state = ENEMIES.INIT
	}
}