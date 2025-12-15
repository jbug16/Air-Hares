if instance_exists(obj_BossHighTop)
if (obj_BossHighTop.sequence == 0)
{
	if (instance_number(object_index) <= 1) 
	{
		// next phase or sequence
		obj_BossHighTop.seq_phase++;
		with (obj_BossHighTop) // spawn next falcon formation
		{
			alarm[0] = time[0][seq_phase];
		}
	}
}