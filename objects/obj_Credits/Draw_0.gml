if (phase == 0)			// poem
{
	// Prepare
	draw_set_halign(fa_center);
	draw_set_valign(fa_top);
	draw_set_font(fnt_Federo24);
	draw_set_color(c_white);
	draw_set_alpha(image_alpha);
	
	// Draw text, line by line
	var _height = 0;
	for (var i = 0; i <= text0_lines and i < array_length(text0); i++)
	{
		if (i == text0_lines) draw_set_alpha(text0_line_alpha);
		draw_text(x, y + _height, text0[i]);
		_height += string_height(text0[i]);
	}
}
else if (phase == 1)	// credits
{
	draw_set_halign(fa_center);
	draw_set_valign(fa_top);
	draw_set_font(fnt_Federo24);
	draw_set_color(c_white);
	draw_set_alpha(1);
	
	draw_text(x, y, text);
}
else if (phase == 2) draw_self();