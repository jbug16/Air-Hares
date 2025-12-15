/// @desc
var _x_pos = DepthGetPositionX(x,z);
//if instance_exists(obj_EndShrine) _x_pos = x;
var _y_pos = DepthGetPositionY(y,z)
if instance_exists(obj_EndShrine) 
{
	_x_pos = x;
	_y_pos = y;
}
var _scaling = DepthGetScale(z)

draw_sprite_ext(sprite_index, image_index, _x_pos, _y_pos, _scaling, _scaling, image_angle, c_white, 1);