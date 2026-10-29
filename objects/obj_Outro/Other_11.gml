///@desc After slide end

// Keep the outro bed playing into the credits. obj_Credits crossfades off it.
// Stopping here (the old alarm[1] check) muted the whole poem.
global.ending_outro_voice = music_bg;
instance_create_layer(room_width/2, room_height/2, layer, obj_Credits);
instance_destroy();

