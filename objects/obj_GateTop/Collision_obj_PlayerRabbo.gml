/// @desc On collision with player
if !activated {
	CombosAddHit(250);
	image_index = 1;	
	side_left_bottom.image_index = 1;
	side_right_bottom.image_index = 1;
	side_left_top.image_index = 1;
	side_right_top.image_index = 1;	
	// Play pickup sound
	audio_play_sound(snd_Gates, 2, false);
 activated = true;
}