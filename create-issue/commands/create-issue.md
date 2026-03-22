---
description: Create a GitHub issue for the current project. Accepts a description and optionally explores the codebase to compose a rich, implementation-ready issue.
allowed-tools: ["Bash", "Read", "Glob", "Grep", "AskUserQuestion", "Agent"]
---

# Create GitHub Issue

Create a GitHub issue for the current project.

## Prerequisites

Before starting, verify `gh` is authenticated:

Run: `gh auth status`

If not authenticated, tell the user to run `gh auth login` and stop.

## Steps

1. **Confirm the repository.** Run `gh repo view --json nameWithOwner -q .nameWithOwner` to get the repo name. Tell the user which repo the issue will be created in.

2. **Get the description.** The user's prompt is the initial description. If no description was provided, ask for one using AskUserQuestion.

3. **Ask: minimal or extensive?** Use AskUserQuestion with these options:
   - **Minimal** — Use the description as-is with light formatting
   - **Extensive** — Ask clarifying questions, explore the codebase, and compose a detailed implementation-ready description

4. **If Minimal:** Skip to step 7.

5. **If Extensive:** Ask clarifying questions one at a time using AskUserQuestion:
   - What is the purpose / user-facing goal of this change?
   - What is the scope — which parts of the codebase are affected?
   - What are the acceptance criteria — how do we know it's done?
   - Any additional context (related issues, constraints, deadlines)?

   Then ask: **Should I include git context?** (recent commits, branches, diffs relevant to this area)
   - If yes: run `git log --oneline -20`, `git branch -a`, and relevant `git diff` commands
   - If no: skip git exploration

   Then explore the codebase:
   - Use Glob/Grep/Agent to find files related to the described change
   - Read key files to understand current implementation
   - Identify affected components, dependencies, and potential risks

   Compose a rich description including:
   - **Context:** What exists today and why the change is needed
   - **Affected files/components:** List specific files discovered during exploration
   - **Suggested approach:** Based on codebase exploration
   - **Acceptance criteria:** From clarifying questions
   - **Additional context:** Git history, related code, risks

6. **Check for issue templates.** Run `ls .github/ISSUE_TEMPLATE/ 2>/dev/null` or `ls .github/ 2>/dev/null`.
   - If templates exist, read them and adapt the issue body to match the template format (fill in template sections).
   - If no templates, use plain markdown formatting.

7. **Draft the issue.** Compose a title and body. Show the full draft to the user:

   ```
   **Title:** <title>

   **Body:**
   <body>
   ```

   Ask for approval using AskUserQuestion:
   - **Create issue** — looks good, create it
   - **Edit** — I want to change something (ask what to change, revise, show again)

8. **Create the issue.** Run:

   ```bash
   gh issue create --title "<title>" --body "<body>"
   ```

   Print the resulting issue URL.
