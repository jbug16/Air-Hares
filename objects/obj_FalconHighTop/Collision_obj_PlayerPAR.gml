if (state == BOSS.INIT or state == BOSS.APPEAR) exit;

// Inherit the parent event
event_inherited();
if (other.hp_invincibility <= 0)
if (other.state != PLAYERSTATE.ROLL_LEFT and other.state != PLAYERSTATE.ROLL_RIGHT and other.state != PLAYERSTATE.LOOP 
	and other.state != PLAYERSTATE.PARRY) obj_BossHighTop.can_dive = false;