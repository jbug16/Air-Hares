/// @desc Init
event_inherited();

// Prop
state = ENEMIES.INIT;

event_user(15);	// Cloud spawn prop - additional for boss combat

hightop_death_pos = [];
//th_prop = noone;

// Spawn first ground bg
instance_create_layer(room_width*0.5, 0, "Ground_Tile", obj_BossBackground);

// Music
audio_stop_all();
music_bg = audio_play_sound(snd_FalconWaves, 1, true); // current backtrack

// Boss title card
boss_card = false; // flag if showing boss card
card_x = room_width + 0.51*sprite_get_width(spr_CardBossCloud);

dirk_prop = noone;