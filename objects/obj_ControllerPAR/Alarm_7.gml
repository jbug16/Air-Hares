///@desc Combo enlarger

if (combo_multiplier1 == 1)
{
	combo_multiplier1 = 0;
	combo_multiplier2 = 1;
	alarm[7] = 0.25*GAMESPD;
}
else
{
	combo_multiplier1 = 0;
	combo_multiplier2 = 0;
}