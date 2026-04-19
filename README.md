# whisper-to-prompt

Record your voice, transcribe it locally with [WhisperKit](https://github.com/anthropics/claude-code) and open [OpenCode](https://opencode.ai) with a clean, rewritten AI-agent instruction.

## Why this exists

You could dictate into an AI chat, but you'd get a rambling wall of text that wastes tokens. This tool gives you the best of both: speak freely and at length into your microphone, then get back a clean, well-written prompt you can hand off to any AI agent.

Everything runs fully locally, audio never leaves your machine and transcription happens on-device via WhisperKit.

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

Speak, wait for the beep and OpenCode opens with your rewritten instruction.

## OpenCode integration

The rewrite step runs inside OpenCode, so the agent has access to search, MCP tools, and any other integrations already configured in your environment. It can pull in project context and external references to produce better prompts than the raw transcript alone could yield.

## Project layout

| Path             | Purpose                                          |
| ---------------- | ------------------------------------------------ |
| `talk-now.sh`    | Main script                                      |
| `prompt.md`      | Prompt template (editable)                       |
| `archive/`       | Timestamped `.wav` + `.txt` pairs from every run |
| `audio.wav`      | Latest recording (overwritten each run)          |
| `transcript.txt` | Latest transcript (overwritten each run)         |

## License

MIT
