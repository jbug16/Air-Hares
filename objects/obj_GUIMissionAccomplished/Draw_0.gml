/// @desc
draw_self();

if (!peaceful_intro_summary) exit;

var _bottom = y + sprite_get_height(sprite_index) * 0.5 * abs(image_yscale);
var _cy = _bottom + 48;
draw_set_valign(fa_middle);
draw_set_color(c_white);
draw_set_font(fnt_Federo37);
draw_set_halign(fa_left);
draw_text(x - 196, _cy, "Crops:");
draw_set_halign(fa_right);
draw_text(x + 196, _cy, crops_pct_display + "%");
DrawReset();
