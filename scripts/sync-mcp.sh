#!/usr/bin/env bash
# Copy the MCP server definitions from this project's .codex/config.toml into
# ~/.codex/config.toml so the ChatGPT app lists them under Settings > MCP
# servers and can authenticate them. Idempotent: existing entries are left alone.
set -u
cd "$(dirname "$0")/.." || exit 1
src=".codex/config.toml"
dst="$HOME/.codex/config.toml"
mkdir -p "$HOME/.codex"; touch "$dst"

servers=$(grep -o '^\[mcp_servers\.[A-Za-z0-9_-]*\]' "$src" | sed 's/\[mcp_servers\.\(.*\)\]/\1/')
added=0
for name in $servers; do
  if grep -q "^\[mcp_servers\.$name\]" "$dst"; then
    echo "  already present: $name"
    continue
  fi
  block=$(awk -v s="[mcp_servers.$name]" '
    $0 == s {p=1}
    p && $0 != s && /^\[/ {exit}
    p && !/^[[:space:]]*#/ && !/^[[:space:]]*$/ {print}
  ' "$src")
  printf '\n# design-agent: synced from %s/.codex/config.toml\n%s\n' "$(pwd)" "$block" >> "$dst"
  echo "  added: $name"
  added=$((added+1))
done
echo "MCP sync done ($added added). Restart the ChatGPT app, then open Settings > MCP servers to authenticate."
