/// @desc Time between phases

//==========================================================
// Before boss appears
//==========================================================
if (sequence != 0) exit;

if (seq_phase <= array_length(falcon_positions) - 1)
{
	prep_wave_took_hp_hit = false;
	var _num = array_length(falcon_positions[seq_phase]);	// how many to spawn
		
	falcon_ids = array_create(_num, noone);	// reset falcon IDs
	for (var i = 0; i < _num; i++)
	{
		falcon_ids[i] = instance_create_layer(falcon_positions[seq_phase][i], room_height + 500, "Top", 
			obj_FalconTwinHorn);
	}
}
//==========================================================
// Boss appears
//==========================================================
else
{
	falcon_ids = array_create(4, noone);
	sequence = 1;
	seq_phase = -1;
	visible = true;
	boss_spawn = true;
}
