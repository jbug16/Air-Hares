/// @desc

// Inherit the parent event
event_inherited();

text = "CONTINUE";
button_id = 1;
if (StoryHasMainMenuContinue()) {
	event_user(1); // default selection when save exists
} else {
	visible = false;
}
TweenStart("x", x, x - 100, 0.5*GAMESPD, TWEENTYPE.CIRC_OUT, 0.2*GAMESPD);