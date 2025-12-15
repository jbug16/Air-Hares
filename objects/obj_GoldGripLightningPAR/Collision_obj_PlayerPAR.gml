/// @desc
if !can_damage exit;
other.trig_damaged_breaker = true;
other.damage_fx.update(60, 3, 15);