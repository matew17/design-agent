#!/usr/bin/env bash
# One-time setup for a designer's Mac. Safe to run again.
#   1. Make sure git exists (Xcode command line tools).
#   2. Set a git identity.
#   3. Install the GitHub CLI if missing (no Homebrew needed) and sign in.
#   4. Mark this folder as trusted for Codex so project config, hooks and
#      rules load.
set -u
cd "$(dirname "$0")/.." || exit 1
here=$(pwd)
echo "Design agent setup in $here"
echo

# 1. git
if ! xcode-select -p >/dev/null 2>&1; then
  echo "Installing Apple command line tools (git). A dialog will open; press Install,"
  echo "then run this script again when it finishes."
  xcode-select --install 2>/dev/null
  exit 0
fi

# 2. git identity
if [ -z "$(git config --global user.name)" ]; then
  read -r -p "Your name (for shared changes): " name
  git config --global user.name "$name"
fi
if [ -z "$(git config --global user.email)" ]; then
  read -r -p "Your work email: " email
  git config --global user.email "$email"
fi
git config --global pull.ff only

# 3. GitHub CLI
mkdir -p "$HOME/.local/bin"
case ":$PATH:" in *":$HOME/.local/bin:"*) ;; *) export PATH="$HOME/.local/bin:$PATH";; esac
if ! command -v gh >/dev/null 2>&1; then
  if command -v brew >/dev/null 2>&1; then
    brew install gh
  else
    echo "Downloading the GitHub CLI..."
    arch=$(uname -m); [ "$arch" = "x86_64" ] && arch=amd64
    asset=$(curl -fsSL https://api.github.com/repos/cli/cli/releases/latest \
      | grep -o "https://[^\"]*gh_[0-9.]*_macOS_${arch}.zip" | head -1)
    tmp=$(mktemp -d)
    if [ -n "$asset" ] && curl -fsSL "$asset" -o "$tmp/gh.zip" && unzip -q "$tmp/gh.zip" -d "$tmp"; then
      cp "$tmp"/gh_*/bin/gh "$HOME/.local/bin/gh" && chmod +x "$HOME/.local/bin/gh"
      grep -q '.local/bin' "$HOME/.zshrc" 2>/dev/null || echo 'export PATH="$HOME/.local/bin:$PATH"' >> "$HOME/.zshrc"
      echo "GitHub CLI installed to ~/.local/bin/gh"
    else
      echo "Could not download the GitHub CLI. Pull requests will fall back to a browser link."
    fi
    rm -rf "$tmp"
  fi
fi
if command -v gh >/dev/null 2>&1 && ! gh auth status >/dev/null 2>&1; then
  echo "Signing in to GitHub in your browser..."
  gh auth login --web --git-protocol https && gh auth setup-git
fi

# 4. Make the Codex CLI bundled with the ChatGPT app available as `codex`
bundled="/Applications/ChatGPT.app/Contents/Resources/codex-cli/CodexCLI.app/Contents/MacOS/codex"
if ! command -v codex >/dev/null 2>&1 && [ -x "$bundled" ]; then
  ln -sf "$bundled" "$HOME/.local/bin/codex"
  grep -q '.local/bin' "$HOME/.zshrc" 2>/dev/null || echo 'export PATH="$HOME/.local/bin:$PATH"' >> "$HOME/.zshrc"
  echo "Linked the app's Codex CLI as ~/.local/bin/codex"
fi

# 5. Trust this project for Codex
cfg="$HOME/.codex/config.toml"
mkdir -p "$HOME/.codex"
touch "$cfg"
if ! grep -Fq "[projects.\"$here\"]" "$cfg"; then
  printf '\n[projects."%s"]\ntrust_level = "trusted"\n' "$here" >> "$cfg"
  echo "Marked $here as a trusted Codex project."
fi

# 6. Make the MCP servers visible in the app's settings
echo "Syncing MCP servers into ~/.codex/config.toml"
bash scripts/sync-mcp.sh

echo
echo "Setup complete. Next steps:"
echo "  1. Open the ChatGPT app, go to Codex, and add this folder as a project (make it the primary folder)."
echo "  2. In Settings > MCP servers press Authenticate for 'github' and 'figma'."
echo "  3. In Settings > Hooks, review and trust the design agent hooks."
echo "  4. Start a chat and type @update-tool to confirm everything works."
bash scripts/doctor.sh
