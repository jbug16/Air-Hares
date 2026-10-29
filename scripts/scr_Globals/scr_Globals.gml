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
global.dev_mode = false;				// developer mode on/off
global.demo = false;					// demo mode (only levels 1-1, 2-2, 3-B)
global.version = "v1.0.20260818.01";
global.mouse_disable = false;
global.menu = false;

// Title _screen variables
global.game_mode = GAMEMODE.STORY;
global.current_level = 0;		// Current story mode level being played. (0-15)
global.story_mode_progress = 0;	// Current progress in story mode
global.arcade_max_unlocked = 0;	// Max level ever unlocked for arcade (starts locked; never decreases)
// Main-menu Story popup: 0 = Continue/New/Back, 1 = New Story Game (initials + Continue/Back)
global.story_popup_screen = 0;
global.story_new_initials = "";
// After New Story + tutorial: first 1-1 farm with no enemies/score/medals; then real 1-1.
global.story_peaceful_intro_farm = false;
// Options → Tutorial slideshow → peaceful farm practice (does not change story progress).
global.tutorial_from_options = false;
global.options_peaceful_practice = false;
global.peaceful_practice_saved_level = 0;
global.peaceful_practice_saved_progress = 0;
global.main_menu_open_options = false;
// After practice skip pre-screen: open Options with same fade as obj_Tutorial → Options (not instant TitleBtnOptions path).
global.main_menu_open_options_tutorial_fade = false;
// Arcade level popup: 0 = level + Play/Back, 1 = initials + Continue/Back
global.arcade_popup_screen = 0;
global.arcade_new_initials = "";
global.virtual_keyboard_active = false;
global.virtual_keyboard_context = "";
global.virtual_keyboard_saved = "";

// Co-op drop-in: portrait select (obj_Pause freeze + obj_ControllerPAR UI)
global.pause_coop_portrait_select = false;
global.coop_portrait_select_device = 0;
global.coop_portrait_select_index = 0;
global.coop_portrait_select_ignore_confirm = 0;

// Controller hot-plug guard (Switch): drop-in join debounce + reconnect-pause state.
// gp_join_ready[slot] counts consecutive frames a pad has been connected AND idle so
// re-enumerated Joy-Cons cannot trigger a phantom P2 join (see ControllerJoinReadyUpdate).
global.gp_join_ready = array_create(12, 0);
// True while gameplay is frozen waiting for P1's controller to reconnect.
global.controller_reconnect_wait = false;
// Slot reserved for a still-connected P2 during a P1 reconnect wait (noone if solo).
global.controller_reconnect_exclude = noone;
// Consecutive frames a live player has had no valid controller (grace before pausing).
global.controller_unbound_frames = 0;

global.coop_portrait_sprite[0] = spr_DirkIcon;
global.coop_portrait_sprite[1] = spr_LinnieIcon;
global.coop_portrait_sprite[2] = spr_BettyIcon;
global.coop_portrait_sprite[3] = spr_CandieIcon;

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
SaveIniOpen();
global.currency_cloud = SaveIniReadReal("currency", "cloud", 0);
global.currency_feather_blue = SaveIniReadReal("currency", "blue", 0);
global.currency_feather_brown = SaveIniReadReal("currency", "brown", 0);
global.currency_feather_black = SaveIniReadReal("currency", "black", 0);
global.currency_feather_purple= SaveIniReadReal("currency", "purple", 0);
global.currency_feather_hightop = SaveIniReadReal("currency", "hightop", 0);
global.currency_feather_bigred = SaveIniReadReal("currency", "bigred", 0);
global.currency_feather_goldgrip = SaveIniReadReal("currency", "goldgrip", 0);
global.currency_feather_twinhorn = SaveIniReadReal("currency", "twinhorn", 0);
SaveIniClose();
	
// Highscore (arcade per-level) + initials for who set the record
global.highscore_initials = array_create(16, "");
SaveIniOpen();
for (var i = 0; i <= 15; i += 1) {
	global.highscore[i] = SaveIniReadReal("highscore", i, 0);
	global.highscore_initials[i] = SaveIniReadString("highscore_initials", string(i), "");
}
SaveIniClose();

// Leaderboards (local JSON: rank + score entries for UI)
global.leaderboard_singleplayer = [];
global.leaderboard_coop = [];
// Use a dedicated file so old per-mission entries don't mix with cumulative story-run scores.
global.leaderboard_json_filename = SaveGetLeaderboardFilename();
global.leaderboard_max_entries = 10;

// Story Mode run tracking (cumulative full-run score for leaderboards)
global.story_run_active = false;
global.story_run_score_cumulative = 0;
global.story_run_level_scores = array_create(16, 0);
global.story_run_level_scores_set = array_create(16, false);
global.story_run_initials = "";
global.story_run_ever_coop = false;

// Farm level 100% crop completion (per level index 0–15), local save only
global.achievement_farm100 = array_create(16, false);
// No-damage / no-aggression per story level (0–15); persisted when gameplay sets them
global.achievement_no_damage = array_create(16, false);
global.achievement_no_aggression = array_create(16, false);
// Mission-complete UI: medals newly unlocked this clear (set by AchievementMarkUnlocked, cleared when UI reads)
global.mission_ach_just_earned_farm100 = false;
global.mission_ach_just_earned_no_damage = false;
global.mission_ach_just_earned_no_aggression = false;
// Mission-complete UI: whether each challenge was met on this clear only (consumed by score UI Create)
global.mission_run_farm100_met = false;
global.mission_run_no_damage_met = false;
global.mission_run_no_aggression_met = false;
// True if any obj_PlayerRabbo took HP damage this level run (medal tracking)
global.level_run_any_hp_damage = false;
// True if player seed/water hit an enemy via EnemyBirdPAR hit helpers (medal tracking)
global.level_run_ammo_aggression = false;

// Load story mode progress
SaveIniOpen();
global.story_mode_progress = SaveIniReadReal("story", "progress", global.story_mode_progress);
global.arcade_max_unlocked = SaveIniReadReal("arcade", "max_unlocked", global.arcade_max_unlocked);
global.player_initials = SaveIniReadString("leaderboard", "initials", "---");

// Load story run tracking (if a run was mid-way when the game was last closed)
global.story_run_active = bool(SaveIniReadReal("story_run", "active", 0));
global.story_run_score_cumulative = SaveIniReadReal("story_run", "cumulative", 0);
var _story_run_cumulative_ini = global.story_run_score_cumulative;
for (var i = 0; i <= 15; i += 1) {
	global.story_run_level_scores[i] = SaveIniReadReal("story_run", "level_score_" + string(i), 0);
	global.story_run_level_scores_set[i] = bool(SaveIniReadReal("story_run", "level_score_set_" + string(i), 0));
}
global.story_run_initials = SaveIniReadString("story_run", "initials", global.story_run_initials);
global.story_run_ever_coop = bool(SaveIniReadReal("story_run", "ever_coop", 0));
if (string_length(global.story_run_initials) <= 0 && global.story_run_active) {
	global.story_run_initials = global.player_initials;
}

for (var _af = 0; _af <= 15; _af += 1) {
	global.achievement_farm100[_af] = bool(SaveIniReadReal("achievements", "farm100_" + string(_af), 0));
	global.achievement_no_damage[_af] = bool(SaveIniReadReal("achievements", "nodamage_" + string(_af), 0));
	global.achievement_no_aggression[_af] = bool(SaveIniReadReal("achievements", "noaggro_" + string(_af), 0));
}

// Load arcade mode depending on dev mode
if (global.dev_mode) {
	global.arcade_max_unlocked = 16;
} else {
	global.arcade_max_unlocked = max(global.arcade_max_unlocked, global.story_mode_progress);
}
SaveIniClose();

StoryRunReconcileCumulative();
if (global.story_run_score_cumulative != _story_run_cumulative_ini) {
	StoryRunSave();
}

DemoApplyProgressCaps();

LeaderboardDownloadTopScores();

// Options (music/sfx; windowed + resolution on Windows only)
OptionsDisplayLoadFromSave();

// Apply the options setting
audio_group_load(audiogroup_music);
audio_group_set_gain(audiogroup_default, global.options_sfx, 0);
audio_group_set_gain(audiogroup_music, global.options_music, 0);

// Voice id of the outro bed, kept across the room change into the credits.
global.ending_outro_voice = noone;

// Texture prefetch (Switch): the project ships a single, on-demand texture group, so the
// first time a level references its sprites the page is decompressed + uploaded to VRAM
// mid-frame -> the "stutter when a level starts" from QA. Pages are uploaded a few per
// frame from boot (see TexturePrefetchTick) instead of all at once on the Wondoro logo.
// Flip prefetch_textures off here if a future build ever hits a VRAM limit.
global.prefetch_textures = true;
global.textures_prefetched = false;
global.prefetch_pages = undefined;
global.prefetch_index = 0;

/// @desc Upload a few Default-group texture pages. One page while the Wondoro logo is up.
function TexturePrefetchTick() {
	if (!SavePlatformIsSwitch() || !global.prefetch_textures || global.textures_prefetched) return;
	if (!is_array(global.prefetch_pages)) {
		global.prefetch_pages = texturegroup_get_textures("Default");
		global.prefetch_index = 0;
	}
	var _pages = global.prefetch_pages;
	var _count = array_length(_pages);
	if (_count <= 0) {
		global.textures_prefetched = true;
		return;
	}
	var _budget = instance_exists(obj_SplashTitle) ? 1 : 2;
	repeat (_budget) {
		if (global.prefetch_index >= _count) {
			global.textures_prefetched = true;
			return;
		}
		texture_prefetch(_pages[global.prefetch_index]);
		global.prefetch_index += 1;
	}
	if (global.prefetch_index >= _count) global.textures_prefetched = true;
}

// Transition
//global.transition_art = noone;
//global.transition_target = noone;

// Global character selection
global.character_selected[0] = CHARACTER.RABBO;
global.character_selected[1] = CHARACTER.DIRK;

// Character Name
global.character_name[CHARACTER.RABBO] = "Captain Rabbo";
global.character_name[CHARACTER.DIRK] = "Dirk Doggo";
global.character_name[CHARACTER.LINNIE] = "Linnie Lightfoote";
global.character_name[CHARACTER.BETTY] = "Betty Bunting";
global.character_name[CHARACTER.CANDIE] = "Candie Clayton";

// Define character sprites here. Format: global.character_sprite[enum _character][enum _char_sprite]
// Rabbo
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

// Dirk
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

// Linnie
global.character_sprite[CHARACTER.LINNIE][CHARACTER_SPRITE.IDLE] = spr_LinnieIdle;
global.character_sprite[CHARACTER.LINNIE][CHARACTER_SPRITE.BANK_LEFT] = spr_LinnieLeft;
global.character_sprite[CHARACTER.LINNIE][CHARACTER_SPRITE.BANK_LEFT_MAX] = spr_LinnieLeftMax;
global.character_sprite[CHARACTER.LINNIE][CHARACTER_SPRITE.BANK_RIGHT] = spr_LinnieRight;
global.character_sprite[CHARACTER.LINNIE][CHARACTER_SPRITE.BANK_RIGHT_MAX] = spr_LinnieRightMax;
global.character_sprite[CHARACTER.LINNIE][CHARACTER_SPRITE.ROLL_LEFT] = spr_LinnieRollLeft;
global.character_sprite[CHARACTER.LINNIE][CHARACTER_SPRITE.ROLL_RIGHT] = spr_LinnieRollRight;
global.character_sprite[CHARACTER.LINNIE][CHARACTER_SPRITE.LOOP] = spr_LinnieLoopDeLoop;
global.character_sprite[CHARACTER.LINNIE][CHARACTER_SPRITE.PARRY] = spr_LinnieParry;
global.character_sprite[CHARACTER.LINNIE][CHARACTER_SPRITE.DEATH] = spr_LinnieIdle;

// Betty
global.character_sprite[CHARACTER.BETTY][CHARACTER_SPRITE.IDLE] = spr_BettyIdle;
global.character_sprite[CHARACTER.BETTY][CHARACTER_SPRITE.BANK_LEFT] = spr_BettyLeft;
global.character_sprite[CHARACTER.BETTY][CHARACTER_SPRITE.BANK_LEFT_MAX] = spr_BettyLeftMax;
global.character_sprite[CHARACTER.BETTY][CHARACTER_SPRITE.BANK_RIGHT] = spr_BettyRight;
global.character_sprite[CHARACTER.BETTY][CHARACTER_SPRITE.BANK_RIGHT_MAX] = spr_BettyRightMax;
global.character_sprite[CHARACTER.BETTY][CHARACTER_SPRITE.ROLL_LEFT] = spr_BettyRollLeft;
global.character_sprite[CHARACTER.BETTY][CHARACTER_SPRITE.ROLL_RIGHT] = spr_BettyRollRight;
global.character_sprite[CHARACTER.BETTY][CHARACTER_SPRITE.LOOP] = spr_BettyLoopDeLoop;
global.character_sprite[CHARACTER.BETTY][CHARACTER_SPRITE.PARRY] = spr_BettyParry;
global.character_sprite[CHARACTER.BETTY][CHARACTER_SPRITE.DEATH] = spr_BettyIdle;

// Candie
global.character_sprite[CHARACTER.CANDIE][CHARACTER_SPRITE.IDLE] = spr_CandieIdle;
global.character_sprite[CHARACTER.CANDIE][CHARACTER_SPRITE.BANK_LEFT] = spr_CandieLeft;
global.character_sprite[CHARACTER.CANDIE][CHARACTER_SPRITE.BANK_LEFT_MAX] = spr_CandieLeftMax;
global.character_sprite[CHARACTER.CANDIE][CHARACTER_SPRITE.BANK_RIGHT] = spr_CandieRight;
global.character_sprite[CHARACTER.CANDIE][CHARACTER_SPRITE.BANK_RIGHT_MAX] = spr_CandieRightMax;
global.character_sprite[CHARACTER.CANDIE][CHARACTER_SPRITE.ROLL_LEFT] = spr_CandieRollLeft;
global.character_sprite[CHARACTER.CANDIE][CHARACTER_SPRITE.ROLL_RIGHT] = spr_CandieRollRight;
global.character_sprite[CHARACTER.CANDIE][CHARACTER_SPRITE.LOOP] = spr_CandieLoopDeLoop;
global.character_sprite[CHARACTER.CANDIE][CHARACTER_SPRITE.PARRY] = spr_CandieParry;
global.character_sprite[CHARACTER.CANDIE][CHARACTER_SPRITE.DEATH] = spr_CandieIdle;

// Actual levels
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


// Input (defaults + save overrides; Switch + PC share letter-based face map — A=select on both)
InputInitDefaultMaps();

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

InputInitBindingDisplayNames();
InputLoadBindingsFromSave();

if (SavePlatformIsSwitch()) {
	global.mouse_disable = true;
}