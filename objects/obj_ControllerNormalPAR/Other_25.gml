///@desc Clouds for bosses
switch(global.overworld_progress){
	case PLOTSTATE.BARREN:
		cloud_sprite[0] = spr_PropCloudDaySmall;
		cloud_sprite[1] = spr_PropCloudDayMedium;
		cloud_sprite[2] = spr_PropCloudDayLarge;
		break;
	case PLOTSTATE.BUDDING:
		cloud_sprite[0] = spr_PropCloudDuskSmall;
		cloud_sprite[1] = spr_PropCloudDuskMedium;
		cloud_sprite[2] = spr_PropCloudDuskLarge;
		break;
	case PLOTSTATE.BUSTING:
		cloud_sprite[0] = spr_PropCloudNightSmall;
		cloud_sprite[1] = spr_PropCloudNightMedium;
		cloud_sprite[2] = spr_PropCloudNightLarge;
		break;
	case PLOTSTATE.BOOMING:
		cloud_sprite[0] = spr_PropCloudDawnSmall;
		cloud_sprite[1] = spr_PropCloudDawnMedium;
		cloud_sprite[2] = spr_PropCloudDawnLarge;
		break;
}