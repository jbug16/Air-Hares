/// @desc Evaluate if thunderstrike
alarm[0] = 60;
if (instance_exists(obj_EnemyBirdPAR) or instance_exists(obj_FalconFormationPAR)) exit;
if (random(1) < lightning_chance and lightning_phase == "NONE") {
	lightning_fx_create();
	lightning_phase = "FLASH"
}