///@desc Save the '_screenshot'

// Save the current sprite _screenshot
if (screen_save_sprite != noone) exit;
var _surf = surface_get_target();
screen_save_sprite = sprite_create_from_surface(_surf,0, 0,surface_get_width(_surf), surface_get_height(_surf),0,0,0,0);