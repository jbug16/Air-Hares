///@desc
/*
	============  DESCRIPTION  =============
	Persistent object which manages all the tweening in the game. Tween values are updated in the pre-draw event (after steps/alarms).
	Works with simple 1D arrays and normal variable values (not dynamic structures or structs though).
	Disabled instances are taken into account, so tweening their values is skipped while they are disabled.
	
	All the tween values to go through are split into 101-element bits/parts, and next bit recalculated when last end is reached.
	This is done to preserve memory and optimize long value tweens (faster initial start as only first 100 elements are calculated).
	========================================
*/

depth = 15000;	// needed so the depth is not accidentally changed on room transition (removing the possibility of layer it is on
				// to be disabled or made invisible, effectively disabling this object) - with this it is on unmanaged layer forever
tweeners = [];	// array of all the tween data for a particular instance&variable being tweened



///@func	_CheckExists(id)
///@desc	Checks to see if the instance exists, even if it is disabled.
///@arg		{id}	instance or object id
///@return	{bool}	True/false - if instance exists.
_CheckExists = function(_id)
{
	try
	{
		_id.x += 0;
		return true;
	}
	catch (_error)
	{
		return false;
	}
}