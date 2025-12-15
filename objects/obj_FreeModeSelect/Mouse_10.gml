if(mouse_x == mouse_prev_x and mouse_y == mouse_prev_y) exit;
if(global.mouse_disable) exit;

if (!is_disabled) 
{
	with(obj_FreeModeSelect)	//unhover other buttons
	{ 
		if (id != other.id) 
			if(instance_exists(obj_FreeModeController) and obj_FreeModeController.selected == tgt_level)
				event_user(2);
	}
	if(instance_exists(obj_FreeModeController)) obj_FreeModeController.selected = tgt_level; //navigate from this level
	audio_play_sound(snd_ProjSeedShot, 1, false);
	focus = true;
	
	// scale
	TweenStart("image_xscale", scale_normal, scale_big, 0.5*GAMESPD, TWEENTYPE.CIRC_OUT);
	TweenStart("image_yscale", scale_normal, scale_big, 0.5*GAMESPD, TWEENTYPE.CIRC_OUT);
}
