# AGENTS.md

## What this is

A single-script utility: `talk-now.sh` records voice, transcribes it with WhisperKit, and opens OpenCode to rewrite the transcript into a clean, precise AI-agent instruction.

## Dependencies

- **sox** — audio recording (`brew install sox`)
- **whisperkit-cli** — on-device transcription, uses model `large-v3`
- **opencode** — launched with the generated prompt

The script checks for all three at startup and exits if any are missing.

## Project layout

| Path | Purpose |
|------|---------|
| `talk-now.sh` | Main script |
| `prompt.md` | Prompt template (`$TRANSCRIPT` placeholder is replaced at runtime) |
| `archive/` | Timestamped `.wav` + `.txt` pairs from every run |
| `audio.wav` | Latest recording (overwritten each run) |
| `transcript.txt` | Latest transcript (overwritten each run) |

`audio.wav` and `transcript.txt` are runtime artifacts. `prompt.md` is user-editable.

## Behavior

- Records at 16 kHz mono, auto-stops after 2 s of silence
- Beeps before and after recording
- Archives every run to `archive/YYYYMMDD-HHMMSS.{wav,txt}`
- Uses a temp file for the prompt (safe for concurrent runs)
