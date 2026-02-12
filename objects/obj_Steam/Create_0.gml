/// @desc

if(steam_initialised()) {
	show_debug_message("Steam Initialized!")
	
	// Initialize leaderboards
	LeaderboardInitialize();
} else {
	show_debug_message("Steam not initialized.")
}