///@desc Initiate pause

instance_deactivate_all(true);
// Reactivate shader
instance_activate_object(obj_CRTController);
instance_activate_object(obj_Main);
instance_activate_object(obj_TweenManager);
// Create a pause object
instance_create_depth(0, 0, depth - 1, obj_ControllerPause);