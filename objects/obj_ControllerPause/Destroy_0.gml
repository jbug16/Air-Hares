/// @desc Remove pause menu buttons (child object types are not covered by instance_destroy(obj_PauseButtonPAR))

if (instance_exists(obj_PauseButtonResume)) instance_destroy(obj_PauseButtonResume);
if (instance_exists(obj_PauseButtonMMenu)) instance_destroy(obj_PauseButtonMMenu);
if (instance_exists(obj_PauseButtonExit)) instance_destroy(obj_PauseButtonExit);
