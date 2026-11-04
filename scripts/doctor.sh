#!/usr/bin/env bash
# Check that this machine is ready to run the design agent.
set -u
cd "$(dirname "$0")/.." || exit 1
ok() { printf '  [ok]   %s\n' "$1"; }
warn() { printf '  [warn] %s\n' "$1"; }
fail() { printf '  [FAIL] %s\n' "$1"; failures=$((failures+1)); }
failures=0
echo "Design agent doctor"

if xcode-select -p >/dev/null 2>&1; then ok "Command line tools (git) installed"; else fail "Command line tools missing. Run: xcode-select --install"; fi
if command -v git >/dev/null 2>&1; then ok "git $(git --version | awk '{print $3}')"; else fail "git not found"; fi

if [ -n "$(git config user.name)" ] && [ -n "$(git config user.email)" ]; then
  ok "git identity: $(git config user.name) <$(git config user.email)>"
else
  fail "git identity not set. Run scripts/install.sh"
fi

if git remote get-url origin >/dev/null 2>&1; then ok "remote: $(git remote get-url origin)"; else warn "no git remote; updates and sharing will not work"; fi

if command -v gh >/dev/null 2>&1; then
  if gh auth status >/dev/null 2>&1; then ok "GitHub CLI signed in"; else warn "GitHub CLI installed but not signed in. Run: gh auth login --web"; fi
else
  warn "GitHub CLI (gh) not found. Pull requests fall back to a browser link."
fi

if [ -d "/Applications/ChatGPT.app" ] || command -v codex >/dev/null 2>&1; then ok "Codex (ChatGPT app or CLI) present"; else fail "Codex not found. Install the ChatGPT desktop app."; fi

cfg="$HOME/.codex/config.toml"
here=$(pwd)
if [ -f "$cfg" ] && grep -Fq "projects.\"$here\"" "$cfg"; then
  ok "project trusted in $cfg"
else
  warn "project not marked trusted in $cfg. Run scripts/install.sh or accept the trust prompt in Codex."
fi

if [ -f ".codex/hooks.json" ]; then ok "hooks present (trust them once in Settings > Hooks)"; fi
echo
if [ "$failures" -eq 0 ]; then echo "All required checks passed."; else echo "$failures required check(s) failed."; exit 1; fi
