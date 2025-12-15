// Depth related _script
// z < 0 will scale up (closer than player to the cam), z > 0 will scale down (further away towards the ground)
// At z of 0, all is at the original size (player plane level)
// At z of 100, all will be scaled down to 50 % of original (ground)
// At z of 200, all will be scaled to 25% of original


// @func DepthGetScale()
function DepthGetScale(_zpos){
	// This function takes depth value, and returns proper scaling according to depth
	return power((0.5),(_zpos/100));
}

// @func DepthGetPositionX(_x_pos, _zpos)
function DepthGetPositionX(_x_pos, _zpos){
	return SHADOW_ANCHOR_X + ((_x_pos - SHADOW_ANCHOR_X) * power((0.5),(_zpos/100)));
}

// @func DepthGetPositionY(_y_pos, _zpos) {
function DepthGetPositionY(_y_pos, _zpos){
	return SHADOW_ANCHOR_Y + ((_y_pos - SHADOW_ANCHOR_Y) * power((0.5),(_zpos/100)));
}