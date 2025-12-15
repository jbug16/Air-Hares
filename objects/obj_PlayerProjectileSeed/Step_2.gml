if instance_exists(obj_EndShrine)
{
	var _pos_y = obj_EndShrine.y - pos_y;
	target_y += min(global.speed_parallax, _pos_y);
}