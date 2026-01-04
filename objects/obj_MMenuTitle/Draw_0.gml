// AIR-HARES title
if (obj_TitlebBtnGeneralPAR.mode_on) shader_set(sh_Grayscale);
draw_self();
shader_reset();

// copyright text
draw_set_color(c_white);
draw_set_font(fnt_Federo37);
draw_set_halign(fa_center);
draw_set_valign(fa_middle);
draw_text_transformed(x, 0.95*room_height, "WONDORO 2026 ©", 0.4, 0.4, 0);

// white fade-in
draw_set_alpha(fade_alpha);
draw_rectangle(0, 0, room_width, room_height, false);
draw_set_alpha(1);


// Game version
draw_set_halign(fa_right);
draw_text_transformed(0.95*room_width, 0.97*room_height, global.version, 0.4, 0.4, 0);

DrawReset();