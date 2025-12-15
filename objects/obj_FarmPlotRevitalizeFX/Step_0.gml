/// @desc
if (master != noone) {
	if !instance_exists(master) {
		instance_destroy();
		exit;
	}
	x = master.x;
	y = master.y;
}