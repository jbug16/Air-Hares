/// @desc Skip all
if(alarm[10] > 0) exit;

// Mapped input
var _mapped = [INPUT.MENU_DOWN, INPUT.MENU_LEFT, INPUT.MENU_RIGHT, INPUT.MENU_SELECT, INPUT.MENU_UP,
	INPUT.LEFT, INPUT.RIGHT, INPUT.UP, INPUT.DOWN, INPUT.SEED, INPUT.ROLL_LEFT, INPUT.ROLL_RIGHT,
	INPUT.PARRY, INPUT.WATER, INPUT.LOOP_DE_LOOP];
			
for(var i = 0; i < array_length(_mapped); i++)
{
	if (InputGet(_mapped[i]) or (!global.mouse_disable and mouse_check_button_pressed(mb_left))) event_perform(ev_alarm, 2);	
}


// Hardcoded input
var _hardcoded_kb = [vk_enter, vk_escape];
var _hardcoded_gp = InputGpSplashAdvanceButtons();

for(var i = 0; i < array_length(_hardcoded_kb); i++)
{
	if(keyboard_check_pressed(_hardcoded_kb[i])) event_perform(ev_alarm, 2);
}

for(var i = 0; i < gamepad_get_device_count(); i++)
{
	if(gamepad_is_connected(i))
	{
		for(var j = 0; j < array_length(_hardcoded_gp); j++)
		{
			if(gamepad_button_check_pressed(i, _hardcoded_gp[j])) event_perform(ev_alarm, 2);
		}
	}
}