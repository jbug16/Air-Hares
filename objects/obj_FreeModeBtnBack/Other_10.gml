/// @desc

// Inherit the parent event
event_inherited();

with(obj_FreeModeSelect){
	is_disabled = false;
	alarm[0] = 2;
}
instance_destroy(obj_FreeModeFrame);
while(instance_exists(obj_ModesBtnPAR)) instance_destroy(obj_ModesBtnPAR);
