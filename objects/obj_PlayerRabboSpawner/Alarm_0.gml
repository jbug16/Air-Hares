///@desc Spawn player obj

var _spawned = instance_create_layer(x, y, "Instances", obj_PlayerRabbo);
_spawned.can_move = true;
if (instance_exists(_spawned.ground_shadow) and instance_exists(ground_shadow)) _spawned.ground_shadow.z = ground_shadow.z;
_spawned.splash[0].z = splash[0].z;
_spawned.splash[1].z = splash[1].z;
_spawned.player = player;
_spawned.character = character;
// Apply sprite
with(_spawned)
{
	PlayerAssignSprite(character);
}
instance_destroy();