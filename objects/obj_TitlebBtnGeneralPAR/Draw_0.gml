if (TitleMainIsSocialButtonId(button_id) && !TitleMainSocialLinksEnabled()) exit;

// Basic setup
if (draw_get_font() != fnt_Federo37) draw_set_font(fnt_Federo37);
if (draw_get_halign() != fa_center) draw_set_halign(fa_center);
if (draw_get_valign() != fa_middle) draw_set_valign(fa_middle);

// Drawing - selected
if (focus)
{
	draw_set_color(col_glow);
	
	// draw text to surface in a circle
	if !surface_exists(surf) surf = surface_create(1280,720);
	surface_set_target(surf);
	draw_clear_alpha(col_glow,0);
	if (draw_get_alpha() != 1) draw_set_alpha(1);
	gpu_set_blendmode(bm_add);
	for(c = 0;c < 360;c += 18)
	{
		draw_text_transformed(x + lengthdir_x(glow_size,c), y + lengthdir_y(glow_size,c), text, 
			image_xscale, image_yscale, image_angle);
	}
	gpu_set_blendmode(bm_normal);
	surface_reset_target();
	
	// draw the black and then white surface, blurred
	shader_set(sh_GaussBlur);
	shader_set_uniform_f(usize,room_width,room_height,8)//width,height,radius
	draw_surface_ext(surf, 5, 5, 1, 1, 0, c_black, 1);
	draw_surface_ext(surf, 0, 0, 1, 1, 0, c_white, 1);
	shader_reset();
}

// Normal draw
draw_set_color(c_white);
draw_text_transformed(x, y, text, image_xscale, image_yscale, image_angle);