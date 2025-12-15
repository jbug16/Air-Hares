speed = 6;

// boss levels use different clouds
if (global.current_level == 3) sprite_index = spr_PropCloudDaySmall;
else if (global.current_level == 7) sprite_index = spr_PropCloudDuskSmall;
else if (global.current_level == 11) sprite_index = spr_PropCloudNightSmall;
else if (global.current_level == 15) sprite_index = spr_PropCloudDawnSmall;
else	// non-boss level
{
	// Create black shadow on ground
	var _ground_shadow = instance_create_layer(x, y, "Ground", obj_ShadowGround);
	_ground_shadow.master = id;
}