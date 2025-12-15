/// @desc For sequence 0 control

//==========================================================
// ADJUSTABLE
//==========================================================
y = 80;
z = 0;
vsp = 0;
scaling = DepthGetScale(z);
timer_prepare = 60; // time between phases
image_angle = 0;
visible = false;

// Falcon positions for the 1st part (without the boss)
falcon_positions[0] = [0.2*room_width, 0.5*room_width, 0.8*room_width];
falcon_positions[1] = [0.2*room_width, 0.4*room_width, 0.6*room_width, 0.8*room_width];
falcon_positions[2] = [0.17*room_width, 0.33*room_width, 0.5*room_width, 0.67*room_width, 0.83*room_width];
falcon_positions2 = [0.1*room_width, 0.3*room_width, 0.7*room_width, 0.9*room_width];	// 2nd sequence
time[0] = [1.2*GAMESPD, 1.2*GAMESPD, 1.2*GAMESPD, 1.2*GAMESPD, 2*GAMESPD];		// sequence 1
time[1] = [GAMESPD];	// sequence 2



//==========================================================
// BACKEND
//==========================================================
// Sound
flyby_sound_played = false;
// Create shadow
VfxShadow(id);
// Weather
obj_ControllerPAR.env_weather.lightning_fx_create(1, 1);

// Sequences and phases
sequence = 0; // in which sequence the fight - 0 is first wave of falcons, 1 is boss sequence
seq_phase = 0;

// Falcon goons
falcon_ids = array_create(4, noone);	// for 2nd sequence - remember for roost/dive
falcons_diving = false;
hp_lost_during_dive = 0;

alarm[0] = timer_prepare;