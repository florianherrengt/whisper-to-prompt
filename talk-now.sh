#!/usr/bin/env bash
set -e

DIR="$(cd "$(dirname "$0")" && pwd)"
AUDIO="$DIR/audio.wav"
TRANSCRIPT_FILE="$DIR/transcript.txt"
CLEAN_FILE="$DIR/transcript-clean.txt"
ARCHIVE="$DIR/archive"
PROMPT_TEMPLATE="$DIR/prompt.md"
TIMESTAMP=$(date +"%Y%m%d-%H%M%S")

mkdir -p "$ARCHIVE"

INPUT=$(mktemp)
cleanup() { rm -f "$INPUT" "$CLEAN_FILE"; }
trap cleanup EXIT

for cmd in sox whisperkit-cli opencode; do
  if ! command -v "$cmd" &>/dev/null; then
    echo "Missing dependency: $cmd" >&2
    exit 1
  fi
done

echo "Recording... (Ctrl+C to stop recording)"
printf '\a'
sox -d -r 16000 -c 1 "$AUDIO" || true
printf '\a'

[ -s "$AUDIO" ] || { echo "No audio recorded." >&2; exit 1; }

echo "Transcribing with WhisperKit..."

whisperkit-cli transcribe \
  --audio-path "$AUDIO" \
  --language en \
  --model large-v3_turbo \
  > "$TRANSCRIPT_FILE"

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
  printf '\n\nWrite the cleaned-up transcript to this file: %s\n' "$CLEAN_FILE"
} > "$INPUT"

echo "Opening in OpenCode..."
opencode --prompt "$(cat "$INPUT")" "$DIR"

if [ -f "$CLEAN_FILE" ]; then
  cp "$CLEAN_FILE" "$ARCHIVE/${TIMESTAMP}-clean.txt"
  pbcopy < "$CLEAN_FILE"
  echo "Cleaned transcript copied to clipboard."
else
  echo "Warning: cleaned transcript not found at $CLEAN_FILE" >&2
fi
