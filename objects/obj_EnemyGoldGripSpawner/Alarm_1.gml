///@desc Falcons need to dive!

if(sequence > 0) exit; // only when there is no boss!

// get all the falcons
for (var i = array_length(falcon_ids) - 1; i >= 0; i--)
{
	if !instance_exists(falcon_ids[i]) array_delete(falcon_ids, i, 1);
}

// dive all of them (in order of closest to player)

with(obj_FalconGoldGrip) alarm[0] = -1;

if(array_length(falcon_ids) == 0) exit;

var _who = falcon_ids[0];
var _num = 1;

for (var i = array_length(falcon_ids) - 1; i >= 0; i--)
{
	var _dist = room_width;
	// get the falcon closest to the player
	with (obj_FalconGoldGrip)
	{
		if (alarm[0] > 0) continue;
		var _inst = instance_nearest(x,y,obj_PlayerPAR);
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