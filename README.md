# whisper-to-prompt

Record your voice, transcribe it locally with [WhisperKit](https://github.com/anthropics/claude-code), and open [OpenCode](https://opencode.ai) with a clean, rewritten AI-agent instruction.

## How it works

1. **Record** — `sox` captures audio at 16 kHz mono. Auto-stops after 2 s of silence.
2. **Transcribe** — `whisperkit-cli` runs the `large-v3` model entirely on-device. No audio leaves your machine.
3. **Rewrite** — The raw transcript is injected into a prompt template (`prompt.md`) and sent to OpenCode, which rewrites it into a precise instruction.

## Install dependencies

```bash
brew install sox
```

Install [WhisperKit CLI](https://github.com/anthropics/claude-code) and [OpenCode](https://opencode.ai).

## Usage

```bash
./talk-now.sh
```

Speak, wait for the beep, and OpenCode opens with your rewritten instruction.

## Project layout

| Path | Purpose |
|------|---------|
| `talk-now.sh` | Main script |
| `prompt.md` | Prompt template (editable) |
| `archive/` | Timestamped `.wav` + `.txt` pairs from every run |
| `audio.wav` | Latest recording (overwritten each run) |
| `transcript.txt` | Latest transcript (overwritten each run) |

## License

MIT
