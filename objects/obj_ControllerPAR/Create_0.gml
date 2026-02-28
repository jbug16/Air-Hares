/// @desc Parent initialization for controller

// Record time elapsed
time_elapsed = 0;

// Lives (clear death flag so next death can trigger transition)
if(global.game_mode == GAMEMODE.STORY) {
	p1_lives = global.lives;
	global.death_transition_triggered = false;
} else {
	p1_lives = 1;
	global.death_transition_triggered = false;  // Arcade/free: allow tips transition on every death
}


// Set the speed of the parallax for grass, game object, etc
global.speed_parallax = 0.75;	// Multiplier for speed. Goes from 0.75 to 3 (player speed)

// Reset tally score
global.score_base = 0;
global.score_current = 0;

// Load level parameters for story mode
global.overworld_progress = global.story_mode_level[global.current_level][STORYPROP.OVERWORLD];
global.weather = global.story_mode_level[global.current_level][STORYPROP.WEATHER];
global.level_highscore = global.current_level;

// Multiplayer join flag
multiplayer_status[0][MPPROP.JOINED] = true;
multiplayer_status[1][MPPROP.JOINED] = false;
multiplayer_status[0][MPPROP.COOLDOWN] = 0; // Start with no MP cooldown
multiplayer_status[1][MPPROP.COOLDOWN] = 0;

level_completed = false; // Flag whether level has been completed successfully

// Combo parameters
global.combos_count = 0;
global.combos_multiplier = 1;
global.combos_multiplier_increase = false;
global.combos_pronoun = "";
combo_prev = global.combos_multiplier;		// combo count in previous step
combo_multiplier1 = 0;	// timer for combo pop-up
combo_multiplier2 = 0;	// timer for combo pop-up

// hp flash when hit
hp_prev1 = 0;
hp_prev2 = 0;
hp_flash_max = 10;
hp_flash1 = 0;
hp_flash_on1 = false;
hp_flash_on2 = false;
hp_flash2 = 0;

// Falcon, period between falcon spawn during normal runs
falcon_counter = 0;
falcon_period = 300;

// Flag for whether there are splash due to flying over water.
splash = false;

// Parameter for duration of view shake and shake's strength
view_shake_duration = 0;
view_shake_range = 6;

// Frame skip, a vfx
frame_skip_duration = 0;

// GUI
instance_create_layer(1280 - 32, 132, layer, obj_GUICloudCounter);
instance_create_layer(1280 - 128, 132, layer, obj_GUIFeatherCounter);

// Background music
AudioBgmChange(global.bgm_gametrack[global.current_level]);
audio_sound_gain(global.bgm_playing, global.options_music, 0);


// READY sign
ready_sign_state = 0;
ready_sign_time[0] = 0.1*GAMESPD;				// delay, 0
array_push(ready_sign_time, GAMESPD);		// fade in, 1
array_push(ready_sign_time, 0.7*GAMESPD);	// delay, 2
array_push(ready_sign_time, GAMESPD);		// fade out, 3
alarm[0] = ready_sign_time[0];

if(room == rm_Level4_3FightBoss) instance_create_layer(0, 0, "Top_Weather", WeatherGetObject(WEATHER.CLEAR));
else
{
	if (global.current_level != 11)
	instance_create_layer(0, 0, "Top_Weather", WeatherGetObject(global.weather));
}
