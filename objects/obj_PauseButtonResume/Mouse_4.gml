// Inherit the parent event

if(global.mouse_disable) exit;

event_inherited();

// Delete all pause button
instance_destroy(obj_PauseButtonPAR);	
instance_destroy(obj_Pause);
instance_activate_all();

with(obj_PlayerRabbo) alarm[2] = 10;