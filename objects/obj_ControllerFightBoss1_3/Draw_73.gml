/// @desc Boss Card
if(!boss_card) exit;

draw_set_alpha(image_alpha);

draw_sprite(spr_CardBossCloud, 0, card_x, 0.5*room_height); // cloud bg
draw_sprite(spr_CardBossIcon, 0, card_x, 0.5*room_height); // boss icon
draw_sprite_ext(spr_CardBossName, 0, card_x, 0.5*room_height, 1.5, 1.5, 0, image_blend, image_alpha); // boss name

draw_set_alpha(1);