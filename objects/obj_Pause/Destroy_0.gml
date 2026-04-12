///@desc Flush memory

if (screen_save_sprite != noone) sprite_delete(screen_save_sprite);

// Normal pause creates obj_ControllerPause from Alarm_0; resume only destroyed obj_Pause, so the
// controller could orphan and block gameplay (e.g. reticle toggle checks instance_exists).
if (instance_exists(obj_ControllerPause)) {
	instance_destroy(obj_ControllerPause);
}