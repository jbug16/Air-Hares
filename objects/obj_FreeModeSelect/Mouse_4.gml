if(global.mouse_disable) exit;
if !focus 
{
	with (object_index)
	{
		if (focus)
		{
			event_user(2);
			break;
		}
	}
	obj_FreeModeController.selected = tgt_level;
	event_user(1);
}
event_user(0);