/// @desc Flash red when angry

// Angry - red
if(isangry and isangry_blink)
	draw_sprite_ext(sprite_index, image_index, x, y, image_xscale, image_yscale, image_angle, c_red, 1);
else 
{
	if(shflash_alpha > 0) ShFlashDraw();	
	else draw_self();	
}