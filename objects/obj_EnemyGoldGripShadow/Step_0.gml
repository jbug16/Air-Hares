/// @desc

//==========================================================
// STATEMACHINE
//==========================================================
switch(state)
{
	
	//----------------------------------------------------------
	// Starting statemachine (wait)
	//----------------------------------------------------------
	case ENEMIES.INIT:
		target_id = instance_nearest(x, y, obj_PlayerPAR);
		state = ENEMIES.PREP;
		break;
		
	case ENEMIES.PREP:
		EnemyFaceTarget(target_id);
		break;
		
	//----------------------------------------------------------
	// Dive preparation
	//----------------------------------------------------------
	case ENEMIES.DIVE_PREP:
		// Launch control
		EnemyFaceTarget(target_id);
		dive_delay--;
		if(dive_delay <= 0)
		{
			_DiveSetup(0.3*GAMESPD, 20);
			state = ENEMIES.DIVE;
		}
		break;
		
	case ENEMIES.DIVE_2_PREP:
		// Launch control
		EnemyFaceTarget(target_id);
		dive_delay--;
		if(dive_delay <= 0)
		{
			_DiveSetup(0.25*GAMESPD, 25);
			state = ENEMIES.DIVE;
		}
		break;
		
	case ENEMIES.DIVE_3_PREP:
		// Launch control
		EnemyFaceTarget(target_id);
		dive_delay--;
		if(dive_delay <= 0)
		{
			_DiveSetup(0.2*GAMESPD, 28);
			state = ENEMIES.DIVE;
		}
		break;
		
	case ENEMIES.DIVE_4_PREP:
		// Launch control
		EnemyFaceTarget(target_id);
		dive_delay--;
		if(dive_delay <= 0)
		{
			_DiveSetup(0.2*GAMESPD, 28);
			state = ENEMIES.DIVE;
		}
		break;
		
	//----------------------------------------------------------
	// Ending states (dive and after)
	//----------------------------------------------------------
	case ENEMIES.DIVE:
		if(y > 1280 or x < -384 or x > (room_width + 384)) state = ENEMIES.DESTROY;	
		break;
	case ENEMIES.HIT:
		break;
	case ENEMIES.DESTROY:
		instance_destroy();
		break;
}

target_id = instance_nearest(x, y, obj_PlayerPAR);

//----------------------------------------------------------
// Sprite changes
//----------------------------------------------------------
if(sprite_index != sprite[state]) sprite_index = sprite[state];