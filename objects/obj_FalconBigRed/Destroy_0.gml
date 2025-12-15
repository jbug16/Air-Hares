if instance_exists(obj_BossBigRed)
if (obj_BossBigRed.sequence == 0)
{
	if (instance_number(object_index) <= 1) 
	{
		// next phase or sequence
		obj_BossBigRed.seq_phase++;
		with (obj_BossBigRed) // spawn next falcon formation
		{
			alarm[0] = time[0][seq_phase];
		}
	}
}