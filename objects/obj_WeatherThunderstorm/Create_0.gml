event_inherited();

ps = part_system_create();
part_system_depth(ps, depth + 10);

image_speed = 0;
y = room_height*0.9;
lightning_phase = "NONE";	// "NONE", "FLASH", "DELAY", "LIGHTNING"
player_hit = false;

// Create particle emitter
ps = part_system_create();
p_emitter = part_emitter_create(ps);
//part_emitter_region(ps, p_emitter, 0, 1600, 0, 10, 3, 0); // Set emitter region
part_emitter_region(ps, p_emitter, -0.25*room_width, room_width + 0.25*room_width, 0, 10, 3, 0); // Set emitter region

// Stream
part_emitter_stream(ps, p_emitter, global.particle_type_rain, 6);


// Lightning alpha
lightning_alpha = 0;
lightning_chance = 0.15;	// 10% chance of lightning every second
alarm[0] = 2*GAMESPD;

// Play rain sound
weather_ambience_sfx = snd_Rain2Soft;
audio_play_sound(weather_ambience_sfx, 1, true);

// Method
/// @func	lightning_fx_create(alpha, delay)
/// @param	alpha
/// @param	sound_delay
lightning_fx_create = function(_alpha = 0.5, _delay = undefined) {
	lightning_alpha = _alpha
	var _sound_delay = 1 + irandom(15);
	if _delay != undefined _sound_delay = _delay;
	alarm[1] = _sound_delay;
	if instance_exists(obj_PlayerPAR) x = obj_PlayerPAR.x;
}

// Special case for bossfight 4
if(instance_exists(obj_ControllerFightBoss4_3))
{
	dark_alpha = 0;
	TweenStart("dark_alpha", 0, 0.4, GAMESPD);
}