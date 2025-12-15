///@desc Reset gamepad axes
for (var i = 0; i < gamepad_get_device_count(); i++)
{
	if !gamepad_is_connected(i) continue;
	
	// left axis
	if (abs(gamepad_axis_value(i, gp_axislh)) < 0.5 and abs(gamepad_axis_value(i, gp_axislv)) < 0.5) gp_left_axis[i] = 0;
	else gp_left_axis[i] = 1;
	
	// right axis
	if (abs(gamepad_axis_value(i, gp_axisrh)) < 0.5 and abs(gamepad_axis_value(i, gp_axisrv)) < 0.5) gp_right_axis[i] = 0;
	else gp_right_axis[i] = 1;
}