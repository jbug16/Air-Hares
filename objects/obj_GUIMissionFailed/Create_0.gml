/// @desc

image_xscale = 0.45
image_yscale = 0;
TweenStart("image_yscale", 0, 0.45, 0.5*GAMESPD, TWEENTYPE.QUAD_OUT);

// Fade out/in audio
AudioBgmChange(noone);
sound = audio_play_sound(snd_MissionFailed, 1, false);
text = "";
text_time = "";
text_total= "";
text_highscore = "";
color = c_white;
font = fnt_Federo16;
sep = 36;
w = 1280;

y_draw = 0.5*room_height + 24;

txt_yscale = 0;
score_base = global.score_base;
score_time = 14000 - obj_ControllerPAR.time_elapsed;
score_total = score_base + score_time;
crops_filled = 0;


// Update highscore
if (score_total > global.highscore[global.level_highscore]) {
	// Update highscore	
	global.highscore[global.level_highscore] = score_total;
	ini_open("save.sav");
	ini_write_real("highscore", string(global.level_highscore), global.highscore[global.level_highscore]);
	ini_close();
}
score_highscore = global.highscore[global.level_highscore];

display_score = 0;
display_score_time = 0;
display_score_total = 0;
display_highscore = 0;

TweenStart("txt_yscale", 0, 1, 0.5*GAMESPD, TWEENTYPE.QUAD_OUT);