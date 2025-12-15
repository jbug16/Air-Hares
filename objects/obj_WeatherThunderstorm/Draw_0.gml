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