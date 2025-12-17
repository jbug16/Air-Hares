///@desc Hover
if(global.mouse_disable) exit;

// Convert window mouse coordinates to room coordinates
var _room_mouse_x = window_mouse_get_x() * (room_width / window_get_width());
var _room_mouse_y = window_mouse_get_y() * (room_height / window_get_height());

if position_meeting(_room_mouse_x, _room_mouse_y, id) image_alpha = 1;
else image_alpha = 0.7;