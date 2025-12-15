/// @desc
if !focus {
	var _self_id = id;
	with(obj_TitlebBtnGeneralPAR){
		if id == _self_id continue;
		event_perform(ev_mouse, ev_mouse_leave);
	}
	audio_play_sound(snd_ProjSeedShot, 1, false);
	focus = true;

	TweenStart("image_xscale", image_xscale, 1.5, 0.5*GAMESPD, TWEENTYPE.CIRC_OUT);
	TweenStart("image_yscale", image_xscale, 1.5, 0.5*GAMESPD, TWEENTYPE.CIRC_OUT);
	
	
	color = c_orange;
}