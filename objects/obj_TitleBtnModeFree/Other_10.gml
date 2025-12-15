/// @desc Click

event_inherited();	// unhover

global.game_mode = GAMEMODE.FREE;
obj_TitlebBtnGeneralPAR.mode_on = true;
layer_enable_fx("Backgrounds_1", true);		// Grayscale bg

instance_create_layer(0, 0, "Instances", obj_FreeModeController);