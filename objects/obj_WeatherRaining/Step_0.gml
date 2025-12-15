/// @desc Check if wind direction changed

if(!instance_exists(obj_WindParticles)) exit;

if(obj_WindParticles.wind_dir != wind_dir_prev){
	if(obj_WindParticles.wind_dir == 180) //if wind blowing to the left
		part_type_direction(particle_rain, 247, 253, 0, 0);
	else							//if wind blowing to the right
		part_type_direction(particle_rain, 287, 293, 0, 0);
	wind_dir_prev = obj_WindParticles.wind_dir;
}