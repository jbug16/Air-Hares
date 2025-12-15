/// @desc Click

event_inherited();	// unhover

with(all){
	if (!persistent) instance_deactivate_object(id);
}
layer_set_visible("Background_Options", true); //black out the background

//create options
instance_create_layer(0.3*room_width, 0.5*room_height, "Instances", obj_OptionsController);
instance_create_layer(0.5*room_width, 0.1*room_height, "Instances", obj_OptionsTitle);