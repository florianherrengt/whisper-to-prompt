# 🎙️ whisper-to-prompt

Record your voice. Transcribe locally. Get a clean AI-agent prompt.

- 🔒 Fully on-device
- ✍️ Auto-rewrites rambling speech into precise instructions
- 📋 Cleaned transcript copied to clipboard automatically

## Requirements

- [sox](https://sox.sourceforge.net/) — `brew install sox`
- [WhisperKit CLI](https://github.com/argmaxinc/WhisperKit)
- [OpenCode](https://opencode.ai)

## Usage

```bash
./talk-now.sh
```

## How it works

1. **Record** — `sox` captures 16 kHz mono audio.
2. **Transcribe** — `whisperkit-cli` runs `large-v3` on-device.
3. **Rewrite** — The transcript is injected into `prompt.md` and sent to OpenCode, which rewrites it into a clean instruction.
