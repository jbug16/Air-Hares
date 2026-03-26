/// @desc
draw_set_color(c_white);
draw_set_font(fnt_Federo37);
draw_set_halign(fa_center);
draw_set_valign(fa_middle);

// Draw title

var _x_left = room_width * 0.2; //position of the text
if (in_controls) _x_left = room_width*0.1;

// Draw options
if menu_draw and !in_controls and !in_leaderboards {
	for (var i=0; i<array_length(menu); i++) {
		if (i == menu_selected and !in_saves and !in_achievements and !in_leaderboards) {
			draw_set_color(c_orange);	
		} else{
			draw_set_color(c_white);	
			if(i == menu_count - 1 and (in_achievements or in_saves or in_leaderboards)) draw_set_color(c_orange);
		}
		
		// Draw menu		
		draw_set_halign(fa_left)
		draw_text_transformed(_x_left, room_height * 0.3 + (52 * i), menu[i], image_xscale, image_yscale, image_angle);
		// Draw menu-status
		draw_set_halign(fa_right)
		draw_text_transformed(room_width*0.8, room_height*0.3 + (52*i), menu_status[i], image_xscale, image_yscale, image_angle);
		
		draw_set_alpha(1);
	}
}
else if(menu_draw and in_controls)
{
	draw_set_halign(fa_left)
	draw_set_font(fnt_Federo24);
	
	// Draw titles
	draw_text_transformed(0.07*room_width, 0.155*room_height, "Actions:", image_xscale, image_yscale, image_angle);
	draw_text_transformed(0.37*room_width, 0.155*room_height, "Keyboard:", image_xscale, image_yscale, image_angle);
	draw_text_transformed(0.7*room_width, 0.155*room_height, "Joypad:", image_xscale, image_yscale, image_angle);
	
	// Draw action text
	_x_left = room_width*0.07;
	var _y_start = 0.24*room_height;
	for (var i = 0; i < array_length(menu); i++) 
	{
		if(i == menu_selected)
		{
			draw_set_color(c_orange);
			if(alarm[1] > 0) draw_set_alpha(control_alpha);
		}
		else draw_set_color(c_white);
		draw_text_transformed(_x_left, _y_start + (45 * i), menu[i], image_xscale, image_yscale, image_angle);
		draw_set_alpha(image_alpha);
	}
	
	// Keyboard key text
	_x_left = room_width*0.37;
	for (var i = 0; i < array_length(menu); i++) 
	{
		if(i == menu_selected)
		{
			draw_set_color(c_orange);
			if(alarm[1] > 0) draw_set_alpha(control_alpha);
		}
		else draw_set_color(c_white);
		draw_text_transformed(_x_left, _y_start + (45 * i), key_keyboard[i], image_xscale, image_yscale, image_angle);
		draw_set_alpha(image_alpha);
	}
	
	// Gamepad key text
	_x_left = room_width*0.7;
	for (var i = 0; i < array_length(menu); i++) 
	{
		if(i == menu_selected)
		{
			draw_set_color(c_orange);
			if(alarm[1] > 0) draw_set_alpha(control_alpha);
		}
		else draw_set_color(c_white);
		draw_text_transformed(_x_left, _y_start + (45 * i), key_joypad[i], image_xscale, image_yscale, image_angle);
		draw_set_alpha(image_alpha);
	}
}
// Draw leaderboards
else if(menu_draw and in_leaderboards)
{
	draw_set_font(fnt_Federo24);
	draw_set_halign(fa_center);
	draw_set_valign(fa_top);
	
	// Draw titles
	var _title_y = room_height * 0.15;
	draw_set_color(c_white);
	draw_text_transformed(room_width * 0.25, _title_y, "SINGLEPLAYER", image_xscale, image_yscale, image_angle);
	draw_text_transformed(room_width * 0.75, _title_y, "CO-OP", image_xscale, image_yscale, image_angle);
	
	// Draw column headers
	var _header_y = room_height * 0.22;
	draw_set_font(fnt_Federo16);
	draw_set_halign(fa_left);
	
	// Singleplayer headers (rank + score only)
	var _sp_x = room_width * 0.12;
	draw_text_transformed(_sp_x, _header_y, "Rank", image_xscale, image_yscale, image_angle);
	draw_set_halign(fa_right);
	draw_text_transformed(room_width * 0.38, _header_y, "Score", image_xscale, image_yscale, image_angle);
	
	// Co-op headers
	var _coop_x = room_width * 0.62;
	draw_set_halign(fa_left);
	draw_text_transformed(_coop_x, _header_y, "Rank", image_xscale, image_yscale, image_angle);
	draw_set_halign(fa_right);
	draw_text_transformed(room_width * 0.88, _header_y, "Score", image_xscale, image_yscale, image_angle);
	
	// Draw entries
	var _entry_start_y = room_height * 0.28;
	var _entry_spacing = 32;
	draw_set_halign(fa_left);
	
	// Draw singleplayer entries
	for(var i = 0; i < array_length(global.leaderboard_singleplayer); i++) {
		var _entry = global.leaderboard_singleplayer[i];
		var _y = _entry_start_y + (i * _entry_spacing);
		
		draw_set_color(c_white);
		draw_text_transformed(_sp_x, _y, string(_entry.rank) + ".", image_xscale, image_yscale, image_angle);
		draw_set_halign(fa_right);
		draw_text_transformed(room_width * 0.38, _y, string(_entry.score), image_xscale, image_yscale, image_angle);
		draw_set_halign(fa_left);
	}
	
	// Draw co-op entries
	for(var i = 0; i < array_length(global.leaderboard_coop); i++) {
		var _entry = global.leaderboard_coop[i];
		var _y = _entry_start_y + (i * _entry_spacing);
		
		draw_set_color(c_white);
		draw_text_transformed(_coop_x, _y, string(_entry.rank) + ".", image_xscale, image_yscale, image_angle);
		draw_set_halign(fa_right);
		draw_text_transformed(room_width * 0.88, _y, string(_entry.score), image_xscale, image_yscale, image_angle);
		draw_set_halign(fa_left);
	}
	
	// Draw back button
	var _back_y = room_height * 0.9;
	if(menu_selected == 0) {
		draw_set_color(c_orange);
	} else {
		draw_set_color(c_white);
	}
	draw_set_halign(fa_center);
	draw_set_font(fnt_Federo24);
	draw_text_transformed(room_width * 0.5, _back_y, menu[0], image_xscale, image_yscale, image_angle);
}