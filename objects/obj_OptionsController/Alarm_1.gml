/// @desc Control buttons blink
if(control_alpha == 0) TweenStart("control_alpha", control_alpha, 1, blink_dur, TWEENTYPE.LINEAR);
else TweenStart("control_alpha", control_alpha, 0, blink_dur, TWEENTYPE.LINEAR)

alarm[1] = blink_dur;