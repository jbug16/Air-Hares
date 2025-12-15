if instance_exists(obj_EnemyGoldGripSpawner)
if (obj_EnemyGoldGripSpawner.sequence == 0)
{
	if (instance_number(object_index) <= 1) 
	{
		// next phase or sequence
		obj_EnemyGoldGripSpawner.seq_phase++;
		with (obj_EnemyGoldGripSpawner) // spawn next falcon formation
		{
			alarm[0] = time[0][seq_phase];
		}
	}
}
