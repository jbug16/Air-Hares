///@desc Speed & self_destruct
vspeed = global.speed_parallax;
if (room == rm_LevelX1Farm) vspeed *= 0.5;

if (bbox_bottom > room_height + 2*sprite_height) instance_destroy();