# nudge-hitl

A Claude Code plugin that plays a sound nudge when Claude finishes responding and is waiting for your input. Cancels automatically when you return.

## How it works

- **Sound triggers** after a configurable delay (default: 20s) when Claude stops (`Stop` event) or sends a notification (`Notification` event)
- **Cancels automatically** when you submit a prompt (`UserPromptSubmit`) or close the session (`SessionEnd`)
- **Session-aware**: only cancels the timer for the terminal session that triggered it — multiple Claude terminals won't interfere with each other

## Requirements

- **macOS**: `afplay` (built-in, plays `Submarine.aiff`)
- **Linux**: `paplay` (PulseAudio) or `aplay` (ALSA)
- `jq` must be installed (`brew install jq` / `apt install jq`)

## Configuration

To change the delay, edit `hooks/scripts/start-timer.sh` and update the `DELAY` variable at the top:

```bash
DELAY=20  # seconds before sound plays
```

## Installation

```bash
claude plugin install github:spadarshut/spadarskills/nudge-hitl
```

Or clone and install locally:

```bash
git clone https://github.com/spadarshut/spadarskills.git
claude plugin install ./spadarskills/nudge-hitl
```