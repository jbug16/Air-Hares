/// @desc

// Inherit the parent event
event_inherited();

// Lerping the score
var _next_score = lerp(global.score_current, global.score_base, 0.15);
if (round(_next_score) != round(global.score_current)) {
	if (!audio_is_playing(snd_ScoreTick)) {
		audio_play_sound(snd_ScoreTick, 1, false);	
	}
}
global.score_current = _next_score;

// All combat at 300 kts.
global.speed_parallax = 3;