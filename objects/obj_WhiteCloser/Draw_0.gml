/// @desc
if (alarm[0] <= 0) draw_set_color(c_black);
else draw_set_color(c_white);
draw_set_alpha(image_alpha);
draw_rectangle(-1, -1, room_width + 1, room_height + 1, false);
draw_set_alpha(1);