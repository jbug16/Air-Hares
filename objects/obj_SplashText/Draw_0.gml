// draw set
draw_set_halign(fa_center);
draw_set_valign(fa_middle);
draw_set_font(fnt_Federo37);
draw_set_alpha(image_alpha);
draw_set_color(c_white);

// text
draw_text_transformed(x, y + 10, "PRESENTS", image_xscale, image_yscale, 0);

// draw reset
draw_set_alpha(1);