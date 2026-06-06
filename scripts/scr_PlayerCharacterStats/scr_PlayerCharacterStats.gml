/// @desc Per-character combat/movement modifiers (applied after spawner sets `character`).
function PlayerApplyCharacterStats() {
	var _bank = 1;
	var _roll = 1;
	var _loop = 1;
	var _wind = 1;
	var _hp = 1;
	var _damage_taken = 1;
	lightning_immune = false;
	has_last_stand = false;
	last_stand_used = false;
	
	switch (character) {
		case CHARACTER.RABBO:
			has_last_stand = true;
			break;
		case CHARACTER.DIRK:
			// Base stats; falcon aggro uses PlayerGetEnemyAggroTarget() (not for boss *objects*).
			break;
		case CHARACTER.LINNIE:
			_bank = 1.15;
			_roll = 1.15;
			_loop = 1.25;
			_damage_taken = 4 / 3; // ~25% more damage per hit (replaces old 0.75 max HP)
			_wind = 1.15;
			break;
		case CHARACTER.BETTY:
			_bank = 0.85;
			_roll = 0.85;
			_loop = 0.75;
			_hp = 1.25;
			_wind = 0.85;
			break;
		case CHARACTER.CANDIE:
			_bank = 0.75;
			_roll = 0.75;
			_loop = 0.65;
			_hp = 1.35;
			_wind = 1;
			lightning_immune = true;
			break;
	}
	
	stat_bank_mult = _bank;
	stat_roll_mult = _roll;
	stat_loop_dist_mult = _loop;
	stat_wind_mult = _wind;
	stat_max_hp_mult = _hp;
	stat_damage_taken_mult = _damage_taken;
	stat_damage_taken_debt = 0;
	loop_parallax_target = -6 * stat_loop_dist_mult;
	hp = max(1, floor(PlayerStatsArmorLoad() * stat_max_hp_mult));
}

/// @desc Pick a player for enemies to chase. Any living Dirk is always chosen unless _neutral (actual boss AI).
/// @param {real} _x
/// @param {real} _y
/// @param {bool} [_neutral] If true, plain nearest player (use for obj_Boss* and worm boss only — not obj_Falcon* minions).
function PlayerGetEnemyAggroTarget(_x, _y, _neutral = false) {
	if (_neutral) {
		return instance_nearest(_x, _y, obj_PlayerPAR);
	}
	var _n = instance_number(obj_PlayerRabbo);
	for (var _i = 0; _i < _n; _i++) {
		var _p = instance_find(obj_PlayerRabbo, _i);
		if (!instance_exists(_p) || _p.state == PLAYERSTATE.DEATH) continue;
		if (_p.character == CHARACTER.DIRK) {
			return _p;
		}
	}
	return instance_nearest(_x, _y, obj_PlayerPAR);
}
