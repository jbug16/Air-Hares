event_inherited();

// idle time
timer_prepare = 150;

// Fight parameter
direct_attack_speed = 24;
direct_attack_homing = 0.35;

// Sprite
sprite = array_create(ENEMY_STATE.length + 1, noone)
sprite[ENEMY_STATE.IDLE] = spr_EnemyFalconBluePrepare;
sprite[ENEMY_STATE.DEFEATED] = spr_EnemyFalconBluePrepare;
sprite[ENEMY_STATE.ATTACK] = spr_EnemyFalconBlueDive;
sprite[ENEMY_STATE.HURT] = spr_EnemyFalconBlueHurt;

// Tween for entering ready position
TweenStart("y", -480, 0, 2*GAMESPD, TWEENTYPE.QUINT_OUT);

feather_type = obj_PropFeatherBlue;