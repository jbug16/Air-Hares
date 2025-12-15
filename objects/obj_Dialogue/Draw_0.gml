/// @desc
// Draw self
draw_self();

// Draw character portrait
draw_sprite(portrait[dialog_current], 0, x - 100, y + 55);

// Draw the displayed text
DrawText2(x, y, dialog_display, fa_left, fa_top, c_black, fnt_Federo24);
if (dialog_current_ended) {
	var _text = "<Press Space or 'A'>"
	if dialog_auto _text = "<AUTO>";
	DrawText2(x + 750, y + 90, _text, fa_right, fa_top, c_black, fnt_Federo16);
}

// Skip
if skip <= 0 {
	DrawText2(room_width - 32, room_height - 32, "Hold F or 'A' on Gamepad to skip", fa_right, fa_bottom, c_white, fnt_Federo24);
} else {
	// Draw skip
	draw_set_color(c_white)
	var _left_val = room_width - 92 - (skip);
	var _right_val = room_width - 92 + (skip);
	draw_rectangle(_left_val, room_height - 32, _right_val, room_height - 16, false);
	// Draw skip max
	draw_rectangle(room_width - 152, room_height - 32, room_width - 32, room_height - 16, true);
}