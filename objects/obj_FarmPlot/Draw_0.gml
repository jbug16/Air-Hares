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
		var _col = merge_color(PlayerTargetTintColor(0), PlayerTargetTintColor(1), 0.5);
		if (global.overworld_progress == PLOTSTATE.BUSTING or global.overworld_progress == PLOTSTATE.BOOMING)
		{
			_alpha = 0.5;
			gpu_set_blendmode(bm_add);
			draw_sprite_ext(sprite_index, image_index, _x_pos, _y_pos, scaling, scaling, image_angle, _col, _alpha);
			gpu_set_blendmode(bm_normal);
			draw_sprite_ext(spr_Targets, 5, _x_pos, _y_pos, 0.5*scaling, 0.5*scaling, image_angle, image_blend, 1);
		}
		else
		{
			draw_sprite_ext(sprite_index, image_index, _x_pos, _y_pos, scaling, scaling, image_angle, _col, _alpha);
			draw_sprite_ext(spr_Targets, 5, _x_pos, _y_pos, 0.5*scaling, 0.5*scaling, image_angle, image_blend, 1);
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
				var _col = PlayerTargetTintColor(targeted[i]);
				_alpha = 0.5;
				gpu_set_blendmode(bm_add);
				draw_sprite_ext(sprite_index, image_index, _x_pos, _y_pos, scaling, scaling, image_angle, _col, _alpha);
				gpu_set_blendmode(bm_normal);
				
				// Draw targets (per-character reticle)
				var _tix = TargetReticleSpriteIndex(targeted[i], false);
				draw_sprite_ext(spr_Targets, _tix, _x_pos, _y_pos, 0.5*scaling, 0.5*scaling, image_angle, image_blend, 1);
			}
			else
			{
				var _col = PlayerTargetTintColor(targeted[i]);
				draw_sprite_ext(sprite_index, image_index, _x_pos, _y_pos, scaling, scaling, image_angle, _col, _alpha);
				
				// Draw targets (per-character reticle)
				var _tix = TargetReticleSpriteIndex(targeted[i], false);
				draw_sprite_ext(spr_Targets, _tix, _x_pos, _y_pos, 0.5*scaling, 0.5*scaling, image_angle, image_blend, 1);
			}
		}
	}
}