/// DrmValidator_AsyncHTTP.gml
/// IndiePass DRM async HTTP response handler for GameMaker Studio
///
/// INTEGRATION INSTRUCTIONS:
/// -------------------------
/// Add this script to the Async - HTTP Event of your DRM validator object.
/// See drm.gml for full integration and testing instructions.

function drm_validator_async() {
	if (!BUILD_INDIEPASS) return;

	// Check if this is our DRM validation request
	if (async_load[? "id"] == global.drm_http_request) {
	    var status = async_load[? "status"];
	    var result = async_load[? "result"];

	    // Check if HTTP request failed (status < 0 indicates error)
	    if (status < 0) {
	        game_end();
	    }

	    // Parse JSON response
	    var response = json_parse(result);

	    // Check if status field exists and equals expected value
	    if (!variable_struct_exists(response, "status") || response.status != global.drm_validation_success_status) {
	        game_end();
	    }

	    // If we reach here, validation passed - game continues
	}
}