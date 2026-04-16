/// @desc
var _x_pos = DepthGetPositionX(x,z)
var _y_pos = DepthGetPositionY(y,z)


draw_sprite_ext(sprite_index, image_index, _x_pos, _y_pos, scaling, scaling, image_angle, c_white, 1);

if (array_length(targeted) > 0) {
	
	// Check if both players are targeting this crop
	var _both_targeting = (array_length(targeted) == 2);
	
	if (_both_targeting) {
		// Both players targeting
		var _alpha = 0.15;
		if (global.overworld_progress == PLOTSTATE.BUSTING or global.overworld_progress == PLOTSTATE.BOOMING)
		{
			var _col = c_yellow;
			_alpha = 0.5;
			gpu_set_blendmode(bm_add);
			draw_sprite_ext(sprite_index, image_index, _x_pos, _y_pos, scaling, scaling, image_angle, _col, _alpha);
			gpu_set_blendmode(bm_normal);
			draw_sprite_ext(spr_Targets, 2, _x_pos, _y_pos, 0.5*scaling, 0.5*scaling, image_angle, image_blend, 1);
		}
		else
		{
			var _col = c_yellow;
			draw_sprite_ext(sprite_index, image_index, _x_pos, _y_pos, scaling, scaling, image_angle, _col, _alpha);
			draw_sprite_ext(spr_Targets, 2, _x_pos, _y_pos, 0.5*scaling, 0.5*scaling, image_angle, image_blend, 1);
		}
	}
	else
	{
		// Single player targeting - existing logic
		for (var i = 0; i < array_length(targeted); i++)
		{
			var _alpha = 0.15;
			if (global.overworld_progress == PLOTSTATE.BUSTING or global.overworld_progress == PLOTSTATE.BOOMING)
			{
				var _col = c_aqua;
				if (global.overworld_progress == PLOTSTATE.BOOMING) _col = c_blue;
				if (targeted[i] == 1) 
				{
					if (global.overworld_progress == PLOTSTATE.BOOMING) _col = c_green;
					else _col = c_lime;
				}
				_alpha = 0.5;
				gpu_set_blendmode(bm_add);
				draw_sprite_ext(sprite_index, image_index, _x_pos, _y_pos, scaling, scaling, image_angle, _col, _alpha);
				gpu_set_blendmode(bm_normal);
				
				// Draw targets
				if(_col == c_lime or _col == c_green) draw_sprite_ext(spr_Targets, 1, _x_pos, _y_pos, 0.5*scaling, 0.5*scaling, image_angle, image_blend, 1);
				else draw_sprite_ext(spr_Targets, 0, _x_pos, _y_pos, 0.5*scaling, 0.5*scaling, image_angle, image_blend, 1);
			}
			else
			{
				var _col = c_blue;
				if (targeted[i] == 1) _col = c_green; 
				draw_sprite_ext(sprite_index, image_index, _x_pos, _y_pos, scaling, scaling, image_angle, _col, _alpha);
				
				// Draw targets
				var _index = 0;
				if(_col == c_green) _index = 1;
				draw_sprite_ext(spr_Targets, _index, _x_pos, _y_pos, 0.5*scaling, 0.5*scaling, image_angle, image_blend, 1);
			}
		}
	}
}