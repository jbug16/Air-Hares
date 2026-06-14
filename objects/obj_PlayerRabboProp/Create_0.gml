/// @desc This is prop item
player = 0;
state = PLAYERSTATE.IDLE;
character = CHARACTER.RABBO;

// Properties
hp = PlayerStatsArmorLoad();
hp_invincibility = 0;	// When invincible, cannot be damaged
hsp = 0;
x_stored = 0;
y_stored = 0;
can_move = true;
can_shoot = true;
can_control = true;
speed_bank_inertia = 0.1;
speed_roll_multiplier = 2;
// Per-character modifiers (defaults; real values from PlayerApplyCharacterStats after spawn)
stat_bank_mult = 1;
stat_roll_mult = 1;
stat_loop_dist_mult = 1;
stat_wind_mult = 1;
stat_max_hp_mult = 1;
stat_damage_taken_mult = 1;
stat_damage_taken_debt = 0;
loop_parallax_target = -6;
lightning_immune = false;
has_last_stand = false;
last_stand_used = false;
speed_projectile_water = 12;
speed_projectile_seed = 12;
shoot_target = noone;
aim_at_crops = !(instance_exists(obj_ControllerFightBoss1_3) || 
				instance_exists(obj_ControllerFightBoss2_3) || 
				instance_exists(obj_ControllerFightBoss3_3) || 
				instance_exists(obj_ControllerFightBoss4_3)); // automatically off for boss levels
shoot_target_acquisition_minimum = 128;
shoot_target_acquisition_range = 1280;
shoot_cooldown_seed = 0;
shoot_cooldown_water = 0;
shoot_cooldown_period_seed = 0.4 * GAMESPD;
shoot_cooldown_period_water = 0.4 * GAMESPD;
shoot_ammo_depletion = true;
shoot_ammo_seed = GetAmmo();	// Load ammo
shoot_ammo_water = GetAmmo(); // Load ammo
death_counter = 180;
parry_hitbox = noone;
parallax_speed_prev = 0;
paralysis_counter = 0;
confusion_counter = 0;

// Trigger
trig_anim_end = false;
trig_damaged = false;
trig_paralyzed = false;
trig_confused = false;
trig_death = false;
trig_shoot_auto = false;
trig_fortune = false;
trig_foresight = false;
trig_fortitude = false;

// Sprite assignment
PlayerAssignSprite(character);

// Flashing when damaged
flashing = false;
flashing_interval = 5;
flashing_counter = flashing_interval;

// Sound variable
sound_engine = snd_PlaneRabboEngine;
sound_roll = snd_PlaneRabboRoll;

// Create smoke
smoke = instance_create_depth(x, y + 120, depth, obj_PlayerPlaneSmoke);

// Create two splash
PropsSpawnSplash(id, 34);

// Create black shadow on ground
ground_shadow = instance_create_layer(x, y, "Ground", obj_ShadowGround);
ground_shadow.master = id;