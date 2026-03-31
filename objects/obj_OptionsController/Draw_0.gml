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
	var _main_y = room_height * 0.15;
	var _title_y = room_height * 0.22;
	draw_set_color(c_white);
	draw_text_transformed(room_width * 0.5, _main_y, "STORY MODE HIGHSCORES", image_xscale, image_yscale, image_angle);
	draw_text_transformed(room_width * 0.25, _title_y, "SINGLEPLAYER", image_xscale, image_yscale, image_angle);
	draw_text_transformed(room_width * 0.75, _title_y, "CO-OP", image_xscale, image_yscale, image_angle);
	
	// Draw column headers — same Rank / Initials / Score spacing for both panels (offsets from each title center)
	var _header_y = room_height * 0.28;
	draw_set_font(fnt_Federo16);
	var rw = room_width;
	var _cx_sp = rw * 0.25;
	var _cx_co = rw * 0.75;
	var _lb_rank_dx = -0.13 * rw;
	var _lb_init_dx = 0.01 * rw;
	var _lb_score_dx = 0.13 * rw;
	var _sp_rank_x = _cx_sp + _lb_rank_dx;
	var _sp_name_x = _cx_sp + _lb_init_dx;
	var _sp_score_x = _cx_sp + _lb_score_dx;
	var _coop_rank_x = _cx_co + _lb_rank_dx;
	var _coop_name_x = _cx_co + _lb_init_dx;
	var _coop_score_x = _cx_co + _lb_score_dx;

	draw_set_halign(fa_left);
	draw_text_transformed(_sp_rank_x, _header_y, "Rank", image_xscale, image_yscale, image_angle);
	draw_text_transformed(_sp_name_x, _header_y, "Initials", image_xscale, image_yscale, image_angle);
	draw_set_halign(fa_right);
	draw_text_transformed(_sp_score_x, _header_y, "Score", image_xscale, image_yscale, image_angle);

	draw_set_halign(fa_left);
	draw_text_transformed(_coop_rank_x, _header_y, "Rank", image_xscale, image_yscale, image_angle);
	draw_text_transformed(_coop_name_x, _header_y, "Initials", image_xscale, image_yscale, image_angle);
	draw_set_halign(fa_right);
	draw_text_transformed(_coop_score_x, _header_y, "Score", image_xscale, image_yscale, image_angle);
	
	// Draw entries
	var _entry_start_y = room_height * 0.32;
	var _entry_spacing = 32;
	draw_set_halign(fa_left);
	
	// Draw singleplayer entries (always show up to leaderboard_max_entries rows)
	var _max_rows = global.leaderboard_max_entries;
	var _sp_len = array_length(global.leaderboard_singleplayer);
	for (var i = 0; i < _max_rows; i++) {
		var _has = i < _sp_len;
		var _entry = _has ? global.leaderboard_singleplayer[i] : undefined;
		var _y = _entry_start_y + (i * _entry_spacing);
		
		draw_set_color(c_white);
		draw_set_halign(fa_left);
		// Rank column: always 1..N old-school style, even if empty slot
		draw_text_transformed(_sp_rank_x, _y, string(i + 1) + ".", image_xscale, image_yscale, image_angle);
		
		// Initials + score only when we actually have an entry for this row
		var _name_txt = "---";
		var _score_txt = "";
		if (_has) {
			var _n = string(_entry.name);
			_n = string_upper(_n);
			if (string_length(_n) > 3) _n = string_copy(_n, 1, 3);
			_name_txt = _n;
			_score_txt = string(_entry.score);
		}
		draw_text_transformed(_sp_name_x, _y, _name_txt, image_xscale, image_yscale, image_angle);
		draw_set_halign(fa_right);
		draw_text_transformed(_sp_score_x, _y, _score_txt, image_xscale, image_yscale, image_angle);
		draw_set_halign(fa_left);
	}
	
	// Draw co-op entries (same pattern as singleplayer)
	var _coop_len = array_length(global.leaderboard_coop);
	for (var i = 0; i < _max_rows; i++) {
		var _has_c = i < _coop_len;
		var _entry_c = _has_c ? global.leaderboard_coop[i] : undefined;
		var _y = _entry_start_y + (i * _entry_spacing);
		
		draw_set_color(c_white);
		draw_set_halign(fa_left);
		draw_text_transformed(_coop_rank_x, _y, string(i + 1) + ".", image_xscale, image_yscale, image_angle);
		
		var _name_txt_c = "---";
		var _score_txt_c = "";
		if (_has_c) {
			var _nc = string(_entry_c.name);
			_nc = string_upper(_nc);
			if (string_length(_nc) > 3) _nc = string_copy(_nc, 1, 3);
			_name_txt_c = _nc;
			_score_txt_c = string(_entry_c.score);
		}
		draw_text_transformed(_coop_name_x, _y, _name_txt_c, image_xscale, image_yscale, image_angle);
		draw_set_halign(fa_right);
		draw_text_transformed(_coop_score_x, _y, _score_txt_c, image_xscale, image_yscale, image_angle);
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