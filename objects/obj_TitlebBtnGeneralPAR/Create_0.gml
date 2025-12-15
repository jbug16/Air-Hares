button_id = 0;		// button order
mode_on = false;	//if in free mode or story mode select
alarm[2] = 2;		// delay unintentional clicks
parent_index = object_get_parent(object_index);
surf = surface_create(1280,720);

focus = false;
text = "Exit";

mouse_prev_x = mouse_x;
mouse_prev_y = mouse_y;
					
col_glow = make_color_rgb(230, 237, 245);	// light chrome #e6edf5
glow_size = 1;
tween_spd = 0.45*GAMESPD;				// tween in/out (repetitive, when selected)

image_xscale = 0.5;
image_yscale = 0.5;
scale_normal = image_xscale;
scale_big = image_xscale * 1.5;



usize = shader_get_uniform(sh_GaussBlur,"size");//uniform for width, height, radius