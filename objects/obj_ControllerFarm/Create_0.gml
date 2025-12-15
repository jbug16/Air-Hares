///@desc

// Inherit the parent event
event_inherited();

state = LVLFARM.CROP1_SPAWN;
instance_create_layer(room_width*0.5, room_height, "Ground_Tile", obj_LevelTile);

plots = [];		// plots currently active {inst}

// Enemy spawns
enemy_type = [obj_EnemyFalconBlackSpawner, obj_EnemyFalconBlueSpawner, obj_EnemyFalconBrownSpawner, obj_EnemyFalconPurpleSpawner];
enemy_type = enemy_type[global.current_level div 4];
formation_type = [obj_FalconFormation3, obj_FalconFormation4, obj_FalconFormation5];
formation_type = formation_type[global.current_level mod 4];
enemy_spawn_delay = 1.5*GAMESPD;	// how much the delay will be at 75 speed - at 300 speed it will be almost 0
enemy_can_spawn = 1;		// just a help var
formation_spawn_delay = GAMESPD*2.2;	// so the pond tile is shown a bit before they appear
alarm[10] = GAMESPD*4.5;	// initial enemy spawn delay (only on level start)

// Opening black screens ('curtains')
instance_create_layer(640, 0, "GUI_Top", obj_GUIScreenOpenLeft);
instance_create_layer(640, 0, "GUI_Top", obj_GUIScreenOpenRight);

// Crops available (dependent on the stage)
crops_available = 36;
crops_filled = 0;
crops_created = 0;

if((global.current_level - 1) mod 4 == 0) crops_available = 54; // 2nd level in stage
else if((global.current_level - 2) mod 4 == 0) crops_available = 72; // 3rd level in stage