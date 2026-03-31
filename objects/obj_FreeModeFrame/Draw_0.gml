// init & frame
draw_self();
draw_set_color(c_white);
draw_set_font(fnt_Federo24);
draw_set_halign(fa_center);
draw_set_valign(fa_middle);

// scaling
var _scale_x = image_xscale/3;
var _scale_y = image_yscale/3;

// Drawing text
// icon
draw_sprite_ext(spr_PlayerIcon, 0, x - 130*image_xscale, y - 5*image_yscale, _scale_x, _scale_y, 0, c_white, 1);

if (global.arcade_popup_screen == 1) {
	var _body_sx = image_xscale / 2;
	var _body_sy = image_yscale / 2;
	draw_set_font(fnt_Federo16);
	draw_set_color(c_white);
	draw_text_transformed(x, y - 20 * image_yscale, text, _body_sx, _body_sy, 0);
	draw_set_font(fnt_Federo24);
	draw_set_color(c_orange);
	var _s = global.arcade_new_initials;
	var _n = string_length(_s);
	var _initials_text = "";
	for (var _slot = 0; _slot < 3; _slot++) {
		if (_slot < _n) _initials_text += string_copy(_s, _slot + 1, 1);
		else _initials_text += "_";
	}
	draw_text_transformed(x, y + 8 * image_yscale, _initials_text, _body_sx, _body_sy, 0);
	exit;
}

// Level
draw_text_transformed(x , y, text, _scale_x, _scale_y, 0);
// Per-level arcade highscore (same index as global.highscore / current_level)
var _hs = 0;
var _hname = "";
if (arcade_popup_level >= 0 && arcade_popup_level <= 15) {
	_hs = global.highscore[arcade_popup_level];
	_hname = global.highscore_initials[arcade_popup_level];
}
var _hs_line = "HIGH SCORE: " + string(round(_hs));
if (round(_hs) > 0 && is_string(_hname) && string_length(_hname) > 0) {
	_hs_line += " (" + string_upper(string_copy(_hname, 1, min(3, string_length(_hname)))) + ")";
}
draw_text_transformed(x, y + 20 * image_yscale, _hs_line, _scale_x, _scale_y, 0);
