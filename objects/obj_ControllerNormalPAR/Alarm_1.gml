///@desc Cloud spawn

var _x_pos = irandom(1280);
var _y_pos = cloud_special_anchor_y;
var _cloud = instance_create_layer(_x_pos, _y_pos, "Middle", obj_PropCloudSpecial);
if random(1) < 0.1 {	// large
	_cloud.sprite_index = cloud_sprite[2];
	_cloud.cloud_value = 3;
	_cloud.cloud_disperse = 12;
} else if (random(1) < 0.66) {	// small
	_cloud.sprite_index = cloud_sprite[0];
	_cloud.cloud_value = 1;
	_cloud.cloud_disperse = 4;
} else {	// medium
	_cloud.sprite_index = cloud_sprite[1];
	_cloud.cloud_value = 2;
	_cloud.cloud_disperse = 8;
}
_cloud.z = 0;
_cloud.vsp = 2 + random(1);	

alarm[1] = irandom_range(0.6*cloud_interval, cloud_interval);