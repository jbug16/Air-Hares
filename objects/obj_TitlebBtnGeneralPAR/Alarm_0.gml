///@desc Hover tween repeat
if (parent_index == obj_TitlebBtnGeneralPAR and (mode_on or !focus)) exit;

if (image_xscale >= scale_big)
TweenStart("image_xscale", scale_big, scale_normal, tween_spd*1.5, TWEENTYPE.CIRC_OUT);
else 
TweenStart("image_xscale", scale_normal, scale_big, tween_spd, TWEENTYPE.CIRC_OUT);
alarm[0] = tween_spd;