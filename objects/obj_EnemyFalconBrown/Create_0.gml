y = -0.8*room_height;

event_inherited();	


timer_prepare = 150;

direct_attack_speed = 28;
direct_attack_homing = 0.45;	// Homing power

feather_type = obj_PropFeatherBrown;


// Sprite
sprite = array_create(ENEMY_STATE.length + 1, noone)
sprite[ENEMY_STATE.IDLE] = spr_EnemyFalconBrownPrepare;
sprite[ENEMY_STATE.DEFEATED] = spr_EnemyFalconBrownPrepare;
sprite[ENEMY_STATE.ATTACK] = spr_EnemyFalconBrownDiveAttack;
sprite[ENEMY_STATE.HURT] = spr_EnemyFalconBrownHurt;

//obj_PlayerPAR.trig_foresight = true;