/// @desc Controller-reconnect wait: resume once P1 has a controller again

if (!global.controller_reconnect_wait) exit;

if (ControllerReconnectTryResolve()) {
	global.controller_reconnect_wait = false;
	global.controller_reconnect_exclude = noone;
	instance_activate_all();
	instance_destroy();
}
