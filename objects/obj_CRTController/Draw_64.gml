///Ensure GUI layer is the correct size, same as the application surface.
display_set_gui_size(surface_width, surface_height);

///Check if the CRT shader is enabled and apply the effect to the application surface.
////if (crt_shader_enabled) { _scr_CRT_appy_to_surface(application_surface, view_camera[0]); }	
////  else draw_surface(application_surface, 0,0);

///Reset GUI layer back to the window size so we can draw text, etc.
display_set_gui_size(window_get_width(), window_get_height());
display_set_gui_maximise();
