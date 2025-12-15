/// @desc

alarm[0] = 2;
focus = false;
is_disabled = false;

tgt_level = noone;
menu_index = 0;

image_xscale = 0;
image_yscale = 0.5;
scale_normal = 0.5;
scale_big = scale_normal * 1.4;

// scale in!
TweenStart("image_xscale", image_xscale, scale_normal, 0.6*GAMESPD, TWEENTYPE.CIRC_OUT, 0.4*GAMESPD);
TweenStart("image_yscale", image_xscale, scale_normal, 0.6*GAMESPD, TWEENTYPE.CIRC_OUT, 0.4*GAMESPD);

// For remembering mouse coordinates
mouse_prev_x = mouse_x;
mouse_prev_y = mouse_y;

mask_index = spr_TitleSelectionFrame;