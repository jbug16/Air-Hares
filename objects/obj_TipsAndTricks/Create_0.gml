/// @desc Death mid-level tips screen: single slide, wait for input to continue
event_inherited();
hold_end = true;   // don't auto-advance; wait for key/click
// TODO: replace with new tip jingle when ready
music_bg = snd_MissionFailed;
// Parent defaults zoom to [0,0] which makes the image invisible; use visible scale
zoom_img[0] = [1, 1];
fadein_img[0] = 0.3;   // seconds for image fade-in
if (array_length(timings_ends) < 2)
	array_push(timings_ends, timings_ends[0]);

event_user(0);