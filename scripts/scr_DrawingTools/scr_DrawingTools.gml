/*
	DrawReset
*/
///@func DrawReset(default_fnt)
///@desc Resets the draw_set values to defaults.
///@arg		default_fnt	{font}	Which font to use as a default one. Just change the default value in the brackets.
function DrawReset(_default_fnt = fnt_Federo37){
	if (draw_get_alpha() != 1) draw_set_alpha(1);
	if (draw_get_color != c_white) draw_set_color(c_white);
	if (draw_get_halign() != fa_left) draw_set_halign(fa_left);
	if (draw_get_valign() != fa_top) draw_set_valign(fa_top);
	if (draw_get_font() != _default_fnt) draw_set_font(_default_fnt);
}