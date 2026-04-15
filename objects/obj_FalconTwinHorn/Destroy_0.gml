if instance_exists(obj_EnemyTwinhornSpawner)
if (obj_EnemyTwinhornSpawner.sequence == 0)
{
	if (instance_number(object_index) <= 1) 
	{
		with (obj_EnemyTwinhornSpawner)
		{
			if (prep_wave_took_hp_hit)
			{
				prep_wave_took_hp_hit = false;
				alarm[0] = time[0][seq_phase];
			}
			else
			{
				seq_phase++;
				alarm[0] = time[0][seq_phase];
			}
		}
	}
}
