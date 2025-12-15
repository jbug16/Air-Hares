/// @desc Click
if(global.demo) exit;
event_inherited();	// unhover

global.game_mode = GAMEMODE.STORY;
obj_TitlebBtnGeneralPAR.mode_on = true;
layer_set_visible("Effect_Grayscale", true);

var _sprite_width = sprite_get_width(spr_TitleSelectionFrame);
var _sprite_height = sprite_get_height(spr_TitleSelectionFrame);

instance_create_layer(0.5*room_width - 0.31*_sprite_width, 0.5*room_height + 0.3*_sprite_height, "Instances_PopUp", obj_StoryBtnContinue);
instance_create_layer(0.5*room_width, 0.5*room_height + 0.3*_sprite_height, "Instances_PopUp", obj_StoryBtnPlay);
instance_create_layer(0.5*room_width + 0.31*_sprite_width, 0.5*room_height + 0.3*_sprite_height, "Instances_PopUp", obj_StoryBtnBack);
instance_create_layer(0.5*room_width, 0.5*room_height, "Instances_PopUp", obj_StoryModeFrame);
