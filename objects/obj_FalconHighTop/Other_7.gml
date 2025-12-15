if (state == BOSS.HURT)
{
	TweenStop();
	
	if (hp <= 0)	// Defeated
	{		
		state = BOSS.DYING;
		// Run away
		direction = choose(45, 135);
		image_angle = direction + 90;
		speed = 0;
		TweenStart("speed", 0, direct_attack_speed, GAMESPD, TWEENTYPE.CUBIC_OUT);
	}
	else			// still alive
	{
		speed = speed_prev;
		state = state_prev;
		if(state_prev == BOSS.HURT)
		{
			if(y > 0.3*sprite_height)
			{
				state = BOSS.DIVE
				TweenStart("speed", 0, direct_attack_speed, GAMESPD, TWEENTYPE.CUBIC_OUT);
			}
			else state = BOSS.IDLE;
		}
		if(state_prev == BOSS.APPEAR) TweenStart("y", y, 0.2*sprite_height, 2*GAMESPD, TWEENTYPE.QUINT_OUT);
		if(state_prev == BOSS.DIVE) TweenStart("speed", 0, direct_attack_speed, GAMESPD, TWEENTYPE.CUBIC_OUT);
	}
}
else if(state == BOSS.DODGE)
{	
	// Return all falcons to previous states
	for(var i = 0; i < 4; i++)
	{
		if(instance_exists(obj_BossHighTop.falcon_ids[i]) and array_length(alarm_save) >= i + 1)
		{
			if(obj_BossHighTop.falcon_ids[i] != id)
			{
				obj_BossHighTop.falcon_ids[i].alarm[0] = alarm_save[i];
				obj_BossHighTop.falcon_ids[i].state = state_save[i];
			}
		}
	}
	alarm_save = [];
	state = state_prev;
	
	// Setup according to state
	if(state == BOSS.APPEAR)
	{
		depth = layer_get_depth("Middle");
		speed = 0;
		direction = 270;
		image_angle = 0;
	}
	else if(state == BOSS.IDLE)
	{
		alarm[0] = 10*GAMESPD;
		// check if all of them are IDLE
		var _idle = true;
		with object_index
		{
			if (state != BOSS.IDLE)
			{
				_idle = false;
				break;
			}
		}
		if (_idle and obj_BossHighTop.alarm[1] < 0) obj_BossHighTop.alarm[1] = time1[state];	// wait before diving
	}
}