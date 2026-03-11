#!/bin/bash
set -euo pipefail

PIDFILE="/tmp/claude-nudge-hitl.pid"
SESSION_FILE="/tmp/claude-nudge-hitl.session"

# Read session_id from hook input JSON
INPUT=$(cat)
SESSION_ID=$(echo "$INPUT" | jq -r '.session_id // empty' 2>/dev/null || true)

if [ -f "$PIDFILE" ]; then
  # If session tracking is active, only cancel for the matching session
  if [ -f "$SESSION_FILE" ] && [ -n "$SESSION_ID" ]; then
    STORED_SESSION=$(cat "$SESSION_FILE")
    if [ "$SESSION_ID" != "$STORED_SESSION" ]; then
      exit 0  # Different session — leave timer running
    fi
  fi

  pid=$(cat "$PIDFILE")
  kill "$pid" 2>/dev/null || true
  pkill -P "$pid" 2>/dev/null || true
  rm -f "$PIDFILE" "$SESSION_FILE"
fi