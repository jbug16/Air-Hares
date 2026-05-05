/// @desc
hsp = 0;
vsp = 0;
z = 0;
zsp = 0;
target = noone;
from_parry = false;
have_shadow = false;
target_y = -10000;
pos_y = -10000;

// Create shadow
var _ground_shadow = instance_create_layer(x, y, "Ground", obj_ShadowGround);
_ground_shadow.master = id;