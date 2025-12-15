/// @desc Lightning strike

// Create lightning (type randomly defined)
if(instance_exists(obj_PlayerPAR) and !instance_exists(obj_GoldGripLightningPAR))
{
	var _spr = choose(spr_EnemyGoldGripLightningB, spr_EnemyGoldGripLightningC);
	var _light = instance_create_layer(obj_PlayerPAR.x, obj_PlayerPAR.y - 24, "InstancesShadow", obj_GoldGripLightningPAR);	
	_light.sprite_index = _spr;
	_light.delay_set(60);
}