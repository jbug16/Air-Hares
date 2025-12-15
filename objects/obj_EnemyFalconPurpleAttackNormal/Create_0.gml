/// @desc

var _chance = random(1);
if (_chance < 0.2) // behaves like the black falocn - speed wise etc.
{
	timer_prepare = 140;
	// Fight parameter
	direct_attack_speed = 20;
	direct_attack_homing = 0.1;
	TweenStart("y", -480, 0, 2*GAMESPD, TWEENTYPE.QUINT_OUT);
}
else if (_chance < 0.5)	// behave like blue falcon
{
	timer_prepare = 90 + irandom(90); //150
	// Fight parameter
	direct_attack_speed = 26;
	direct_attack_homing = 0.30;
	TweenStart("y", -480, 0, 2*GAMESPD, TWEENTYPE.QUINT_OUT);
}
else					// behave like brown falcon, but faster
{
	timer_prepare = 50; //150;
	direct_attack_speed = 32;
	direct_attack_homing = 0.55;	// Homing power
	//obj_PlayerPAR.trig_foresight = true;
	y = -720;
}

event_inherited();

// Prop
hp = 4;
timer_prepare = 125;
//tween = noone;
state = ENEMIES.PREPARING;

// Feather
feather = 1;

// Fight parameter
target_id = noone;
direct_attack_chance = 0.75; // Chance for this falcon to attack without preparing
direct_attack_perform = false;
direct_attack_speed = 32;
direct_attack_homing = 0.55;
feint_count = 1;
feint_wait = 0.5 * 60;
is_feint_shot = false;

// Trigger
trig_anim_end = false;

// Create shadow
var _ground_shadow = instance_create_layer(x, y, "Ground", obj_ShadowGround);
_ground_shadow.master = id;

// Sprite
s_prep = spr_EnemyFalconPurplePrepare;
s_dive = spr_EnemyFalconPurplePrepare;
s_dive_claw = spr_EnemyFalconPurpleDiveAttack;
s_hurt = spr_EnemyFalconPurpleHurt;

// Roll for direct attack
if (false) {
	direct_attack_perform = true;
	timer_prepare = 50;
	y = -720;
	//obj_PlayerPAR.trig_foresight = true;
} else {
	// Tween for entering ready position
	//var _y = choose(0, -sprite_height);
	//TweenStart("y", -480, _y, 2*GAMESPD, TWEENTYPE.QUINT_OUT);
}