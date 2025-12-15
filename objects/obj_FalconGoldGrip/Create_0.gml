/// @desc GoldGrip's special falcon goon

event_inherited();

scaling = 1;
hp = 2;
feather = 1;

//state = ENEMIES.PREPARING;
state = BOSS.INIT;
state_prev = state;

// speeds and position
x_origin = x;		// spawn position
direction = 90;
speed_prev = speed;

// attacking
target_id = noone;
direct_attack_speed = 24;
parry_snd = false;			// parry sound bugfix
direct_attack_homing = 0.35;

state_save = [];

// default sprite
image_angle = 180;
for (var i = 0; i < BOSS.length; i++)
{
	sprite[i] = spr_EnemyFalconBrownPrepare;
}
// state-specific animation
sprite[BOSS.INIT] = spr_EnemyFalconBrownFlyBy;
sprite[BOSS.APPEAR] = spr_EnemyFalconBrownPrepare;
sprite[BOSS.HURT] = spr_EnemyFalconBrownHurt;
sprite[BOSS.DIVE] = spr_EnemyFalconBrownDiveAttack;
sprite[BOSS.DODGE] = spr_EnemyFalconBrownDiveAttack;

// Create shadow
var _ground_shadow = instance_create_layer(x, y, "Ground", obj_ShadowGround);
_ground_shadow.master = id;

// wait times: time1 for sequences without the boss, time2 for sequences with the boss
// they denote a delay before going to the next phase/sequence
time1[BOSS.IDLE] = 0.1*GAMESPD;


audio_play_sound(snd_EnemyFalconFlyBy, 1, false);