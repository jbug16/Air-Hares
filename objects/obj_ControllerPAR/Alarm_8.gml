///@desc hp flash on hit - p1
if (hp_flash1 < hp_flash_max) 
{
	alarm[8] = 0.1*GAMESPD;
	hp_flash1 ++;
	hp_flash_on1 = !hp_flash_on1;
}
else 
{
	hp_flash1 = 0;
	hp_flash_on1 = false;
}