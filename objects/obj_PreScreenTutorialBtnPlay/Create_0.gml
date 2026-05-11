/// @desc
event_inherited();

button_id = 1;
text = "PLAY";

with (obj_PreScreenTutorialBtnSkip) {
	if (focus) event_user(2);
}
event_user(1);
