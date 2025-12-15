/// @desc This object controls falcon formation. 3 criss cross


function state_trans(_state_next, _state_wait = 0){
	state_next = _state_next;
	state_wait = _state_wait;
	state = ENEMIES.WAIT;
}

state = ENEMIES.INIT;
state_next = noone;
state_wait = 0;