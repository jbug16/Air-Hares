// WHO AM I? Parent object for the transition objects. I do all the common hard work: fadin', transitioning etc.
// HOW TO USE ME? In child obj Create event call event_inherited(), change the variables and then call event_user(0) to finish setup.

// LIST OF MY FUNCTIONALITIES:
//-----------------------------
// - adjustable slide text (slide-specific): text
// - adjustable fade-in times (slide-specific): fadein_img, fadein_txt
// - adjustable fade-out time (NOT slide-specific): fadeout
// - adjustable image zoom levels (slide-specific): zoom_img
// - adjustable text zoom levels (NOT slide-specific): zoom_txt
// - adjustable text vertical pos (NOT slide-specific): txt_pos
// - adjustable slide end & txt show timings (slide-specific): timings_ends, timings_txt
// - adjustable image movement start-to-finish of slide (slide specific): x_start, x_stop, y_start, y_stop
// - adj. tween type (NOT slide-spec.): tween_end, tween_fadein_img, tween_fadein_txt, tween_zoom_img, tween_zoom_txt, tween_pos_img


// =========================
// ====== ADJUSTABLE =======
// =========================
hold_end = false; // if after cutscenes go straight to the next part
// Image
//-> Position
x_start = array_create(image_number);	// initial offset of image x-pos, at start of slide showing
x_stop = array_create(image_number);	// end offset of image x-pos
y_start = array_create(image_number);	// same as above, for y offset
y_stop = array_create(image_number);
//-> Zoom
img_scale = 1.35;						// initial referenced image scaling to fill the required area
zoom_img = array_create(image_number);	// zoom levels for each slides (start, end)
for (var i = image_number - 1; i >= 0; i--)
{
	zoom_img[i] = [0,0];
}

// Text
text = array_create(image_number, "");			// text to show on each slide
zoom_txt = [1, 1];								// start/end text zoom levels
txt_pos = [room_height*0.92, room_height*0.92];	// start/end vertical text positiins

// Transition lengths
fadeout = 1.5*GAMESPD;							// {seconds} end slide transition length
//-> Fade-ins
fadein_img = array_create(image_number);	// {seconds} fade in length
fadein_txt = array_create(image_number);
//-> Slide ends & text begins
timings_ends = array_create(image_number);	// When to end the slide (after fadeout)
timings_txt = array_create(image_number);	// When to start when to start showing txt on the specific slide, slideshow times
											// put a number instead of array to have all actually be equal delays, not specific times

// Tween types
tween_end = TWEENTYPE.LINEAR;				// slide end
tween_fadein_img = TWEENTYPE.LINEAR;		// image fadein
tween_fadein_txt = TWEENTYPE.LINEAR;		// text fadein
tween_zoom_img = TWEENTYPE.SINE_OUT;		// image zoom
tween_zoom_txt = TWEENTYPE.CIRC_OUT;		// text zoom
tween_pos_img =  TWEENTYPE.LINEAR;			// image position

// BG music
music_bg = snd_CutsceneIntro;



// =========================
// ======== BACKEND ========
// =========================
// General
image_speed = 0;
alarm[10] = 0.5*GAMESPD;	// delay enabling key-press
text_alpha = 0;				// curent txt alpha
scale_txt = zoom_txt[0];	// initial text zoom level
txt_position = txt_pos[0];		// init. text vertical position
fade_out = true;			// if fade out should happen next

// Sounds
audio_stop_all();