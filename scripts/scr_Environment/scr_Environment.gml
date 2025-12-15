// LEVEL ENVIRONMENT

function PropsFeatherSpecialSpawn(_obj_feather){
	if feather > 0 {
		feather -= 1;
		instance_create_depth(x, y - 30, depth, _obj_feather);
	}
}

function PropsSpawnSplash(_id, _offset){ // Spawn two splash
	splash[0] = instance_create_layer(x, y, "Ground", obj_GroundSplash);
	splash[0].master = _id;
	splash[0].x_offset = -_offset;
	splash[1] = instance_create_layer(x, y, "Ground", obj_GroundSplash);
	splash[1].master = _id;
	splash[1].x_offset = _offset;
}


function WeatherGetObject(_weather_enum){
	switch(_weather_enum){
		case WEATHER.CLEAR:
			return obj_WeatherClear;
			break;
		case WEATHER.WIND_RIGHT:
			return obj_WeatherWindy;
			break;
		case WEATHER.WIND_LEFT:
			return obj_WeatherWindy;
			break;
		case WEATHER.ROTATING_WIND:
			return obj_WeatherWindy;
			break;
		case WEATHER.RAINING:
			return obj_WeatherRaining;
			break;
		case WEATHER.THUNDERSTORM:
		case WEATHER.THUNDERSTORM_WINDY:
			return obj_WeatherThunderstorm;
			break;
	}
}

function WeatherGetWindDraft(){
	if !instance_exists(obj_WindParticles) return 0;
	if (obj_WindParticles.wind_blowing == 0) return 0
	var _ret = 1;
	if(obj_WindParticles.wind_dir == 180) _ret = -1;		
	
	switch(global.weather){
		case WEATHER.WIND_RIGHT:
		case WEATHER.WIND_LEFT:
		_ret *= 0.16;
		break;	
		
		case  WEATHER.ROTATING_WIND:
		_ret *= 0.16;
		break;
		
		case WEATHER.THUNDERSTORM_WINDY:
		_ret *= 0.20;
		break;
		
		default:
		_ret = 0;
		break;
	}
	return _ret;
}
