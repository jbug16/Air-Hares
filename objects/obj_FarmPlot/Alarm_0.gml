///@desc Check if line complete

// Check if line complete
var _line_complete = true;
with (object_index)
{
	if (other.id == id or y != other.y) continue;
	if (state != PLOTSTATE.CARROT_OLD and state != PLOTSTATE.BARREN and state != PLOTSTATE.CARROT_FRESH)
	{
		_line_complete = false;
		break;
	}
}

// Fill the row, apply points, fill the next empty row...
if (_line_complete)
{
	// Same row fillup
	with (object_index)
	{
		if (other.id == id or y != other.y) continue;
		if (state == PLOTSTATE.CARROT_OLD) state = PLOTSTATE.CARROT_FRESH;
		// VFX
		with (instance_create_layer(x, y, "Ground", obj_FarmPlotRevitalizeFX))
		{
			master = other.id;
			depth -= 1;
		}
	}
	
	// Next line fillup
	with (object_index)
	{
		if (other.id == id) continue;
		if (!place_meeting(other.x, y + 100, other.id)) continue;
		if (state == PLOTSTATE.CARROT_OLD) state = PLOTSTATE.CARROT_FRESH;
		else if (state == PLOTSTATE.BARREN) state = PLOTSTATE.BARREN_WATERED;
		// VFX
		with (instance_create_layer(x, y, "Ground", obj_FarmPlotRevitalizeFX))
		{
			master = other.id;
			depth -= 1;
		}
	}
		
	// Add score by 1000 on completed line
	with (instance_create_layer(x + 50, y, "GUI", obj_GUITextFlying))
	{
		z = 100;
		text = "+1000";
	}
	global.score_base += 1000;
	audio_play_sound(snd_FarmTransform, 1, false);	// sfx
}