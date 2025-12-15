event_inherited();

// Image
//-> Zoom
zoom_img[0] = [1.1,1.3];
zoom_img[1] = [1.2,1.1];
zoom_img[2] = [1.4,1];
zoom_img[3] = [1,1.4];
zoom_img[4] = [1,1.2];
zoom_img[5] =[1.4,1];
zoom_img[6] = [1.4,1];

// Text
text[0] = "The Black Blaze has destroyed the land and humankind has fled.";
text[1] = "In its wake lies a barren realm where food is scarce and life is short.";
text[2] = "But from this hopeless void, a young bunny vows to change her fate...";
text[3] = "And finds a fleet of planes to farm her carrot crop.";
text[4] = "Thus, by refusing to yield to her natural destiny...";
text[5] = "She'll unleash not only the fury of the Gale Gang...";
text[6] = "But the courage of her peers, who take to the sky in becoming...";

// Transition lengths
//-> Fade-ins
fadein_img = [2.6, 1.6, 2, 1.4, 0.7, 1.2, 1.5];	// {seconds} fade in length
fadein_txt = [3.3, 2.8, 1.6, 1.8, 1.2, 1.2, 2.9];
//-> Slide ends & text begins
timings_ends = [9, 17.5, 27, 35.7, 44, 52, 61];	// When to start ending each slide (img and txt)
//timings_txt = [1.8, 11.5, 21.2, 30.5, 39.5, 47.8, 56];	// When to start when to start showing txt on the specific slide
timings_txt = GAMESPD;


event_user(0);

/* ///////////////////////// OLD, with movement
move_start_x = [20,0,0,		20,-5,-10,0];
move_stop_x = [-60,-20,0,	-20,10,10,0];
move_start_y = [-30,0,0,	-10,0,0,-20];
move_stop_y = [60,0,0,		30,0,0,10];


txt_pos_final = room_height*0.96;
txt_pos_init = room_height*0.94;