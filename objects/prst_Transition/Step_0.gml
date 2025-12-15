/// @desc
switch(trans_state){
	case TRANSITION_STATE.IDLE:
		// Trans when triggered
		if trans_trigger {
			trans_trigger = false;
			trans_state = TRANSITION_STATE.FADE_OUT;
		}
		break;
	case TRANSITION_STATE.FADE_OUT:
		trans_alpha += trans_alpha_diff;
		if trans_alpha >= 1 {
			trans_state = TRANSITION_STATE.SWITCH;	
		}
		break;
	case TRANSITION_STATE.SWITCH:
		if(trans_target == noone) break;
		room_goto(trans_target);
		trans_target = noone;
		trans_state = TRANSITION_STATE.FADE_IN;
		break;
	case TRANSITION_STATE.FADE_IN:
		trans_alpha -= trans_alpha_diff;
		if trans_alpha <= 0 {
			trans_state = TRANSITION_STATE.IDLE;	
		}
		break;
}