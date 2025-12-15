/// Common text functions

function DrawText2(_x_pos, _y_pos, _text, _halign, _valign, _color, _font){
	draw_set_halign(_halign);
	draw_set_valign(_valign);
	draw_set_color(_color);
	draw_set_font(_font);
	draw_text(_x_pos, _y_pos, _text);
}

function DrawText3(_x_pos, _y_pos, _text, _halign, _valign, _color, _font, _sep, _w, _angle, _scale){
	draw_set_halign(_halign);
	draw_set_valign(_valign);
	draw_set_color(_color);
	draw_set_font(_font);
	draw_text_ext_transformed(_x_pos, _y_pos, _text, _sep, _w, _scale, _scale, _angle);
}

// Dialogue related _script
// @func DialogCreate(s_portrait, dialog)
// @arg s_portrait {int}
// @arg _dialog {array}
function DialogCreate(_s_portrait, _dialog, _is_auto){
	return false;
	var _dialogbox = instance_create_layer(337, 58, "GUI", obj_Dialogue);
	_dialogbox.portrait = _s_portrait;
	_dialogbox.dialog = _dialog;
	_dialogbox.dialog_auto = _is_auto;
}

function ControllerDialogWait(_next_state){
	with(obj_Dialogue) {
		instance_destroy();	
	}
	if !instance_exists(obj_Dialogue) state = _next_state;
}

// GUI helper function
function GUIFlyingTextCreate(_x_pos, _y_pos, _text){
	var _scr = instance_create_layer(_x_pos, _y_pos, "GUI", obj_GUITextFlying);
	_scr.z = 0;
	_scr.color = c_black;
	_scr.text = _text;
	_scr = instance_create_layer(_x_pos, _y_pos - 2, "GUI", obj_GUITextFlying);
	_scr.depth -= 1;
	_scr.z = 0;
	_scr.color = c_white;
	_scr.text = _text;
}