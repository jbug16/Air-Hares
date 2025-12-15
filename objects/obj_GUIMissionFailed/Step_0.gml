/// @desc
if (txt_yscale >= 1) {
	display_score = lerp(display_score, score_base, 0.07);
	text = string(round(display_score));
	if (round(display_score) != round(score_base)) {
		if (!audio_is_playing(snd_ScoreTick)) {
			audio_play_sound(snd_ScoreTick, 1, false);
		}
	}
	
	display_score_time = lerp(display_score_time, score_time, 0.07);
	text_time = string(round(display_score_time));
	if (round(display_score_time) != round(score_time)) {
		if (!audio_is_playing(snd_ScoreTick)) {
			audio_play_sound(snd_ScoreTick, 1, false);
		}
	}
	
	display_score_total = display_score + display_score_time;
	text_total = string(round(display_score_total));
	
	display_highscore = lerp(display_highscore, score_highscore, 0.07);
	text_highscore = string(round(display_highscore));
}