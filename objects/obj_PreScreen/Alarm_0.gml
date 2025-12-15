///@desc End - create controller

// which level to go to
if (room == rm_LevelX1Farm) instance_create_layer(0,0, layer, obj_ControllerFarm);
else if (room == rm_Level1_3FightBoss) instance_create_layer(0,0, layer, obj_ControllerFightBoss1_3);
else if (room == rm_Level2_3FightBoss) instance_create_layer(0,0, layer, obj_ControllerFightBoss2_3);
else if (room == rm_Level3_3FightBoss) instance_create_layer(0,0, layer, obj_ControllerFightBoss3_3);
else if (room == rm_Level4_3FightBoss) instance_create_layer(0,0, layer, obj_ControllerFightBoss4_3);

// Weather and player
if(room != rm_Level4_3FightBoss) instance_create_layer(0,0, "Top_Weather", obj_WindParticles);	// only wind
instance_create_layer(x, 608, "Instances", obj_PlayerRabboSpawner);

instance_destroy();