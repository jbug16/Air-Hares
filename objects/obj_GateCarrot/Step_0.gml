/// @desc
y += vsp * global.speed_parallax;

if  y > 840 {
	CombosAddMiss(-100);
	instance_destroy();
}