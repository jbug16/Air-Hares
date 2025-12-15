///@desc Spawn next BG
if (!position_meeting(0, 0, object_index)) 
{
	var _bg_nearest = instance_nearest(0, 0, object_index);	
	with (instance_create_layer(0.5*room_width, -room_height+5, "Ground_Tile", object_index)) y += _bg_nearest.y;
}