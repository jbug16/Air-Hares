// Set image based on stage and level
var _is_boss = (global.tips_return_room == rm_Level1_3FightBoss) || 
			   (global.tips_return_room == rm_Level2_3FightBoss) || 
			   (global.tips_return_room == rm_Level3_3FightBoss) || 
			   (global.tips_return_room == rm_Level4_3FightBoss);
sprite_index = _is_boss ? spr_TipsAndTricks_Boss : spr_TipsAndTricks_Farm;
image_index = global.current_level div 4;

// Audio - only play if not from mission failed (where music already playing)
AudioBgmChange(noone);
if (!variable_struct_exists(global, "tips_skip_music") || !global.tips_skip_music) {
    sound = audio_play_sound(snd_MissionFailed, 1, false);
}
// Reset the flag after checking
global.tips_skip_music = false;