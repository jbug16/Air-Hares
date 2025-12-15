/* _script for enemy class */

// @func EnemySpriteSet(s_index)
// @arg s_index
function EnemySpriteSet(s_index){
	if (sprite_index != s_index) 
	{
		sprite_index = s_index;
		image_index = 0;
		trig_anim_end = false;
	}
}

// @func EnemyFaceTarget()
// Return a target id
function EnemyFaceTarget(_target_id){
	if (_target_id != noone and instance_exists(_target_id))
	{
		image_angle = point_direction(x, y, _target_id.x, _target_id.y) + 90;
		return;
	}
	// Default facing
	image_angle = 270;
}

//@func EnemyHomingTarget()
// This function alter direction for homing
function EnemyHomingTarget(_target_id, _homing_speed){
	// Validate _target_id
	if _target_id != noone && instance_exists(_target_id) {
		var _player_headings = point_direction(x, y, _target_id.x, _target_id.y);
		var _deviation = _player_headings - direction;
		var _dev_sign = sign(_deviation);
		var _dev_diff = abs(_deviation);
		direction = direction + (_dev_sign * min(_dev_diff, _homing_speed));
		image_angle = direction + 90;
		exit;
	} else {
		// No change
		exit;	
	}
}