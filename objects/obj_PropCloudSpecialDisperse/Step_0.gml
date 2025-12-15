/// @desc Fade out and move
image_angle += 15;
image_xscale -= 0.03;
image_yscale = image_xscale;
image_alpha = image_xscale;

if (image_xscale <= 0) instance_destroy();