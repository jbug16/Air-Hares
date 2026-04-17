/// @desc Per-character combat/movement modifiers (applied after spawner sets `character`).
function PlayerApplyCharacterStats() {
	var _bank = 1;
	var _roll = 1;
	var _loop = 1;
	var _wind = 1;
	var _hp = 1;
	
	switch (character) {
		case CHARACTER.RABBO:
		case CHARACTER.DIRK:
			// Base tuning; unique passives (last stand, falcon taunt) hook in later.
			break;
		case CHARACTER.LINNIE:
			_bank = 1.15;
			_roll = 1.15;
			_loop = 1.25;
			_hp = 0.75;
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
			break;
	}
	
	stat_bank_mult = _bank;
	stat_roll_mult = _roll;
	stat_loop_dist_mult = _loop;
	stat_wind_mult = _wind;
	stat_max_hp_mult = _hp;
	loop_parallax_target = -6 * stat_loop_dist_mult;
	hp = max(1, floor(PlayerStatsArmorLoad() * stat_max_hp_mult));
}
