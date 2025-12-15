/// @desc
image_speed = 0;
visible = false;
can_damage = false;
delay = 60;

/// @func delay_set(delay)
/// @param	delay
delay_set = function(_delay){
	if delay > 0 {
		delay = _delay;
		return true;
	}
	return false;
}
