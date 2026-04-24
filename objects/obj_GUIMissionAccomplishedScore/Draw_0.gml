/// @desc
// Three medal carrots between title art and score block (empty → spr_AnimShine → filled)
var _cy;
var _ma = noone;
if (instance_exists(obj_GUIMissionAccomplished)) _ma = instance_find(obj_GUIMissionAccomplished, 0);
if (_ma != noone) {
	var _title_bottom = _ma.y + sprite_get_height(_ma.sprite_index) * 0.5 * abs(_ma.image_yscale);
	var _y_min = _title_bottom + 36;
	var _y_max = y - 58;
	if (_y_max > _y_min) {
		_cy = lerp(_y_min, _y_max, 0.32);
	} else {
		_cy = (_y_min + _y_max) * 0.5;
	}
} else {
	_cy = y - 78;
}
var _gap = 70;
var _sc_c = 0.05;
var _nfx = sprite_get_number(spr_AnimShine);
for (var _i = 0; _i < 3; _i++) {
	var _cx = x + (_i - 1) * _gap;
	var _ph = mission_ach_phase[_i];
	if (_ph == 0) {
		draw_sprite_ext(spr_Carrot, 0, _cx, _cy, _sc_c, _sc_c, 0, c_white, 1);
	} else if (_ph == 1) {
		var _sub = clamp(floor(mission_ach_anim[_i]), 0, _nfx - 1);
		draw_sprite_ext(spr_AnimShine, _sub, _cx, _cy, 0.5, 0.5, 0, c_white, 1);
	} else {
		draw_sprite_ext(spr_Carrot, 1, _cx, _cy, _sc_c, _sc_c, 0, c_white, 1);
	}
}

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