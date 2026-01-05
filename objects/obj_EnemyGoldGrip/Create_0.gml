/// @desc
event_inherited();

//==========================================================
// ADJUSTABLE
//==========================================================
// State AI variable
hp = 4;
y_base = 80;			// height for most of the bossfight
target_id = noone;		// closest player instance (target)
dive_delay = 0;			// how long is delay before dive
prep_duration = 60;		// how long does preparation for attack last
prep_counter = 0;		
hurt_duration = 1.5*GAMESPD //42;		// how long is it in hurting states
hurt_counter = hurt_duration;
feather = 1;
hurt_delay = 0.5*GAMESPD;
outro_music_played = false;		// Flag to track if outro music has been played



//==========================================================
// BACKEND
//==========================================================
shadows = []; // array of shadow instances for attack
invincible = false; // if shadow parried, goldgrip invincible for that attack

// FX
linblur_fx = {
	filter : fx_create("_filter_linear_blur"),
	vector : [0, 0],
	enabled: false,
	trigger_once : function(_vector) {
		if vector[0] != 0 or vector[1] != 0 return;
		vector[0] = _vector[0];
		vector[1] = _vector[1];
	},
	update : function() {
		vector[0] = vector[0] > 0 ? vector[0] - 2 : 0;
		vector[1] = vector[1] > 0 ? vector[1] - 2 : 0;
		enabled = vector[0] > 0 ? true : false;
		fx_set_parameter(filter, "g_LinearBlurVector", vector);
		layer_enable_fx("InstancesBoss", enabled);
	}
}
fx_set_single_layer(linblur_fx.filter, true);
layer_set_fx("InstancesBoss", linblur_fx.filter);
layer_enable_fx("InstancesBoss", false);

// Sprite setup
for (var i = 0; i < ENEMIES.length; i++)
{
	sprite[i] = spr_EnemyGoldGripIdle;
}
sprite[ENEMIES.HURT] = spr_EnemyGoldGripHurt;
sprite[ENEMIES.DIVE_1] = spr_EnemyGoldGripDive;
sprite[ENEMIES.DIVE_2] = spr_EnemyGoldGripDive;
sprite[ENEMIES.DIVE_3] = spr_EnemyGoldGripDive;
sprite[ENEMIES.DIVE_4] = spr_EnemyGoldGripDive;
sprite[ENEMIES.EVADE] = spr_EnemyGoldGripDive;
state = ENEMIES.INIT;
state_prev = state;

// Trigger
trig_anim_end = false;

// Sprite
VfxShadow(id);

//==========================================================
// METHODS
//==========================================================
///@func _AttackPrepSetup()
///@desc Prepares attack setup by creating phantom shadows and sending them to dive
///@arg		no	{real}		Number of shadows to create - based on seq_phase
_AttackPrepSetup = function(_no = -1){
	if(_no == -1) return; // no number of shadows defined
	
	invincible = false;
	
	// Setup shadows
	shadows = [];
	
	// Positions
	 var _x_pos_offset = [];
	 if(_no == 1) _x_pos_offset = [520, 780];
	 else if(_no == 2) _x_pos_offset = [x, x - 196, x + 196];
	 else if(_no == 3) _x_pos_offset = [256, 512, 768, 1024];
	 else if(_no == 4) _x_pos_offset = [256, 512, 768, 1024];
	 
	 array_push(shadows, id);
	 
	 
	 //----------------------------------------------------------
	 // Create shadows and add to the array
	 //----------------------------------------------------------
	 // One shadow
	 if(_no == 1) 
	 {
		var _shadow = instance_create_layer(x, y, layer, obj_EnemyGoldGripShadow);
		_shadow.image_alpha = 0.7;
		_shadow.depth -= 1;
		array_push(shadows, _shadow);
	 }
	 // Multiple shadows
	 else if(_no > 1) 
	 {
		 var _fortitude_active = obj_Main.profile.stat.fortitude_roll();
		 
		 // Create shadows
		 repeat(_no)
		 {
			var _shadow = instance_create_layer(x, y, layer, obj_EnemyGoldGripShadow);
			_shadow.image_alpha = 0.8;
			if _fortitude_active {
				_shadow.image_alpha = 0.7;
				if instance_exists(obj_PlayerPAR) {
					GUIFlyingTextCreate(obj_PlayerPAR.x, obj_PlayerPAR.y - 62, "FORTITUDE!");
				}
			}
			_shadow.depth -= 1;
			array_push(shadows, _shadow);
		}
	}
	
	// If no shadows created - repeat the process
	if(array_length(shadows) == 0) _AttackPrepSetup(_no);
	
	
	//----------------------------------------------------------
	// Send shadows and boss to dive in random order
	//----------------------------------------------------------
	repeat(_no + 1)
	{
		var _x_index = irandom(array_length(_x_pos_offset) - 1);
		var _shadow = array_pop(shadows);
		
		// Special case - phase 4 real boss outside of the room
		if(_no == 4 and _shadow == id)
		{
			var _id_tgt = [256, 512, 768, 1024];
			TweenStart("x", x, _id_tgt[irandom(3)], GAMESPD, , , ,,_shadow);
			y = -128;
		}
		else
		{	
			var _x_tgt = _x_pos_offset[_x_index];
			array_delete(_x_pos_offset, _x_index, 1);
			TweenStart("x", x, _x_tgt, GAMESPD, , , ,,_shadow);
		}
	}

	// Change state to dive
	if(_no == 1) state = ENEMIES.DIVE_1_BASE;
	else if(_no == 2) state = ENEMIES.DIVE_2_BASE;
	else if(_no == 3) state = ENEMIES.DIVE_4_BASE;
	else if(_no == 4) state = ENEMIES.DIVE_3_BASE;
}


///@func _AttackBaseSetup()
///@desc Prepares attack with launch delay
///@arg		no	{real}		Number of shadows to create - based on seq_phase
_AttackBaseSetup = function(_no = -1){
	if(_no == -1) return; // no number of shadows defined
	
	// Get all the shadows
	with(obj_EnemyGoldGripShadow) array_push(other.shadows, id);
	
	// Roll randomly for who goes first
	array_push(shadows, id);
	var _launch_delay = [];
	if(_no == 1) _launch_delay = [90, 115];
	else if(_no == 2) _launch_delay = [90, 120, 150];
	else if(_no == 3) _launch_delay = [90, 110, 130, 150];
	else if(_no == 4) _launch_delay = [90, 110, 130, 150, 170];
	
	while(array_length(shadows) > 0)
	{
		var _shadow = array_pop(shadows);
		
		// Assign random launch delay (different each time)
		var _rnd = irandom(array_length(_launch_delay) - 1);
		
		_shadow.dive_delay = _launch_delay[_rnd];
		
		array_delete(_launch_delay, _rnd, 1);
		if(_shadow != id)
		{
			if(_no == 1) _shadow.state = ENEMIES.DIVE_PREP;
			else if(_no == 2) _shadow.state = ENEMIES.DIVE_2_PREP;
			else if(_no == 3) _shadow.state = ENEMIES.DIVE_4_PREP;
			else if(_no == 4) _shadow.state = ENEMIES.DIVE_3_PREP;
		}
	}
	if(_no == 4) dive_delay = 200;
}

///@func _DiveRecoverySetup()
///@desc Starts recovery from boss dive
_DiveRecoverySetup = function() {
	// Return to base position
	speed = 0;
	direction = 0;
	image_angle = 0;
	TweenStop();
	TweenStart("y", -480, y_base, GAMESPD, TWEENTYPE.QUINT_OUT);
	
	x = random_range(520, 760);
	state = ENEMIES.DIVE_RECOVERY;
}

///@func _HurtSetup()
///@desc Boss was hurt - consequences
_HurtSetup = function() {
	// Visuals
	VfxShake(3, 10);
	CombosAddHit(50);
	speed = 0;
	direction = 0;
	TweenStop();
	TweenStart("y", y, y - 128, GAMESPD);
		
	hp -= 1; // take damage
	PropsFeatherSpecialSpawn(obj_PropFeatherGoldGrip);
	feather = 1;
	state = ENEMIES.HURT;
	hurt_counter = hurt_duration; // Reset counter to allow multiple hits like Twin Horn
	alarm[1] = 3*hurt_duration;
	
	// Change sequence 2 phase -> change music
	if(hp ==2)
	{
		with(obj_ControllerFightBoss3_3)
		{
			audio_stop_sound(music_bg);
			music_bg = audio_play_sound(snd_BossGoldGripPhase2, 1, true);
		}
	}
}