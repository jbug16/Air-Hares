// score
if (image_yscale >= 1) {
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
	
	// Stagger medal carrot reveals during tally (farm → damage → aggression)
	mission_ach_tally_step += 1;
	var _nfx = sprite_get_number(spr_AnimShine);
	var _delay = [20, 38, 56];
	for (var _i = 0; _i < 3; _i++) {
		if (mission_ach_phase[_i] == 0 && mission_run_met[_i] && mission_ach_tally_step >= _delay[_i]) {
			mission_ach_phase[_i] = 1;
			mission_ach_anim[_i] = 0;
			audio_play_sound(snd_FarmTransform, 1, false);
		} else if (mission_ach_phase[_i] == 1) {
			mission_ach_anim[_i] += 0.55;
			if (mission_ach_anim[_i] >= _nfx) {
				mission_ach_phase[_i] = 2;
			}
		}
	}
}