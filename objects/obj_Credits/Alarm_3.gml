///@desc All done!

if(from_options)
{
	instance_activate_object(obj_OptionsController);
	instance_activate_object(obj_OptionsTitle);
	instance_destroy();
}
else 
{
	audio_stop_all();
	room_goto(rm_MainMenu);
}