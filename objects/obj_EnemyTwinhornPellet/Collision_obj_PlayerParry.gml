/// @desc Create new seed

if(countered) exit;

var _new_seed = instance_create_layer(x, y, layer, obj_EnemyTwinhornPellet);
_new_seed.countered = true;
_new_seed.speed = speed * 0.8;
_new_seed.direction = direction + 180;
_new_seed.image_angle = _new_seed.direction;
audio_play_sound(snd_SFXPelletBounce, 1, false);
if(instance_exists(obj_EnemyTwinhorn)) obj_EnemyTwinhorn.prep_pellet_countered++;

instance_destroy();