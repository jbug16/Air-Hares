///@desc Control falcon dive (start)

//==========================================================
// Before boss appears
//==========================================================
if (sequence == 0)
{
	// get all the falcons
	for (var i = array_length(falcon_ids) - 1; i >= 0; i--)
	{
		if !instance_exists(falcon_ids[i]) array_delete(falcon_ids, i, 1);
	}
	
	// dive all of them (in order of closest to player)
	
	with (obj_FalconHighTop) alarm[0] = 0;
	if(array_length(falcon_ids) == 0) exit;
	
	var _who = falcon_ids[0];
	var _num = 1;
	
	for (var i = array_length(falcon_ids) - 1; i >= 0; i--)
	{
		var _dist = room_width;
		
		// get the falcon closest to the player
		with (obj_FalconHighTop)
		{
			if (alarm[0] > 0) continue;
			var _inst = PlayerGetEnemyAggroTarget(x, y, true);
			if (distance_to_object(_inst) < _dist)
			{
				_who = id;
				_dist = distance_to_object(_inst);
			}
		}
		
		// dive with this falcon and remove from array
		_who.alarm[0] = _num*0.3*GAMESPD;
		for (var j = 0; j < array_length(falcon_ids); j++)
		{
			if (_who == falcon_ids[j]) array_delete(falcon_ids, j, 1);
		}
		_num++;
	}
}
//==========================================================
// After boss appears
//==========================================================
else if (sequence == 1)
{
	// check if any falcons currently dodging
	var _falcon_dodge = false;
	for(var i = 0; i < array_length(falcon_ids); i++)
	{
		if(falcon_ids[i] != noone and instance_exists(falcon_ids[i]) and falcon_ids[i].state == BOSS.DODGE)
			_falcon_dodge = true;
	}
	
	// check if any of the falcons defeated too soon
	if (falcon_ids[0] == noone or falcon_ids[1] == noone or falcon_ids[2] == noone or falcon_ids[3] == noone or
		_falcon_dodge) 
	{
		state = BOSS.IDLE;
		alarm[0] = 0.5*time[1][0];
	}
	else
	{
		falcons_diving = true;
		can_dive = true;
	
		// who will attack (remove 1 or 2 or 3 depending on which phase it is)
		var _who = [0,1,2,3];
		repeat (3 - seq_phase)
		{
			array_delete(_who, irandom(array_length(_who)) - 1, 1);
		}
	
		// instruct falcons to attack!
		for (var i = 0; i < array_length(_who); i++)
		{
			if !instance_exists(falcon_ids[_who[i]]) continue;
			with (falcon_ids[_who[i]])
			{
				if (state != BOSS.IDLE and state != BOSS.APPEAR) continue;
				hp = 2;
				state = BOSS.IDLE;
				alarm[0] = i*20+irandom_range(10,30);
			}
		}
	}
}