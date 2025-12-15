/// @desc Go back

instance_destroy(obj_FreeModeSelect); //destroy buttons
//destroy controllers
instance_destroy(obj_FreeModeController); 


instance_destroy(obj_FreeModeFrame);
instance_destroy(obj_ModesBtnPAR);

with(obj_TitlebBtnGeneralPAR){
	mode_on = false;
	if (button_id == 2) event_user(1);
}

// grayscale off
layer_enable_fx("Backgrounds_1", false);