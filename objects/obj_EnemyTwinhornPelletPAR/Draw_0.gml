/// @desc

if(!countered)
{
	var _x_pos = DepthGetPositionX(x, z);
	var _y_pos = DepthGetPositionY(y, z);

	draw_sprite_ext(sprite_index, image_index, _x_pos, _y_pos, scaling, scaling, image_angle, c_white, 1);
}
else
{
	var _x_pos = DepthGetPositionX(x, z);
	var _y_pos = DepthGetPositionY(y, z);
	if instance_exists(obj_EndShrine) 
	{
		_x_pos = x;
		_y_pos = y;
	}

	scaling = DepthGetScale(z);
	draw_sprite_ext(sprite_index, image_index, _x_pos, _y_pos, scaling, scaling, image_angle, c_white, 1);
}