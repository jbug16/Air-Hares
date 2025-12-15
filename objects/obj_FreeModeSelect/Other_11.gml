/// @desc Level hovered
if is_disabled exit;
if(obj_FreeModeController.selected == tgt_level) audio_play_sound(snd_ProjSeedShot, 1, false);
focus = true;

// scale
TweenStart("image_xscale", scale_normal, scale_big, 0.5*GAMESPD, TWEENTYPE.CIRC_OUT);
TweenStart("image_yscale", scale_normal, scale_big, 0.5*GAMESPD, TWEENTYPE.CIRC_OUT);