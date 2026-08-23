///Keep the GUI layer matched to the window size, but ONLY when it actually changes
///(e.g. docking / undocking). This used to run every frame and, when docked (window
///1920x1080 != 1280x720 application surface), it reallocated the GUI surface twice per
///frame - a constant cost present in every room ("low FPS from the Main Menu onwards").
var _ww = window_get_width();
var _wh = window_get_height();
if (_ww != gui_last_w || _wh != gui_last_h)
{
	display_set_gui_size(_ww, _wh);
	display_set_gui_maximise();
	gui_last_w = _ww;
	gui_last_h = _wh;
}

