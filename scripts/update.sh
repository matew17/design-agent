#!/usr/bin/env bash
# Update the design agent to the latest shared version (fast-forward only).
set -u
cd "$(dirname "$0")/.." || exit 1
. scripts/lib.sh
root=$(repo_root) || { echo "Not inside the design agent repository."; exit 1; }
cd "$root"
branch=$(default_branch)
before=$(cat VERSION 2>/dev/null || echo "?")

if [ -n "$(git status --porcelain)" ]; then
  echo "You have local edits that are not shared yet:"
  git status --short
  echo
  echo "Share them first with @share-changes, or ask the designer whether to keep or discard them."
  echo "Nothing was changed."
  exit 2
fi

current=$(current_branch)
if [ "$current" != "$branch" ]; then
  echo "Switching from '$current' back to '$branch'."
  git checkout --quiet "$branch" || { echo "Could not switch to $branch."; exit 1; }
fi

GIT_TERMINAL_PROMPT=0 git pull --ff-only --quiet origin "$branch" || {
  echo "Update failed. Check your connection or GitHub sign-in (scripts/doctor.sh)."
  exit 1
}

after=$(cat VERSION 2>/dev/null || echo "?")
if [ "$before" = "$after" ]; then
  echo "Design agent is already up to date (v$after)."
else
  echo "Updated design agent: v$before -> v$after"
  echo
  echo "What changed:"
  awk '/^## /{n++} n==1' CHANGELOG.md
fi
echo
echo "Open a new chat so Codex picks up the new skills and configuration."
