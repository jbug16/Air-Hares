///@desc Create particles
alarm[0] = time;

if(wind_blowing == 1)
{
	var _random_y = random_range(0, camera_height/2) + camera_y;		// anchor y positions
	var _random_y2 = random_range(camera_height / 2, camera_height);
	
	if (global.weather == WEATHER.WIND_LEFT) wind_dir = 180;
	else if (global.weather == WEATHER.WIND_RIGHT) wind_dir = 0;
	
	part_type_direction(particle_wind, wind_dir, wind_dir, 0, 0);
	
	for (var i = 0; i < 60; i++)
	{
		// blow to the left or right...
		var _pos_x = -camera_width + random_range(0, camera_width);
		if (wind_dir == 180) _pos_x = camera_x + camera_width + 20 + random_range(camera_width/5, camera_width);
			
		part_particles_create(particle_system, _pos_x, _random_y + choose(1,-1)*5*i, particle_wind, 7);
			
		var _pos_x = -camera_width + random_range(0, camera_width);
		if (wind_dir == 180) _pos_x = camera_x + camera_width + 20 + random_range(camera_width/5, camera_width);
		
		part_particles_create(particle_system, _pos_x, _random_y2 + choose(1,-1)*5*i, particle_wind, 7);
	}
}