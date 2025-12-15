/// @desc

if (master != noone && instance_exists(master)) {
	// Get position relative to master
	x = DepthGetPositionX(master.x + x_offset, z);
	y = DepthGetPositionY(master.y + y_offset, z);
} else {
	instance_destroy();
}