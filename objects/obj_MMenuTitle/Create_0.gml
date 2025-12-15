// Initialize
x = room_width/2;

AudioBgmChange(snd_Theme);

fade_alpha = 1;	// used for white screen fade-in

// Reset default controller
global.control_device[0] = -1; // Default uses keyboard


// Image scale
image_xscale = 0.88;
image_yscale = 0.88;

// fade in and scale in
TweenStart("image_xscale", image_xscale, image_xscale*1.2, GAMESPD, TWEENTYPE.QUART_OUT);
TweenStart("image_yscale", image_yscale, image_yscale*1.2, GAMESPD, TWEENTYPE.QUART_OUT);
TweenStart("image_alpha", 0, 1, GAMESPD, TWEENTYPE.QUART_OUT);

// background disable grayscale
layer_enable_fx("Backgrounds_1", false);