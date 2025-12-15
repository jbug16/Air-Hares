/// @desc Init
portrait = noone;	// Sprite
dialog = noone;		// Dialog
dialog_speed = 0.2;		// Speed of counter increate
dialog_counter = 0;		// Current counter of text to be displayed
dialog_counter_max = 0; // Maximum counter for this line
dialog_display = "";	// Currently displayed text, based on counter
dialog_current = 0;		// Index of dialog[] being displayed
dialog_current_ended = false;	// Flag if current dialog[dialog_current] has displayed all
dialog_ended = false;	// Flag if all dialog has been displayed
dialog_auto = false;	// Whether auto if chosen
dialog_auto_wait = 2 * GAMESPD * dialog_speed;
skip = 0;
skip_max = 60;

// Sound
sound_typing = snd_DialogTyping;
sound_typing_end = snd_DialogTypingEnd;
sound_end_is_played = false;