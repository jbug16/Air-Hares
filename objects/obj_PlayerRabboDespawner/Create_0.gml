/// @desc
TweenStart("y", y, y - 960, 3*GAMESPD, TWEENTYPE.QUART_IN);

alarm[0] = 3*GAMESPD;

// Create two splash
PropsSpawnSplash(id, 34);

// Create black shadow on ground
ground_shadow = instance_create_layer(x, y, "Ground", obj_ShadowGround);
ground_shadow.master = id;

// SFX
sound_engine = snd_PlaneRabboEngine;
audio_play_sound(sound_engine, 1, true);