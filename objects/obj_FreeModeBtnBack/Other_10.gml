/// @desc

// Inherit the parent event
event_inherited();

if (global.arcade_popup_screen == 1) {
	global.arcade_popup_screen = 0;
	global.arcade_new_initials = "";
	with (obj_FreeModeBtnPlay) text = "PLAY";
	ArcadePopupFocusPlayButton();
	exit;
}

with(obj_FreeModeSelect){
	is_disabled = false;
	alarm[0] = 2;
}
instance_destroy(obj_FreeModeFrame);
while(instance_exists(obj_ModesBtnPAR)) instance_destroy(obj_ModesBtnPAR);
