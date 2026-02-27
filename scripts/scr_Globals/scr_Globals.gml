/*
   ___                             _       _           _     
  / _ \__ _ _ __ ___   ___    __ _| | ___ | |__   __ _| |___ 
 / /_\/ _` | '_ ` _ \ / _ \  / _` | |/ _ \| '_ \ / _` | / __|
/ /_\\ (_| | | | | | |  __/ | (_| | | (_) | |_) | (_| | \__ \
\____/\__,_|_| |_| |_|\___|  \__, |_|\___/|_.__/ \__,_|_|___/
                             |___/                           
*/

// General
global.gamepad_connected = noone;		// Gamepad
global.gamepad_debug = false;			// Set to false to disable debug messages after testing
global.dev_mode = false;					// developer mode on/off
global.demo = false;					// demo mode (only levels 1-1, 2-2, 3-B)
global.version = "v1.0.20251102.01";
global.mouse_disable = false;
global.menu = false;

// Title _screen variables
global.game_mode = GAMEMODE.STORY;
global.current_level = 0;		// Current story mode level being played. (0-15)
global.story_mode_progress = 0;	// Current progress in story mode
global.arcade_max_unlocked = 0;	// Max level  ever unlocked for arcade (never decreases)

// Tips screen
global.tips_return_room = noone;
global.death_transition_triggered = false;	// Prevents multiple lives decrements while fade runs
	
// Gameplay & movement
global.armor_strength = 3;	// Hit points. When 0, will return for repair
global.ammo_max = 60;		// Maximum ammo for water and seed
global.lives = 4;			// story mode current lives
	
global.movement_bank_speed = 0.6;	// Bank speed;

global.movement_barrel_roll = 3;	// = 0; Barrel roll mechanic upgrade level default
global.movement_barrel_roll_max = 3;	// Max level
global.movement_barrel_roll_temp = 0;	// Temperature. Higher BR level allow higher temp
global.movement_barrel_roll_temp_increase = 1;	// Temperature increase per roll execute
global.movement_barrel_roll_temp_cooling = 1/30;	// How fast cooling per step.
	
global.movement_parry = 3;	// 0; Parry upgrade level. 0 means can't parry.
global.movement_loop = 1;	// 0; Loop de loop upgrade level. 0 is default, whcih means cant loop.

// Environment
global.overworld_progress = PLOTSTATE.BARREN;
global.speed_parallax = 1;
global.weather = WEATHER.CLEAR;
global.wind_on_off_time = GAMESPD*8;

// Rain particles to use
global.particle_type_rain = part_type_create();
part_type_shape(global.particle_type_rain,pt_shape_line);
part_type_size(global.particle_type_rain,2,3,0,0);
part_type_scale(global.particle_type_rain,0.05,0.05);
part_type_color1(global.particle_type_rain,8421504);
part_type_alpha1(global.particle_type_rain,1);
part_type_speed(global.particle_type_rain,15,15.50,0,0);
part_type_direction(global.particle_type_rain,258,263,0,0);
part_type_gravity(global.particle_type_rain,0,270);
part_type_orientation(global.particle_type_rain,260,260,0,0,0);
part_type_blend(global.particle_type_rain,1);
part_type_life(global.particle_type_rain,90,180);

// Score
global.score_base = 0;
global.score_current = 0;

// Sounds
global.bgm_playing = noone;
// game stages/level background music
global.bgm_gametrack[0] = snd_MusicStage1_1;	// stage 1
global.bgm_gametrack[1] = snd_MusicStage1_2;
global.bgm_gametrack[2] = snd_MusicStage1_3;
global.bgm_gametrack[3] = snd_MusicStage1_4Loop;
global.bgm_gametrack[4] = snd_MusicStage2_1;	// stage 2
global.bgm_gametrack[5] = snd_MusicStage2_2;
global.bgm_gametrack[6] = snd_MusicStage2_3;
global.bgm_gametrack[7] = snd_MusicStage2_4Loop;
global.bgm_gametrack[8] = snd_MusicStage3_1;	// stage 3
global.bgm_gametrack[9] = snd_MusicStage3_2;
global.bgm_gametrack[10] = snd_MusicStage3_3;
global.bgm_gametrack[11] = snd_MusicStage3_4Loop;
global.bgm_gametrack[12] = snd_MusicStage4_1;	// stage 4
global.bgm_gametrack[13] = snd_MusicStage4_2;
global.bgm_gametrack[14] = snd_MusicStage4_3;
global.bgm_gametrack[15] = snd_MusicStage4_4Loop;

// Currency
ini_open("save.sav");
global.currency_cloud = ini_read_real("currency", "cloud", 0);
global.currency_feather_blue = ini_read_real("currency", "blue", 0);
global.currency_feather_brown = ini_read_real("currency", "brown", 0);
global.currency_feather_black = ini_read_real("currency", "black", 0);
global.currency_feather_purple= ini_read_real("currency", "purple", 0);
global.currency_feather_hightop = ini_read_real("currency", "hightop", 0);
global.currency_feather_bigred = ini_read_real("currency", "bigred", 0);
global.currency_feather_goldgrip = ini_read_real("currency", "goldgrip", 0);
global.currency_feather_twinhorn = ini_read_real("currency", "twinhorn", 0);
ini_close();
	
// Highscore
ini_open("save.sav");
for(var i=0; i<=15; i+=1){
	global.highscore[i] = ini_read_real("highscore", i, 0);	
}
ini_close();

// Leaderboards
global.leaderboard_singleplayer = [];
global.leaderboard_coop = [];

global.leaderboard_name_singleplayer = "AirHares_Singleplayer";
global.leaderboard_name_coop = "AirHares_Coop";

global.leaderboard_upload_id_singleplayer = -1;
global.leaderboard_upload_id_coop = -1;
global.leaderboard_download_id_singleplayer = -1;
global.leaderboard_download_id_coop = -1;

// Load story mode progress
ini_open("save.sav");
global.story_mode_progress = ini_read_real("story", "progress", global.story_mode_progress);
global.arcade_max_unlocked = ini_read_real("arcade", "max_unlocked", global.arcade_max_unlocked);
// Test
//global.story_mode_progress = 16;
global.arcade_max_unlocked = 16;
ini_close();
	
// Options
// Load saved options value
ini_open("save.sav");
global.options_music = ini_read_real("options", "music", 1);
global.options_sfx = ini_read_real("options", "sfx", 1);
global.options_scanline = ini_read_real("options", "scanline", 1);
global.options_windowed = bool(ini_read_real("options", "windowed", 1));
global.options_res_h = ini_read_real("options", "resolution height", 720);
global.options_res_w = ini_read_real("options", "resolution width", 1280);
ini_close();
// Setup loaded options
window_set_fullscreen(!global.options_windowed);
window_set_size(global.options_res_w, global.options_res_h);
	
// Apply the options setting
audio_group_load(audiogroup_music);
audio_group_set_gain(audiogroup_default, global.options_sfx, 0);
audio_group_set_gain(audiogroup_music, global.options_music, 0);
// Scanline is applied at obj_CRTController

// Transition
//global.transition_art = noone;
//global.transition_target = noone;

// Global character selection
global.character_selected[0] = CHARACTER.RABBO;
global.character_selected[1] = CHARACTER.DIRK;

// Character Name
global.character_name[CHARACTER.RABBO] = "Captain Rabbo";
global.character_name[CHARACTER.DIRK] = "Dirk Doggo";

// Define character sprites here. Format: global.character_sprite[enum _character][enum _char_sprite]
global.character_sprite[CHARACTER.RABBO][CHARACTER_SPRITE.IDLE] = spr_RabboIdle;
global.character_sprite[CHARACTER.RABBO][CHARACTER_SPRITE.BANK_LEFT] = spr_RabboLeft;
global.character_sprite[CHARACTER.RABBO][CHARACTER_SPRITE.BANK_LEFT_MAX] = spr_RabboLeftMax;
global.character_sprite[CHARACTER.RABBO][CHARACTER_SPRITE.BANK_RIGHT] = spr_RabboRight;
global.character_sprite[CHARACTER.RABBO][CHARACTER_SPRITE.BANK_RIGHT_MAX] = spr_RabboRightMax;
global.character_sprite[CHARACTER.RABBO][CHARACTER_SPRITE.ROLL_LEFT] = spr_RabboRollLeft;
global.character_sprite[CHARACTER.RABBO][CHARACTER_SPRITE.ROLL_RIGHT] = spr_RabboRollRight;
global.character_sprite[CHARACTER.RABBO][CHARACTER_SPRITE.LOOP] = spr_RabboLoopDeLoop;
global.character_sprite[CHARACTER.RABBO][CHARACTER_SPRITE.PARRY] = spr_RabboParry;
global.character_sprite[CHARACTER.RABBO][CHARACTER_SPRITE.DEATH] = spr_RabboIdle;

global.character_sprite[CHARACTER.DIRK][CHARACTER_SPRITE.IDLE] = spr_DirkIdle;
global.character_sprite[CHARACTER.DIRK][CHARACTER_SPRITE.BANK_LEFT] = spr_DirkLeft;
global.character_sprite[CHARACTER.DIRK][CHARACTER_SPRITE.BANK_LEFT_MAX] = spr_DirkLeftMax;
global.character_sprite[CHARACTER.DIRK][CHARACTER_SPRITE.BANK_RIGHT] = spr_DirkRight;
global.character_sprite[CHARACTER.DIRK][CHARACTER_SPRITE.BANK_RIGHT_MAX] = spr_DirkRightMax;
global.character_sprite[CHARACTER.DIRK][CHARACTER_SPRITE.ROLL_LEFT] = spr_DirkRollLeft;
global.character_sprite[CHARACTER.DIRK][CHARACTER_SPRITE.ROLL_RIGHT] = spr_DirkRollRight;
global.character_sprite[CHARACTER.DIRK][CHARACTER_SPRITE.LOOP] = spr_DirkLoopDeLoop;
global.character_sprite[CHARACTER.DIRK][CHARACTER_SPRITE.PARRY] = spr_DirkParry;
global.character_sprite[CHARACTER.DIRK][CHARACTER_SPRITE.DEATH] = spr_DirkIdle;

// Actual levels
if(global.demo)
{
	global.story_mode_level[0][STORYPROP.ROOM] = rm_LevelX1Farm;		// First farm armor = 3;
	global.story_mode_level[0][STORYPROP.OVERWORLD] = PLOTSTATE.BARREN;
	global.story_mode_level[0][STORYPROP.WEATHER] = WEATHER.CLEAR;
	global.story_mode_level[0][STORYPROP.NAME] = "Barren Bunlands";
	
	global.story_mode_level[5][STORYPROP.ROOM] = rm_LevelX1Farm;
	global.story_mode_level[5][STORYPROP.OVERWORLD] = PLOTSTATE.BUDDING;
	global.story_mode_level[5][STORYPROP.WEATHER] = WEATHER.WIND_LEFT;
	global.story_mode_level[5][STORYPROP.NAME] = "Hopeful Hareway";
	
	global.story_mode_level[11][STORYPROP.ROOM] = rm_Level3_3FightBoss;
	global.story_mode_level[11][STORYPROP.OVERWORLD] = PLOTSTATE.BUSTING;
	global.story_mode_level[11][STORYPROP.WEATHER] = WEATHER.THUNDERSTORM;
	global.story_mode_level[11][STORYPROP.NAME] = "Lushy Lagmire";
}
else
{
	// STAGE 1 (levels 0-3)
	global.story_mode_level[0][STORYPROP.ROOM] = rm_LevelX1Farm;		// First farm armor = 3;
	global.story_mode_level[0][STORYPROP.OVERWORLD] = PLOTSTATE.BARREN;
	global.story_mode_level[0][STORYPROP.WEATHER] = WEATHER.CLEAR;
	global.story_mode_level[0][STORYPROP.NAME] = "Barren Bunlands";

	global.story_mode_level[1][STORYPROP.ROOM] = rm_LevelX1Farm;
	global.story_mode_level[1][STORYPROP.OVERWORLD] = PLOTSTATE.BARREN;	// Blue Falcon start spawns here
	global.story_mode_level[1][STORYPROP.WEATHER] = WEATHER.CLEAR;
	global.story_mode_level[1][STORYPROP.NAME] = "Barren Bunlands";

	global.story_mode_level[2][STORYPROP.ROOM] = rm_LevelX1Farm;
	global.story_mode_level[2][STORYPROP.OVERWORLD] = PLOTSTATE.BARREN;
	global.story_mode_level[2][STORYPROP.WEATHER] = WEATHER.CLEAR;
	global.story_mode_level[2][STORYPROP.NAME] = "Barren Bunlands";

	global.story_mode_level[3][STORYPROP.ROOM] = rm_Level1_3FightBoss;		// Second farm armor = 4;
	global.story_mode_level[3][STORYPROP.OVERWORLD] = PLOTSTATE.BARREN;
	global.story_mode_level[3][STORYPROP.WEATHER] = WEATHER.CLEAR;
	global.story_mode_level[3][STORYPROP.NAME] = "Barren Bunlands";

	// STAGE 2 (levels 4-7)
	global.story_mode_level[4][STORYPROP.ROOM] = rm_LevelX1Farm;	// Brown Falcon start spawn here
	global.story_mode_level[4][STORYPROP.OVERWORLD] = PLOTSTATE.BUDDING;
	global.story_mode_level[4][STORYPROP.WEATHER] = WEATHER.WIND_RIGHT;
	global.story_mode_level[4][STORYPROP.NAME] = "Hopeful Hareway";

	global.story_mode_level[5][STORYPROP.ROOM] = rm_LevelX1Farm;
	global.story_mode_level[5][STORYPROP.OVERWORLD] = PLOTSTATE.BUDDING;
	global.story_mode_level[5][STORYPROP.WEATHER] = WEATHER.WIND_LEFT;
	global.story_mode_level[5][STORYPROP.NAME] = "Hopeful Hareway";

	global.story_mode_level[6][STORYPROP.ROOM] = rm_LevelX1Farm;		// Third farm armor = 5;
	global.story_mode_level[6][STORYPROP.OVERWORLD] = PLOTSTATE.BUDDING;
	global.story_mode_level[6][STORYPROP.WEATHER] = WEATHER.ROTATING_WIND;
	global.story_mode_level[6][STORYPROP.NAME] = "Hopeful Hareway";

	global.story_mode_level[7][STORYPROP.ROOM] = rm_Level2_3FightBoss;	// Purple Falcon start spawn here
	global.story_mode_level[7][STORYPROP.OVERWORLD] = PLOTSTATE.BUDDING;
	global.story_mode_level[7][STORYPROP.WEATHER] = WEATHER.ROTATING_WIND;
	global.story_mode_level[7][STORYPROP.NAME] = "Hopeful Hareway";

	// STAGE 3 (levels 8-11)
	global.story_mode_level[8][STORYPROP.ROOM] = rm_LevelX1Farm;
	global.story_mode_level[8][STORYPROP.OVERWORLD] = PLOTSTATE.BUSTING;
	global.story_mode_level[8][STORYPROP.WEATHER] = WEATHER.THUNDERSTORM;
	global.story_mode_level[8][STORYPROP.NAME] = "Lushy Lagmire";

	global.story_mode_level[9][STORYPROP.ROOM] = rm_LevelX1Farm;		// Fourth farm armor = 6;
	global.story_mode_level[9][STORYPROP.OVERWORLD] = PLOTSTATE.BUSTING;
	global.story_mode_level[9][STORYPROP.WEATHER] = WEATHER.THUNDERSTORM;
	global.story_mode_level[9][STORYPROP.NAME] = "Lushy Lagmire";

	global.story_mode_level[10][STORYPROP.ROOM] = rm_LevelX1Farm;	// Boss fight
	global.story_mode_level[10][STORYPROP.OVERWORLD] = PLOTSTATE.BUSTING;
	global.story_mode_level[10][STORYPROP.WEATHER] = WEATHER.THUNDERSTORM;
	global.story_mode_level[10][STORYPROP.NAME] = "Lushy Lagmire";

	global.story_mode_level[11][STORYPROP.ROOM] = rm_Level3_3FightBoss;
	global.story_mode_level[11][STORYPROP.OVERWORLD] = PLOTSTATE.BUSTING;
	global.story_mode_level[11][STORYPROP.WEATHER] = WEATHER.THUNDERSTORM;
	global.story_mode_level[11][STORYPROP.NAME] = "Lushy Lagmire";

	// STAGE 4 (levels 12-15)
	global.story_mode_level[12][STORYPROP.ROOM] = rm_LevelX1Farm;
	global.story_mode_level[12][STORYPROP.OVERWORLD] = PLOTSTATE.BOOMING;
	global.story_mode_level[12][STORYPROP.WEATHER] = WEATHER.CLEAR;
	global.story_mode_level[12][STORYPROP.NAME] = "County Coney";

	global.story_mode_level[13][STORYPROP.ROOM] = rm_LevelX1Farm;		// Fourth farm armor = 6;
	global.story_mode_level[13][STORYPROP.OVERWORLD] = PLOTSTATE.BOOMING;
	global.story_mode_level[13][STORYPROP.WEATHER] = WEATHER.ROTATING_WIND;
	global.story_mode_level[13][STORYPROP.NAME] = "County Coney";

	global.story_mode_level[14][STORYPROP.ROOM] = rm_LevelX1Farm;	// Boss fight
	global.story_mode_level[14][STORYPROP.OVERWORLD] = PLOTSTATE.BOOMING;
	global.story_mode_level[14][STORYPROP.WEATHER] = WEATHER.THUNDERSTORM_WINDY;
	global.story_mode_level[14][STORYPROP.NAME] = "County Coney";


	global.story_mode_level[15][STORYPROP.ROOM] = rm_Level4_3FightBoss;
	global.story_mode_level[15][STORYPROP.OVERWORLD] = PLOTSTATE.BOOMING;
	global.story_mode_level[15][STORYPROP.WEATHER] = WEATHER.THUNDERSTORM_WINDY;
	global.story_mode_level[15][STORYPROP.NAME] = "County Coney";
}


// Input

// Keyboard
global.keymap = ds_map_create();
global.keymap[? INPUT.ANY] = [vk_anykey];
global.keymap[? INPUT.DOWN] = [vk_down];
global.keymap[? INPUT.LEFT] = [vk_left];
global.keymap[? INPUT.PARRY] = [ord("Q")];
global.keymap[? INPUT.RIGHT] = [vk_right];
global.keymap[? INPUT.SEED] = [vk_space];
global.keymap[? INPUT.UP] = [vk_up];
global.keymap[? INPUT.SHIFT] = [vk_shift];
global.keymap[? INPUT.WATER] = [ord("E")];
global.keymap[? INPUT.PAUSE] = [vk_escape];
global.keymap[? INPUT.LOOP_DE_LOOP] = [ord("Q"), vk_shift];
global.keymap[? INPUT.ROLL_LEFT] = [vk_left, vk_shift];
global.keymap[? INPUT.ROLL_RIGHT] = [vk_right, vk_shift];
global.keymap[? INPUT.MENU_SELECT] = [vk_enter, vk_space];
global.keymap[? INPUT.MENU_UP] = [vk_up];
global.keymap[? INPUT.MENU_DOWN] = [vk_down];
global.keymap[? INPUT.MENU_LEFT] = [vk_left];
global.keymap[? INPUT.MENU_RIGHT] = [vk_right];
global.keymap[? INPUT.TOGGLE_AIM] = [vk_enter];

// Gamepad
global.gpmap = ds_map_create();
global.gpmap[? INPUT.SEED] = [gp_face1];
global.gpmap[? INPUT.WATER] = [gp_face2];
global.gpmap[? INPUT.PARRY] = [gp_face3];
global.gpmap[? INPUT.UP] = [gp_padu];
global.gpmap[? INPUT.DOWN] = [gp_padd];
global.gpmap[? INPUT.LEFT] = [gp_padl];
global.gpmap[? INPUT.RIGHT] = [gp_padr];
global.gpmap[? INPUT.PAUSE] = [gp_start, gp_face2];
//global.gpmap[? INPUT.PAUSE] = [gp_start];
global.gpmap[? INPUT.LOOP_DE_LOOP] = [gp_face4];
global.gpmap[? INPUT.MENU_SELECT] = [gp_face1];
global.gpmap[? INPUT.MENU_UP] = [gp_padu];
global.gpmap[? INPUT.MENU_DOWN] = [gp_padd];
global.gpmap[? INPUT.MENU_LEFT] = [gp_padl];
global.gpmap[? INPUT.MENU_RIGHT] = [gp_padr];
global.gpmap[? INPUT.ROLL_RIGHT] = [gp_shoulderrb];
global.gpmap[? INPUT.ROLL_LEFT] = [gp_shoulderlb];
global.gpmap[? INPUT.TOGGLE_AIM] = [gp_shoulderr];

// Keyboard/gamepad names
global.key_names = ds_map_create();
global.key_names[? gp_face1] = "A";
global.key_names[? gp_face2] = "B";
global.key_names[? gp_face3] = "X";
global.key_names[? gp_face4] = "Y";
global.key_names[? gp_padd] = "Down";
global.key_names[? gp_padu] = "Up";
global.key_names[? gp_padl] = "Left";
global.key_names[? gp_padr] = "Right";
global.key_names[? gp_start] = "Start";
global.key_names[? gp_paddlel] = "?";
global.key_names[? gp_paddler] = "?";
global.key_names[? gp_shoulderl] = "L1";
global.key_names[? gp_shoulderlb] = "L2";
global.key_names[? gp_shoulderr] = "R1";
global.key_names[? gp_shoulderrb] = "R2";
global.key_names[? gp_select] = "Select";
global.key_names[? gp_axislh] = "L horizont axis";
global.key_names[? gp_axislv] = "L vert axis";
global.key_names[? gp_axisrh] = "R horizont axis";
global.key_names[? gp_axisrv] = "R vert axis";
global.key_names[? gp_stickr] = "R stick";
global.key_names[? gp_stickl] = "L stick";
global.key_names[? vk_add] = "+";
global.key_names[? vk_alt] = "Alt";
global.key_names[? vk_backspace] = "Bckspc";
global.key_names[? vk_control] = "Ctrl";
global.key_names[? vk_delete] = "Del";
global.key_names[? vk_down] = "Down";
global.key_names[? vk_enter] = "Enter";
global.key_names[? vk_escape] = "Esc";
global.key_names[? vk_f1] = "F1";
global.key_names[? vk_f2] = "F2";
global.key_names[? vk_f3] = "F3";
global.key_names[? vk_f4] = "F4";
global.key_names[? vk_f5] = "F5";
global.key_names[? vk_f6] = "F6";
global.key_names[? vk_f7] = "F7";
global.key_names[? vk_f8] = "F8";
global.key_names[? vk_f9] = "F9";
global.key_names[? vk_f10] = "F10";
global.key_names[? vk_f11] = "F11";
global.key_names[? vk_f12] = "F12";
global.key_names[? vk_home] = "Home";
global.key_names[? vk_insert] = "Insert";
global.key_names[? vk_end] = "End";
global.key_names[? vk_subtract] = "-";
global.key_names[? vk_pause] = "Pause";
global.key_names[? vk_divide] = "Divide";
global.key_names[? vk_multiply] = "*";
global.key_names[? vk_pagedown] = "Pg Dn";
global.key_names[? vk_pageup] = "Pg up";
global.key_names[? vk_printscreen] = "Pr Scr";
global.key_names[? vk_left] = "Left";
global.key_names[? vk_right] = "Right";
global.key_names[? vk_space] = "Space";
global.key_names[? vk_shift] = "Shift";
global.key_names[? vk_tab] = "Tab";
global.key_names[? vk_up] = "Up";
global.key_names[? vk_numpad0] = "Numpad 0";
global.key_names[? vk_numpad1] = "Numpad 1";
global.key_names[? vk_numpad2] = "Numpad 2";
global.key_names[? vk_numpad3] = "Numpad 3";
global.key_names[? vk_numpad4] = "Numpad 4";
global.key_names[? vk_numpad5] = "Numpad 5";
global.key_names[? vk_numpad6] = "Numpad 6";
global.key_names[? vk_numpad7] = "Numpad 7";
global.key_names[? vk_numpad8] = "Numpad 8";
global.key_names[? vk_numpad9] = "Numpad 9";
global.key_names[? ord("1")] = "1";
global.key_names[? ord("2")] = "2";
global.key_names[? ord("3")] = "3";
global.key_names[? ord("4")] = "4";
global.key_names[? ord("5")] = "5";
global.key_names[? ord("6")] = "6";
global.key_names[? ord("7")] = "7";
global.key_names[? ord("8")] = "8";
global.key_names[? ord("9")] = "9";
global.key_names[? ord("0")] = "0";
global.key_names[? ord("A")] = "A";
global.key_names[? ord("B")] = "B";
global.key_names[? ord("C")] = "C";
global.key_names[? ord("D")] = "D";
global.key_names[? ord("E")] = "E";
global.key_names[? ord("F")] = "F";
global.key_names[? ord("G")] = "G";
global.key_names[? ord("H")] = "H";
global.key_names[? ord("I")] = "I";
global.key_names[? ord("J")] = "J";
global.key_names[? ord("K")] = "K";
global.key_names[? ord("L")] = "L";
global.key_names[? ord("M")] = "M";
global.key_names[? ord("N")] = "N";
global.key_names[? ord("O")] = "O";
global.key_names[? ord("P")] = "P";
global.key_names[? ord("Q")] = "Q";
global.key_names[? ord("R")] = "R";
global.key_names[? ord("S")] = "S";
global.key_names[? ord("T")] = "T";
global.key_names[? ord("U")] = "U";
global.key_names[? ord("V")] = "V";
global.key_names[? ord("W")] = "W";
global.key_names[? ord("X")] = "X";
global.key_names[? ord("Y")] = "Y";
global.key_names[? ord("Z")] = "Z";

// Gameplay input from ini file
ini_open("save.sav");

var _input = [INPUT.LEFT, INPUT.RIGHT, INPUT.UP, INPUT.DOWN, INPUT.ROLL_LEFT, INPUT.ROLL_RIGHT, INPUT.PARRY, INPUT.SEED, INPUT.WATER, INPUT.LOOP_DE_LOOP, INPUT.TOGGLE_AIM];

for(var i = 0; i < array_length(_input); i++)
{
	// Keyboard
	var _input_string = ini_read_string("controls kb", string(_input[i]), "");
	if(_input_string != "")
	{
		_input_string = string_split(_input_string, "-");
		var _keys = [];
		for(var j = 0; j < array_length(_input_string); j++)
		{
			if(_input_string[j] != "") array_push(_keys, real(_input_string[j]));
		}
		
		global.keymap[? _input[i]] = _keys;
	}
	
	// Gamepad
	_input_string = ini_read_string("controls gp", string(_input[i]), "");
	if(_input_string != "")
	{
		_input_string = string_split(_input_string, "-");
		var _keys = [];
		for(var j = 0; j < array_length(_input_string); j++)
		{
			if(_input_string[j] != "") array_push(_keys, real(_input_string[j]));
		}
		
		global.gpmap[? _input[i]] = _keys;
	}
}

ini_close();