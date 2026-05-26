/// @desc Button hovered
if (TitleMainIsSocialButtonId(button_id) && !TitleMainSocialLinksEnabled()) exit;
if (parent_index != obj_EndLevelPAR && parent_index != obj_PreScreenTutorialBtnPAR)
if !(parent_index == obj_TitlebBtnGeneralPAR and !mode_on or parent_index == obj_ModesBtnPAR and mode_on) exit;

audio_play_sound(snd_ProjSeedShot, 1, false);
focus = true;

TweenStart("image_xscale", scale_normal, scale_big, tween_spd, TWEENTYPE.CIRC_OUT);
alarm[0] = tween_spd;