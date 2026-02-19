///@desc Next phase & hit
if (instance_exists(obj_TipsAndTricks)) exit;

event_inherited();

// check if outside the room
//if (y - sprite_height*0.9 > room_height)
//{
//	if !passed
//	{
//		passed = true;
//		with obj_ControllerPAR state = LEVEL1.PHASE_11_TALK;
//	}
//}

// check if projectile hit it...
var _hit = false;
var _projectile_array = [obj_PlayerProjectileWater, obj_PlayerProjectileSeed];
for (var i = 0; i < array_length(_projectile_array); i++)
{
	with _projectile_array[i]
	{
		if collision_point(x, target_y, id, false, false)
		{
			CombosAddHit(20);
			var _create_obj = obj_PlayerProjectileWaterFX;
			if (_projectile_array[i] == obj_PlayerProjectileSeed) 
			{
				var _mask = other.mask_index;
				other.mask_index = other.water_hit_sprite;
				if !place_meeting(x,y, other) _create_obj = obj_PlayerProjectileSeedFX;
				other.mask_index = _mask;
			}
			var _fx = instance_create_layer(x, target_y, layer, _create_obj);
			_fx.z = z;
			_fx.depth -= 1;
			if (_fx.object_index == obj_PlayerProjectileWaterFX)
				audio_play_sound(snd_ProjWaterHit, 1, false);
			else audio_play_sound(snd_ProjSeedHit, 1, false);
			other.alarm[0] = other.flash_len;
			with(other)
			{
				propeller_spd = clamp(propeller_spd + 2, 1, max_spd);
				alarm[1] = GAMESPD;
			}
			instance_destroy();
		}
	}
}

propeller_angle += propeller_spd;
if(propeller_angle == 360) propeller_angle = 0;