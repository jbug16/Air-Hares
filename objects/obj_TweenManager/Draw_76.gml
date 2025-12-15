///@desc Update all
for (var i = array_length(tweeners) - 1; i >= 0; i--)
{
	var _tweener = tweeners[i];
	var _inst = _tweener.who;	// instance_id
	
	// Game paused!
	if (instance_exists(obj_Pause))
	{
		if !_CheckExists(_inst) 
		{
			array_delete(tweeners, i, 1);	//no instance with this id
			continue;
		}
		if (object_get_parent(_inst.object_index) != obj_PauseButtonPAR) continue;
	}
	
	//==========================================================
	// Error checks
	//==========================================================
	if !_CheckExists(_inst) array_delete(tweeners, i, 1);	//	no instance with this id!
	else if (instance_exists(_inst) and !variable_instance_exists(_inst, _tweener.what)) 
		array_delete(tweeners, i, 1);						// no variable with this name in instance
	else if (!instance_exists(_inst) or _tweener.paused) continue;
	
	
	
	//==========================================================
	// Normal tweening
	//==========================================================
	else
	{
		if (_tweener.delay > 0) _tweener.delay--;	// wait - tween is delayed
		else 
		{
			_tweener.position++;	
			var _current_index_limit = array_length(_tweener.values) - 1;
			
			
			//----------------------------------------------------------
			// End of current 101-window?
			//----------------------------------------------------------
			if (_tweener.position >= _current_index_limit + 1)
			{
				if (_current_index_limit < _tweener.duration)	// concat the array (recalculate next 101-window)
				{
					_tweener.values = array_concat(_tweener.values, TweenCreateData(_tweener.start_value, _tweener.end_value,
						_tweener.duration, _tweener.tw_type, _current_index_limit + 1));
				}
				else 
				{
					// Update loop nomber and check if last loop
					if (_tweener.loops != infinity) _tweener.loops--;
					if  (_tweener.loops <= 0)				
					{
						array_delete(tweeners, i, 1);	
						continue;
					}
					
					//===================== Retweening etc. =======================
					_tweener.position = 0;
					if (_tweener.tw_repeat == TWEENREPEAT.RETWEEN)
					{
						var _temp = _tweener.start_value;
						_tweener.start_value = _tweener.end_value;
						_tweener.end_value = _temp;
						_tweener.values = TweenCreateData(_tweener.start_value, _tweener.end_value, _tweener.duration, _tweener.tw_type);
					}
					else if (_tweener.tw_repeat == TWEENREPEAT.PATROL) _tweener.values = array_reverse(_tweener.values);
				}
			}
			
			
			//----------------------------------------------------------
			// Update instance variable value
			//----------------------------------------------------------
			if (_tweener.arr_index < 0) variable_instance_set(_inst, _tweener.what, _tweener.values[_tweener.position]);
			else		// array
			{
				var _tmp = variable_instance_get(_inst, _tweener.what);
				_tmp[_tweener.arr_index] = _tweener.values[_tweener.position];
			}
		}
	}
}
