// Spawn the interface
/*
Controls
SFX Slider
Music Slider
Graphics
Tutorial
Credits
Back
*/

menu_selected = 0;
menu_draw = false;
in_controls = false;
in_graphics = false;
in_scores = false;
in_achievements = false;
in_saves = false;
in_leaderboards = false;
from_title_menu = false;
alarm[0] = 30;
control_alpha = 1;
blink_dur = 0.5*GAMESPD;

menu = OptionsMainMenuLabels();
menu_status = array_create(array_length(menu), "");
menu_status[1] = string(round(global.options_music * 100));
menu_status[2] = string(round(global.options_sfx * 100));
menu_count = array_length(menu);


key_keyboard[0] = "";
key_joypad[0] = "";

// Remembering previous mouse coords
mouse_prev_x = mouse_x;
mouse_prev_y = mouse_y;

// For input change
input[0] = INPUT.LEFT;
input[1] = INPUT.RIGHT;
input[2] = INPUT.UP;
input[3] = INPUT.DOWN;
input[4] = INPUT.ROLL_LEFT;
input[5] = INPUT.ROLL_RIGHT;
input[6] = INPUT.PARRY;
input[7] = INPUT.SEED;
input[8] = INPUT.WATER;
input[9] = INPUT.LOOP_DE_LOOP;
input[10] = INPUT.TOGGLE_AIM;

input_captured = false; // flag if new input for control is captured