event_inherited();

// Create particle system
ps = part_system_create();

particle_rain = global.particle_type_rain;
if(instance_exists(obj_WindParticles)){
	if(obj_WindParticles.wind_dir == 180) //if wind blowing to the left
		part_type_direction(particle_rain, 247, 253, 0, 0);
	else							//if wind blowing to the right
		part_type_direction(particle_rain, 287, 293, 0, 0);
		
	wind_dir_prev = obj_WindParticles.wind_dir;
}

// Create particle emitter
p_emitter = part_emitter_create(ps);
part_emitter_region(ps, p_emitter, -0.25*room_width, room_width + 0.25*room_width, 0, 10, 3, 0); // Set emitter region

// Stream
part_emitter_stream(ps, p_emitter, particle_rain, 6);

// Lightning alpha
lightning_alpha = 0;
lightning_chance = 0.10;	// 5% chance of lightning every second
alarm[0] = 60;

// Play rain sound
weather_ambience_sfx = snd_Rain2Soft;
audio_play_sound(weather_ambience_sfx, 1, true);

if(instance_exists(obj_ControllerFightBoss4_3))
{
	dark_alpha = 0;
	TweenStart("dark_alpha", 0, 0.4, GAMESPD);
}