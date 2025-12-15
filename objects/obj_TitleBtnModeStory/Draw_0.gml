/// @desc

if(global.demo)
{
	// Normal draw
	draw_set_color(c_ltgray);
	draw_text_transformed(x, y, text, image_xscale, image_yscale, image_angle);
	draw_set_color(c_white);
}
else
{
	// Inherit the parent event
	event_inherited();
}