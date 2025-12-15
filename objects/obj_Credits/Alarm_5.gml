///@desc Line by line

text0_lines++;
if (text0_lines >= array_length(text0)) alarm[0] = text0_spd;	// next phase
else															// next line
{
	alarm[5] = text0_spd;
	TweenStart("text0_line_alpha", 0, 1, text0_spd);
}