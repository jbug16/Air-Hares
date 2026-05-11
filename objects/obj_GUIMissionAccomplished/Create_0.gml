/// @desc
peaceful_intro_summary = false;
crops_pct_display = "";
text = "MISSION ACCOMPLISHED";
color = c_white;
font = fnt_Federo16;
sep = 36;
w = 1280;


image_xscale = 0.45;
image_yscale = 0;
TweenStart("image_yscale", 0, 0.45, 0.5*GAMESPD, TWEENTYPE.QUAD_OUT);


if(instance_exists(obj_ControllerFightBoss1_3) or instance_exists(obj_ControllerFightBoss2_3) or
	instance_exists(obj_ControllerFightBoss3_3) or instance_exists(obj_ControllerFightBoss4_3)) exit;
	
// Fade out/in audio
AudioBgmChange(noone);
sound = audio_play_sound(snd_MissionAccomplished, 1, false);