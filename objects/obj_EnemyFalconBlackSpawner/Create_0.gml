/// @desc
z = -50;
vsp = -30;
scaling = DepthGetScale(z);

timer_prepare = noone;

image_angle = 180;

// Sound
flyby_sound_played = false;

// Create shadow
var _ground_shadow = instance_create_layer(x, y, "Ground", obj_ShadowGround);
_ground_shadow.master = id;