if (master != noone && instance_exists(master)) {
	// Get position relative to master
	x = DepthGetPositionX(master.x, z);
	y = DepthGetPositionY(master.y, z);
} else {
	instance_destroy();
}

// remove shadows on boss fights (everything in the air)
if (global.current_level mod 4 == 3) instance_destroy();