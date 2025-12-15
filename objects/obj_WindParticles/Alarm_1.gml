///@desc Wind direction

//Change the blowing every other time alarm runs
if(wind_blowing == 1)			// if it was blowing
{
	wind_blowing = -1;			
	alarm[1] = 0.4*global.wind_on_off_time;
}
else if (wind_blowing == -1)	// if there was a delay after the blow
{
	wind_blowing = 0;		
	alarm[1] = global.wind_on_off_time;
}
else							// if it was not blowing
{
	wind_blowing = 1;
	alarm[1] = 0.8*global.wind_on_off_time;
}


//Change direction on every other time that the alarm runs
if ((global.weather == WEATHER.ROTATING_WIND or global.weather == WEATHER.THUNDERSTORM_WINDY) and wind_blowing == 1)
{
		if (wind_dir == 180) wind_dir = 0;
		else wind_dir = 180;
}