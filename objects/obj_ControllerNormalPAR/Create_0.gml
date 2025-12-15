// Inherit the parent event
event_inherited();

// Ready sign
alarm[0] = GAMESPD*3;

// Clouds
cloud_special_anchor_y = -120;
cloud_sprite[0] = spr_PropCloudSmall;	// small
cloud_sprite[1] = spr_PropCloudMedium;	// medium
cloud_sprite[2] = spr_PropCloudMedium;	// large
cloud_interval = GAMESPD*3;		// how often the clouds will spawn
alarm[1] = irandom(cloud_interval);

// Reset tally score
global.score_base = 0;
global.score_current = 0;