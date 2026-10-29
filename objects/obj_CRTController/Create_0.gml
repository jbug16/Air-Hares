draw_set_color(c_white);
show_debug_overlay(false);

///Setting up the cameras view of the world.
view_camera[0] = camera_create();
camera_set_view_size(view_camera[0], 1280, 720); //See common resolution sizes above.

view_visible[0] = true;
view_enabled = true;
view_wport[0] = 1280;
view_hport[0] = 720;
OptionsDisplayApply();
// The game is drawn at 1280x720. Leaving the application surface at the
// window size scales that image twice and the text goes soft.
surface_resize(application_surface, 1280, 720);

///_xx and _yy variables are used to move the views position around.
///Just for demonstration purposes, can be removed.
_xx = 0;
_yy = 0;

///Track the window size so the GUI layer is only re-sized when it actually changes
///(e.g. dock/undock), instead of every frame - see Draw GUI.
gui_last_w = -1;
gui_last_h = -1;