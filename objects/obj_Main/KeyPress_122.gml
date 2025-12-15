///@desc Mute/unmute
if(!global.dev_mode) exit;
if (audio_group_get_gain(audiogroup_music) == 0)	// unmute
{
	audio_group_set_gain(audiogroup_music, 1, 0);
	audio_group_set_gain(audiogroup_default, 1, 0);
}
else												// mute
{
	audio_group_set_gain(audiogroup_music, 0, 0);
	audio_group_set_gain(audiogroup_default, 0, 0);
}