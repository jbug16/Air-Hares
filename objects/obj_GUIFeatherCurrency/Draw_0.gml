/// @desc
draw_self();

// Draw number of feather
var _feather = 0;
_feather += global.currency_feather_black;
_feather += global.currency_feather_blue;
_feather += global.currency_feather_brown;
_feather += global.currency_feather_purple;
_feather += global.currency_feather_twinhorn;
DrawText2(x - 32, y, string(round(_feather)), fa_right, fa_middle, c_white, fnt_Federo24);