/// @desc
switch(state){
	case 0:
		// Create two from spawner
		switch(spawner_type){
			case obj_EnemyFalconBlackSpawner:
			case obj_EnemyFalconBlueSpawner:
				spawn[0] = instance_create_layer(250, 960, "Top", spawner_type);
				spawn[1] = instance_create_layer(500, 960, "Top", spawner_type);
				spawn[2] = instance_create_layer(750, 960, "Top", spawner_type);
				spawn[3] = instance_create_layer(1000, 960, "Top", spawner_type);
				spawn[0].timer_prepare = 150;
				spawn[1].timer_prepare = 150;
				spawn[2].timer_prepare = 150;
				spawn[3].timer_prepare = 150;
				spawn[irandom(3)].timer_prepare = 220;
				break;
			case obj_EnemyFalconBrownSpawner:
				var _roll = random(1);
				if _roll < 0.3 {
					// 30% chance for all direct attack
					spawn[0] = instance_create_layer(250, 960, "Top", obj_EnemyFalconBrownSpawnerAttackDirect);
					spawn[1] = instance_create_layer(500, 960, "Top", obj_EnemyFalconBrownSpawnerAttackDirect);
					spawn[2] = instance_create_layer(750, 960, "Top", obj_EnemyFalconBrownSpawnerAttackDirect);
					spawn[3] = instance_create_layer(1000, 960, "Top", obj_EnemyFalconBrownSpawnerAttackDirect);
					spawn[0].timer_prepare = 45;
					spawn[1].timer_prepare = 50;
					spawn[2].timer_prepare = 55;
					spawn[3].timer_prepare = 60;
					spawn[irandom(3)].timer_prepare = 70;	
				} else if _roll < 0.6 {
					// 2x normal, 1x direct
					spawn[0] = instance_create_layer(250, 960, "Top", obj_EnemyFalconBrownSpawnerAttackNormal);
					spawn[1] = instance_create_layer(500, 960, "Top", obj_EnemyFalconBrownSpawnerAttackNormal);
					spawn[2] = instance_create_layer(750, 960, "Top", obj_EnemyFalconBrownSpawnerAttackNormal);
					spawn[3] = instance_create_layer(1000, 960, "Top", obj_EnemyFalconBrownSpawnerAttackDirect);
					spawn[0].timer_prepare = 110;
					spawn[2].timer_prepare = 110;
					spawn[1].timer_prepare = 140;
					spawn[3].timer_prepare = 140;
				} else {
					// 2x direct attack, 1x normal attack
					spawn[0] = instance_create_layer(250, 960, "Top", obj_EnemyFalconBrownSpawnerAttackDirect);
					spawn[1] = instance_create_layer(500, 960, "Top", obj_EnemyFalconBrownSpawnerAttackDirect);
					spawn[2] = instance_create_layer(750, 960, "Top", obj_EnemyFalconBrownSpawnerAttackNormal);
					spawn[3] = instance_create_layer(1000, 960, "Top", obj_EnemyFalconBrownSpawnerAttackDirect);
					spawn[0].timer_prepare = 50;
					spawn[2].timer_prepare = 50;
					spawn[1].timer_prepare = 120;
					spawn[3].timer_prepare = 120;
				}
				break;
			case obj_EnemyFalconPurpleSpawner:
				var _roll = random(1);
				if _roll < 0.3 {
					// 30% chance for all direct attack
					//spawn[0] = instance_create_layer(250, 960, "Top", obj_EnemyFalconBrownSpawnerAttackDirect);
					//spawn[1] = instance_create_layer(500, 960, "Top", obj_EnemyFalconBrownSpawnerAttackDirect);
					//spawn[2] = instance_create_layer(750, 960, "Top", obj_EnemyFalconBrownSpawnerAttackDirect);
					//spawn[3] = instance_create_layer(1000, 960, "Top", obj_EnemyFalconBrownSpawnerAttackDirect);
					spawn[0] = instance_create_layer(250, 960, "Top", obj_EnemyFalconPurpleSpawnerAttackDirect);
					spawn[1] = instance_create_layer(500, 960, "Top", obj_EnemyFalconPurpleSpawnerAttackDirect);
					spawn[2] = instance_create_layer(750, 960, "Top", obj_EnemyFalconPurpleSpawnerAttackDirect);
					spawn[3] = instance_create_layer(1000, 960, "Top", obj_EnemyFalconPurpleSpawnerAttackDirect);
					spawn[0].timer_prepare = 45;
					spawn[1].timer_prepare = 50;
					spawn[2].timer_prepare = 55;
					spawn[3].timer_prepare = 60;
					spawn[irandom(3)].timer_prepare = 60;	
				} else if _roll < 0.6 {
					// 2x normal, 1x direct
					spawn[0] = instance_create_layer(250, 960, "Top", obj_EnemyFalconPurpleSpawnerAttackNormal);
					spawn[1] = instance_create_layer(500, 960, "Top", obj_EnemyFalconPurpleSpawnerAttackDirect);
					spawn[2] = instance_create_layer(750, 960, "Top", obj_EnemyFalconPurpleSpawnerAttackNormal);
					spawn[3] = instance_create_layer(1000, 960, "Top", obj_EnemyFalconPurpleSpawnerAttackDirect);
					spawn[0].timer_prepare = 100;
					spawn[1].timer_prepare = 140;
					spawn[3].timer_prepare = 140;
					spawn[2].timer_prepare = 100;			
				} else {
					// 2x direct attack, 1x normal attack
					spawn[0] = instance_create_layer(250, 960, "Top", obj_EnemyFalconPurpleSpawnerAttackNormal);
					spawn[1] = instance_create_layer(500, 960, "Top", obj_EnemyFalconPurpleSpawnerAttackNormal);
					spawn[2] = instance_create_layer(750, 960, "Top", obj_EnemyFalconPurpleSpawnerAttackNormal);
					spawn[3] = instance_create_layer(1000, 960, "Top", obj_EnemyFalconPurpleSpawnerAttackDirect);
					spawn[0].timer_prepare = 50;
					spawn[1].timer_prepare = 110;
					spawn[3].timer_prepare = 70;
					spawn[2].timer_prepare = 50;
				}
				break;
		}
		state = 1;
		break;
	case 1:
		instance_destroy();
		break;
}