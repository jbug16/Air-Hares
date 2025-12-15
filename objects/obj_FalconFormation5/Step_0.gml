/// @desc
switch(state){
	case 0:
		// Create two from spawner
		switch(spawner_type){
			case obj_EnemyFalconBlackSpawner:
			case obj_EnemyFalconBlueSpawner:
				spawn[0] = instance_create_layer(213, 960, "Top", spawner_type);
				spawn[1] = instance_create_layer(213 * 2, 960, "Top", spawner_type);
				spawn[2] = instance_create_layer(213 * 3, 960, "Top", spawner_type);
				spawn[3] = instance_create_layer(213 * 4, 960, "Top", spawner_type);
				spawn[4] = instance_create_layer(213 * 5, 960, "Top", spawner_type);
				spawn[0].timer_prepare = 140;
				spawn[1].timer_prepare = 160;
				spawn[2].timer_prepare = 140;
				spawn[3].timer_prepare = 160;
				spawn[4].timer_prepare = 140;
				spawn[irandom(4)].timer_prepare = 200;
				break;
			case obj_EnemyFalconBrownSpawner:
				var _roll = random(1);
				if _roll < 0.3 {
					// 30% chance for all direct attack
					spawn[0] = instance_create_layer(213, 960, "Top", obj_EnemyFalconBrownSpawnerAttackDirect);
					spawn[1] = instance_create_layer(213 * 2, 960, "Top", obj_EnemyFalconBrownSpawnerAttackDirect);
					spawn[2] = instance_create_layer(213 * 3, 960, "Top", obj_EnemyFalconBrownSpawnerAttackDirect);
					spawn[3] = instance_create_layer(213 * 4, 960, "Top", obj_EnemyFalconBrownSpawnerAttackDirect);
					spawn[4] = instance_create_layer(213 * 5, 960, "Top", obj_EnemyFalconBrownSpawnerAttackDirect);
					//spawn[0].timer_prepare = choose(40, 50);
					//spawn[1].timer_prepare = choose(40, 50);
					//spawn[2].timer_prepare = choose(40, 50);
					//spawn[3].timer_prepare = choose(40, 50);
					//spawn[4].timer_prepare = choose(40, 50);
					//spawn[irandom(4)].timer_prepare = 95;	
				} else if _roll < 0.6 {
					// 2x normal, 3x direct
					spawn[0] = instance_create_layer(213, 960, "Top", obj_EnemyFalconBrownSpawnerAttackDirect);
					spawn[1] = instance_create_layer(213 * 2, 960, "Top", obj_EnemyFalconBrownSpawnerAttackNormal);
					spawn[2] = instance_create_layer(213 * 3, 960, "Top", obj_EnemyFalconBrownSpawnerAttackDirect);
					spawn[3] = instance_create_layer(213 * 4, 960, "Top", obj_EnemyFalconBrownSpawnerAttackNormal);
					spawn[4] = instance_create_layer(213 * 5, 960, "Top", obj_EnemyFalconBrownSpawnerAttackDirect);
					//spawn[0].timer_prepare = choose(40, 50);
					//spawn[1].timer_prepare = 160;
					//spawn[2].timer_prepare = choose(40, 50);
					//spawn[3].timer_prepare = 155;
					//spawn[4].timer_prepare = choose(40, 50);
					//spawn[choose(0,2,4)].timer_prepare = 95;	
				} else {
					// 4x normal, 1x direct
					spawn[0] = instance_create_layer(213, 960, "Top", obj_EnemyFalconBrownSpawnerAttackNormal);
					spawn[1] = instance_create_layer(213 * 2, 960, "Top", obj_EnemyFalconBrownSpawnerAttackNormal);
					spawn[2] = instance_create_layer(213 * 3, 960, "Top", obj_EnemyFalconBrownSpawnerAttackDirect);
					spawn[3] = instance_create_layer(213 * 4, 960, "Top", obj_EnemyFalconBrownSpawnerAttackNormal);
					spawn[4] = instance_create_layer(213 * 5, 960, "Top", obj_EnemyFalconBrownSpawnerAttackNormal);
					//spawn[0].timer_prepare = 110;
					//spawn[1].timer_prepare = 120;
					//spawn[2].timer_prepare = 70;
					//spawn[3].timer_prepare = 130;
					//spawn[4].timer_prepare = 190;
				}
				break;
			case obj_EnemyFalconPurpleSpawner:
				var _roll = random(1);
				if _roll < 0.3 {
					// 30% chance for all direct attack
					spawn[0] = instance_create_layer(213, 960, "Top", obj_EnemyFalconPurpleSpawnerAttackDirect);
					spawn[1] = instance_create_layer(213 * 2, 960, "Top", obj_EnemyFalconPurpleSpawnerAttackDirect);
					spawn[2] = instance_create_layer(213 * 3, 960, "Top", obj_EnemyFalconPurpleSpawnerAttackDirect);
					spawn[3] = instance_create_layer(213 * 4, 960, "Top", obj_EnemyFalconPurpleSpawnerAttackDirect);
					spawn[4] = instance_create_layer(213 * 5, 960, "Top", obj_EnemyFalconPurpleSpawnerAttackDirect);
					spawn[0].timer_prepare = choose(40, 50);
					spawn[1].timer_prepare = choose(40, 50);
					spawn[2].timer_prepare = choose(40, 50);
					spawn[3].timer_prepare = choose(40, 50);
					spawn[4].timer_prepare = choose(40, 50);
					spawn[irandom(4)].timer_prepare = 90;		
				} else if _roll < 0.6 {
					// 2x normal, 3x direct
					spawn[0] = instance_create_layer(213, 960, "Top", obj_EnemyFalconPurpleSpawnerAttackDirect);
					spawn[1] = instance_create_layer(213 * 2, 960, "Top", obj_EnemyFalconPurpleSpawnerAttackNormal);
					spawn[2] = instance_create_layer(213 * 3, 960, "Top", obj_EnemyFalconPurpleSpawnerAttackDirect);
					spawn[3] = instance_create_layer(213 * 4, 960, "Top", obj_EnemyFalconPurpleSpawnerAttackNormal);
					spawn[4] = instance_create_layer(213 * 5, 960, "Top", obj_EnemyFalconPurpleSpawnerAttackDirect);
					spawn[0].timer_prepare = choose(40, 50);
					spawn[1].timer_prepare = 160;
					spawn[2].timer_prepare = choose(40, 50);
					spawn[3].timer_prepare = 155;
					spawn[4].timer_prepare = choose(40, 50);
					spawn[choose(0,2,4)].timer_prepare = 90;
				} else {
					// 4x normal, 1x direct
					spawn[0] = instance_create_layer(213, 960, "Top", obj_EnemyFalconPurpleSpawnerAttackNormal);
					spawn[1] = instance_create_layer(213 * 2, 960, "Top", obj_EnemyFalconPurpleSpawnerAttackNormal);
					spawn[2] = instance_create_layer(213 * 3, 960, "Top", obj_EnemyFalconPurpleSpawnerAttackDirect);
					spawn[3] = instance_create_layer(213 * 4, 960, "Top", obj_EnemyFalconPurpleSpawnerAttackNormal);
					spawn[4] = instance_create_layer(213 * 5, 960, "Top", obj_EnemyFalconPurpleSpawnerAttackNormal);
					spawn[0].timer_prepare = 110;
					spawn[1].timer_prepare = 115;
					spawn[2].timer_prepare = 70;
					spawn[3].timer_prepare = 120;
					spawn[4].timer_prepare = 125;
					spawn[choose(0,1,3,4)].timer_prepare = 170;
				}
				break;
		}
		state = 1;
		break;
	case 1:
		instance_destroy();
		break;
}