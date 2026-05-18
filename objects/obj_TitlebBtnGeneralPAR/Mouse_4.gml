/// @desc On press, execute _script
if(global.mouse_disable) exit;
if  (alarm[2] > 0) exit;
if (parent_index == obj_TitlebBtnGeneralPAR and mode_on) exit;
if (parent_index == obj_ModesBtnPAR && !visible) exit;
event_user(0);