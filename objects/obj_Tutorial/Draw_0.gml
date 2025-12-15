/// @desc

draw_set_color(c_black);
draw_rectangle(0, 0, room_width, room_height, false);

draw_self();

if(fade_alpha > 0)
{
	draw_set_alpha(fade_alpha);
	draw_set_color(c_black);
	draw_rectangle(0, 0, room_width, room_height, false);
}

DrawReset();