/// @desc Mouse coords
if(global.mouse_disable) exit;

// Convert window mouse coordinates to room coordinates
var _room_mouse_x = window_mouse_get_x() * (room_width / window_get_width());
var _room_mouse_y = window_mouse_get_y() * (room_height / window_get_height());

if((mouse_prev_x != _room_mouse_x or mouse_prev_y != _room_mouse_y) and position_meeting(_room_mouse_x, _room_mouse_y, id) and !focus)
	event_perform(ev_mouse, ev_mouse_enter);

mouse_prev_x = _room_mouse_x;
mouse_prev_y = _room_mouse_y;