///@desc hp flash on hit - p2
if (hp_flash2 < hp_flash_max) 
{
	alarm[9] = 0.1*GAMESPD;
	hp_flash2 ++;
	hp_flash_on2 = !hp_flash_on2;
}
else 
{
	hp_flash2 = 0;
	hp_flash_on2 = false;
}