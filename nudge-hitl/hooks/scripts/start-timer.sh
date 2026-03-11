#!/bin/bash
set -euo pipefail

# Delay in seconds before the nudge sound plays
DELAY=20

PIDFILE="/tmp/claude-nudge-hitl.pid"
SESSION_FILE="/tmp/claude-nudge-hitl.session"

# Read session_id from hook input JSON
INPUT=$(cat)
SESSION_ID=$(echo "$INPUT" | jq -r '.session_id // empty' 2>/dev/null || true)

# Kill any existing timer
if [ -f "$PIDFILE" ]; then
  pid=$(cat "$PIDFILE")
  kill "$pid" 2>/dev/null || true
  pkill -P "$pid" 2>/dev/null || true
  rm -f "$PIDFILE" "$SESSION_FILE"
fi

# Store session_id so cancel can match it
if [ -n "$SESSION_ID" ]; then
  echo "$SESSION_ID" > "$SESSION_FILE"
fi

# Spawn background timer: wait DELAY seconds then play sound
(
  trap 'rm -f "$PIDFILE" "$SESSION_FILE"; exit 0' TERM INT
  sleep "$DELAY"

  # macOS
  if command -v afplay &>/dev/null; then
    afplay /System/Library/Sounds/Submarine.aiff 2>/dev/null || true
  # Linux (PulseAudio)
  elif command -v paplay &>/dev/null; then
    paplay /usr/share/sounds/freedesktop/stereo/complete.oga 2>/dev/null || true
  # Linux (ALSA fallback)
  elif command -v aplay &>/dev/null; then
    aplay /usr/share/sounds/alsa/Front_Left.wav 2>/dev/null || true
  fi

  rm -f "$PIDFILE" "$SESSION_FILE"
) &

echo $! > "$PIDFILE"
disown $! 2>/dev/null || true