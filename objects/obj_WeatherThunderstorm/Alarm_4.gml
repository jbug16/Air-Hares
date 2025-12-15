/// @desc Bossfight 3 and 4

if(instance_exists(obj_EnemyTwinhorn))
{
	// Phase 3
	if(obj_EnemyTwinhorn.hp == 2)
	{
		alarm[0] = -1;
		alarm[4] = -1;
	}
	// Phase 4
	else if(obj_EnemyTwinhorn.hp == 1) alarm[0] = -1;
}

lightning_fx_create();
lightning_phase = "FLASH"

with(obj_EnemyGoldGrip) alarm[0] = 3;