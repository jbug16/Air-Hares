/// @desc
player = 0;
character = global.character_selected[player];
sprite_index = global.character_sprite[character][CHARACTER_SPRITE.IDLE];

alarm[0] = 2*GAMESPD;
TweenStart("y", y + 360, y, 2*GAMESPD, TWEENTYPE.QUART_OUT);

// Create two splash
PropsSpawnSplash(id, 42);

// Create black shadow on ground
ground_shadow = instance_create_layer(x, y, "Ground", obj_ShadowGround);
ground_shadow.master = id;

// Sound variable
sound_engine = snd_PlaneRabboEngine;

// Play engine sound
audio_play_sound(sound_engine, 1, true);
audio_sound_pitch(sound_engine, 1.6);