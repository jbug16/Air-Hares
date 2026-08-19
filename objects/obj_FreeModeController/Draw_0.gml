/// @desc Empty arcade state — no story progress yet (matches obj_StoryModeFrame layout)
if (!show_empty_message) exit;

var _msg = "Play Story Mode to Unlock Levels";
var _cx = room_width * 0.5;
var _cy = room_height * 0.5;

// Same frame scale as obj_StoryModeFrame / obj_FreeModeFrame (tweened to 1.8 in Create).
shader_set(sh_Grayscale);
draw_sprite_ext(spr_TitleSelectionFrame, 0, _cx, _cy, image_xscale, image_yscale, 0, c_white, 1);
shader_reset();

// Same text scale as obj_StoryModeFrame Draw.
var _scale_x = image_xscale / 2;
var _scale_y = image_yscale / 2;
draw_set_font(fnt_Federo24);
draw_set_halign(fa_center);
draw_set_valign(fa_middle);
draw_set_color(c_white);
draw_text_transformed(_cx, _cy+5, _msg, _scale_x, _scale_y, 0);
