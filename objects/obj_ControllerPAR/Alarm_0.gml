///@desc Ready sign animation
ready_sign_state ++;
if (ready_sign_state < array_length(ready_sign_time)) alarm[0] = ready_sign_time[ready_sign_state];
