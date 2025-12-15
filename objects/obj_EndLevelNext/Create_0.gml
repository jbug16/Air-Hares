/// @desc

// Inherit the parent event
event_inherited();

button_id = 3;
text = "CONTINUE";

// CONTINUE is always created last, so focus it
with(obj_EndLevelPAR) 
{
    if (id != other.id) event_user(2);
}
event_user(1);