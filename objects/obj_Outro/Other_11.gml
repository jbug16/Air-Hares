///@desc After slide end

instance_create_layer(room_width/2, room_height/2, layer, obj_Credits);
if (alarm[1] > 0) audio_stop_all();
instance_destroy();

