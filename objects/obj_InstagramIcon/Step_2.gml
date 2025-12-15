///@desc Hover
if(global.mouse_disable) exit;

if position_meeting(mouse_x, mouse_y, id) image_alpha = 1;
else image_alpha = 0.7;