/// @desc Pressed
if (alarm[0] < 0 and !is_disabled)
{
	global.arcade_popup_screen = 0;
	global.arcade_new_initials = "";
	var _inst = instance_create_layer(room_width/2, room_height/2, "Instances_PopUp", obj_FreeModeFrame);
	_inst.text = global.story_mode_level[tgt_level][STORYPROP.NAME];
	_inst.arcade_popup_level = tgt_level;
	with (obj_FreeModeBtnPlay) {
		tgt_level = other.tgt_level;
		text = "PLAY";
	}
	
	layer_set_visible("Effect_Grayscale", true);		// grayscale
	obj_FreeModeSelect.is_disabled = true;
}