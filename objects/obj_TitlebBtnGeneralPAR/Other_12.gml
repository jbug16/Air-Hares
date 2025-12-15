/// @desc Button unhovered
if (parent_index != obj_EndLevelPAR)
if !(parent_index == obj_TitlebBtnGeneralPAR and !mode_on or parent_index == obj_ModesBtnPAR and mode_on) exit;

focus = false;
TweenStart("image_xscale", scale_big, scale_normal, tween_spd, TWEENTYPE.CIRC_OUT);
alarm[0] = -1;
