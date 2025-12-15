/// @desc

// Inherit the parent event
event_inherited();

button_id = 1;
text = "PLAY";

TweenStart("x", x, x - 120, 0.5*GAMESPD, TWEENTYPE.CIRC_OUT, 0.2*GAMESPD);

// focus this button
event_user(1);