/// @desc Portraits above obj_Pause dim
if (!global.pause_coop_portrait_select || !instance_exists(obj_Pause)) exit;

var _t = current_time * 0.008;
var _pulse = 0.78 + 0.22 * (0.5 + 0.5 * sin(_t));
var _cx = room_width * 0.5;
var _cy = room_height * 0.48;
var _n = array_length(global.coop_portrait_sprite);
var _gap = 140;
var _slot = global.coop_portrait_select_index;

draw_set_halign(fa_center);
draw_set_valign(fa_middle);
draw_set_font(fnt_Federo24);
draw_set_color(c_white);

draw_text_transformed(_cx, _cy - 120, "CHOOSE CO-OP PILOT", 1, 1, 0);

var _frame_sc = 1.85;
//draw_sprite_ext(spr_TitleSelectionFrame, 0, _cx, _cy, _frame_sc, _frame_sc, 0, c_white, 1);

for (var _i = 0; _i < _n; _i++) {
	var _spr = global.coop_portrait_sprite[_i];
	var _x = _cx + (_i - (_n - 1) * 0.5) * _gap;
	var _sel = (_i == _slot);
	var _locked = !CoopPortraitSelectSlotAvailable(_i);
	var _sc = (_sel && !_locked) ? (1.12 * _pulse) : 1;
	var _a = _locked ? (_sel ? 0.7 : 0.45) : (_sel ? 1 : 0.94);
	var _col = _locked ? c_gray : c_white;
	draw_sprite_ext(_spr, 0, _x, _cy, _sc, _sc, 0, _col, _a);
}

// Bottom center inside frame (sprite origin is middle center)
var _name_txt = global.character_name[CHARACTER.DIRK + _slot];
var _slot_locked = !CoopPortraitSelectSlotAvailable(_slot);
draw_set_font(fnt_Federo24);
draw_set_halign(fa_center);
draw_set_valign(fa_bottom);
draw_set_color(_slot_locked ? c_gray : c_orange);
draw_text_transformed(_cx, _cy + 105, _name_txt, 1, 1, 0);

if (_slot_locked) {
	draw_set_font(fnt_Federo16);
	draw_set_valign(fa_top);
	draw_set_color(c_gray);
	draw_text_transformed(_cx, _cy + 108, "NOT INCLUDED IN DEMO", 1, 1, 0);
}

//draw_set_font(fnt_Federo16);
//draw_set_valign(fa_middle);
//draw_set_color(c_white);
//draw_text_transformed(_cx, _cy + 140, "A to Confirm     B to Cancel", 1, 1, 0);

DrawReset();
