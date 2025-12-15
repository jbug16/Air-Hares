// Get previous
var _prev_f = draw_get_font();
var _prev_halign = draw_get_halign();
var _prev_valign = draw_get_valign();

// Prepare
draw_set_font(fnt_Federo30);
draw_set_halign(fa_center);
draw_set_valign(fa_bottom);


// Draw
//-> Image
draw_self();
//-> Border overlay
draw_set_color(#191919);
draw_rectangle(0,0,border_left, room_height, 0);			// left overlay
draw_rectangle(border_right,0,room_width, room_height, 0);	// right overlay
draw_rectangle(0, border_bot,room_width, room_height, 0);	// bot overlay
//-> Text
draw_set_alpha(text_alpha);
draw_set_color(c_white);
draw_text_transformed(room_width/2, txt_position, text[image_index], scale_txt, scale_txt, 0);


// Reset
draw_set_alpha(1);
draw_set_font(_prev_f);
draw_set_halign(_prev_halign);
draw_set_valign(_prev_valign);
