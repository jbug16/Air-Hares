///@desc Disable grayscale
layer_set_visible("Effect_Grayscale", false);
VirtualKeyboardForceClose();
global.arcade_popup_screen = 0;
global.arcade_new_initials = "";
with (obj_FreeModeBtnPlay) instance_destroy();
with (obj_FreeModeBtnBack) instance_destroy();