/// @desc
if !instance_exists(master) {
	instance_destroy();
	exit;
}

draw_sprite_ext(master.sprite_index, master.image_index, x, y, scaling * sign(master.image_xscale), scaling * sign(master.image_yscale), master.image_angle, c_black, (0.5 * master.image_alpha));