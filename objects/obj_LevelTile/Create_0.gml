///@desc

// Inherit the parent event
image_speed = 0;
vspeed = global.speed_parallax;

// Pick the sprite / index according to level
image_index = global.current_level div 4;
if (room == rm_LevelX1Farm)
{
	if (instance_number(object_index) == 1) sprite_index = spr_LevelTileStart;		// start of level?
	else if (obj_ControllerPAR.state == LVLFARM.SHRINE_END) sprite_index = spr_LevelTileEnd;	// end level tile?
	else if (obj_ControllerPAR.state == LVLFARM.POND1_SPAWN or obj_ControllerPAR.state == LVLFARM.POND2_SPAWN) sprite_index = spr_BgPond;
	else	// normal tile (can be shot at)
	{
		var _spr = [spr_BgBarren, spr_BgBudding, spr_BgBusting, spr_BgBooming];
		sprite_index = _spr[global.current_level div 4];
		image_index = irandom(image_number - 1);
		y -= sprite_height;
	}
	
	vspeed *= 0.5;
	image_xscale *= choose(-1,1);
}
else	// boss level tiles
{
	sprite_index = spr_BgCombat;
	y -= sprite_height;
}