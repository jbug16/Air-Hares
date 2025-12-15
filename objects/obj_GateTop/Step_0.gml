/// @desc
y += vsp * global.speed_parallax;

// Move child
side_left_bottom.y = y;
side_right_bottom.y = y;
side_left_top.y = y;
side_right_top.y = y;
hitbox_left.y = y;
hitbox_right.y = y;

if y > 840 {
	// Destroy child
	instance_destroy(side_left_bottom);
	instance_destroy(side_right_bottom);
	instance_destroy(side_left_top);
	instance_destroy(side_right_top);
	instance_destroy(hitbox_left);
	instance_destroy(hitbox_right);
	instance_destroy();
}