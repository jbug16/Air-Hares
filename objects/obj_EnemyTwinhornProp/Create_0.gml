/// @desc
sprite_index = spr_TwinHornsStunned;
with(obj_PlayerRabboProp)
{
	TweenStart("y", y, other.y, 0.75*GAMESPD, TWEENTYPE.LINEAR);
	TweenStart("x", x, other.x, 0.75*GAMESPD, TWEENTYPE.LINEAR);
}