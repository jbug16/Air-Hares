if (alarm[0] < 0 && !wait_tutorial_choice) exit;

// Init and bg
draw_set_color(c_black);
draw_set_font(fnt_Federo37);
draw_set_alpha(1);
draw_rectangle(-1 , -1, room_width + 1, room_height + 1, false);
	
// Top part
draw_set_halign(fa_left);
draw_set_valign(fa_middle);
draw_set_color(c_white);
draw_set_alpha(image_alpha);
var _spacing = 0.5 * sprite_get_width(spr_PlayerIcon);
var _posY = room_height * 0.3;
// Center the full row (level digits + txt) on x; sprite origins are middle-center.
var _sub_w = global.current_level div 4;
var _sub_m = global.current_level mod 4;
var _w_first = sprite_get_width(spr_LevelNumbers) * scale_num;
var _w_mid = sprite_get_width(spr_LevelNumbersSpecial) * scale_num;
var _w_last = (_sub_m == 3)
	? sprite_get_width(spr_LevelNumbersSpecial) * scale_num
	: sprite_get_width(spr_LevelNumbers) * scale_num;
var _tw = string_width(txt);
var _row_left_at_origin = min(
	-_w_first * 0.5,
	_spacing - _w_mid * 0.5,
	2 * _spacing - _w_last * 0.5,
	3 * _spacing
);
var _row_right_at_origin = max(
	_w_first * 0.5,
	_spacing + _w_mid * 0.5,
	2 * _spacing + _w_last * 0.5,
	3 * _spacing + _tw
);
var _posX = x - (_row_left_at_origin + _row_right_at_origin) * 0.5;

if(global.demo)
{
	draw_sprite_ext(spr_LevelNumbers, global.current_level div 4, _posX, _posY, scale_num,scale_num,0,c_white, image_alpha);
	draw_sprite_ext(spr_LevelNumbersSpecial, 0, _posX + _spacing, _posY, scale_num,scale_num,0,c_white, image_alpha);
	if (global.current_level mod 4 == 3)	// boss level or not
		draw_sprite_ext(spr_LevelNumbersSpecial, 1, _posX + 2*_spacing, _posY, scale_num,scale_num, 0, c_white, image_alpha);
	else draw_sprite_ext(spr_LevelNumbers, global.current_level mod 4, _posX + 2*_spacing, 
		_posY, scale_num, scale_num, 0, c_white, image_alpha);
	draw_text(_posX + 3*_spacing , _posY, txt);
}
else
{
	draw_sprite_ext(spr_LevelNumbers, global.current_level div 4, _posX, _posY, scale_num,scale_num,0,c_white, image_alpha);
	draw_sprite_ext(spr_LevelNumbersSpecial, 0, _posX + _spacing, _posY, scale_num,scale_num,0,c_white, image_alpha);
	if (global.current_level mod 4 == 3)	// boss level or not
		draw_sprite_ext(spr_LevelNumbersSpecial, 1, _posX + 2*_spacing, _posY, scale_num,scale_num, 0, c_white, image_alpha);
	else draw_sprite_ext(spr_LevelNumbers, global.current_level mod 4, _posX + 2*_spacing, 
		_posY, scale_num, scale_num, 0, c_white, image_alpha);
	draw_text(_posX + 3*_spacing , _posY, txt);
}
	
// Mid part: only in story mode (lives hidden during post-tutorial peaceful intro farm)
if (global.game_mode == GAMEMODE.STORY && !StoryPeacefulIntroFarmActive())
{
	draw_sprite_ext(spr_PlayerIcon, 0, x - sprite_get_width(spr_PlayerIcon), y, 0.6,0.6,0,c_white, image_alpha);
	draw_text(x, y, "X");
	draw_sprite_ext(spr_LevelNumbers, max(0, global.lives - 1), x + sprite_get_width(spr_PlayerIcon), y, scale_num,scale_num,
		0, c_white, image_alpha);
}

DrawReset();