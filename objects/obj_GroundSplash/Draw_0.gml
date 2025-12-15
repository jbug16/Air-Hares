/// @desc
if !instance_exists(master) {
	instance_destroy();
	exit;
}

if (obj_ControllerPAR.splash) {
	draw_sprite_ext(sprite_index, image_index, x, y, scaling * image_xscale, scaling * image_yscale, image_angle, c_white, 1);
}