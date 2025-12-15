/// @desc Lower propeller speed
propeller_spd = clamp(propeller_spd - 2, 1, max_spd);
alarm[1] = 0.5*GAMESPD;