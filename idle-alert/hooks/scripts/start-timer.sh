#!/bin/bash
set -euo pipefail

# Defaults
DELAY=20
SOUND=""

# Read user config from .claude/idle-alert.local.md
CONFIG_FILE=".claude/idle-alert.local.md"
if [[ -f "$CONFIG_FILE" ]]; then
  FRONTMATTER=$(sed -n '/^---$/,/^---$/{ /^---$/d; p; }' "$CONFIG_FILE")
  USER_DELAY=$(echo "$FRONTMATTER" | grep '^delay:' | sed 's/delay: *//' || true)
  USER_SOUND=$(echo "$FRONTMATTER" | grep '^sound:' | sed 's/sound: *//' | sed 's/^"\(.*\)"$/\1/' || true)

  if [[ "$USER_DELAY" =~ ^[0-9]+$ ]] && [[ "$USER_DELAY" -ge 1 ]]; then
    DELAY="$USER_DELAY"
  fi
  if [[ -n "$USER_SOUND" ]] && [[ -f "$USER_SOUND" ]]; then
    SOUND="$USER_SOUND"
  fi
fi

PIDFILE="/tmp/claude-idle-alert.pid"
SESSION_FILE="/tmp/claude-idle-alert.session"

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

  # Custom sound from config
  if [[ -n "$SOUND" ]]; then
    if command -v afplay &>/dev/null; then
      afplay "$SOUND" 2>/dev/null || true
    elif command -v paplay &>/dev/null; then
      paplay "$SOUND" 2>/dev/null || true
    elif command -v aplay &>/dev/null; then
      aplay "$SOUND" 2>/dev/null || true
    fi
  # macOS default
  elif command -v afplay &>/dev/null; then
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