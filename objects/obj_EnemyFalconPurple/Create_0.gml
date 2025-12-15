// Roll for type of attack/behavior
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
feather_type = obj_PropFeatherPurple;


// Fight parameter
//direct_attack_perform = false;
direct_attack_speed = 32;
direct_attack_homing = 0.55;


// Sprite
sprite = array_create(ENEMY_STATE.length + 1, noone)
sprite[ENEMY_STATE.IDLE] = spr_EnemyFalconPurplePrepare;
sprite[ENEMY_STATE.DEFEATED] = spr_EnemyFalconPurplePrepare;
sprite[ENEMY_STATE.ATTACK] = spr_EnemyFalconPurpleDiveAttack;
sprite[ENEMY_STATE.HURT] = spr_EnemyFalconPurpleHurt;
