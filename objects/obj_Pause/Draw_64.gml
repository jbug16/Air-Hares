/// @desc Controller-disconnect prompt (screen-space so it is camera-independent)

if (!global.controller_reconnect_wait) exit;

var _gw = display_get_gui_width();
var _gh = display_get_gui_height();

DrawText2(_gw * 0.5, _gh * 0.5 - 28, "CONTROLLER DISCONNECTED", fa_center, fa_middle, c_white, fnt_Federo37);
DrawText2(_gw * 0.5, _gh * 0.5 + 28, "Please reconnect a controller", fa_center, fa_middle, c_white, fnt_Federo30);

// Reset draw state so we don't leak alignment/colour into other GUI draws.
draw_set_halign(fa_left);
draw_set_valign(fa_top);
draw_set_color(c_white);
