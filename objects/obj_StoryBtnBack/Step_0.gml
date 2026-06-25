// Inherit the parent event
event_inherited();

// Initials sub-screen: obj_StoryModeFrame handles cancel / button focus
if (global.story_popup_screen == 1) exit;

if (InputMenuCancelPressed()) event_user(0);