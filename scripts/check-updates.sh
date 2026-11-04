#!/usr/bin/env bash
# SessionStart hook: tell the designer if the tool has updates or unshared edits.
# Prints JSON understood by Codex hooks. Must never fail the session, so every
# error path exits 0 with a quiet message.
set -u
cd "$(dirname "$0")/.." || exit 0
. scripts/lib.sh

root=$(repo_root) || exit 0
cd "$root" || exit 0
branch=$(default_branch)
version=$(cat VERSION 2>/dev/null || echo "unknown")

# Leave a trace so "did the hook run?" has a simple answer: cat .local/hooks.log
mkdir -p .local
log() { printf '%s check-updates: %s\n' "$(date '+%Y-%m-%d %H:%M:%S')" "$1" >> .local/hooks.log; }

notes=()

if git remote get-url origin >/dev/null 2>&1; then
  # Quiet fetch; no terminal prompts, and give up fast when offline.
  GIT_TERMINAL_PROMPT=0 git -c http.lowSpeedLimit=1000 -c http.lowSpeedTime=8 \
    fetch --quiet origin "$branch" >/dev/null 2>&1 || notes+=("Could not reach the tool repository (offline?). Skipped the update check.")

  if git rev-parse --verify --quiet "origin/$branch" >/dev/null; then
    behind=$(git rev-list --count "HEAD..origin/$branch" 2>/dev/null || echo 0)
    if [ "${behind:-0}" -gt 0 ]; then
      latest=$(git show "origin/$branch:VERSION" 2>/dev/null || echo "?")
      changes=$(git log --oneline "HEAD..origin/$branch" 2>/dev/null | head -5 | sed 's/^/  - /')
      notes+=("Design agent update available: ${version} -> ${latest} (${behind} new change(s)). Run @update-tool to install. Highlights:"$'\n'"${changes}")
    fi
  fi
else
  notes+=("This folder has no git remote yet, so updates cannot be checked.")
fi

current=$(current_branch)
if [ -n "$(git status --porcelain 2>/dev/null)" ]; then
  notes+=("There are local edits in the design agent folder that are not shared yet. Use @share-changes when ready.")
fi
if [ "$current" != "$branch" ] && [ "$current" != "detached" ]; then
  notes+=("You are on branch '${current}', not '${branch}'. If your pull request was merged, run @update-tool to get back to the latest version.")
fi

if [ ${#notes[@]} -eq 0 ]; then
  ctx="Design agent v${version} is up to date."
  log "v${version} up to date"
  printf '{"hookSpecificOutput":{"hookEventName":"SessionStart","additionalContext":"%s"}}\n' "$(json_escape "$ctx")"
  exit 0
fi

msg=$(printf '%s\n' "${notes[@]}")
log "${#notes[@]} notice(s): $(printf '%s' "$msg" | head -1)"
ctx="Design agent v${version} session notices (tell the designer in one or two sentences, then continue):"$'\n'"${msg}"
printf '{"systemMessage":"%s","hookSpecificOutput":{"hookEventName":"SessionStart","additionalContext":"%s"}}\n' \
  "$(json_escape "$msg")" "$(json_escape "$ctx")"
exit 0
