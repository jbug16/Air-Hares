
// Inherit the parent event
event_inherited();

if (global.game_mode == GAMEMODE.STORY) global.current_level = global.story_mode_progress - 1;
room_restart();