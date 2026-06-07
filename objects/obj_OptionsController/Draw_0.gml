/// @desc
draw_set_color(c_white);
draw_set_font(fnt_Federo30);
draw_set_halign(fa_center);
draw_set_valign(fa_middle);

// Draw title

var _x_left = room_width * 0.2; //position of the text
if (in_controls) _x_left = room_width*0.1;

var _oa = image_alpha;
// Main options / graphics / saves column — below obj_OptionsTitle (logo); tighter than 0.3*rh
var _opts_menu_y0 = max(room_height * 0.17, 120);
var _opts_line = 44;
// Main 7-row list: same small gap after Graphics and before Back
var _opts_gap_block = _opts_line * 0.5;
var _opts_grouped_main = (!in_scores && menu_count == 7);
var _opts_grouped_scores = in_scores;

// Draw options
if menu_draw and !in_controls and !in_leaderboards and !in_achievements and !in_saves {
	draw_set_alpha(_oa);
	for (var i=0; i<menu_count; i++) {
		if (i == menu_selected) {
			draw_set_color(c_orange);	
		} else {
			draw_set_color(c_white);	
		}
		
		var _yy = _opts_menu_y0 + _opts_line * i;
		if (_opts_grouped_main) {
			if (i >= 4) _yy += _opts_gap_block;
			if (i >= 6) _yy += _opts_gap_block;
		}
		else if (_opts_grouped_scores && i >= 4) _yy += _opts_gap_block;
		
		// Draw menu		
		draw_set_halign(fa_left)
		draw_text_transformed(_x_left, _yy, menu[i], image_xscale, image_yscale, image_angle);
		// Draw menu-status
		draw_set_halign(fa_right)
		draw_text_transformed(room_width*0.8, _yy, menu_status[i], image_xscale, image_yscale, image_angle);
		
		draw_set_alpha(_oa);
	}
}
else if(menu_draw and in_controls)
{
	draw_set_halign(fa_left)
	draw_set_font(fnt_Federo24);
	draw_set_alpha(_oa);
	
	var _show_kb = InputControlsKeyboardRebindEnabled();
	
	// Draw titles
	draw_text_transformed(0.07*room_width, 0.155*room_height, "Actions:", image_xscale, image_yscale, image_angle);
	if (_show_kb) {
		draw_text_transformed(0.37*room_width, 0.155*room_height, "Keyboard:", image_xscale, image_yscale, image_angle);
	}
	draw_text_transformed((_show_kb ? 0.7 : 0.45) * room_width, 0.155*room_height, "Controller:", image_xscale, image_yscale, image_angle);
	
	// Draw action text
	_x_left = room_width*0.07;
	var _y_start = 0.24*room_height;
	for (var i = 0; i < array_length(menu); i++) 
	{
		if(i == menu_selected)
		{
			draw_set_color(c_orange);
			if(alarm[1] > 0) draw_set_alpha(control_alpha * _oa);
			else draw_set_alpha(_oa);
		}
		else { draw_set_color(c_white); draw_set_alpha(_oa); }
		draw_text_transformed(_x_left, _y_start + (45 * i), menu[i], image_xscale, image_yscale, image_angle);
	}
	
	// Keyboard key text (desktop only)
	if (_show_kb) {
		_x_left = room_width*0.37;
		for (var i = 0; i < array_length(menu); i++) 
		{
			if(i == menu_selected)
			{
				draw_set_color(c_orange);
				if(alarm[1] > 0) draw_set_alpha(control_alpha * _oa);
				else draw_set_alpha(_oa);
			}
			else { draw_set_color(c_white); draw_set_alpha(_oa); }
			draw_text_transformed(_x_left, _y_start + (45 * i), key_keyboard[i], image_xscale, image_yscale, image_angle);
		}
	}
	
	// Controller key text
	_x_left = (_show_kb ? 0.7 : 0.45) * room_width;
	for (var i = 0; i < array_length(menu); i++) 
	{
		if(i == menu_selected)
		{
			draw_set_color(c_orange);
			if(alarm[1] > 0) draw_set_alpha(control_alpha * _oa);
			else draw_set_alpha(_oa);
		}
		else { draw_set_color(c_white); draw_set_alpha(_oa); }
		draw_text_transformed(_x_left, _y_start + (45 * i), key_joypad[i], image_xscale, image_yscale, image_angle);
	}
}
// Achievements — transposed table: levels across the top, challenge types down the left (fits tall spr_Carrot art)
else if(menu_draw and in_achievements)
{
	draw_set_alpha(_oa);
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
	
	draw_set_font(fnt_Federo16);
	var _lvl_hdr_y = _title_y + _title_line_h + rh * 0.034;
	var _hdr_line_h = string_height("100% Completion") * image_yscale;
	
	// Whole table (challenge labels + grid) centered horizontally on the room
	var _label_gap = max(10, rw * 0.01);
	var _lw = string_width("100% Completion");
	_lw = max(_lw, string_width("No Damage"));
	_lw = max(_lw, string_width("No Aggression"));
	_lw *= image_xscale;
	var _table_max_w = rw * 0.92;
	var _grid_max_w = _table_max_w - _lw - _label_gap;
	var _col_w = _grid_max_w / 16;
	var _table_w = _lw + _label_gap + 16 * _col_w;
	var _grid_left = rw * 0.5 - _table_w * 0.5 + _lw + _label_gap;
	var _label_right_x = _grid_left - _label_gap;
	
	var _lvl_hdr_bottom = _lvl_hdr_y + _hdr_line_h + rh * 0.018;
	var _back_y = rh * 0.93;
	var _table_end = _back_y - rh * 0.065;
	var _row_h = (_table_end - _lvl_hdr_bottom) / 3;
	var _row_start = _lvl_hdr_bottom + _row_h * 0.5;
	
	var _sw = sprite_get_width(spr_Carrot);
	var _sh = sprite_get_height(spr_Carrot);
	var _cell = min(_col_w * 0.86, _row_h * 0.86);
	var _carrot_sc = _cell / max(_sw, _sh);
	var _sx = _carrot_sc * image_xscale;
	var _sy = _carrot_sc * image_yscale;
	
	// Top row: level ids 1-1 … 4-B
	draw_set_halign(fa_center);
	draw_set_valign(fa_top);
	draw_set_color(c_white);
	for (var _c = 0; _c < 16; _c++) {
		var _stage = (_c div 4) + 1;
		var _col = _c mod 4;
		var _lvl_txt = string(_stage) + "-" + ((_col == 3) ? "B" : string(_col + 1));
		var _cx = _grid_left + (_c + 0.5) * _col_w;
		draw_text_transformed(_cx, _lvl_hdr_y, _lvl_txt, image_xscale, image_yscale, image_angle);
	}
	
	var _ch_name = ["100% Completion", "No Damage", "No Aggression"];
	draw_set_valign(fa_middle);
	for (var _r = 0; _r < 3; _r++) {
		var _cy = _row_start + _r * _row_h;
		draw_set_halign(fa_right);
		draw_set_color(c_white);
		draw_text_transformed(_label_right_x, _cy, _ch_name[_r], image_xscale, image_yscale, image_angle);
		
		for (var _c = 0; _c < 16; _c++) {
			var _cx = _grid_left + (_c + 0.5) * _col_w;
			var _e = false;
			var _is_boss_col = (_c mod 4 == 3);
			if (_r == 0) {
				// Boss levels have no crop objective, so this medal is not shown there.
				if (_is_boss_col) continue;
				_e = bool(global.achievement_farm100[_c]);
			}
			else if (_r == 1) _e = bool(global.achievement_no_damage[_c]);
			else _e = bool(global.achievement_no_aggression[_c]);
			draw_sprite_ext(spr_Carrot, _e ? 1 : 0, _cx, _cy, 0.1, 0.1, 0, c_white, _oa);
		}
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
	draw_set_alpha(_oa);
	for (var i = 0; i < array_length(menu); i++) {
		if (i == menu_selected)
			draw_set_color(c_orange);
		else
			draw_set_color(c_white);
		draw_set_halign(fa_left);
		draw_text_transformed(_x_left, _opts_menu_y0 + (_opts_line * i), menu[i], image_xscale, image_yscale, image_angle);
		draw_set_halign(fa_right);
		draw_text_transformed(room_width * 0.8, _opts_menu_y0 + (_opts_line * i), menu_status[i], image_xscale, image_yscale, image_angle);
		draw_set_alpha(_oa);
	}
}
// Draw leaderboards
else if(menu_draw and in_leaderboards)
{
	draw_set_alpha(_oa);
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