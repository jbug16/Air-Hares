/// @desc Init
event_inherited();

// Prop
state = ENEMIES.INIT;

env_weather		= instance_create_layer(0, 0, "Top_Weather", obj_WeatherThunderstorm);
env_weather.lightning_chance = 0;


event_user(15);	// Cloud spawn prop - additional for boss combat

goldgrip_deathpos = {};

// Spawn first ground bg
instance_create_layer(room_width*0.5, 0, "Ground_Tile", obj_BossBackground);

// Music
audio_stop_all();
music_bg = audio_play_sound(snd_FalconWaves, 0, true); // current backtrack

// Boss title card
boss_card = false; // flag if showing boss card
card_x = room_width + 0.51*sprite_get_width(spr_CardBossCloud);

coop_prop = noone;