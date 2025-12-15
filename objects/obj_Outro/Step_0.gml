/// @desc

if(alarm[10] > 0) exit;

var _mapped = [INPUT.MENU_DOWN, INPUT.MENU_LEFT, INPUT.MENU_RIGHT, INPUT.MENU_SELECT, INPUT.MENU_UP,
	INPUT.LEFT, INPUT.RIGHT, INPUT.UP, INPUT.DOWN, INPUT.SEED, INPUT.ROLL_LEFT, INPUT.ROLL_RIGHT,
	INPUT.PARRY, INPUT.WATER, INPUT.LOOP_DE_LOOP];
			
for(var i = 0; i < array_length(_mapped); i++)
{
	if (InputGet(_mapped[i]) or (!global.mouse_disable and mouse_check_button_pressed(mb_left))) event_user(1);
}