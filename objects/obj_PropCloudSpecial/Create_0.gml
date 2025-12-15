event_inherited();

cloud_value = 1;
cloud_disperse = 4;
hsp = 12; // wind draft speed
y_pos -= room_height*0.5;
y = y_pos;

if (global.current_level mod 4 == 3) image_alpha = 0.9;
else image_alpha = 0.6;
image_xscale *= random_range(0.7, 1.5);
image_yscale = image_xscale;

// Create black shadow on ground
var _ground_shadow = instance_create_layer(x, y, "Ground", obj_ShadowGround);
_ground_shadow.master = id;