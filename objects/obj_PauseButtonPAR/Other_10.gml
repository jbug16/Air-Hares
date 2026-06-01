/// @desc Focus - mouse disabled

if !focus {
	// On any other
	with(obj_PauseButtonPAR){
		event_perform(ev_mouse, ev_mouse_leave);	
	}
	
	audio_play_sound(snd_ProjSeedShot, 1, false);
	focus = true;
	if (object_index == obj_PauseButtonResume)obj_ControllerPause.menu_selected = 0;
	if (object_index == obj_PauseButtonMMenu)obj_ControllerPause.menu_selected = 1;
	if (object_index == obj_PauseButtonExit)obj_ControllerPause.menu_selected = 2;
	
	//scale
	TweenStart("image_xscale", image_xscale, 1.5, 0.5*GAMESPD, TWEENTYPE.CIRC_OUT);
	TweenStart("image_yscale", image_yscale, 1.5, 0.5*GAMESPD, TWEENTYPE.CIRC_OUT);
	
	color = c_orange;
}