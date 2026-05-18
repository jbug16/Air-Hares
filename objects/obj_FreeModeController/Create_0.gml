/// @desc Init
// Calc level that can be finished. Progress 2 means only two tutorials are completed

//var _level_count = global.story_mode_progress;
var _level_count = global.arcade_max_unlocked;
//if (global.dev_mode) _level_count = 16;					// DEBUG
if(global.demo) _level_count = 3;
level_count = max(1, _level_count);
prev_left = false;
prev_right = false;
prev_up = false;
prev_down = false;

selected = 0;
selected_prev = 0;

var _anchor_x = 0.2*room_width;
var _anchor_y = 0.24*room_height;
var _spacing_x = 0.2*room_width;
var _spacing_y = 0.15*room_height;


// Create all the level selects
for(var i=0; i<_level_count; i++) 
{
	// Spawn the button
	var _row = i div 4;
	var _col = i mod 4;
	var _x_pos = _anchor_x + (_row*_spacing_x);
	var _y_pos = _anchor_y + (_col*_spacing_y);
	var _data_struct = { button_id: i+1 };
	var _btn = instance_create_layer(_x_pos, _y_pos, layer, obj_FreeModeSelect, _data_struct);

	// button vars
	_btn.text = string(_row+1) + "-"; //global.story_mode_level[i][STORYPROP.NAME];
	if (_col == 3) _btn.text += "B" else _btn.text += string(_col+1);
	_btn.tgt_level = i;
	_btn.menu_index = i;	// Index of this is menu
	
	if (i == 0) with _btn event_user(1); //event_perform(ev_mouse, ev_mouse_enter);
}
