event_inherited();
// idle time
timer_prepare = 150;

// Fight parameter
direct_attack_speed = 18;
direct_attack_homing = 0.1;	// Slight homing

// Sprite
sprite = array_create(ENEMY_STATE.length + 1, noone)
sprite[ENEMY_STATE.IDLE] = spr_FalconBlackPrepare;
sprite[ENEMY_STATE.DEFEATED] = spr_FalconBlackPrepare;
sprite[ENEMY_STATE.ATTACK] = spr_FalconBlackDive;
sprite[ENEMY_STATE.HURT] = spr_FalconBlackHurt;

// Tween for entering ready position
TweenStart("y", -480, 0, 2*GAMESPD, TWEENTYPE.QUINT_OUT);