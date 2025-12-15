/// @desc Flash and trail
var _c_sel = alive mod 4;
switch(_c_sel) {
	case 0:
		color = c_yellow;
		break;
	case 1:
		color = c_green;
		break;
	case 2:
		color = c_teal;
		break;
	case 3:
		color = c_fuchsia;
		break;
}
draw_sprite_ext(sprite_index, image_index, x, y, image_xscale, image_yscale, image_angle, color, image_alpha);