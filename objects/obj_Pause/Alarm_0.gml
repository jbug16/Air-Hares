///@desc Initiate pause

instance_deactivate_all(true);
// Reactivate shader
instance_activate_object(obj_CRTController);
instance_activate_object(obj_Main);
instance_activate_object(obj_TweenManager);
if (global.controller_reconnect_wait) {
	// Controller-reconnect freeze: no menu; prompt drawn here (Draw GUI), resolved in Step.
} else if (global.pause_coop_portrait_select) {
	instance_create_depth(0, 0, depth - 1, obj_CoopPortraitSelect);
} else {
	instance_create_depth(0, 0, depth - 1, obj_ControllerPause);
}