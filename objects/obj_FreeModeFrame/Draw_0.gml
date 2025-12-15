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
// Level
draw_text_transformed(x , y, text, _scale_x, _scale_y, 0);
// Highscore
draw_text_transformed(x , y + 20*image_yscale, "HIGH SCORE", _scale_x, _scale_y, 0);