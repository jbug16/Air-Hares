/// @desc
gui_text_anchor_x = 32;
gui_text_anchor_y = 34;
var _scale = 0.7;


// combo multiplier scaling
var _combo = global.combos_multiplier;
var _combo_max = GAMESPD*0.25;
if (_combo > combo_prev) 
{
	alarm[7] = _combo_max - alarm[7];
	combo_multiplier1 = !combo_multiplier1;
}
var _scale_combo = 1 + combo_multiplier1*(_combo_max - clamp(alarm[7], 1, 5000))/_combo_max + 
	combo_multiplier2*(1 - (_combo_max - clamp(alarm[7], 1, 5000))/_combo_max);
_scale_combo *= _scale;
	
combo_prev = global.combos_multiplier;
// Draw the pronoun
//DrawText3(gui_text_anchor_x, gui_text_anchor_y + (80 * 2), global.combos_pronoun, fa_left, fa_middle, c_white,fnt_HiloDeco, 32, 
//	800, 0, image_xscale);

// Draw elapsed time
var _time_sec = floor(time_elapsed / 60) mod 60;
if _time_sec < 10 _time_sec = "0" + string(_time_sec);
var _time_min = floor(time_elapsed / 60) div 60;
var _time = string(_time_min) + ":" + string(_time_sec);
DrawText3(640, gui_text_anchor_y /*+ (80 * 3)*/, _time, fa_center, fa_middle, c_white, fnt_Federo24, -1, 5000, 0, _scale);

// Draw throttle speed
var _throttle = round(global.speed_parallax * 100);
DrawText3(640,  gui_text_anchor_y + 40*_scale, string(_throttle) + " kts", fa_center, fa_middle, c_white, fnt_Federo24, -1, 5000, 0, _scale);

// Draw ammo and speed
if instance_exists(obj_PlayerPAR) {
	draw_set_color(c_white);
	// Set alignment
	draw_set_valign(fa_middle);
	
	/* Draw barrel roll overheat status ==DISABLED==
	var _barrel_roll_status = "";
	if global.movement_barrel_roll == 0 {
		_barrel_roll_status = "Roller Not Installed";	
	} else {
		_barrel_roll_status = "Roll Temp: " + string(round(global.movement_barrel_roll_temp*100));
	}
	draw_text(gui_text_anchor_x,  gui_text_anchor_y + (48 * 6), _barrel_roll_status); */
	
	// Player's own
	var _p1 = noone;
	var _p2 = noone;
	with(obj_PlayerPAR){
		if (player == 0) {
			_p1 = id;	
		} else if (player == 1) {
			_p2 = id;
		}
	}
	
	if _p1 != noone && instance_exists(_p1) 
	{

		// Draw player icon
		var _x1 = gui_text_anchor_x - _scale*20 + _scale*0.5*sprite_get_width(spr_PlayerIcon);
		var _y1 = gui_text_anchor_y - _scale*20 + _scale*0.5*sprite_get_height(spr_PlayerIcon);
		draw_sprite_ext(spr_PlayerIcon, 0, _x1, _y1, _scale, _scale, 0, c_white, 0.8);
		
		// Draw current lives
		DrawText3(gui_text_anchor_x + 10, gui_text_anchor_y + _scale*114, string(p1_lives) + "x", fa_left, 
			fa_middle, c_white,fnt_Federo24, -1, 5000, 0, _scale);
		
		// draw combo multiplier
		var _x_pos= _x1 + _scale*0.5*sprite_get_width(spr_PlayerIcon) + _scale*0.5*sprite_get_width(spr_HPFrame);
		 _x_pos -= _scale*0.36*sprite_get_width(spr_HPFrame);
		DrawText3(_x_pos, gui_text_anchor_y + _scale*114, "x" + string(global.combos_multiplier), fa_left, 
			fa_middle, c_white,fnt_Federo24, -1, 5000, 0, _scale_combo);
		//DrawText3(gui_text_anchor_x + 50, gui_text_anchor_y + _scale*114, "x" + string(global.combos_multiplier), fa_left, 
		//	fa_middle, c_white,fnt_Federo24, -1, 5000, 0, _scale_combo);
		
		// Draw HP Frame
		_x1 += _scale*0.5*sprite_get_width(spr_PlayerIcon) + _scale*0.5*sprite_get_width(spr_HPFrame);
		draw_sprite_ext(spr_HPFrame, 0, _x1, _y1, _scale,_scale, 0, c_white, 0.8);
		
		// Draw the score (below 1st player)
		_x_pos += 60; //_scale*0.5*sprite_get_width(spr_PlayerIcon) + _scale*0.5*sprite_get_width(spr_HPFrame);
		DrawText3(_x_pos, gui_text_anchor_y + _scale*114, 
			round(global.score_current), fa_left, fa_middle, c_white,fnt_Federo24, -1, 5000, 0, _scale);
		//DrawText3(_x1 - _scale*0.4*sprite_get_width(spr_HPFrame)+ 5, gui_text_anchor_y + _scale*114, 
		//	round(global.score_current), fa_left, fa_middle, c_white,fnt_Federo24, -1, 5000, 0, _scale)
		
		// draw water (adjusts x1, so needs re-adjustment later for that)
		_x1 += _scale*0.6*sprite_get_width(spr_HPFrame);
		draw_sprite_ext(spr_WaterCountGUI, 0, _x1, _y1, _scale,_scale, 0, c_white, 0.8);
		var _max_water = 0;
		with _p1 _max_water = GetAmmo();
		var _xx1 = _x1 - _scale*8;
		var _xx2 = _xx1 + _scale*16;
		var _yy2 = _y1 + 43*_scale;
		var _yy1 = _y1 - 42*_scale;
		draw_healthbar(_xx1, _yy1, _xx2, _yy2, (_p1.shoot_ammo_water/_max_water)*100, c_black, c_aqua, c_aqua, 3, false, false);
		
		// Draw seeds
		draw_sprite_ext(spr_SeedProjectile, 0, _x1 - 0.3*_scale*sprite_get_width(spr_WaterCountGUI), gui_text_anchor_y + _scale*114, _scale, _scale, 0, 
			c_white, 0.8);
		DrawText3(_x1, gui_text_anchor_y + _scale*114, _p1.shoot_ammo_seed, fa_left, fa_middle, c_white, fnt_Federo24, -1, 5000, 0, _scale);
		
		// HP/armor data
		_x1 -= _scale*0.92*sprite_get_width(spr_HPFrame);
		_y1 -= _scale*0.1*sprite_get_height(spr_HPFrame);
		var _x2 = _x1 + _scale*0.63*sprite_get_width(spr_HPFrame);
		var _y2 = _y1 + 12*_scale;
		var _max_hp = 0;
		var _max_armor = 0;
		var _armor = 0;
		with _p1
		{
			_max_hp = PlayerStatsArmorLoad();
			_max_armor = _max_hp - global.armor_strength;
			_armor = clamp(hp - global.armor_strength, 0, 5000);
		}
		
		// Armor bar
		draw_healthbar(_x1, _y1, _x2, _y2, (_armor/_max_armor)*100, c_black, c_ltgray, c_dkgray, 0, false, false);
		
		// hp flash if hit
		if (hp_prev1 > _p1.hp) alarm[8] = 0.1*GAMESPD;
		if hp_flash_on1 draw_healthbar(_x1, _y1, _x2, _y2, (_armor/_max_armor)*100, c_black, c_white, c_white, 0, false, false);
		
		// HP bar
		_y1 = _y2 + _scale*0.1*sprite_get_height(spr_HPFrame);
		_y2 = _y1 + _scale*12;
		draw_healthbar(_x1, _y1, _x2, _y2, (_p1.hp/global.armor_strength)*100, c_black, c_aqua, c_blue, 0, false, false);
		if (hp_flash_on1 and _armor <= 0)
			draw_healthbar(_x1, _y1, _x2, _y2, (_p1.hp/global.armor_strength)*100, c_black, c_white, c_white, 0, false, false);
		hp_prev1 = _p1.hp;
	} 
	else if !PlayerCheckAlive(0) 
	{
		//var _mp_spawn_counter = multiplayer_status[PLAYER.PLAYER_1][MPPROP.COOLDOWN];
		//if  _mp_spawn_counter > 0 {
		//	draw_text(gui_text_anchor_x,  gui_text_anchor_y + (80 * 5), "Repairing: " + string(_mp_spawn_counter));
		//} else {
		//	draw_text(gui_text_anchor_x,  gui_text_anchor_y + (80 * 6), "Can Join!");
		//}
	}
	
	// If player 2 exists, draw seed & water
	if _p2 != noone && instance_exists(_p2) 
	{
		// Draw player icon
		var _x1 = 1280 - _scale*0.5*sprite_get_width(spr_PlayerIcon);
		var _y1 = gui_text_anchor_y - _scale*20 + _scale*0.5*sprite_get_height(spr_PlayerIcon);
		draw_sprite_ext(spr_PlayerIcon, 1, _x1, _y1, _scale, _scale, 0, c_white, 0.8);
		
		// Draw lives
		DrawText3(_x1 - _scale*20, gui_text_anchor_y + _scale*114, string(p1_lives) + "x", fa_left, 
			fa_middle, c_white, fnt_Federo24, -1, 5000, 0, _scale);
		
		// draw combo multiplier
		var _x_pos = _x1 - _scale*0.5*sprite_get_width(spr_PlayerIcon) + _scale*0.5*sprite_get_width(spr_HPFrame);
		_x_pos -= 0.96*sprite_get_width(spr_HPFrame);
		DrawText3(_x_pos, gui_text_anchor_y + _scale*114, "x" + string(global.combos_multiplier), fa_left, 
			fa_middle, c_white, fnt_Federo24, -1, 5000, 0, _scale_combo);
		//DrawText3(_x1 - _scale*20, gui_text_anchor_y + _scale*114, "x" + string(global.combos_multiplier), fa_left, 
		//	fa_middle, c_whi
		
		// Draw HP Frame
		_x1 -= _scale*0.5*sprite_get_width(spr_PlayerIcon) + _scale*0.5*sprite_get_width(spr_HPFrame);
		draw_sprite_ext(spr_HPFrame, 1, _x1, _y1, _scale,_scale, 0, c_white, 0.8);
		
		// draw score below 2nd player as well
		_x_pos += 60;
		DrawText3(_x_pos, gui_text_anchor_y + _scale*114, 
			round(global.score_current), fa_left, fa_middle, c_white, fnt_Federo24, -1, 5000, 0, _scale);
		//DrawText3(_x1  + _scale*0.4*sprite_get_width(spr_HPFrame)+ 5, gui_text_anchor_y + _scale*114, 
		//	round(global.score_current), fa_right, fa_middle, c_white, fnt_Federo24, -1, 5000, 0, _scale);
			
		// draw water (adjusts x1, so needs re-adjustment later for that)
		_x1 -= _scale*0.6*sprite_get_width(spr_HPFrame);
		draw_sprite_ext(spr_WaterCountGUI, 0, _x1, _y1, _scale,_scale, 0, c_white, 0.8);
		var _max_water = 0;
		with _p2 _max_water = GetAmmo();
		var _xx1 = _x1 - _scale*8;
		var _xx2 = _xx1 + _scale*16;
		var _yy2 = _y1 + 43*_scale;
		var _yy1 = _y1 - 42*_scale;
		draw_healthbar(_xx1, _yy1, _xx2, _yy2, (_p2.shoot_ammo_water/_max_water)*100, c_black, c_aqua, c_aqua, 3, false, false);
		
		// Draw seeds
		draw_sprite_ext(spr_SeedProjectile, 0, _x1 - 0.3*_scale*sprite_get_width(spr_WaterCountGUI), gui_text_anchor_y + _scale*114, _scale, _scale, 0, 
			c_white, 0.8);
		DrawText3(_x1, gui_text_anchor_y + _scale*114, _p2.shoot_ammo_seed, fa_left, fa_middle, c_white, fnt_Federo24, -1, 5000, 0, _scale);
		
		// HP/armor data
		_x1 += _scale*0.28*sprite_get_width(spr_HPFrame);
		_y1 -= _scale*0.1*sprite_get_height(spr_HPFrame);
		var _x2 = _x1 + _scale*0.63*sprite_get_width(spr_HPFrame);
		var _y2 = _y1 + 12*_scale;
		var _max_hp = 0;
		var _max_armor = 0;
		var _armor = 0;
		with _p2
		{
			_max_hp = PlayerStatsArmorLoad();
			_max_armor = _max_hp - global.armor_strength;
			_armor = clamp(hp - global.armor_strength, 0, 5000);
		}
		
		// hp flash if hit
		if (hp_prev2 > _p2.hp) alarm[9] = 0.1*GAMESPD;
		if hp_flash_on2 draw_healthbar(_x1, _y1, _x2, _y2, (_armor/_max_armor)*100, c_black, c_white, c_white, 0, false, false);
		
		// Armor bar
		draw_healthbar(_x1, _y1, _x2, _y2, (_armor/_max_armor)*100, c_black, c_ltgray, c_dkgray, 0, false, false);
		
		// HP bar
		_y1 = _y2 + _scale*0.1*sprite_get_height(spr_HPFrame);
		_y2 = _y1 + _scale*12;
		draw_healthbar(_x1, _y1, _x2, _y2, (_p2.hp/global.armor_strength)*100, c_black, c_lime, c_green, 0, false, false);
		if (hp_flash_on2 and _armor <= 0)
			draw_healthbar(_x1, _y1, _x2, _y2, (_p2.hp/global.armor_strength)*100, c_black, c_white, c_white, 0, false, false);
		hp_prev2 = _p2.hp;
		
	} 
	else if !PlayerCheckAlive(1) 
	{
		//draw_set_halign(fa_right);
		
		//var _mp_spawn_counter = multiplayer_status[PLAYER.PLAYER_2][MPPROP.COOLDOWN];
		//if  _mp_spawn_counter > 0 {
		//	draw_text(gui_text_anchor_x + 1232,  gui_text_anchor_y + (34 * 7), "Repairing: " + string(_mp_spawn_counter));
		//} else {
		//	draw_text(gui_text_anchor_x + 1232,  gui_text_anchor_y + (34 * 8), "Can Join!");
		//}
	}
}

// Ready sign & lives remaining
if (ready_sign_state < array_length(ready_sign_time))
{
	// READY
	var _alph = 1;
	var _scale = 0.15;
	switch ready_sign_state
	{
		case 0:
		_alph = 0;
		break;
		case 1:
		_alph = 1 - clamp((alarm[0]/ready_sign_time[ready_sign_state]), 0, 1);
		//_scale *= 1-clamp(alarm[0]/ready_sign_time[ready_sign_state], 0, 1);
		break;
		case 3:
		_alph = clamp((alarm[0]/ready_sign_time[ready_sign_state]), 0, 1);
		_scale *= clamp(alarm[0]/ready_sign_time[ready_sign_state], 0, 1);
		break;
	}
	draw_sprite_ext(spr_Ready, 0, room_width/2, room_height/2, 0.8*_scale, 0.8*_scale, 0, c_white, _alph);
	

	// lives
	//if (global.game_mode == GAMEMODE.STORY)
	//{
	//	var _spacingY = sprite_get_height(spr_PlayerIcon);
	//	var _spacingX = [0];
	//	if (global.lives == 2) _spacingX = [-0.4, 0.4];
	//	else if (global.lives == 3) _spacingX = [-0.8, 0, 0.8];
	//	else if (global.lives == 4) _spacingX = [-1.2, -0.4, 0.4, 1.2];
	//	for (var i = 0; i <array_length(_spacingX); i++)
	//	{
	//		draw_sprite_ext(spr_PlayerIcon, 0, room_width/2 + _spacingX[i]*_spacingY, room_height/2 + _spacingY, 
	//			_scale/0.2, _scale/0.2, 0, c_white, _alph);
	//	}
	//}
}