/// @desc Start the outro bed one frame after audio_stop_all()

audio_sound_gain(snd_CutsceneOutro, 1, 0);
music_bg = audio_play_sound(snd_CutsceneOutro, 1, false);
global.ending_outro_voice = music_bg;
