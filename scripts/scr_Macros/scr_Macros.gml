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

// snd_CutsceneOutro is 72.4s, but the music falls silent around 65.5s.
// Hand off before that tail. snd_Credits goes quiet around 80.5s of 84.8s;
// loop the bed before that tail so the roll does not drop out.
#macro ENDING_OUTRO_CROSSFADE_AT 63
#macro ENDING_CREDITS_LOOP_AT 78

// Level stuff
#macro SHADOW_ANCHOR_X 640
#macro SHADOW_ANCHOR_Y 414
#macro BORDER_LEFT 80
#macro BORDER_RIGHT 1200

// Controller hot-plug guard (Switch Joy-Con detach / dock / disconnect handling)
// A freshly-connected gamepad must be seen idle (not holding confirm) for this many
// frames before a confirm press counts as a drop-in join. Filters spurious presses
// generated when Joy-Cons are re-enumerated on detach/attach.
#macro CONTROLLER_JOIN_DEBOUNCE 15
// A live player may be without a valid controller for this many frames (e.g. mid
// re-enumeration) before we pause and show the reconnect prompt. Avoids false pauses
// during the brief device shuffle when Joy-Cons are slid on/off.
#macro CONTROLLER_UNBOUND_GRACE 12