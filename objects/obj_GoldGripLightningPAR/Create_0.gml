/// @desc
image_speed = 0;
visible = false;
can_damage = false;
delay = 60;

caution_flash_on = true;
caution_flash_interval = 8;
caution_flash_counter = caution_flash_interval;
caution_scale = 0.35;
caution_y_offset = -96;

/// @func delay_set(delay)
/// @param	delay
delay_set = function(_delay){
	if delay > 0 {
		delay = _delay;
		caution_flash_on = true;
		caution_flash_counter = caution_flash_interval;
		return true;
	}
	return false;
}
