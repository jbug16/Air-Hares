/// @desc Boss card show

// Start tweening the card back
if(card_x == 0.5*room_width)
{
	var _dur = audio_sound_length(snd_BossAnnouncement)*GAMESPD/3;
	TweenStart("card_x", card_x, room_width + 0.51*sprite_get_width(spr_CardBossCloud), _dur);
	TweenStart("image_alpha", 1, 0, _dur);
	alarm[2] = _dur;
}
// Card announcement end - start new music
else boss_card = false;
