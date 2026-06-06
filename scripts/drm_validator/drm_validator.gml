/// DrmValidator.gml
/// IndiePass DRM validation for GameMaker Studio
///
/// INTEGRATION INSTRUCTIONS:
/// -------------------------
/// 1. In GameMaker Studio IDE, create a new Script asset and name it "drm_validator"
/// 2. Copy the contents of this file (drm.gml) into that script
/// 3. Create another Script asset named "drm_validator_async" and copy drm_async.gml into it
/// 4. Create a new Object in your project (e.g., obj_drm_validator):
///    - In the Object's Create Event: Add the "drm_validator" script
///    - In the Object's Async - HTTP Event: Add the "drm_validator_async" script
/// 5. Place this object (obj_drm_validator) in your first room (game startup room)
///

function drm_validator() {
	if (!BUILD_INDIEPASS) return;

	// Configuration
	global.drm_validation_url = "https://api.indiepass.gg/api/auth/verification/hasActiveSubscription";
	global.drm_validation_success_status = "active";

	// Parse token from command-line arguments
	var token = "";
	var count = parameter_count();

	for (var i = 1; i <= count; i++) {
	    var arg = parameter_string(i);

	    // Check for --token=VALUE format
	    if (string_pos("--token=", arg) == 1) {
	        token = string_delete(arg, 1, 8);
	        break;
	    }

	    // Check for --token VALUE format
	    if (arg == "--token" && i < count) {
	        token = parameter_string(i + 1);
	        break;
	    }
	}

	// If no token found, quit
	if (token == "") {
	    game_end();
	    return;
	}

	// Make HTTP request with Bearer token
	var headers = ds_map_create();
	ds_map_add(headers, "Authorization", "Bearer " + token);
	global.drm_http_request = http_request(global.drm_validation_url, "GET", headers, "");
	ds_map_destroy(headers);
}