/// @desc Boss card sound and draw

boss_card = true;

// Start card showing (tween)
var _dur = audio_sound_length(snd_BossAnnouncement)*GAMESPD/3;
TweenStart("card_x", card_x, 0.5*room_width, _dur);
TweenStart("image_alpha", 0, 1, _dur);

// Start music
audio_stop_sound(music_bg);
music_bg = audio_play_sound(snd_BossAnnouncement, 0, false);

alarm[2] = 2*_dur + 2*GAMESPD;
alarm[10] = 3*_dur;