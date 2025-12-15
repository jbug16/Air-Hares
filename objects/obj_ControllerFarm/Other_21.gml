///@desc Create crops

var _anchor_pos = [room_width/8, -1.5*room_height];
plots = [];



//==========================================================
// Crops
//==========================================================
for (var j = 0; j < 12; j++)		// row (vertical)
{		
	var _shoot_places = [2, 3, 4, 5, 6, 7, 8, 9];	// which spots will you be able shoot at - spots removed from this list
	
	// which level in a stage: 2-3-4 slots to shoot at
	if (j mod 2 == 0)	// odd rows only - have the shooting spots
	{
		var _num = 6;
		if ((global.current_level mod 4) >= 2) _num = 4;
		else if ((global.current_level mod 4) == 1) _num = 5;
		repeat (_num)
		{
			array_delete(_shoot_places, irandom(array_length(_shoot_places)) - 1, 1);
		}
	}
	
	// Crops creation
	for (var i = 0; i < 12; i++)	// column (horizontal)
	{	
		plots[i][j] = instance_create_layer(_anchor_pos[0] + 100*i, _anchor_pos[1] - 100*j, "Ground", obj_FarmPlot);
		with plots[i][j]
		{
			// 2 side plots on each side are dead, and every even row. Otherwise barren (can't be shot at & empty)
			if (i < 2 or i > 9 or (j mod 2 == 0)) state = PLOTSTATE.CARROT_OLD;	
			else state = PLOTSTATE.BARREN;
			
			if ((j mod 2 == 0) and array_contains(_shoot_places, i)) state = PLOTSTATE.EMPTY;	// able to shoot at!
		}
		crops_created++;
	}
}



//==========================================================
// Fence
//==========================================================
// Fence - horizontal
for (var i = 0; i < 12; i += 1) 
{
	instance_create_layer(_anchor_pos[0] + 100*i, _anchor_pos[1] + 100, "Ground", obj_PropFence);	// top
	instance_create_layer(_anchor_pos[0] + 100*i, _anchor_pos[1] - 1200, "Ground", obj_PropFence);	// bottom
}

// Fence - vertical
for (var j = 0; j < 12; j += 1)
{
	// Left
	with (instance_create_layer(_anchor_pos[0] - 100, _anchor_pos[1] - 100*j, "Ground", obj_PropFence)) sprite_index = spr_PropFenceSide;
	// Right
	with (instance_create_layer(_anchor_pos[0] + 1200, _anchor_pos[1] - 100*j, "Ground", obj_PropFence))
	{
		sprite_index = spr_PropFenceSide;
		image_xscale *= -1;	
	}
}	

// Fence - corners
with (instance_create_layer(_anchor_pos[0] -100, _anchor_pos[1] + 100, "Ground", obj_PropFence))	// bot-left
	sprite_index = spr_PropFenceCorner;	
with (instance_create_layer( _anchor_pos[0] -100,  _anchor_pos[1] - 1200, "Ground", obj_PropFence))	// top-left
	sprite_index = spr_PropFenceCorner;	
with (instance_create_layer( _anchor_pos[0] + 1200, _anchor_pos[1] + 100, "Ground", obj_PropFence))	// bot-right
{
	sprite_index = spr_PropFenceCorner;
	image_xscale *= -1;
}
with (instance_create_layer(_anchor_pos[0] + 1200,  _anchor_pos[1] - 1200, "Ground", obj_PropFence))	// top-right
{
	sprite_index = spr_PropFenceCorner;
	image_xscale *= -1;
}