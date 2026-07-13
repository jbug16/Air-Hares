if (TitleMainIsSocialButtonId(button_id) && !TitleMainSocialLinksEnabled()) exit;

// Basic setup
if (draw_get_font() != fnt_Federo37) draw_set_font(fnt_Federo37);
if (draw_get_halign() != fa_center) draw_set_halign(fa_center);
if (draw_get_valign() != fa_middle) draw_set_valign(fa_middle);

// The selected button is indicated by its scale-up tween; the old blurred glow/shadow
// halo was removed - it was a per-frame full-screen Gaussian blur (a big FPS cost) and
// it misaligned on buttons that slide/scale in, showing a garbled offset shadow.
draw_set_color(c_white);
draw_text_transformed(x, y, text, image_xscale, image_yscale, image_angle);
