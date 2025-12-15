event_inherited();

// Image
//-> Zoom
zoom_img[0] = [1,1.1];
zoom_img[1] = [1.5,1];
zoom_img[2] = [1.15,1];
zoom_img[3] = [1,1.4];
zoom_img[4] = [1.4,1];
zoom_img[5] =[1.7,1];
zoom_img[6] = [1.6,1];

// Text
text[0] = "In her final act, Rabbo rams Twin Horn out of the sky forever.";
text[1] = "Both leaders plummet to the ground, sharing the same tragic end.";
text[2] = "The two factions rush to the crash, braced to find their leaders dead.";
text[3] = "But to their surprise, they see only machine has been destroyed.";
text[4] = "Twin Horn cries in revelation, his faith in natural law forsaken...";
text[5] = "As Rabbo sees the logo from her planes stamped upon his frame.";
text[6] = "Thus, her final victory came...as did the return of the Black Blaze.";

// Transition lengths
//-> Fade-ins
fadein_img = [1.2, 0.5, 1.1, 0.4, 0.6, 0.6, 0.75];	// {seconds} fade in length
fadein_txt = [1.3, 0.8, 1.3, 0.45, 2.5, 3.3, 3.8];
//-> Slide ends & text begins
timings_ends = [6, 13.7, 21.2, 28.9, 36.5, 48, 59];	// When to start ending each slide (img and txt)
//timings_txt = [0.1, 7.55, 15.3, 22.75, 30.4, 41.7, 53.3];	// When to start when to start showing txt on the specific slide
timings_txt = 0.2*GAMESPD;

// Tween types
tween_fadein_img = TWEENTYPE.QUAD_OUT;		// image fadein
tween_fadein_txt = TWEENTYPE.QUAD_OUT;

// BG music
music_bg = snd_CutsceneOutro;

event_user(0);