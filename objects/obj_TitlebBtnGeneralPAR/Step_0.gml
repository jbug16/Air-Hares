/// @desc Interaction and easeInOut
if (parent_index == obj_TitlebBtnGeneralPAR and mode_on) exit;


// Convert window mouse coordinates to room coordinates
var _room_mouse_x = window_mouse_get_x() * (room_width / window_get_width());
var _room_mouse_y = window_mouse_get_y() * (room_height / window_get_height());

// MOUSE hover-in - use converted coordinates for movement detection too
if (!global.mouse_disable and !focus and (mouse_prev_x != _room_mouse_x or mouse_prev_y != _room_mouse_y)) 
{
	var _scale = scale_big/image_xscale;	// check relative to original btn size
	if (_room_mouse_x > x - 0.5*sprite_width*_scale and _room_mouse_x < x + 0.5*sprite_width*_scale)
	if (_room_mouse_y > y - 0.5*sprite_height*_scale and _room_mouse_y < y + 0.5*sprite_height*_scale)
	{
		with (parent_index)
		{
			if focus event_user(2);		// unhover all buttons
		}
		event_user(1);					// hover into the current one
	}
}


// KEYBOARD
if(alarm[2] < 0 and focus)
{
	//get input
	var _movement = InputGet(INPUT.MENU_RIGHT) - InputGet(INPUT.MENU_LEFT);
	
	if (InputGet(INPUT.MENU_SELECT)) event_user(0);	// button press
	else if (_movement != 0)	
	{
		// move selection
		var _sel = button_id + _movement;
		//loop buttons selection
		if(global.demo)
		{
			// Story mode disabled
			if(button_id == 2 and _movement == -1) _sel = 4;
			else if(button_id == 4 and _movement == 1) _sel = 2;
		}
		else
		{
			if (_sel < 1) _sel = instance_number(parent_index);
			else if(_sel > instance_number(parent_index)) _sel = 1;
		}
		if (button_id != _sel) 
		{
			event_user(2);		// unselect
			
			with (parent_index)	// select another
			{
				if (id == other.id) continue;
				if (button_id == _sel) 
				{
					event_user(1);
					break;
				}
			}
		}
		parent_index.alarm[2] = 1;	// delay the unintentional selection
	}
}


image_yscale = image_xscale;	// tweeining is done only on xscale, so this ensures the same scaling

// Remember previous mouse x/y (for mouse hover) - store converted coordinates
mouse_prev_x = _room_mouse_x;
mouse_prev_y = _room_mouse_y;