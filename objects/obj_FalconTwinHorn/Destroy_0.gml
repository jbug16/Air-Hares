if instance_exists(obj_EnemyTwinhornSpawner)
if (obj_EnemyTwinhornSpawner.sequence == 0)
{
	if (instance_number(object_index) <= 1) 
	{
		// next phase or sequence
		obj_EnemyTwinhornSpawner.seq_phase++;
		with (obj_EnemyTwinhornSpawner) // spawn next falcon formation
		{
			alarm[0] = time[0][seq_phase];
		}
	}
}
