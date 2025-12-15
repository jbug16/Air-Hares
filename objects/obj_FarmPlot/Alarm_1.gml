/// @desc Check if field complete
var _filled = true;

// If there is any plots that are free to shoot at, field not filled
with(obj_FarmPlot)
{
	if(state == PLOTSTATE.EMPTY or state == PLOTSTATE.SEEDED or state == PLOTSTATE.WATERED)
	{
		_filled = false;
		break;
	}
}

if(_filled) with(obj_ControllerFarm) event_user(2);
else alarm[0] = 1;