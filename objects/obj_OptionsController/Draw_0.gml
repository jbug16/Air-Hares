/// @desc
draw_set_color(c_white);
draw_set_font(fnt_Federo37);
draw_set_halign(fa_center);
draw_set_valign(fa_middle);

// Draw title

var _x_left = room_width * 0.2; //position of the text
if (in_controls) _x_left = room_width*0.1;

// Draw options
if menu_draw and !in_controls and !in_leaderboards and !in_achievements and !in_saves {
	for (var i=0; i<array_length(menu); i++) {
		if (i == menu_selected) {
			draw_set_color(c_orange);	
		} else {
			draw_set_color(c_white);	
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
// Achievements — table layout (spr_Carrot: only subimages 0 and 1 — 0 = empty, 1 = star; data from global.achievement_*)
else if(menu_draw and in_achievements)
{
	var rw = room_width;
	var rh = room_height;
	// Clear obj_OptionsTitle / spr_Title (scaled logo ~top third); start text below it
	var _title_y = max(rh * 0.16, 112);
	
	draw_set_font(fnt_Federo24);
	draw_set_halign(fa_center);
	draw_set_valign(fa_top);
	draw_set_color(c_white);
	draw_text_transformed(rw * 0.5, _title_y, "ACHIEVEMENTS", image_xscale, image_yscale, image_angle);
	var _title_line_h = string_height("ACHIEVEMENTS") * image_yscale;
	
	// Column centers: generous spacing (match mockup grid)
	var _col_lvl = rw * 0.10;
	var _cx_pct = rw * 0.40;
	var _cx_ndmg = rw * 0.58;
	var _cx_peace = rw * 0.76;
	
	draw_set_font(fnt_Federo16);
	// Subtitle row sits below full title height + extra gap (breathing room under ACHIEVEMENTS)
	var _hdr_y = _title_y + _title_line_h + rh * 0.042;
	draw_set_halign(fa_left);
	draw_text_transformed(_col_lvl, _hdr_y, "Level", image_xscale, image_yscale, image_angle);
	draw_set_halign(fa_center);
	draw_text_transformed(_cx_pct, _hdr_y, "100% completion", image_xscale, image_yscale, image_angle);
	draw_text_transformed(_cx_ndmg, _hdr_y, "No damage", image_xscale, image_yscale, image_angle);
	draw_text_transformed(_cx_peace, _hdr_y, "No Aggression", image_xscale, image_yscale, image_angle);
	
	// Clear band below header text (carrots are centered in each row; tops must not cover headers)
	var _hdr_line_h = string_height("100% completion") * image_yscale;
	var _header_bottom = _hdr_y + _hdr_line_h + rh * 0.022;
	var _row_start = _header_bottom + rh * 0.014;
	
	// Reserve only for Back (hint line removed — extra height for taller rows + bigger carrots)
	var _back_y = rh * 0.93;
	var _table_end = _back_y - rh * 0.065;
	var _row_spacing = (_table_end - _row_start) / 16;
	// spr_Carrot is 100×100, origin centered — use most of each row, leave ~8% padding so rows never overlap
	var _carrot_px = min(100, _row_spacing * 0.92);
	var _carrot_sc = _carrot_px / 100;
	
	draw_set_valign(fa_middle);
	for (var _r = 0; _r < 16; _r++) {
		var _y = _row_start + _r * _row_spacing;
		var _stage = (_r div 4) + 1;
		var _col = _r mod 4;
		var _lvl_txt = string(_stage) + "-" + ((_col == 3) ? "B" : string(_col + 1));
		
		var _cy = _y + _row_spacing * 0.5;
		draw_set_halign(fa_left);
		draw_set_color(c_white);
		draw_text_transformed(_col_lvl, _cy, _lvl_txt, image_xscale, image_yscale, image_angle);
		
		// spr_Carrot has subimages 0 (empty) and 1 (star); coerce in case values came from INI as reals
		var _e0 = bool(global.achievement_farm100[_r]);
		var _e1 = bool(global.achievement_no_damage[_r]);
		var _e2 = bool(global.achievement_no_aggression[_r]);
		
		draw_set_halign(fa_center);
		var _sx = _carrot_sc * image_xscale;
		var _sy = _carrot_sc * image_yscale;
		draw_sprite_ext(spr_Carrot, _e0 ? 1 : 0, _cx_pct, _cy, _sx, _sy, 0, c_white, 1);
		draw_sprite_ext(spr_Carrot, _e1 ? 1 : 0, _cx_ndmg, _cy, _sx, _sy, 0, c_white, 1);
		draw_sprite_ext(spr_Carrot, _e2 ? 1 : 0, _cx_peace, _cy, _sx, _sy, 0, c_white, 1);
	}
	
	draw_set_halign(fa_center);
	draw_set_valign(fa_middle);
	if (menu_selected == 0)
		draw_set_color(c_orange);
	else
		draw_set_color(c_white);
	draw_set_font(fnt_Federo24);
	draw_text_transformed(rw * 0.5, _back_y, menu[0], image_xscale, image_yscale, image_angle);
}
// Saves (same list style as main options)
else if(menu_draw and in_saves)
{
	for (var i = 0; i < array_length(menu); i++) {
		if (i == menu_selected)
			draw_set_color(c_orange);
		else
			draw_set_color(c_white);
		draw_set_halign(fa_left);
		draw_text_transformed(_x_left, room_height * 0.3 + (52 * i), menu[i], image_xscale, image_yscale, image_angle);
		draw_set_halign(fa_right);
		draw_text_transformed(room_width * 0.8, room_height * 0.3 + (52 * i), menu_status[i], image_xscale, image_yscale, image_angle);
		draw_set_alpha(1);
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