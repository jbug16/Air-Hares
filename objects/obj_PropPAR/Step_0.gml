/// @desc Move relative to screen

// Move
y_pos += vsp * global.speed_parallax;
// Destroy when passing bottom limits
if (y - 3*sprite_height > room_height)  instance_destroy();