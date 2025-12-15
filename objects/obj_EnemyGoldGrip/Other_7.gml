/// @desc End evade

if(state == ENEMIES.EVADE)
{
	state = state_prev;
	sprite_index = sprite[state];
	exit;
}

trig_anim_end = true;