///@desc Spawn enemy formation
with (instance_create_layer(0, 0, "Top", formation_type))
{
	spawner_type = other.enemy_type;
}