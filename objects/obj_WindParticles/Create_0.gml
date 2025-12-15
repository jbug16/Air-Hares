//Particle System
particle_system = part_system_create();
particle_wind = part_type_create();
wind_dir = 0;
wind_speed = 10;

part_type_shape(particle_wind, pt_shape_cloud);
part_type_size(particle_wind, 3, 3, 0, 0);						
part_type_direction(particle_wind, wind_dir, wind_dir, 0, 0);	// move to right by default
part_type_speed(particle_wind, wind_speed, wind_speed, 0, 2);
part_type_alpha1(particle_wind, 0.07);
part_type_life(particle_wind, room_width*3/wind_speed, room_width*3/wind_speed);
part_type_colour_rgb(particle_wind, 205, 205, 170, 170, 127, 127);

camera_x = camera_get_view_x(view_camera[0]);
camera_y = camera_get_view_y(view_camera[0]);

camera_width = camera_get_view_width(view_camera[0]);
camera_height = camera_get_view_height(view_camera[0]);

//Wind Related
time = GAMESPD * 1.05;
if(global.weather == WEATHER.WIND_RIGHT or global.weather == WEATHER.ROTATING_WIND 
	or global.weather == WEATHER.WIND_LEFT or global.weather == WEATHER.THUNDERSTORM_WINDY){
	alarm[0] = time;
	alarm[1] = 0.8*global.wind_on_off_time;
	audio_play_sound(snd_DesertWind, 1, true);
}

// Used to store whether the wind blows or not
wind_blowing = 1;	// -1 (delay after the blow), 0 (no blow) or 1 (blowing and particles)
