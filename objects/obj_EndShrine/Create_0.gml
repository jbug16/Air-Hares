// position, scaling, if passed the shrine
y -= sprite_height;	// move to top of screen
event_inherited();

//y_pos = -0.5*sprite_height;
flash_len = 0.3*GAMESPD;

targeted = [];	// which player(s) targeted the shrine

// Propeller rotation
propeller_angle = 0; // angle to draw
propeller_spd = 1;	 // how much rotation to add
max_spd = 20;		 // max propeller speed

// sprites and hit boxes
sprite_index = spr_EndShrineBarren;
mask_index = spr_EndShrineBarrenHit;
water_hit_sprite = spr_EndShrineBarrenWaterHit;
propeller_sprite = spr_BarrenPropeller;
if (global.overworld_progress == PLOTSTATE.BOOMING) 
{
	water_hit_sprite = spr_EndShrineBoomingWaterHit;
	sprite_index = spr_EndShrineBooming;
	mask_index = spr_EndShrineBoomingHit;
	propeller_sprite = spr_BoomingPropeller;
}
else if (global.overworld_progress == PLOTSTATE.BUDDING) 
{
	water_hit_sprite = spr_EndShrineBuddingWaterHit;
	sprite_index = spr_EndShrineBudding;
	mask_index = spr_EndShrineBuddingHit;
	propeller_sprite = spr_BuddingPropeller;
}
else if (global.overworld_progress == PLOTSTATE.BUSTING) 
{
	water_hit_sprite = spr_EndShrineBustlingWaterHit;
	sprite_index = spr_EndShrineBustling;
	mask_index = spr_EndShrineBustlingHit;
	propeller_sprite = spr_BustingPropeller;
}

with(obj_FarmPlot) targeted = [];