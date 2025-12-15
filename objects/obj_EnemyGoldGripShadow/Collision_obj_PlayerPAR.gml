/// @desc Damage player if in parry
if (other.state == PLAYERSTATE.PARRY)
{
	other.trig_damaged_breaker = true;
	obj_EnemyGoldGrip.invincible = true;
}