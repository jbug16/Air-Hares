// Getting hurt
var _collide_seed = instance_place(x, y, obj_PlayerProjectileSeed);
var _collide_water = instance_place(x, y, obj_PlayerProjectileWater);
var _collide_counter = instance_place(x, y, obj_PlayerParry);
if (!_collide_counter) parry_snd = false;

// In phase 2, falcons dodge the shooting if not diving
if(instance_exists(obj_EnemyGoldGripSpawner) and obj_EnemyGoldGripSpawner.sequence == 1 and (_collide_seed != noone or _collide_water != noone) and state != BOSS.DIVE and state != BOSS.DODGE and state != BOSS.HURT)
{	
	state_prev = state;
	state = BOSS.DODGE
	
	image_index = 0;
	sprite_index = sprite[state];
	
	// Save the states of other falcons
	for(var i = 0; i < 4; i++)
	{
		if(instance_exists(obj_EnemyGoldGripSpawner.falcon_ids[i])) state_save[i] = obj_EnemyGoldGripSpawner.falcon_ids[i].state;
	}
}

if(state == BOSS.DODGE)
{
	// Need to prolong the alarms if any are active
	with(object_index) if(alarm[0] > 0) alarm[0]++;
	exit;
}

if ((state == BOSS.IDLE or state == BOSS.DIVE or state == BOSS.HURT or state == BOSS.APPEAR) and bbox_bottom > 0)
{
	if (_collide_seed or _collide_water)
	{
		// Damage & water/seed splash
		if (_collide_seed != noone)	
		{
			hit_fx_seed(_collide_seed);		
			CombosAddHit(50);
			hp--;
		}
		if (_collide_water != noone)
		{
			_HitFXWater(_collide_water);
			CombosAddHit(50);
			hp--;
		}
		VfxShake(3, 15);
	
		// stop movement and change state
		speed = 0;
		image_index = 0;
		state = BOSS.HURT;
	
		// Tween shot back
		TweenStop();
		TweenStart("y", y, y - 128, GAMESPD, TWEENTYPE.CUBIC_OUT);
	
		// Feather
		if (hp <= 0) instance_create_layer(x, y, "Top", obj_PropFeatherBrown);

		// remove from the boss list
		if (instance_exists(obj_EnemyGoldGripSpawner) and hp <= 0)
		for (var i = 0; i < array_length(obj_EnemyGoldGripSpawner.falcon_ids); i++)
		{
			if (obj_EnemyGoldGripSpawner.falcon_ids[i] == id)
			{
				obj_EnemyGoldGripSpawner.falcon_ids[i] = noone;
				break;
			}
		}
	}
	
	// Parry roll hit
	if(_collide_counter != noone and alarm[1] < 0)
	{
		if (!parry_snd) 
		{
			audio_play_sound(snd_PlaneParry, 1, false);	// parry shot
			parry_snd = true;
		}
		
		// stop movement and change state
		speed = 0;
		image_index = 0;
		state = BOSS.HURT;
		VfxShake(3, 15);
	
		// Tween shot back
		TweenStop();
		TweenStart("y", y, y - 128, GAMESPD, TWEENTYPE.CUBIC_OUT);
	
		// damage and score
		CombosAddHit(50);
		hp--;
		
		// Feather
		if (hp <= 0) instance_create_layer(x, y, "Top", obj_PropFeatherBrown);
		
		alarm[1] = 20;
		
		// remove from the boss list
		if (instance_exists(obj_EnemyGoldGripSpawner) and hp <= 0)
		for (var i = 0; i < array_length(obj_EnemyGoldGripSpawner.falcon_ids); i++)
		{
			if (obj_EnemyGoldGripSpawner.falcon_ids[i] == id)
			{
				obj_EnemyGoldGripSpawner.falcon_ids[i] = noone;
				break;
			}
		}
	}
}


// Statemachine
switch (state)
{
	case BOSS.INIT:		// come into position from the bottom of the screen
	if (y < -720)
	{
		TweenStart("y", y, -sprite_height, 2*GAMESPD, TWEENTYPE.QUINT_OUT);
		
		state = BOSS.APPEAR;
		depth = layer_get_depth("Middle");
		speed = 0;
		direction = 270;
		image_angle = 0;
	}
	else
	{
		if instance_exists(obj_PlayerPAR) speed = 33;
	}
	break;
	
	case BOSS.APPEAR:	// glide into position from top
	target_id = instance_nearest(x, y, obj_PlayerPAR);
	EnemyFaceTarget(target_id);
	if instance_exists(obj_EnemyGoldGripSpawner)
	//if (y == sprite_height*0.2 and obj_EnemyGoldGripSpawner.sequence == 0)
	if (y == -sprite_height and obj_EnemyGoldGripSpawner.sequence == 0)
	{
		state = BOSS.IDLE;
		alarm[0] = 10*GAMESPD;
		// check if all of them are IDLE
		var _idle = true;
		with object_index
		{
			if (state != BOSS.IDLE and state != BOSS.HURT and state != BOSS.DYING)
			{
				_idle = false;
				break;
			}
		}
		if (_idle and obj_EnemyGoldGripSpawner.alarm[1] < 0) obj_EnemyGoldGripSpawner.alarm[1] = time1[state];	// wait before diving
	} 
	break;
	
	case BOSS.IDLE:		// wait before diving
	target_id = instance_nearest(x, y, obj_PlayerPAR);
	EnemyFaceTarget(target_id);
	
	if (alarm[0] < 0) 
	{
		state = BOSS.DIVE;
		// Play sound
		audio_play_sound(snd_EnemyFalconAttackScream, 1, false);
		audio_play_sound(snd_EnemyFalconAttackFly, 1, false);
		// speed up
		TweenStart("speed", 0, direct_attack_speed, GAMESPD, TWEENTYPE.CUBIC_OUT);
				
		direction = image_angle - 90;
		
		// Stop horizontal dive
		if(direction < 40 or direction > 310 or (direction > 140 and  direction < 220))
		{
			var _inst = instance_nearest(x, y, obj_PlayerPAR);
			if(_inst != noone) direction = point_direction(x, y, _inst.x, _inst.y);
		}
	}
	break;
	
	case BOSS.DIVE:		// attack dive
	if (x < -500 or x > room_width + 500 or y > room_height + 500)
	{
		if (obj_EnemyGoldGripSpawner.sequence == 1)
		{
			x = x_origin;
			y = -sprite_height;
			speed = 0;
			direction = 0;
			TweenStop();
			//TweenStart("y", -sprite_height, sprite_height*0.2, 2*GAMESPD, TWEENTYPE.QUINT_OUT);
						
			state = BOSS.APPEAR;
		}
		else if (obj_EnemyGoldGripSpawner.sequence == 0) instance_destroy();
	}
	else EnemyHomingTarget(target_id, direct_attack_homing);		// Homing to target
	break;
	
	case BOSS.DYING:	// defeated
	if(hp <= 0 and (_collide_seed != noone or _collide_water != noone)) 
	{
		if(_collide_seed != noone) hit_fx_seed(_collide_seed);
		if(_collide_water != noone) _HitFXWater(_collide_water);
		VfxShake(3, 10);
		CombosAddHit(50);
		instance_create_layer(x, y, "Top", obj_PropFeatherBrown);
	}
	if (x <= -500 or x > room_width + 500 or y < -500 or y > room_height + 500) instance_destroy();
	break;
}


// Animation & remember previous state/speed etc
if (sprite_index != sprite[state])
{
	image_index = 0;
	sprite_index = sprite[state];
	if (state != state_prev and state != BOSS.HURT) 
	{
		state_prev = state;
		speed_prev = speed;
	}
}


// Play audio of wing flap 
if (state == BOSS.APPEAR or state == BOSS.IDLE)
{
	if (image_index >= 3 and image_index < 7 and !audio_is_playing(snd_FalconWingsFlap))
		audio_play_sound(snd_FalconWingsFlap, 1, false);	
}
