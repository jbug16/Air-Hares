/// @desc
// Create side
activated = false;
vsp = 4;
z = 40;

// Create the side part
side_left_bottom = instance_create_layer(x, y, "Middle", obj_GateSideLeftBottom);
side_left_bottom.vsp = vsp;
side_right_bottom = instance_create_layer(x, y, "Middle", obj_GateSideRightBottom);
side_right_bottom.vsp = vsp;
side_left_top = instance_create_layer(x, y, "Top", obj_GateSideLeftTop);
side_left_top.vsp = vsp;
side_right_top = instance_create_layer(x, y, "Top", obj_GateSideRightTop);
side_right_top.vsp = vsp;
hitbox_left = instance_create_layer(x, y, "Middle", obj_GateHitboxLeft);
hitbox_left.vsp = vsp;
hitbox_right= instance_create_layer(x, y, "Middle", obj_GateHitboxRight);
hitbox_right.vsp = vsp;

// Carrot will be spawn at other position
var _carrot_x_pos = x + choose(-450, -300, 300, 400);
carrot = instance_create_layer(_carrot_x_pos, y + 40, "Middle", obj_GateCarrot);