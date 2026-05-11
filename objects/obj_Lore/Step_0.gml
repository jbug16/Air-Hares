/// @desc

if(alarm[10] > 0 or alarm[0] > 0 or alarm[2] > 0) exit;

var _next_index = [INPUT.MENU_DOWN, INPUT.MENU_LEFT, INPUT.MENU_RIGHT, INPUT.MENU_SELECT, INPUT.MENU_UP,
	INPUT.LEFT, INPUT.RIGHT, INPUT.UP, INPUT.DOWN, INPUT.SEED, INPUT.ROLL_LEFT, INPUT.ROLL_RIGHT,
	INPUT.PARRY, INPUT.WATER, INPUT.LOOP_DE_LOOP];

var _done = false;
	
for(var i = 0; i < array_length(_next_index); i++)
{
	if (InputGet(_next_index[i]) or (!global.mouse_disable and mouse_check_button_pressed(mb_left)))
	{
		if(image_index < image_number - 1)
		{
			//image_index++;
			TweenStart("fade_alpha", 0, 1, fade_time, TWEENTYPE.LINEAR);
			alarm[0] = fade_time;
		}
		else _done = true;
		break;
	}
}

if(InputGet(INPUT.PAUSE) or _done)
{
	TweenStart("fade_alpha", fade_alpha, 1, fade_time, TWEENTYPE.LINEAR);
	alarm[2] = fade_time;
}