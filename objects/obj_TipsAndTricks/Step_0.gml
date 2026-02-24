/// @desc Wait for any input to continue
if (InputGet(INPUT.ANY) || (!global.mouse_disable && mouse_check_button_pressed(mb_left))) {
    TransitionGoto(global.tips_return_room);
}