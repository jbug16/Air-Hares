///@desc Skip phases
if ((InputGet(INPUT.ANY) or (!global.mouse_disable and mouse_check_button_pressed(mb_any))) and alarm[4] < 0)
{
	TweenStop();
	alarm[4] = 2*GAMESPD;	// disable input
	if (phase == 0)			// poem
	{
		text0_line_alpha = 1;
		text0_lines = array_length(text0);
		alarm[0] = -1
		event_perform(ev_alarm, 0);		
	}
	else if (phase == 1)	// credits roll
	{
		alarm[2] = -1
		event_perform(ev_alarm, 2);
	}
	else if (phase == 2)	// logo
	{
		event_perform(ev_alarm, 3);	
	}
}

// Options → Credits keeps the title theme. The ending sequence crossfades.
if (!from_options) EndingCreditsMaintainMusic();
