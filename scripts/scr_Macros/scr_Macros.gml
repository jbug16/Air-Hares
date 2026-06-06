/*
   ___                                                          
  / _ \__ _ _ __ ___   ___   _ __ ___   __ _  ___ _ __ ___  ___ 
 / /_\/ _` | '_ ` _ \ / _ \ | '_ ` _ \ / _` |/ __| '__/ _ \/ __|
/ /_\\ (_| | | | | | |  __/ | | | | | | (_| | (__| | | (_) \__ \
\____/\__,_|_| |_| |_|\___| |_| |_| |_|\__,_|\___|_|  \___/|___/
                                                                
*/

// Set true only for IndiePass distribution builds (Game Options > Configs > IndiePass, or override here).
// Switch / retail builds must keep this false.
#macro BUILD_INDIEPASS false

#macro GAMESPD game_get_speed(gamespeed_fps)

// Level stuff
#macro SHADOW_ANCHOR_X 640
#macro SHADOW_ANCHOR_Y 414
#macro BORDER_LEFT 80
#macro BORDER_RIGHT 1200