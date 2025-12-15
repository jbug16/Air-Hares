/// @desc
if(active)
{
	other.trig_paralyzed = true;
	active = false;
	
	if(other.state != PLAYERSTATE.ROLL_LEFT and other.state != PLAYERSTATE.ROLL_RIGHT)
		obj_EnemyTwinhorn.prep_3_psychic_dive = true;
}