/// @desc

// Inherit the parent event
event_inherited();

button_id = 1;
text = "REPLAY";

// Always focus REPLAY if it's the last button created
// (which happens when there's no NEXT/CONTINUE button)
if (!instance_exists(obj_EndLevelNext))
{
    with(obj_EndLevelPAR) 
    {
        if (id != other.id) event_user(2);
    }
    event_user(1);
}