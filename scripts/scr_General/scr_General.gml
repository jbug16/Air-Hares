/*
	ArrayMultiply
*/

///@func ArrayMultiply(array, multiplier)
///@desc Multiplies all numerical members of the array with a multiplier. Members can be arrays as well (function is recursive). Doesn't work on data structure members!
///@arg array		{array} Array to multiply
///@arg multiplier	{num} Value to multiply with
///@return			{bool} If given arguments are not correct.
function ArrayMultiply(_array, _multiplier)
{
	if (!is_array(_array) or !is_numeric(_multiplier)) return false;	// check if array
	// Main multiply loop
	for (var i = array_length(_array) - 1; i >= 0; i--)
	{
		if is_array(_array[i]) ArrayMultiply(_array[i], _multiplier);	
		else if is_numeric(_array[i]) _array[i] *= _multiplier;
	}
	
	return true;
}


////////////////////////////////////////////////////////////////////////////////////
/* Options */

// Save story mode progress
function StoryProgressSave(){
	// Update arcade max if current progress exceeds it
	global.arcade_max_unlocked = max(global.arcade_max_unlocked, global.story_mode_progress);
	
	ini_open("save.sav");
	ini_write_real("story", "progress", global.story_mode_progress);
	ini_write_real("arcade", "max_unlocked", global.arcade_max_unlocked); // Save arcade max
	ini_close();
}

// Advance level, save progress.
function AdvanceLevel() {
	// Increment current level
	global.current_level++;
	
	// Update story progress (only if we've progressed further than before)
	global.story_mode_progress = max(global.story_mode_progress, global.current_level);
	
	// Save to file
	StoryProgressSave();
	
	return true;
}

/* Transition with art */
function TransitionGoto(_target){
	// Go to transition art room
	
	prst_Transition.trans_target = _target;
	prst_Transition.trans_trigger = true;
}

// BGM change function
function AudioBgmChange(_bgm){
	// No bgm selected. Return false
	if (_bgm == noone) 
	{	
		audio_stop_sound(global.bgm_playing);
		global.bgm_playing = _bgm;
		return false;
	}
	
	// If bgm selected. Will return true.
	if (global.bgm_playing != noone) audio_stop_sound(global.bgm_playing);	// When a bgm is already playing
	audio_play_sound(_bgm, 1, true);
	global.bgm_playing = _bgm;
	return true;
}

// Data structure
function Profile() constructor{
	stat = {
		fortune		: 0,
		foresight	: 0,
		fortitude	: 0,
		
		fortitude_roll : function(){
			if random(1) < fortitude * (0.17) return true;	
			return false;
		}
	}
	
	stat_load		= function(){
		ini_open("save.sav");
		stat.fortune = ini_read_real("stats", "fortune", 0);
		stat.foresight = ini_read_real("stats", "foresight", 0);
		stat.fortitude = ini_read_real("stats", "fortitude", 0);
		ini_close();
	}
	stat_save		= function(){
		ini_open("save.sav");
		ini_write_real("stats", "fortune", stat.fortune);
		ini_write_real("stats", "foresight", stat.foresight);
		ini_write_real("stats", "fortitude", stat.fortitude);
		ini_close();
	}
	stat_reset		= function(){
		stat.fortune	= 0;
		stat.foresight	= 0;
		stat.fortitude	= 0;
		stat_save();
	}
}