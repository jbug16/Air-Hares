// init
draw_set_halign(fa_center);
draw_set_valign(fa_middle);
draw_set_font(fnt_Federo24);

// disabled/enabled
if is_disabled {
	//draw_set_color(c_grey);
	shader_set(sh_Grayscale);
	draw_self();
	
}  else {
	draw_self();
	draw_set_color(c_white);
}

// level names
for (var i = 0; i < string_length(text); ++i) {
	var _char = string_char_at(text, i + 1);
	var _sprite = spr_LevelNumbers;
	if (_char == "-") 
	{
		_sprite = spr_LevelNumbersSpecial;
		_char = 0;
	}
	else if (_char == "B")
	{
		_sprite = spr_LevelNumbersSpecial;
		_char = 1;
	}
	else _char--;
    draw_sprite_ext(_sprite, _char, x + 40*image_xscale*(i-1), y, image_xscale/5, image_yscale/5, 0, c_white, 1);
}

if is_disabled shader_reset();