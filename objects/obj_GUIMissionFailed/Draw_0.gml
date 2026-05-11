/// @desc
draw_self();

if (peaceful_intro_mission) {
	draw_set_valign(fa_middle);
	draw_set_color(c_white);
	draw_set_font(fnt_Federo37);
	draw_set_halign(fa_center);
	draw_text_ext_transformed(x, y + 0.7*sprite_height, "Farm More Carrots!", sep, w, 1, txt_yscale, image_angle);
	draw_set_halign(fa_left);
	draw_text_ext_transformed(x - 196, y_draw + 48, "Crops:", sep, w, 1, txt_yscale, image_angle);
	draw_set_halign(fa_right);
	draw_text_ext_transformed(x + 196, y_draw + 48, crops_filled + "%", sep, w, 1, txt_yscale, image_angle);
	DrawReset();
	exit;
}


draw_set_valign(fa_middle);
draw_set_color(c_white);
draw_set_font(fnt_Federo37);
draw_set_halign(fa_center);
draw_text_ext_transformed(x, y + 0.7*sprite_height, "Farm More Carrots!", sep, w, 1, txt_yscale, image_angle);

draw_set_halign(fa_left);
draw_text_ext_transformed(x - 196, y_draw, "Base:", sep, w, 1, txt_yscale, image_angle);
draw_text_ext_transformed(x - 196, y_draw + 48, "Time:", sep, w, 1, txt_yscale, image_angle);
draw_text_ext_transformed(x - 196, y_draw + 96, "Total:", sep, w, 1, txt_yscale, image_angle);
draw_text_ext_transformed(x - 196, y_draw + 144, "Highscore:", sep, w, 1, txt_yscale, image_angle);
if(room == rm_LevelX1Farm) draw_text_ext_transformed(x - 196, y_draw + 192, "Crops:", sep, w, 1, txt_yscale, image_angle);

draw_set_halign(fa_right);
draw_text_ext_transformed(x + 196, y_draw, text, sep, w, 1, txt_yscale, image_angle);
draw_text_ext_transformed(x + 196, y_draw + 48, text_time, sep, w, 1, txt_yscale, image_angle);
draw_text_ext_transformed(x + 196, y_draw + 96, text_total, sep, w, 1, txt_yscale, image_angle);
draw_text_ext_transformed(x + 196, y_draw + 144, text_highscore, sep, w, 1, txt_yscale, image_angle);
if(room == rm_LevelX1Farm) draw_text_ext_transformed(x + 196, y_draw + 192, crops_filled + "%", sep, w, 1, txt_yscale, image_angle);

// Show simple text if this run set a new highscore
if (new_highscore) {
	draw_set_halign(fa_left);
	draw_text_ext_transformed(x + 210, y_draw + 144, "New!", sep, w, 1, txt_yscale, image_angle);
}