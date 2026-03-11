---
description: Configure idle-alert sound and delay settings
allowed-tools: ["Bash", "Write", "Read", "AskUserQuestion"]
---

# Idle Alert Setup

Configure the idle-alert plugin for this project.

## Steps

1. Detect OS and list available system sounds:

**macOS:** Run `ls /System/Library/Sounds/` to get available sounds.
**Linux:** Run `ls /usr/share/sounds/freedesktop/stereo/ 2>/dev/null` and `ls /usr/share/sounds/ 2>/dev/null` to find available sounds.

2. Print a numbered list of available sounds to the console (e.g. `1. Basso`, `2. Blow`, ...). Add a "Custom path" option as the last entry. Mark the default with `(default)`: **Submarine** (macOS) or **complete.oga** (Linux).

3. Offer to open the sounds directory so the user can preview them:
   - **macOS:** `open /System/Library/Sounds/`
   - **Linux:** `xdg-open /usr/share/sounds/freedesktop/stereo/ 2>/dev/null` or `xdg-open /usr/share/sounds/`
   Tell the user they can double-click files in the opened folder to hear them.

4. Ask the user to enter the **number** of their chosen sound. If they pick "Custom path", ask for the full file path.

5. Ask the user for the **delay in seconds** before the sound plays. Suggest default of **20 seconds**. Validate it's a positive integer.

6. Write the config to `.claude/idle-alert.local.md`:

```markdown
---
delay: <chosen_delay>
sound: <full_path_to_chosen_sound>
---
```

7. Check if `.claude/idle-alert.local.md` is in `.gitignore`. If not, suggest adding `.claude/*.local.md` to `.gitignore`.

8. Confirm setup is complete. Remind the user to **restart Claude Code** for changes to take effect.
