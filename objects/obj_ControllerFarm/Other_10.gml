///@desc Spawn normal enemy (1)
if (alarm[10] > 0 or instance_exists(obj_EndShrine)) exit;
if (enemy_can_spawn) 
{
	instance_create_layer(200 + irandom(880), 960, "Top", enemy_type);
	enemy_can_spawn = 0;
}
else
{
	enemy_can_spawn = 1;
	alarm[10] = 4 + enemy_spawn_delay*(3/global.speed_parallax - 1)*0.75/3;
}