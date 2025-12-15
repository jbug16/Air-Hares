/// @desc Freeze&confuse the player
if(active)
{
	other.trig_paralyzed = true;
	other.trig_confused = true;
	active = false;
	
	// If player in barrel roll - evades this attack
	if(other.state == PLAYERSTATE.ROLL_LEFT or other.state == PLAYERSTATE.ROLL_RIGHT)
		obj_EnemyTwinhorn.prep_4_panic_passed = true;
	else obj_EnemyTwinhorn.prep_4_panic_dive = true;
}