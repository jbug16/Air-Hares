/// @desc


var _pitch = audio_sound_get_pitch(sound_engine);
if (_pitch < 1.6) {
	audio_sound_pitch(sound_engine, _pitch + 0.006);	
}


global.speed_parallax = clamp(global.speed_parallax + 0.03, 0.5, 5);