///@desc Damage the player
if (player_hit) exit;
if (variable_instance_exists(other, "lightning_immune") && other.lightning_immune) exit;

player_hit = true;
other.trig_damaged = true;