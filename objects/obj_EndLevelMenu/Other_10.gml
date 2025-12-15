
// Inherit the parent event
event_inherited();

// If menu in story mode after bossfight - first cutscene, then menu
if (global.game_mode == GAMEMODE.STORY)
{
	if(instance_exists(obj_ControllerFightBoss1_3))
	{
		global.menu = true;
		TransitionGoto(rm_StageClear1);
		exit;
	}

	if(instance_exists(obj_ControllerFightBoss2_3))
	{
		global.menu = true;
		TransitionGoto(rm_StageClear2);
		exit;
	}

	if(instance_exists(obj_ControllerFightBoss3_3))
	{
		global.menu = true;
		TransitionGoto(rm_StageClear3);
		exit;
	}

	if(instance_exists(obj_ControllerFightBoss4_3))
	{
		global.menu = true;
		TransitionGoto(rm_OutroScreen);
		exit;
	}
}

TransitionGoto(rm_MainMenu);