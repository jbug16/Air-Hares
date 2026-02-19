// Black background - extra margin to cover view/camera offsets and prevent gameplay showing through
var _m = 64;
draw_set_color(c_black);
draw_rectangle(-_m, -_m, room_width + _m, room_height + _m, false);

// Scale image to fit on screen (no cut-off)
var _sw = sprite_get_width(sprite_index);
var _sh = sprite_get_height(sprite_index);
var _scale = min(room_width / _sw, room_height / _sh);
draw_sprite_ext(sprite_index, image_index, room_width / 2, room_height / 2, _scale, _scale, image_angle, image_blend, image_alpha);

DrawReset();