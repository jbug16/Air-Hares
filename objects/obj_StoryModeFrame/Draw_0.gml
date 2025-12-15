// init & frame
draw_self();
draw_set_color(c_white);
draw_set_font(fnt_Federo16);
draw_set_halign(fa_center);
draw_set_valign(fa_middle);

// scaling
var _scale_x = image_xscale/2;
var _scale_y = image_yscale/2;

// Icon
draw_sprite_ext(spr_PlayerIcon, 0, x - 130*image_xscale, y - 5*image_yscale, _scale_x, _scale_y, 0, c_white, 1);
// Level
var _progress_display = min(global.story_mode_progress, 15);
var _txt = global.story_mode_progress >= 16 ? "GAME COMPLETE!" : global.story_mode_level[_progress_display][STORYPROP.NAME];
draw_text_transformed(x , y - 20*image_yscale, _txt, _scale_x, _scale_y, 0);
// lives
draw_text_transformed(x , y, "LIVES: " + string(global.lives), _scale_x, _scale_y, 0);
// Highscore
draw_text_transformed(x , y + 15*image_yscale, "SCORE", _scale_x, _scale_y, 0);