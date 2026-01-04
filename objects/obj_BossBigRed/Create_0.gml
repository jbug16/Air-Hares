/*				***	DESCRIPTION ***
	The boss controls the whole level in a sense:
	- spawns the falcons before his appearance, and afterwards as well
	- delays next phases/sequences (time delay)
	
	#1 sequence (4 phases)
	The whole level functions as follows: For the first 4 waves (phases), the falcons appear in groups of 1-2-3-4 falcons.
	This is the 1st sequence. They attack and the player only needs to survive the phases and reach the next sequence.
	
	#2 sequence
	After the first sequence which consists of 4 phases, the next sequence is activated.
	Boss appears and calls in 4 of his falcon friends.
	This sequence consists of 4 phases which are split into 2 parts:
	- falcons diving (1 falcon for phase 1, 2 falcons in phase 2 etc.: 1-2-3-4)
	- boss diving after the falcons in each phase
	If the player is hit by one of the falcons in the first part of the phase, this part is repeated.
	If he is not hit (he either dodges all of them or defeats them), phase part2 takes place - boss dives.
	To progress to the next phase, the player must not be hit by any falcons in part1, and must hit the boss at least
	once in part2. It doesn't matter if the boss htis him or not!
	Last phase in sequence2 ends this level when the player hits the boss (part2 of phase4, sequence2).
*/

event_inherited();

//==========================================================
// ADJUSTABLE
//==========================================================
// Stats
hp = 4;
feather = 4;		// how many feathers will be dropped (each time hurt)
dive_spd = 18;		// when attacking, 30% increase when hurt and flying back
fly_in_spd = 8;	// after the dive or at 2nd sequence begin

// Falcon positions for the 1st part (without the boss)
falcon_positions[0] = [0.2*room_width, 0.5*room_width, 0.8*room_width];
falcon_positions[1] = [0.2*room_width, 0.4*room_width, 0.6*room_width, 0.8*room_width];
falcon_positions[2] = [0.17*room_width, 0.33*room_width, 0.5*room_width, 0.67*room_width, 0.83*room_width];
falcon_positions[3] = [0.1*room_width, 0.3*room_width, 0.5*room_width, 0.7*room_width, 0.9*room_width];
falcon_positions2 = [0.1*room_width, 0.3*room_width, 0.7*room_width, 0.9*room_width];	// 2nd sequence
time[0] = [GAMESPD, GAMESPD, GAMESPD, GAMESPD, 1.5*GAMESPD];		// sequence 1
time[1] = [0.7*GAMESPD];	// sequence 2



//==========================================================
// BACKEND
//==========================================================
// Boss sequence
sequence = 0;	// 0,1 - consists of 2 sequence phases below
seq_phase = -1;	// [0] falcons idle, [1] falcons diving [2] boss diving
state = BOSS.INIT;
state_prev = state;
speed_prev = speed;
dodge_dist = 0;
direction = 90;		// not needed?
hurt_delay = 0.5*GAMESPD; // how long after last hit can be hit again 
can_dive = true;	// boss can dive (falcons haven't hit the player)
parry_snd = false;	// parry sound bugfix


// Falcon goons
falcon_ids = array_create(4, noone);	// for 2nd sequence - remember for roost/dive
falcons_diving = false;
hp_lost_during_dive = 0;

// Animations
image_angle = 180;
for (var i = 0; i < BOSS.length; i++)
{
	sprite[i] = spr_EnemyBigRedSpawn;
}
sprite[BOSS.APPEAR] = spr_EnemyBigRedIdle;
sprite[BOSS.IDLE] = spr_EnemyBigRedIdle;
sprite[BOSS.ROOST] = spr_EnemyBigRedDive;
sprite[BOSS.DODGE] = spr_EnemyBigRedBudge;
sprite[BOSS.DIVE] = spr_EnemyBigRedDive;
sprite[BOSS.HURT] = spr_EnemyBigRedHurt;


// Shadow sprite
VfxShadow(id);