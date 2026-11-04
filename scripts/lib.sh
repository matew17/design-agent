#!/usr/bin/env bash
# Shared helpers for design agent scripts. Source, do not execute.

repo_root() {
  git rev-parse --show-toplevel 2>/dev/null
}

default_branch() {
  # Prefer the remote HEAD, fall back to main.
  local b
  b=$(git symbolic-ref --quiet --short refs/remotes/origin/HEAD 2>/dev/null | sed 's#^origin/##')
  echo "${b:-main}"
}

remote_slug() {
  # Prints owner/repo from the origin URL, empty if none.
  git remote get-url origin 2>/dev/null \
    | sed -E 's#^(git@|https?://)([^/:]+)[:/]##; s#\.git$##'
}

json_escape() {
  # Minimal JSON string escaping for our own messages.
  printf '%s' "$1" | sed -e 's/\\/\\\\/g' -e 's/"/\\"/g' | awk 'BEGIN{ORS="\\n"} {print}' | sed 's/\\n$//'
}

current_branch() {
  git symbolic-ref --short -q HEAD 2>/dev/null || echo "detached"
}
