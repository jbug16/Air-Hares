/// @desc
// Movement
x += hsp;
y += vsp;
if target != noone y += target.vsp;
z += zsp;



// Shadow when activated specially
if have_shadow {
	var _shadow = instance_create_layer(x, y, layer, obj_PlayerShadow);
	_shadow.sprite_index = sprite_index;
	_shadow.image_index = image_index;
	_shadow.image_speed = 0;
}

if (y < -720) {
	// Missed shot reduce score
	var _player = instance_nearest(x, y, obj_PlayerPAR);
	if (_player != noone) var _scr = instance_create_layer(_player.x, _player.y - 64, "GUI", obj_GUITextFlying);
	else var _scr = instance_create_layer(0.5*room_width, 0.8*room_width, "GUI", obj_GUITextFlying);
	_scr.z = 0;
	_scr.color = c_red;
	_scr.text = "-5";
	CombosAddMiss(-5);
	instance_destroy();
}