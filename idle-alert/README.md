# idle-alert

A Claude Code plugin that plays a sound alert when Claude is idle and waiting for your input. Configurable delay and sound. Cancels automatically when you return.

## How it works

- **Sound triggers** after a configurable delay (default: 20s) when Claude stops (`Stop` event) or sends a notification (`Notification` event)
- **Cancels automatically** when you submit a prompt (`UserPromptSubmit`) or close the session (`SessionEnd`)
- **Session-aware**: only cancels the timer for the terminal session that triggered it — multiple Claude terminals won't interfere with each other

## Requirements

- **macOS**: `afplay` (built-in, plays `Submarine.aiff`)
- **Linux**: `paplay` (PulseAudio) or `aplay` (ALSA)
- `jq` must be installed (`brew install jq` / `apt install jq`)

## Configuration

Run `/idle-alert-setup` to interactively pick your sound and delay. It will:
- List available system sounds on your OS
- Let you preview each sound before choosing
- Ask for the delay (default: 20s)
- Write config to `.claude/idle-alert.local.md`

Or create the config file manually:

```markdown
---
delay: 30
sound: /System/Library/Sounds/Glass.aiff
---
```

**Available macOS sounds:** Basso, Blow, Bottle, Frog, Funk, Glass, Hero, Morse, Ping, Pop, Purr, Sosumi, Submarine (default), Tink

**Linux sounds:** Varies by distro — typically in `/usr/share/sounds/freedesktop/stereo/`

After changing settings, restart Claude Code for them to take effect.

## Installation

```bash
claude plugin install github:spadarshut/spadarskills/idle-alert
```

Or clone and install locally:

```bash
git clone https://github.com/spadarshut/spadarskills.git
claude plugin install ./spadarskills/idle-alert
```