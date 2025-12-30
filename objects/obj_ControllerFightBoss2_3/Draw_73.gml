/// @desc Boss Card
if(!boss_card) exit;

draw_set_alpha(image_alpha);

draw_sprite(spr_CardBossCloud, 0, card_x, 0.5*room_height); // cloud bg
draw_sprite(spr_CardBossIcon, 1, card_x, 0.5*room_height); // boss icon
draw_sprite_ext(spr_CardBossName, 1, card_x - 3, 0.5*room_height, 1.5, 1.5, 0, image_blend, image_alpha); // boss name

// Draw subtitle
var _subtitle_y = 0.5*room_height + sprite_get_height(spr_CardBossName)*0.75 + 20;
DrawText2(card_x - 3, _subtitle_y, "Muscular Menace", fa_center, fa_middle, c_white, fnt_Federo30);

draw_set_alpha(1);