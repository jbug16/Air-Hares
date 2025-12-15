/// @desc Mouse coords
if(global.mouse_disable) exit;
if((mouse_x != mouse_prev_x or mouse_y != mouse_prev_y) and position_meeting(mouse_x, mouse_y, id) and !focus)
	event_perform(ev_mouse, ev_mouse_enter);

mouse_prev_x = mouse_x;
mouse_prev_y = mouse_y;