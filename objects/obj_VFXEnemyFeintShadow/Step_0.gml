alive -= 1;
image_alpha -= alpha_step;
if image_alpha <= 0 instance_destroy();