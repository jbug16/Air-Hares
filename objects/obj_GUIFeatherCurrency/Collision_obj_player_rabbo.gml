/// @desc On collision, add to collected cloud.
instance_destroy();
var _angle_start = irandom(90);
for(var i=0; i<4; i+=1){
	var _disperse = instance_create_depth(x, y, depth, obj_prop_cloud_special_disperse);
	_disperse.launch_angle = _angle_start + (i * 90);
}