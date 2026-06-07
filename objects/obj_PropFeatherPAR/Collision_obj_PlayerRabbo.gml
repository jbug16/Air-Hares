///@desc Pickup

var _hp = 0;

// Add hp to player (dependent on the type of feather)
if(object_index == obj_PropFeatherBlack) _hp = 0.25;
else if(object_index == obj_PropFeatherBlue) _hp = 0.5;
else if(object_index == obj_PropFeatherBrown) _hp = 0.75;
else if(object_index == obj_PropFeatherPurple) _hp = 1;
else _hp = 2;

other.hp = clamp(other.hp + _hp, 0, PlayerStatsArmorLoad());

var _scr = instance_create_layer(other.x, other.y - 64, "GUI", obj_GUITextFlying);
_scr.z = 0;
_scr.text = "+ HP";

audio_play_sound(snd_CarrotPickup, 1, false);
VfxPickup(sprite_index, image_angle);
instance_destroy();