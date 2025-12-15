/// @desc Add water/cloud

// Collect cloud based on cloud_value
audio_play_sound(snd_CarrotPickup, 1, false);
obj_GUICloudCounter.cloud_current += cloud_value;
other.shoot_ammo_water = min(other.shoot_ammo_water + 1, GetAmmo());

// create disperse clouds
for (var i=0; i < cloud_disperse; i+=1)
{
	var _disperse = instance_create_depth(x, y, depth, obj_PropCloudSpecialDisperse);
	_disperse.direction = irandom(90) + (i * (360/cloud_disperse));
}

instance_destroy();