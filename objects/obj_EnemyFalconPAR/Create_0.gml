// state & tween

event_inherited();

state = ENEMY_STATE.IDLE;

// fight
hp = 2;
target_id = noone;

// Trigger animation
trig_anim_end = false;

// Create shadow
var _ground_shadow = instance_create_layer(x, y, "Ground", obj_ShadowGround);
_ground_shadow.master = id;

feather_type = obj_PropFeatherBlack;

timer_prepare = 150;