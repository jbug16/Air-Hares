/// @desc DEBUG - all objects
if(!global.dev_mode) exit;
with(all) if(id != other and object_index != obj_FarmPlot and object_index != obj_PropFence) 
		show_debug_message(object_get_name(object_index));