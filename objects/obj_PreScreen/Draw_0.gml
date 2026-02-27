if (alarm[0] < 0) exit;

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
var _posX = x - 2*sprite_get_width(spr_PlayerIcon);
var _posY = room_height*0.3;
var _spacing = 0.5*sprite_get_width(spr_PlayerIcon);


if(global.demo)
{
	draw_sprite_ext(spr_LevelNumbers, global.current_level div 4, _posX, _posY, scale_num,scale_num,0,c_white, image_alpha);
}
else draw_sprite_ext(spr_LevelNumbers, global.current_level div 4, _posX, _posY, scale_num,scale_num,0,c_white, image_alpha);
draw_sprite_ext(spr_LevelNumbersSpecial, 0, _posX + _spacing, _posY, scale_num,scale_num,0,c_white, image_alpha);

if(global.demo)
{
	if (global.current_level mod 4 == 3)	// boss level or not
		draw_sprite_ext(spr_LevelNumbersSpecial, 1, _posX + 2*_spacing, _posY, scale_num,scale_num, 0, c_white, image_alpha);
	else draw_sprite_ext(spr_LevelNumbers, global.current_level mod 4, _posX + 2*_spacing, 
		room_height*0.3, scale_num, scale_num, 0, c_white, image_alpha);
}
else
{
	if (global.current_level mod 4 == 3)	// boss level or not
		draw_sprite_ext(spr_LevelNumbersSpecial, 1, _posX + 2*_spacing, _posY, scale_num,scale_num, 0, c_white, image_alpha);
	else draw_sprite_ext(spr_LevelNumbers, global.current_level mod 4, _posX + 2*_spacing, 
		room_height*0.3, scale_num, scale_num, 0, c_white, image_alpha);
}
draw_text(_posX + 3*_spacing , _posY, txt);
	
// Mid part: only in story mode
if (global.game_mode == GAMEMODE.STORY)
{
	draw_sprite_ext(spr_PlayerIcon, 0, x - sprite_get_width(spr_PlayerIcon), y, 0.6,0.6,0,c_white, image_alpha);
	draw_text(x, y, "X");
	draw_sprite_ext(spr_LevelNumbers, max(0, global.lives - 1), x + sprite_get_width(spr_PlayerIcon), y, scale_num,scale_num,
		0, c_white, image_alpha);
}




DrawReset();