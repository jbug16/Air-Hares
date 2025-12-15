/// @desc Delete all particle
if part_system_exists(ps) {
	part_system_destroy(ps);
}

if weather_ambience_sfx != noone {
	audio_stop_sound(weather_ambience_sfx);
	weather_ambience_sfx = noone;
}