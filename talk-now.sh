#!/usr/bin/env bash
set -e

DIR="$(cd "$(dirname "$0")" && pwd)"
AUDIO="$DIR/audio.wav"
TRANSCRIPT_FILE="$DIR/transcript.txt"
ARCHIVE="$DIR/archive"
PROMPT_TEMPLATE="$DIR/prompt.md"
TIMESTAMP=$(date +"%Y%m%d-%H%M%S")

mkdir -p "$ARCHIVE"

INPUT=$(mktemp)
trap 'rm -f "$INPUT"' EXIT

for cmd in sox whisperkit-cli opencode; do
  if ! command -v "$cmd" &>/dev/null; then
    echo "Missing dependency: $cmd" >&2
    exit 1
  fi
done

beep() {
  printf '\a'
}

echo "Recording... (Ctrl+C to stop)"
beep
sox -d -r 16000 -c 1 "$AUDIO"
beep

echo "Transcribing with WhisperKit..."

spin() {
  local i=0 chars='⠋⠙⠹⠸⠼⠴⠦⠧⠇⠏'
  tput sc
  while kill -0 "$1" 2>/dev/null; do
    tput rc
    printf "  %s Transcribing..." "${chars:$((i % ${#chars})):1}"
    i=$((i + 1))
    sleep 0.1
  done
  tput rc
  printf "  ✓ Done              \n"
}

whisperkit-cli transcribe \
  --audio-path "$AUDIO" \
  --language en \
  --model large-v3 \
  2>/dev/null > "$TRANSCRIPT_FILE" &
whisper_pid=$!

spin $whisper_pid &
wait $whisper_pid

echo "--- Transcript ---"
cat "$TRANSCRIPT_FILE"
echo "------------------"

cp "$AUDIO" "$ARCHIVE/${TIMESTAMP}.wav"
cp "$TRANSCRIPT_FILE" "$ARCHIVE/${TIMESTAMP}.txt"

echo "Building prompt..."
{
  while IFS= read -r line || [ -n "$line" ]; do
    if [ "$line" = '$TRANSCRIPT' ]; then
      cat "$TRANSCRIPT_FILE"
    else
      printf '%s\n' "$line"
    fi
  done < "$PROMPT_TEMPLATE"
} > "$INPUT"

echo "Opening in OpenCode..."
opencode --prompt "$(cat "$INPUT")" "$DIR"

pbcopy < "$TRANSCRIPT_FILE"
echo "Transcript copied to clipboard."
