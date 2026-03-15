/// @desc
draw_set_halign(fa_left);
draw_set_valign(fa_middle);
draw_set_color(c_white);
draw_set_font(fnt_Federo37);
draw_text_ext_transformed(x - 196, y, "Base:", sep, w, image_xscale, image_yscale, image_angle);
draw_text_ext_transformed(x - 196, y + 48, "Time:", sep, w, image_xscale, image_yscale, image_angle);
draw_text_ext_transformed(x - 196, y + 96, "Total:", sep, w, image_xscale, image_yscale, image_angle);
draw_text_ext_transformed(x - 196, y + 144, "Highscore:", sep, w, image_xscale, image_yscale, image_angle);
if(room == rm_LevelX1Farm) draw_text_ext_transformed(x - 196, y + 192, "Crops:", sep, w, image_xscale, image_yscale, image_angle);

draw_set_halign(fa_right);
draw_text_ext_transformed(x + 196, y, text, sep, w, image_xscale, image_yscale, image_angle);
draw_text_ext_transformed(x + 196, y + 48, text_time, sep, w, image_xscale, image_yscale, image_angle);
draw_text_ext_transformed(x + 196, y + 96, text_total, sep, w, image_xscale, image_yscale, image_angle);
draw_text_ext_transformed(x + 196, y + 144, text_highscore, sep, w, image_xscale, image_yscale, image_angle);
if(room == rm_LevelX1Farm) draw_text_ext_transformed(x + 196, y + 192, crops_filled + "%", sep, w, image_xscale, image_yscale, image_angle);

// Show simple text if this run set a new highscore
if (new_highscore) {
	draw_set_halign(fa_left);
	draw_text_ext_transformed(x + 210, y + 144, "New!", sep, w, image_xscale, image_yscale, image_angle);
}