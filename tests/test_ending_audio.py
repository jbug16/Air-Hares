"""Timeline and source checks for the ending-music handoff.

The shipped wavs are not the same length as the slideshow. snd_CutsceneOutro
goes silent several seconds before the file ends, and snd_Credits does too.
The old credits object also waited out the poem before starting its bed, and
it faded the outro *asset* gain to 0, which sticks. These checks fail if that
hole comes back.
"""

from __future__ import annotations

import re
import struct
import wave
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
FPS = 60

OUTRO_WAV = ROOT / "sounds" / "snd_CutsceneOutro" / "snd_CutsceneOutro.wav"
CREDITS_WAV = ROOT / "sounds" / "snd_Credits" / "snd_Credits.wav"


def _read(rel: str) -> str:
    return (ROOT / rel).read_text(encoding="utf-8")


def _macro(name: str) -> float:
    text = _read("scripts/scr_Macros/scr_Macros.gml")
    match = re.search(rf"#macro {name} (\d+(?:\.\d+)?)", text)
    if not match:
        raise AssertionError(f"missing macro {name}")
    return float(match.group(1))


def _wav_silence_start(path: Path, rms_limit: float = 200.0, window: float = 0.25) -> tuple[float, float]:
    with wave.open(str(path), "rb") as handle:
        channels, width, rate, frames = handle.getparams()[:4]
        raw = handle.readframes(frames)
    if width != 2:
        raise AssertionError(f"{path.name} is not 16-bit")
    samples = struct.unpack("<" + "h" * (len(raw) // 2), raw)
    mono = samples[0::channels]
    win = int(rate * window)
    duration = len(mono) / rate
    silence_at = None
    for index in range(0, len(mono) - win, win):
        chunk = mono[index : index + win]
        rms = (sum(sample * sample for sample in chunk) / len(chunk)) ** 0.5
        if rms < rms_limit:
            silence_at = index / rate
            break
    if silence_at is None:
        silence_at = duration
    return silence_at, duration


def _rms_at(path: Path, start: float, length: float = 0.5) -> float:
    with wave.open(str(path), "rb") as handle:
        channels, width, rate, frames = handle.getparams()[:4]
        raw = handle.readframes(frames)
    samples = struct.unpack("<" + "h" * (len(raw) // 2), raw)
    mono = samples[0::channels]
    sl = mono[int(start * rate) : int((start + length) * rate)]
    return (sum(sample * sample for sample in sl) / len(sl)) ** 0.5


def slideshow_end_seconds() -> float:
    """Mirror obj_CutscenePAR Alarm 0 for the outro timings."""
    gamespd = FPS
    fadeout = 1.5 * gamespd
    timings = [value * gamespd for value in (6, 13.7, 21.2, 28.9, 36.5, 48, 59)]
    image_index = 0
    image_number = 7
    fade_out = True
    alarm0 = timings[0]
    frame = 0
    while frame < FPS * 180:
        frame += 1
        alarm0 -= 1
        if alarm0 > 0:
            continue
        if not fade_out:
            image_index += 1
            if image_index == image_number:
                return frame / FPS
            fade_out = True
            alarm0 = timings[image_index] - timings[image_index - 1] - fadeout
        else:
            fade_out = False
            alarm0 = fadeout
    raise AssertionError("slideshow never ended")


def poem_seconds() -> float:
    # 6 lines, plus the extra wait once the last line has shown.
    return 7 * 2.8


def _coverage(events: list[tuple[float, float]], until: float) -> list[tuple[float, float]]:
    """Return silent gaps inside [0, until] given [start, end) audible spans."""
    cursor = 0.0
    gaps = []
    for start, end in sorted(events):
        if start > cursor + 1e-6:
            gaps.append((cursor, start))
        cursor = max(cursor, end)
    if cursor < until - 1e-6:
        gaps.append((cursor, until))
    return [(a, b) for a, b in gaps if b - a > 0.05]


def new_audible_spans(credits_at: float, outro_killed: bool) -> list[tuple[float, float]]:
    """Spans where either bed is in its loud region. Outro play begins next frame."""
    crossfade_at = _macro("ENDING_OUTRO_CROSSFADE_AT")
    loop_at = _macro("ENDING_CREDITS_LOOP_AT")
    outro_silence, _ = _wav_silence_start(OUTRO_WAV)
    credits_silence, _ = _wav_silence_start(CREDITS_WAV)
    phase1_at = credits_at + poem_seconds() + 2.0

    if outro_killed:
        outro_span = None
        credits_start = credits_at
    else:
        outro_span = (1 / FPS, min(outro_silence, crossfade_at + 2.0))
        if credits_at >= crossfade_at:
            credits_start = credits_at
        elif phase1_at < crossfade_at:
            credits_start = phase1_at
        else:
            credits_start = crossfade_at

    spans = []
    if outro_span is not None:
        spans.append(outro_span)

    # Credits bed starts at credits_start and loops before its silent tail
    # until the logo (phase 2), which is the end of the 90s roll.
    roll_end = phase1_at + 90.0
    cursor = credits_start
    while cursor < roll_end:
        loud_end = min(roll_end, cursor + loop_at)
        # Looping jumps back while still loud, so the tail is never heard.
        if loud_end < cursor + credits_silence:
            spans.append((cursor, loud_end))
        else:
            spans.append((cursor, min(roll_end, cursor + credits_silence)))
            break
        cursor = loud_end
    return spans


def test_macros_sit_inside_the_loud_part_of_each_file():
    outro_silence, outro_len = _wav_silence_start(OUTRO_WAV)
    credits_silence, credits_len = _wav_silence_start(CREDITS_WAV)
    crossfade_at = _macro("ENDING_OUTRO_CROSSFADE_AT")
    loop_at = _macro("ENDING_CREDITS_LOOP_AT")

    assert _rms_at(OUTRO_WAV, 0.0) > 500, "outro file itself is silent at the start"
    assert crossfade_at < outro_silence, (crossfade_at, outro_silence)
    assert _rms_at(OUTRO_WAV, crossfade_at) > 500
    assert loop_at < credits_silence, (loop_at, credits_silence)
    assert _rms_at(CREDITS_WAV, loop_at) > 500
    assert outro_silence < outro_len - 2
    assert credits_silence < credits_len - 2


def test_old_timeline_has_the_reported_holes():
    credits_at = slideshow_end_seconds()
    outro_silence, _ = _wav_silence_start(OUTRO_WAV)
    credits_silence, _ = _wav_silence_start(CREDITS_WAV)
    bed_start = credits_at + poem_seconds()
    roll_end = bed_start + 2.0 + 90.0
    gap_before_credits = bed_start - outro_silence
    gap_during_roll = roll_end - (bed_start + credits_silence)
    assert gap_before_credits > 8, gap_before_credits
    assert gap_during_roll > 8, gap_during_roll


def test_full_watch_stays_audible_through_the_roll():
    credits_at = slideshow_end_seconds()
    roll_end = credits_at + poem_seconds() + 2.0 + 90.0
    gaps = _coverage(new_audible_spans(credits_at, outro_killed=False), roll_end)
    assert gaps == [], gaps


def test_skipped_slideshow_still_hands_off_before_the_outro_dies():
    credits_at = 1.0
    outro_silence, _ = _wav_silence_start(OUTRO_WAV)
    roll_end = credits_at + poem_seconds() + 2.0 + 90.0
    gaps = _coverage(new_audible_spans(credits_at, outro_killed=False), roll_end)
    assert gaps == [], gaps
    # Handoff is the poem ending, still during the loud part of the outro.
    assert credits_at + poem_seconds() + 2.0 < outro_silence


def test_source_does_not_bring_the_old_bugs_back():
    outro_create = _read("objects/obj_Outro/Create_0.gml")
    outro_end = _read("objects/obj_Outro/Other_11.gml")
    outro_alarm = _read("objects/obj_Outro/Alarm_2.gml")
    parent_init = _read("objects/obj_CutscenePAR/Other_10.gml")
    credits_alarm = _read("objects/obj_Credits/Alarm_0.gml")
    credits_step = _read("objects/obj_Credits/Step_0.gml")
    maintain = _read("scripts/scr_General/scr_General.gml")
    outro_yy = _read("objects/obj_Outro/obj_Outro.yy")
    outro_sound = _read("sounds/snd_CutsceneOutro/snd_CutsceneOutro.yy")
    credits_sound = _read("sounds/snd_Credits/snd_Credits.yy")

    assert "defer_music = true" in outro_create
    assert "alarm[2] = 1" in outro_create
    assert "audio_stop_all" not in outro_end
    assert "global.ending_outro_voice = music_bg" in outro_end
    assert "audio_play_sound(snd_CutsceneOutro" in outro_alarm
    assert "audio_sound_gain(snd_CutsceneOutro, 1, 0)" in outro_alarm
    assert "defer_music" in parent_init
    assert "audio_sound_gain(snd_CutsceneOutro" not in credits_alarm
    assert "EndingCreditsMaintainMusic" in credits_step
    assert "if (!from_options)" in credits_step
    assert "ENDING_OUTRO_CROSSFADE_AT" in maintain
    assert "ENDING_CREDITS_LOOP_AT" in maintain
    assert "audio_sound_set_track_position(music, 0)" in maintain
    assert '"eventNum":2' in outro_yy and '"eventType":2' in outro_yy
    assert '"preload":true' in outro_sound
    assert '"preload":true' in credits_sound


if __name__ == "__main__":
    test_macros_sit_inside_the_loud_part_of_each_file()
    test_old_timeline_has_the_reported_holes()
    test_full_watch_stays_audible_through_the_roll()
    test_skipped_slideshow_still_hands_off_before_the_outro_dies()
    test_source_does_not_bring_the_old_bugs_back()
    print("ending audio checks passed")
    print(f"  slideshow ends at {slideshow_end_seconds():.2f}s")
    print(f"  outro goes quiet at {_wav_silence_start(OUTRO_WAV)[0]:.2f}s")
    print(f"  credits go quiet at {_wav_silence_start(CREDITS_WAV)[0]:.2f}s")
