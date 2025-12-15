/*
	TweenCheckArray		-	internal
	TweenStart			-	external (called)
	TweenStop			-	external (called)
	TweenResume			-	external (called)
	TweenCreateData		-	internal
	TweenCalculate		-	internal
*/



//==========================================================
// Needed enums
//==========================================================
// Tweening algorithm to use
enum TWEENTYPE
{
	BACK_IN,
	BACK_INOUT,
	BACK_OUT,
	BOUNCE_IN,
	BOUNCE_INOUT,
	BOUNCE_OUT,
	CIRC_IN,
	CIRC_INOUT,
	CIRC_OUT,
	CUBIC_IN,
	CUBIC_INOUT,
	CUBIC_OUT,
	ELASTIC_IN,
	ELASTIC_INOUT,
	ELASTIC_OUT,
	EXPO_IN,
	EXPO_INOUT,
	EXPO_OUT,
	QUAD_IN,
	QUAD_INOUT,
	QUAD_OUT,
	QUART_IN,
	QUART_INOUT,
	QUART_OUT,
	QUINT_IN,
	QUINT_INOUT,
	QUINT_OUT,
	SINE_IN,
	SINE_INOUT,
	SINE_OUT,
	LINEAR,
	len
}

// Tweening - how to play the tween (once or repeat etc.)
enum TWEENREPEAT
{
	RESTART,	// Repeat from starting point (jumps to start point), no recalculation needed
	PATROL,		// Go back and forth between start and end points, without re-calculating with tween function (just goes through the initially calculated values)
	RETWEEN,	// Once one end is reached, re-calculate the tween for opposite direction and go back-forth in this manner (forward-backward)
	len
}



//==========================================================
// Functions
//==========================================================
///@func TweenCheckArray(array_string, inst_id, check_noone)
///@desc Checks the the string to see it is given in array format (e.g. "my_array[0]"). Outputs debug message if wrong, otherwise 
///@desc returns short variable name (e.g. "my_array") and index (e.g. 0).
///@arg		array_string	{string}	The string which should be stringified array+index name, like: "array[12]", "my_array[3]"
///@arg		inst_id			{inst_id}	Which instance to check
///@arg		check_noone		{bool}		If the error check should return error if var == noone. Should be set to false if called within TweenStop/TweenResume, otherwise leave as is
///@return					{array}		["arrayname", index] - array string input split into the name part (string) and the index (int). 0 if error, -1 if not an array.
function TweenCheckArray(_var, _id = id, _check_noone = true){
	var _index = -1;
	var _bracket_start = string_pos("[", _var);		// array bracket start position in variable name
	var _bracket_stop = string_pos("]", _var);
	if (_bracket_start > 0 and _bracket_stop > 0 and _bracket_stop > _bracket_start)	// all ok with array input
	{
		_index = int64(string_digits(string_copy(_var, _bracket_start, _bracket_stop - _bracket_start)));
		_var = string_copy(_var, 1, _bracket_start - 1);		// remove brackets from the variable name
	}
	else if (_bracket_start > 0 or _bracket_stop > 0)	// wrong array input
	{
		show_debug_message("TWEEN ERROR: TweenCheckArray() cannot execute - wrong array input!");
		return false;
	}
	else return -1;
	if !variable_instance_exists(_id, _var)				// wrong variable name?
	{
		if !(_var== noone and !_check_noone) show_debug_message("TWEEN ERROR: TweenCheckArray() -> variable provided does not exist in the instance!");
		return false;
	}
	return [_var, _index];
}



///@func TweenStart(what, start_value, end_value, dur, tw_type, delay, tw_repeat, loops, who)
///@desc Starts the tweening of a particular instance variable. The tweening update is done by persistent obj_TweenManager which should be placed in the init room.
///@desc The tween update is done at End Step by the manager! Works with arrays, but only with specific elements (i.e. "my_array[0]", not "my_array").
///@arg	what		{var}			what instance variable to change - name in string!
///@arg	start_value	{real}			start value
///@arg	end_value	{real}			end value
///@arg	dur			{real}			tween duration, rounded to closest upper number (ceil)
///@arg	tw_type		{TWEENTYPE}		tween type to play/calculate
///@arg	delay		{real}			delay before tween
///@arg	tw_repeat	{TWEENREPEAT}	how to loop the tween
///@arg	loops		{int}			how many times to loop the tween (infinity for infinite). 1 pass in one direction is 1 loop (loop == 2 means it will go forward and back, loop == 1 means no loop)
///@arg	who			{inst_id}		instance id where the variable changes
///@return			{bool}			Succesful?
function TweenStart(_var, _start_value, _end_value, _duration, _tw_type = TWEENTYPE.LINEAR, _delay = 0, _tw_repeat = TWEENREPEAT.RETWEEN, _loops = 1, _id = id){
	//----------------------------------------------------------
	// Error check
	//----------------------------------------------------------
	var _index = -1;		// If variable is array, if not then set the index to -1 for later checks
	if !instance_exists(obj_TweenManager) show_debug_message("TWEEN ERROR: Cannot start tween - TweenManager object not created/activated");
	if !is_string(_var) show_debug_message("TWEEN ERROR: Cannot start tween - variable provided is not in string format!");
	else if (!is_numeric(_start_value) or !is_numeric(_end_value)) show_debug_message("TWEEN ERROR: Cannot start tween - 'min' or 'max' value is not a number");
	else if !instance_exists(_id) show_debug_message("TWEEN ERROR: Cannot start tween - instance provided doesn't exist!");
	else if !variable_instance_exists(_id, _var) show_debug_message("TWEEN ERROR: Cannot start tween - variable provided doesn't exist in the given instance.");
	else
	//----------------------------------------------------------
	// Normal startup
	//----------------------------------------------------------
	{
		// Check if the variable is an array
		var _var_original = _var;		// original, not shortened var name (it gets shortened when it is an array - brackets are removed)
		var _array_return = TweenCheckArray(_var, _id);
		if is_array(_array_return)
		{
			_var = _array_return[0];
			_index = _array_return[1];
		}
		
		
		TweenStop(_id, _var_original);		// first remove the existing tween if there's the same instance/var pair being tweened
		_duration = ceil(_duration);

		with (obj_TweenManager)	// add the tween to the manager
		{
			array_push(tweeners, 
			{
				who:			_id,															// {inst_id}		instance which variable is being tweened
				what:			_var,															// {string}			variable name to tween inside the instance
				start_value:	_start_value,													// {real}			overall min value (value of the first element on the tween timeline)
				end_value:		_end_value,														// {real}			overall max value (value of the last element on the tweening timeline)
				duration:		_duration,														// {real}			whole tweening duration in game steps (one loop, whole tween length)
				tw_type:		_tw_type,														// {TWEENTYPE}		tweening type, enum
				delay:			_delay,															// {int}			how much to delay the tweening (delay before tween start)
				tw_repeat:		_tw_repeat,														// {TWEENREPEAT}	type of repeat, enum
				loops:			_loops,															// {int}			# of loops (1 -> none, 2 -> 1 round trip)
				values:			TweenCreateData(_start_value, _end_value, _duration, _tw_type),	// {array}			array of values which the tweener will go thru - updated in 101-windows
				position:		0,																//	{int}			current position (element index) in the tween timeline (internal value)
				paused:			false,															// {bool}			if variable tweening is currently paused (internal value)
				arr_index:		_index															// {int}			if array - which index to change
			});	
		}
		return true;
	}
	return false;
}



///@func TweenStop(id, variable, pause)
///@desc Stops or pauses a tween of a particular variable within the instance. If no variable given, stops all tweens in an instance.
///@desc Works with arrays, but only with specific elements (i.e. "my_array[0]", not "my_array").
///@arg	id			{id} instance_id
///@arg	variable	{real} variable to stop/pause tweening
///@arg	pause		{bool} if pausing the tween (1) or stoping and deleting from tween list (0)
///@return			{bool} Succesful?
function TweenStop(_id = id, _var = noone, _pause = false){
	// Error check
	if (!is_string(_var) and _var != noone) show_debug_message("TWEEN ERROR: TweenStop()/TweenPause() cannot stop/pause - variable provided is not in string format!");
	else if !instance_exists(_id) show_debug_message("TWEEN ERROR: TweenStop()/TweenPause() cannot stop/pause - instance provided doesn't exist or it is disabled!");
	else
	{
		// Check if the variable is an array
		var _index = -1;		// Used if variable is array, if not then set the index to -1 for later checks
		var _array_return = TweenCheckArray(_var, _id, false);
		if (is_array(_array_return))
		{
			_var = _array_return[0];
			_index = _array_return[1];
		}
		
		// Actual stop/pause of tweening - search through the tweeners in the array
		with (obj_TweenManager)
		{
			for (var i = array_length(tweeners) - 1; i >= 0; i--)	// loop through all tweens
			{
				var _tweener = tweeners[i];
				if (_id == _tweener.who)	// id found
				{
					var _tweener = tweeners[i];
					if (_var == noone or (_var == _tweener.what and _tweener.arr_index == _index))	// applied to all vars, or specific var
					{
						if (!_pause) array_delete(tweeners, i, 1);
						else _tweener.paused = true;	// pause the specific tween
						if (_var != noone) return true;	// if finding only a specific variable, then done
					}
				}
			}
			if (_var != noone) return false;
			return true;
		}
	}
}



///@func TweenPause(id, variable)
///@desc Resumes tweening a variable if it was paused. Returns true/false if successful or not. If _var == noone then it resumes tweening of all variables for this id.
///@desc Works with arrays, but only with specific elements (i.e. "my_array[0]", not "my_array").
///@arg	id			{id} instance_id
///@arg	variable	{real} variable to pause tweening
function TweenPause(_id = id, _var = noone){
	TweenStop(_id, _var, true);
}



///@func TweenResume(id, variable)
///@desc Resumes tweening a variable if it was paused. Returns true/false if successful or not. If _var == noone then it resumes tweening of all variables for this id.
///@desc Works with arrays, but only with specific elements (i.e. "my_array[0]", not "my_array").
///@arg	id			{id} instance_id
///@arg	variable	{real} variable to resume tweening
///@return			{bool} Succesful?
function TweenResume(_id = id, _var = noone){
	// Error check
	if (!is_string(_var) and _var != noone) show_debug_message("TWEEN ERROR: TweenResume() not possible - variable provided is not in string format!");
	else if !instance_exists(_id) show_debug_message("TWEEN ERROR: TweenResume()  not possible - instance provided doesn't exist!");
	else
	{
		// Check if the variable is an array
		var _index = -1;		// Used if variable is array, if not then set the index to -1 for later checks
		var _array_return = TweenCheckArray(_var, _id, false);
		if is_array(_array_return)
		{
			_var = _array_return[0];
			_index = _array_return[1];
		}
	
		// Actual resume of the tweening (search through the tweeners array)
		with (obj_TweenManager)
		{
			for (var i = array_length(tweeners) - 1; i >= 0; i--)	// loop through all tweens
			{
				var _tweener = tweeners[i];
				if (_id == _tweener.who)	// id and var found
				{
					if (_var == noone or (_var == _tweener.what and _tweener.arr_index == _index))	// applied to all vars or specific variable
					{
						_tweener.paused = false;	// resume the specific tween
						if (_var != noone) return true;		// if finding only a specific variable, then done
					}
				}
			}
			if (_var != noone) return false;
			return true;
		}
	}
}



///@func TweenCreateData(start_value, end_value, dur, type, offset)
///@desc Returns the array filled with y-points of the tween. Needs a start/end y-values ('min' and 'max') + duration (overall) of the tween in steps (x-length). 
///@desc Limited to the length of 101 values (TweenManager takes care of re-calculating the next 101-value window during tweening when needed - preserving memory and speeding up initial start).
///@arg	start_value		{real}		start point value for the whole tween
///@arg	end_value		{real}		end point value (end of the whole tween)
///@arg	dur				{real}		duration (whole tween)
///@arg	type			{TWEENTYPE}	tween type (enum)
///@arg	offset			{bool}		At which point in the tween index step to start the calculation. Used when concatenating the calculated arrays (if array too long).
///@return				{array}		Array of calculated values
function TweenCreateData(_start_value, _end_value, _duration, _type, _offset = 0){
	if (_offset >= _duration) show_debug_message("TWEEN ERROR: Tween data creation can't be done - offset >= duration.")
	var _max_index = min(100, _duration - _offset)
	var _array = array_create(_max_index);
	for (var i = _max_index; i >= 0; i--)
	{
		_array[i] = TweenCalculate(i + _offset, _start_value, _end_value - _start_value, _duration, _type);
	}
	return _array;
}



///@func TweenCalculate(time, start, change, dur, shape)
///@desc Calculates one of the points of the tween (current y) according to the algorithm. The core of the system which implements the math function.
///@arg	time	{real}		x, current
///@arg	start	{real}		y0
///@arg	change	{real}		y1-y0
///@arg	dur		{real}		x1-x0
///@arg	shape	{TWEENTYPE}	tween type
///@return		{real}		Calculated value.
function TweenCalculate(_time, _start, _change, _duration, _shape){
	switch (_shape)
	{
		case TWEENTYPE.BACK_IN:
		var _val = _time/_duration;
		return _start + _change*sqr(_val)*(2.70158*_val - 1.70158);
		break;
		
		case TWEENTYPE.BACK_INOUT:
		var _val = 2*_time/_duration;

		if (_val < 1) return _start + _change*0.5*((3.5949095*_val - 2.5949095)*sqr(_val));

		_val -= 2;
		return _start + _change*0.5*((3.5949095*_val + 2.5949095)*sqr(_val) + 2);
		break;
		
		case TWEENTYPE.BACK_OUT:
		var _val = _time/_duration - 1;
		return _start + _change*(sqr(_val)*(2.70158*_val + 1.70158) + 1);
		break;
		
		case TWEENTYPE.BOUNCE_IN:
		return _change + _start - TweenCalculate(_duration - _time, 0, _change, _duration, TWEENTYPE.BOUNCE_OUT);
		break;
		
		case TWEENTYPE.BOUNCE_INOUT:
		if (_time < _duration*0.5) return _start + 0.5*TweenCalculate(_time*2, 0, _change, _duration, TWEENTYPE.BOUNCE_IN);

		return  _change*0.5 + _start + 0.5*TweenCalculate(_time*2 - _duration, 0, _change, _duration, TWEENTYPE.BOUNCE_OUT);
		break;
		
		case TWEENTYPE.BOUNCE_OUT:
		var _val = _time/_duration;

		if (_val < 1/2.75) return _start + _change*7.5625*sqr(_val);
		else if (_val < 2/2.75)
		{
			_val -= 1.5/2.75;
			return _start + _change*(7.5625*sqr(_val) + 0.75);
		}
		else if (_val < 2.5/2.75)
		{
			_val -= 2.25/2.75;
			return _start + _change*(7.5625*sqr(_val) + 0.9375);
		}
		else
		{
			_val -= 2.625/2.75;
			return _start + _change*(7.5625*sqr(_val) + 0.984375);
		}
		break;
		
		case TWEENTYPE.CIRC_IN:
		return _start + _change * (1 - sqrt(1 - sqr(_time/_duration)));
		break;
		
		case TWEENTYPE.CIRC_INOUT:
		var _val = 2*_time/_duration;
		if (_val < 1) return _start + _change*0.5*(1 - sqrt(abs(1 - sqr(_val))));

		_val -= 2;
		return _start + _change*0.5*(sqrt(abs(1 - sqr(_val))) + 1);
		break;
		
		case TWEENTYPE.CIRC_OUT:
		return _start + _change*sqrt(abs(1 - sqr(_time/_duration - 1)));
		break;
		
		case TWEENTYPE.CUBIC_IN:
		return _start + _change * power(_time/_duration, 3);
		break;
		
		case TWEENTYPE.CUBIC_INOUT:
		var _val = 2*_time/_duration;

		if (_val < 1) return _start + _change*0.5*power(_val, 3);

		return _start + _change*0.5*(power(_val - 2, 3) + 2);
		break;
		
		case TWEENTYPE.CUBIC_OUT:
		return _start + _change*(1 + power(_time/_duration - 1, 3));
		break;
		
		case TWEENTYPE.ELASTIC_IN:
		var _val = _time/_duration;

		if (_time == 0 or _change == 0) return _start;

		if (_val == 1) return _start + _change;

		return _start - _change*power(2,10*(--_val))*sin((_val*_duration - _duration*0.3*0.25)*(2*pi)/(_duration*0.3));
		break;
		
		case TWEENTYPE.ELASTIC_INOUT:
		var _val = 2*_time/_duration;

		if (_time == 0 or _change == 0) return _start;

		if (_val == 2) return _start + _change;

		if (_val < 1) return _start - 0.5*(_change*power(2, 10 * (--_val)) * sin((_val * _duration - _duration*0.3*1.5*0.25) * (2*pi)/(_duration*0.3*1.5)));

		return _start + _change*(1 + power(2, -10*(--_val))*0.5*sin((_val*_duration - _duration*0.3*1.5*0.25) * (2*pi)/(_duration*0.3*1.5)));
		break;
		
		case TWEENTYPE.ELASTIC_OUT:
		var _val = _time/_duration;

		if (_time == 0 or _change == 0) return _start;

		if (_val == 1) return _start + _change;

		return _start + _change(1 + power(2, -10*_val)*sin((_val*_duration - _duration*0.3*0.25)*(2*pi)/(_duration*0.3)));
		break;
		
		case TWEENTYPE.EXPO_IN:
		return _start + _change*power(2, 10*(_time/_duration - 1));
		break;
		
		case TWEENTYPE.EXPO_INOUT:
		var _val = 2 * _time / _duration;

		if (_val < 1) return _start + _change*0.5*power(2, 10 *(--_val));

		return _start + _change*0.5*(2 - power(2, -10 *(--_val)));
		break;
		
		case TWEENTYPE.EXPO_OUT:
		return _start + _change*(1 - power(2, -10*_time/_duration));
		break;
		
		case TWEENTYPE.QUAD_IN:
		return _start + _change*sqr(_time/_duration);  
		break;
		
		case TWEENTYPE.QUAD_INOUT:
		var _val = 2*_time/_duration;

		if (_val < 1) return _start + _change*0.5*sqr(_val);

		return _start - 0.5*_change*((_val - 1)*(_val - 3) - 1);
		break;
		
		case TWEENTYPE.QUAD_OUT:
		var _val = _time/_duration;
		return _start - _change*_val*(_val - 2);
		break;
		
		case TWEENTYPE.QUART_IN:
		return _start + _change * power(_time/_duration, 4);
		break;
		
		case TWEENTYPE.QUART_INOUT:
		var _val = 2* _time/_duration;

		if (_val < 1) return _start + _change*0.5*power(_val, 4);

		return _start - _change*0.5*(power(_val - 2, 4) - 2);
		break;
		
		case TWEENTYPE.QUART_OUT:
		return _start -_change*(power(_time/_duration - 1, 4) - 1);
		break;
		
		case TWEENTYPE.QUINT_IN:
		return _start + _change*power(_time/_duration, 5);
		break;
		
		case TWEENTYPE.QUINT_INOUT:
		var _val = 2*_time/_duration;
		if (_val < 1) return _start + _change*0.5*power(_val, 5);
		return _start + _change*0.5*(power(_val - 2, 5) + 2);
		break;
		
		case TWEENTYPE.QUINT_OUT:
		return _start + _change*(power(_time/_duration - 1, 5) + 1);
		break;
		
		case TWEENTYPE.SINE_IN:
		return _start + _change*(1 - cos(_time*pi/(_duration*2)));
		break;
		
		case TWEENTYPE.SINE_INOUT:
		return _start + _change*0.5*(1 - cos(pi*_time/_duration));
		break;
		
		case TWEENTYPE.SINE_OUT:
		return _start + _change*sin(_time*pi/(_duration*2));
		break;
		
		case TWEENTYPE.LINEAR:
		return _start + _time*_change/_duration;
		break;
	}
}