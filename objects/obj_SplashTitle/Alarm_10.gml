/// @desc Hotkey delay

// One-time texture prefetch (Switch only). Runs a couple of frames into the splash - so
// the logo is already on screen (kind to boot-time limits) - and uploads every page of
// the texture group to VRAM up front. GameMaker keeps them resident afterwards, so the
// first frame of each level no longer decompresses/uploads on the fly ("stutter when a
// level starts" from QA). See scr_Globals for the toggle / VRAM fallback note.
if (SavePlatformIsSwitch() && global.prefetch_textures && !global.textures_prefetched) {
	texture_prefetch("Default"); // uploads all pages to VRAM once (hidden behind the splash)
	global.textures_prefetched = true;
}
