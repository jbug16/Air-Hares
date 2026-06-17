/// @desc
if (visible) {
	draw_self();
} else if (delay > 0) {
	if (caution_flash_counter > 0) {
		caution_flash_counter--;
	} else {
		caution_flash_counter = caution_flash_interval;
		caution_flash_on = !caution_flash_on;
	}
	if (caution_flash_on) {
		var _cx = x;
		var _cy = y;
		if (instance_exists(obj_PlayerPAR)) {
			_cx = obj_PlayerPAR.x;
			_cy = obj_PlayerPAR.y;
		}
		draw_sprite_ext(spr_Caution, 0, _cx, _cy + caution_y_offset, caution_scale, caution_scale, 0, c_white, 1);
	}
}
