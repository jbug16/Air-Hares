/// @desc Initialize
menu_selected = 0;		// 0 => Resume, 1 => Main menu, 2 => Exit (non-Switch)
menu_selected_max = MenuExitButtonEnabled() ? 2 : 1;

if (MenuExitButtonEnabled()) {
	instance_create_depth(room_width/2, room_height/2 - 128, depth, obj_PauseButtonResume);
	instance_create_depth(room_width/2, room_height/2, depth, obj_PauseButtonMMenu);
	instance_create_depth(room_width/2, room_height/2 + 128, depth, obj_PauseButtonExit);
} else {
	instance_create_depth(room_width/2, room_height/2 - 64, depth, obj_PauseButtonResume);
	instance_create_depth(room_width/2, room_height/2 + 64, depth, obj_PauseButtonMMenu);
}
