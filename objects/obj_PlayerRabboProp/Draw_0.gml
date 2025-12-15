/// @desc
draw_self();

// Draw invincibility
if hp_invincibility > 0 {
	if flashing_counter > 0 {
		flashing_counter -= 1
	} else {
		flashing_counter = flashing_interval;
		flashing = !flashing;
	}
	if flashing {
		gpu_set_blendmode(bm_one);
		draw_sprite_ext(sprite_index, image_index, x, y, image_xscale, image_yscale, 0, c_white, 1);
		gpu_set_blendmode(bm_normal);
	}
}

// Draw effects
if paralysis_counter > 0 {
	draw_sprite(spr_EffectParalysis, image_index, x, y);	
}
if confusion_counter > 0 {
	draw_sprite(spr_EffectConfusion, image_index, x, y);	
}