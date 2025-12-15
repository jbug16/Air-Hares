draw_set_color(c_white);
show_debug_overlay(false);

///MUST!!! disable automatic drawing of the application surface.
///It will be manually drawn too in the Draw GUI event with the CRT shader applied.
///If you're drawing everything to your own surface then this should already be disabled.

/////application_surface_draw_enable(false);

///Setting up the cameras view of the world.
view_camera[0] = camera_create();
camera_set_view_size(view_camera[0], 1280, 720); //See common resolution sizes above.

view_visible[0] = true;
view_enabled = true;
view_wport[0] = 1280;
view_hport[0] = 720;
window_set_size(view_wport[0], view_hport[0]);

///_xx and _yy variables are used to move the views position around.
///Just for demonstration purposes, can be removed.
_xx = 0;
_yy = 0;

///Variable for enabling/disabling the CRT effect.
///Just for demonstration purposes, can be removed.
crt_shader_enabled = true;
crt_gui_bezel_enabled = false;

///Setup the CRT shaders variables and shader uniforms
//CRTInitShader(view_camera[0], false, 0.12, true, false, true, 0.03, 80.0, 1.0, false, 0);
CRTInitShader(view_camera[0], false, 0.12, true, true, false, 0.04, 80, 1.0, false, 0);