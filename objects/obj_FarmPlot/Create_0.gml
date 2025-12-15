/// @desc
// Depth
vsp = 1;
z = 100;
scaling = DepthGetScale(z);

state = PLOTSTATE.EMPTY;
targeted = [];			// who targeted the plot?: [], [PLAYER.PLAYER1, PLAYER.PLAYER2]

// Sprite index to use
var _spr = [spr_CropBarren, spr_CropBudding, spr_CropBustling, spr_CropBooming];
sprite_index = _spr[global.current_level div 4];

// Image index to use
sprite_num = array_create(PLOTSTATE.len, 0);
sprite_num[PLOTSTATE.SEEDED] = 1;
sprite_num[PLOTSTATE.WATERED] = 2;
sprite_num[PLOTSTATE.BARREN_WATERED] = 2;
sprite_num[PLOTSTATE.CARROT_OLD] = 3;
sprite_num[PLOTSTATE.CARROT_FRESH] = 4;