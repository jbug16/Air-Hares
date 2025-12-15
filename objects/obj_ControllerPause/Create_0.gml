/// @desc Initialize
menu_selected = 0;		// 0 => Resume, 1=> Quit
menu_selected_max = 2;	// Max menu index to be selected

// Create three objects
instance_create_depth(room_width/2, room_height/2 - 128, depth, obj_PauseButtonResume);
instance_create_depth(room_width/2, room_height/2, depth, obj_PauseButtonMMenu);
instance_create_depth(room_width/2, room_height/2 + 128, depth, obj_PauseButtonExit);

//// Create two objects
//instance_create_depth(room_width/2, room_height/2 - 64, depth, obj_PauseButtonResume);
//instance_create_depth(room_width/2, room_height/2 + 64, depth, obj_PauseButtonExit);