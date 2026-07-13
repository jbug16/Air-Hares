button_id = 0;		// button order
mode_on = false;	//if in free mode or story mode select
alarm[2] = 2;		// delay unintentional clicks
parent_index = object_get_parent(object_index);

focus = false;
text = "Exit";

mouse_prev_x = mouse_x;
mouse_prev_y = mouse_y;
					
tween_spd = 0.45*GAMESPD;				// tween in/out (repetitive, when selected)

image_xscale = 0.5;
image_yscale = 0.5;
scale_normal = image_xscale;
scale_big = image_xscale * 1.5;