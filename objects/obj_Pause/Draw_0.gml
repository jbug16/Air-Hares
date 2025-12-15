///@desc Draw BG
if (screen_save_sprite == noone) exit;

// BG sprite
gpu_set_blendenable(false);
draw_sprite(screen_save_sprite,0,0,0);
gpu_set_blendenable(true);

// Black tinting
var _alpha = draw_get_alpha();
var _surf = surface_get_target();
draw_set_alpha(0.6);
draw_rectangle_color(0,0,surface_get_width(_surf), surface_get_height(_surf),c_black,c_black,c_black,c_black,0);
draw_set_alpha (_alpha);