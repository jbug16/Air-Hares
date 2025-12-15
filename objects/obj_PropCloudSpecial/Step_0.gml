/// @description Insert description here
// You can write your code in this editor

// Inherit the parent event
event_inherited();

//if(instance_exists(obj_WindParticles)){
//	if(obj_WindParticles.wind_blowing != 0){
//	// Apply wind draft based on weather. ==== For now being disabled / Only active when wind blows
//			if (global.weather == WEATHER.WIND_RIGHT) x_pos -= 0.5*hsp * WeatherGetWindDraft(global.weather);
//			else if (global.weather == WEATHER.WIND_LEFT) x_pos += 0.5*hsp * WeatherGetWindDraft(global.weather);
//			else if (global.weather == WEATHER.ROTATING_WIND)
//			{
//				var _wind_dir = -1;	// -1 because WeatherGetWindDraft returns negative val;
//				if(obj_WindParticles.wind_dir == 180) _wind_dir = 1;				
//				x_pos += 0.5*hsp * WeatherGetWindDraft(global.weather) * _wind_dir * 2;
//			}
//	}
//}

x_pos += 0.5*WeatherGetWindDraft();