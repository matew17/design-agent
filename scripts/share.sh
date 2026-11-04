#!/usr/bin/env bash
# Share local changes with the team: branch, commit, push, open a pull request.
# Usage: scripts/share.sh "Short description of the change"
set -u
cd "$(dirname "$0")/.." || exit 1
. scripts/lib.sh
root=$(repo_root) || { echo "Not inside the design agent repository."; exit 1; }
cd "$root"
branch=$(default_branch)
title=${1:-}

if [ -z "$title" ]; then
  echo "Usage: scripts/share.sh \"Short description of the change\""
  exit 2
fi
if [ -z "$(git status --porcelain)" ]; then
  echo "There is nothing to share: no local changes."
  exit 0
fi

# Branch name: share/<user>/<date>-<slug>
user=$(git config user.name 2>/dev/null | tr 'A-Z ' 'a-z-' | tr -cd 'a-z0-9-')
user=${user:-designer}
slug=$(printf '%s' "$title" | tr 'A-Z' 'a-z' | tr -cs 'a-z0-9' '-' | sed 's/^-//; s/-$//' | cut -c1-40)
new_branch="share/${user}/$(date +%Y%m%d)-${slug}"

current=$(current_branch)
if [ "$current" = "$branch" ]; then
  git checkout --quiet -b "$new_branch" || exit 1
else
  new_branch=$current
fi

git add -A
git commit --quiet -m "$title" || { echo "Commit failed."; exit 1; }
GIT_TERMINAL_PROMPT=0 git push --quiet -u origin "$new_branch" || {
  echo "Push failed. Run scripts/doctor.sh to check the GitHub sign-in."
  exit 1
}

slugrepo=$(remote_slug)
if command -v gh >/dev/null 2>&1 && gh auth status >/dev/null 2>&1; then
  url=$(gh pr create --base "$branch" --head "$new_branch" --title "$title" \
        --body "Shared from the design agent by ${user}. See CHANGELOG.md for context." 2>/dev/null)
  if [ -n "$url" ]; then
    echo "Pull request created: $url"
    exit 0
  fi
fi

# Fallback: GitHub pre-fills a pull request from the compare page.
url="https://github.com/${slugrepo}/compare/${branch}...${new_branch}?expand=1"
echo "Branch pushed. Open this link to finish the pull request:"
echo "$url"
command -v open >/dev/null 2>&1 && open "$url"
exit 0
