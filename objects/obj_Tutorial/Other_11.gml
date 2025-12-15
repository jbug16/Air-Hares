/// @desc After slides end

instance_activate_object(obj_OptionsController);
instance_activate_object(obj_OptionsTitle);
instance_destroy();

if(!instance_exists(obj_OptionsController)) room_goto(global.story_mode_level[global.current_level][STORYPROP.ROOM]);