/// @desc Send psychic/panic attack

// Psychic attack
if(hp == 2)
{
	prep_3_initial_psychic = true;
	state = ENEMIES.ATTACK_3_PSYCHIC;
}
// Panic attack
else if(hp == 1) state = ENEMIES.ATTACK_4_PANIC;