// Keyboard open: popup is hidden; obj_VirtualKeyboard draws the full screen
if (global.story_popup_screen == 1 && VirtualKeyboardIsActive()) exit;

// init & frame
draw_self();
draw_set_color(c_white);
draw_set_font(fnt_Federo16);
draw_set_halign(fa_center);
draw_set_valign(fa_middle);

// scaling
var _scale_x = image_xscale/2;
var _scale_y = image_yscale/2;

// Icon
draw_sprite_ext(spr_PlayerIcon, 0, x - 130*image_xscale, y - 5*image_yscale, _scale_x, _scale_y, 0, c_white, 1);

if (global.story_popup_screen == 1) {
	draw_text_transformed(x, y - 20*image_yscale, "New Story Game", _scale_x, _scale_y, 0);
	draw_set_font(fnt_Federo24);
	draw_set_color(c_orange);
	var _s = global.story_new_initials;
	var _n = string_length(_s);
	var _initials_text = "";
	for (var _slot = 0; _slot < 3; _slot++) {
		if (_slot < _n) _initials_text += string_copy(_s, _slot + 1, 1);
		else _initials_text += "_";
	}
	draw_text_transformed(x, y + 8*image_yscale, _initials_text, _scale_x, _scale_y, 0);
	draw_set_font(fnt_Federo16);
	draw_set_color(c_white);
	draw_text_transformed(x, y + 28*image_yscale, "Select to edit initials", _scale_x * 0.85, _scale_y * 0.85, 0);
	exit;
}

// Main story popup: stage name, lives, score label
var _progress_display = min(global.story_mode_progress, 15);
var _txt = "GAME COMPLETE!";
if (global.demo && global.story_mode_progress >= DemoMaxProgress()) {
	_txt = "DEMO COMPLETE!";
} else if (global.story_mode_progress < 16) {
	_txt = StoryLevelPopupTitle(DemoClampLevelIndex(_progress_display));
}
draw_text_transformed(x , y - 20*image_yscale, _txt, _scale_x, _scale_y, 0);
draw_text_transformed(x , y, "LIVES: " + string(global.lives), _scale_x, _scale_y, 0);
var _run_sc = global.story_run_score_cumulative;
var _rname = global.story_run_initials;
var _run_line = "SCORE: " + string(round(_run_sc));
var _run_initials = "---";
if (is_string(_rname) && string_length(_rname) > 0) {
	_run_initials = string_upper(string_copy(_rname, 1, min(3, string_length(_rname))));
}
_run_line += " (" + _run_initials + ")";
draw_text_transformed(x , y + 15*image_yscale, _run_line, _scale_x, _scale_y, 0);