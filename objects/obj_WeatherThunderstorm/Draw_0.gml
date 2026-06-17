/// @desc 
// Draw a darker area for the level
draw_set_color(c_black);
if(instance_exists(obj_ControllerFightBoss4_3)) draw_set_alpha(dark_alpha);
else draw_set_alpha(0.4);
draw_rectangle(-5, -5, room_width + 5, room_height + 5, false);
draw_set_alpha(1);

// Lightning
if (lightning_alpha > 0) 
{
	lightning_alpha -= 0.025;
	draw_set_color(c_white);
	gpu_set_blendmode(bm_add);
	draw_set_alpha(lightning_alpha);
	draw_rectangle(-5, -5, room_width + 5, room_height + 5, false);
	gpu_set_blendmode(bm_normal);
	draw_set_alpha(1);
}
else if (lightning_phase == "FLASH")
{
	lightning_phase = "DELAY";
	alarm[2] = 0.8*GAMESPD;
}
else if (lightning_phase == "LIGHTNING") draw_self();

// Flashing caution marker on the plane before lightning strikes
if ((lightning_phase == "FLASH" or lightning_phase == "DELAY") and instance_exists(obj_PlayerPAR)) {
	if (caution_flash_counter > 0) {
		caution_flash_counter--;
	} else {
		caution_flash_counter = caution_flash_interval;
		caution_flash_on = !caution_flash_on;
	}
	if (caution_flash_on) {
		draw_sprite_ext(spr_Caution, 0, obj_PlayerPAR.x, obj_PlayerPAR.y + caution_y_offset, caution_scale, caution_scale, 0, c_white, 1);
	}
}