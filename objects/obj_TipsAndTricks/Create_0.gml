/// @desc Death mid-level tips screen: single slide, wait for input to continue
// Set sprite and frame based on level type and section (1-4 → index 0-3)
var _is_boss = (room == rm_Level1_3FightBoss || room == rm_Level2_3FightBoss || room == rm_Level3_3FightBoss || room == rm_Level4_3FightBoss);
var _section = global.current_level div 4;  // 0-3 for sections 1-4
sprite_index = _is_boss ? spr_TipsAndTricks_Boss : spr_TipsAndTricks_Farm;
image_index = _section;

event_inherited();
hold_end = true;   // don't auto-advance; wait for key/click
// TODO: replace with new tip jingle when ready
music_bg = snd_MissionFailed;
// Parent defaults zoom to [0,0] which makes the image invisible; use visible scale for all frames
for (var i = 0; i < array_length(zoom_img); i++)
	zoom_img[i] = [1, 1];
fadein_img[0] = 0.3;   // seconds for image fade-in
if (array_length(timings_ends) < 2)
	array_push(timings_ends, timings_ends[0]);

event_user(0);