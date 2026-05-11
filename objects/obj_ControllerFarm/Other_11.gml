///@desc Spawn enemy formation
if (StoryPeacefulIntroFarmActive()) exit;
with (instance_create_layer(0, 0, "Top", formation_type))
{
	spawner_type = other.enemy_type;
}