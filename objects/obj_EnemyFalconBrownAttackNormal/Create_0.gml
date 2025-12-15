/// @desc

event_inherited();

// Prop
hp = 2;
timer_prepare = 150;
state = ENEMIES.PREPARING;

// Feather
feather = 1;

// Fight & Feint parameter
target_id = noone;
direct_attack_chance = 0.4; // Chance for this falcon to attack without preparing
direct_attack_perform = false;
direct_attack_speed = 28;
direct_attack_homing = 0.45;	// Homing power
feint_count = 1;
feint_wait = 0.4 * 60;

// Trigger
trig_anim_end = false;

// Create shadow
var _ground_shadow = instance_create_layer(x, y, "Ground", obj_ShadowGround);
_ground_shadow.master = id;

// Sprite
s_prep = spr_EnemyFalconBrownPrepare;
s_dive = spr_EnemyFalconBrownPrepare;
s_dive_claw = spr_EnemyFalconBrownDiveAttack;
s_hurt = spr_EnemyFalconBrownHurt;


// Roll for direct attack
if (true) {
	direct_attack_perform = true;
	timer_prepare = 50;
	y = -720;
	//obj_PlayerPAR.trig_foresight = true;
} else {
	// Tween for entering ready position
	//TweenStart("y", -480, 0, 2*GAMESPD, TWEENTYPE.QUINT_OUT);
	TweenStart("y", y, -sprite_height, 2*GAMESPD, TWEENTYPE.QUINT_OUT);
}