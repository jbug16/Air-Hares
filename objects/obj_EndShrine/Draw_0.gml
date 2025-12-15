// Shrine
draw_sprite_ext(sprite_index, 0, x, y, image_xscale, image_yscale, 0, image_blend, 1);
// Propeller
draw_sprite_ext(propeller_sprite, 0, x, y - 0.5*sprite_height, image_xscale, image_yscale, propeller_angle, image_blend, 1);

// draw flash on hit
if (alarm[0] >= 0)
{
	gpu_set_fog(true, c_white, -100, 100);
	draw_sprite_ext(mask_index, 0, x, y, image_xscale, image_yscale, 0, c_white, 0.7*alarm[0]/flash_len);
	draw_sprite_ext(mask_index, 0, x, y, image_xscale, image_yscale, 0, c_white, 0.7*alarm[0]/flash_len);
	gpu_set_fog(false, c_white, -100, 100);
}