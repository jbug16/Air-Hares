/// @desc

// Inherit the parent event
event_inherited();

text = "NEW";
button_id = 2;
if (!StoryHasMainMenuContinue()) {
	event_user(1); // default focus when Continue is hidden
}