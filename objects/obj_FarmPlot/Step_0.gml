/// @desc
// If collision happened
collide_seed = instance_place(x, y, obj_PlayerProjectileSeed);
collide_water = instance_place(x, y, obj_PlayerProjectileWater);

// State machine
switch(state) {
	case PLOTSTATE.BARREN:
	case PLOTSTATE.BARREN_WATERED:
		break;
	case PLOTSTATE.EMPTY:
		// Transition
		if (collide_seed && collide_seed.target == id) {
			var _fx = instance_create_layer(x, y, "Ground", obj_PlayerProjectileSeedFX);
			_fx.master = id;
			_fx.depth -= 1;
			instance_destroy(collide_seed);
			audio_play_sound(snd_ProjSeedHit, 1, false);
			// Score fx
			if (!StoryPeacefulIntroFarmActive()) {
				var _scr = instance_create_layer(x, y, "GUI", obj_GUITextFlying);
				_scr.z = z;
				_scr.text = "+10";
			}
			CombosAddHit(10);
			state = PLOTSTATE.SEEDED;
		} else if collide_water && collide_water.target == id {
			var _fx = instance_create_layer(x, y, "Ground", obj_PlayerProjectileWaterFX);
			_fx.master = id;
			_fx.depth -= 1;
			instance_destroy(collide_water);
			audio_play_sound(snd_ProjWaterHit, 1, false);
			// Score fx
			if (!StoryPeacefulIntroFarmActive()) {
				var _scr = instance_create_layer(x, y, "GUI", obj_GUITextFlying);
				_scr.z = z;
				_scr.text = "+10";
			}
			CombosAddHit(10);
			state = PLOTSTATE.WATERED;
		}
		break;
	case PLOTSTATE.SEEDED:
		// On collision with seed again, destroy it
		if collide_seed && collide_seed.target == id {
			var _fx = instance_create_layer(x, y, "Ground", obj_PlayerProjectileSeedFX);
			_fx.master = id;
			_fx.depth -= 1;
			instance_destroy(collide_seed);
			audio_play_sound(snd_ProjSeedHit, 1, false);
			// Score fx
			if (!StoryPeacefulIntroFarmActive()) {
				var _scr = instance_create_layer(x, y, "GUI", obj_GUITextFlying);
				_scr.z = z;
				_scr.text = "-15";
				_scr.color = c_red;
			}
			CombosAddMiss(-15);
		}
		
		// Transition
		if collide_water && collide_water.target == id {
			var _fx = instance_create_layer(x, y, "Ground", obj_PlayerProjectileWaterFX);
			_fx.master = id;
			_fx.depth -= 1;
			instance_destroy(collide_water);
			audio_play_sound(snd_ProjWaterHit, 1, false);
			// Score fx
			if (!StoryPeacefulIntroFarmActive()) {
				var _scr = instance_create_layer(x, y, "GUI", obj_GUITextFlying);
				_scr.z = z;
				_scr.text = "+100";
			}
			if (!StoryPeacefulIntroFarmActive()) global.score_base += 100;
			state = PLOTSTATE.CARROT_FRESH;
			alarm[1] = 2;
			obj_ControllerFarm.crops_filled++;
		}
		break;
	case PLOTSTATE.WATERED:
		// On collison with water again, destroy it
		if collide_water && collide_water.target == id {
			var _fx = instance_create_layer(x, y, "Ground", obj_PlayerProjectileWaterFX);
			_fx.master = id;
			_fx.depth -= 1;
			instance_destroy(collide_water);
			audio_play_sound(snd_ProjWaterHit, 1, false);
			// Score fx
			if (!StoryPeacefulIntroFarmActive()) {
				var _scr = instance_create_layer(x, y, "GUI", obj_GUITextFlying);
				_scr.z = z;
				_scr.text = "-15";
				_scr.color = c_red;
			}
			CombosAddMiss(-15);
		}
	
		// Transition
		if (collide_seed && collide_seed.target == id) {
			var _fx = instance_create_layer(x, y, "Ground", obj_PlayerProjectileSeedFX);
			_fx.master = id;
			_fx.depth -= 1;
			instance_destroy(collide_seed);
			audio_play_sound(snd_ProjSeedHit, 1, false);
			// Score fx
			if (!StoryPeacefulIntroFarmActive()) {
				var _scr = instance_create_layer(x, y, "GUI", obj_GUITextFlying);
				_scr.z = z;
				_scr.text = "+100";
			}
			if (!StoryPeacefulIntroFarmActive()) global.score_base += 100;
			state = PLOTSTATE.CARROT_FRESH;
			obj_ControllerFarm.crops_filled++;
			alarm[1] = 2;
		} 
		break;
	case PLOTSTATE.CARROT_OLD:
		break;
	case PLOTSTATE.CARROT_FRESH:
		// On collision with seed again, destroy it
		if collide_seed && collide_seed.target == id {
			var _fx = instance_create_layer(x, y, "Ground", obj_PlayerProjectileSeedFX);
			_fx.master = id;
			_fx.depth -= 1;
			instance_destroy(collide_seed);
			// Score fx
			if (!StoryPeacefulIntroFarmActive()) {
				var _scr = instance_create_layer(x, y, "GUI", obj_GUITextFlying);
				_scr.z = z;
				_scr.text = "-15";
				_scr.color = c_red;
			}
			CombosAddMiss(-15);
		}
		
		// On collison with water again, destroy it
		if collide_water && collide_water.target == id {
			var _fx = instance_create_layer(x, y, "Ground", obj_PlayerProjectileWaterFX);
			_fx.master = id;
			_fx.depth -= 1;
			instance_destroy(collide_water);
			// Score fx
			if (!StoryPeacefulIntroFarmActive()) {
				var _scr = instance_create_layer(x, y, "GUI", obj_GUITextFlying);
				_scr.z = z;
				_scr.text = "-15";
				_scr.color = c_red;
			}
			CombosAddMiss(-15);
		}
		break;
}


image_index = sprite_num[state];

// Movement
y += vsp * global.speed_parallax;

// Destroy if out of room
if (DepthGetPositionY(y, z) > room_height*2) instance_destroy();	