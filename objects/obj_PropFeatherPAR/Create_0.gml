/// @desc

// Inherit the parent event
event_inherited();

// Create black shadow on ground
var _ground_shadow = instance_create_layer(x, y, "Ground", obj_ShadowGround);
_ground_shadow.master = id;



// Create tweening right and left
TweenStart("x", x-75, x+75, GAMESPD, TWEENTYPE.CUBIC_INOUT,,TWEENREPEAT.PATROL, infinity);
TweenStart("image_angle", -70, -20, GAMESPD, TWEENTYPE.CUBIC_INOUT,,TWEENREPEAT.PATROL, infinity);

vsp = 2;