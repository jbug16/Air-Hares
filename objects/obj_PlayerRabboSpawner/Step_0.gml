/// @desc
var _pitch = audio_sound_get_pitch(sound_engine);
if (_pitch > 1) {
	audio_sound_pitch(sound_engine, _pitch - 0.006);	
}