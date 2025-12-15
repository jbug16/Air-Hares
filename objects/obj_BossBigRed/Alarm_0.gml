///@desc Time between phases
event_user(0);

// Stop the wind
if (sequence == 1)
{
	with (obj_WindParticles)
	{
		wind_blowing = 0;
		alarm[1] = -1;
	}
}