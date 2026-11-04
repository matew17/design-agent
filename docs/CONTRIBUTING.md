# Contributing

## For designers

1. Make your change in a chat (edit a skill, add a context file, fix a template).
2. Run `@share-changes`. Describe the change in one line when asked.
3. The design lead reviews the pull request. Once merged, everyone gets it on
   their next `@update-tool`.

## Review checklist (design lead)

- No client names, credentials or customer data.
- Skill `description` says when to use it and when not to.
- Steps are concrete and reference `context/` instead of repeating it.
- `VERSION` bumped and `CHANGELOG.md` updated.
- Scripts are bash only, run from the repo root, and never delete files.

## Versioning

- Patch (0.1.x): wording, fixes, context updates.
- Minor (0.x.0): new or reworked skills, new MCP servers.
- Major: changes that require every designer to re-run install.

## Testing changes locally

- Scripts: `bash scripts/doctor.sh`, then run the script you changed.
- Command rules: the Codex binary bundled with the ChatGPT app can evaluate
  a command against the rules file without starting a chat:

  ```bash
  CODEX="/Applications/ChatGPT.app/Contents/Resources/codex-cli/CodexCLI.app/Contents/MacOS/codex"
  "$CODEX" execpolicy check --pretty --rules .codex/rules/design-agent.rules -- git push --force
  ```

- Project config: `CODEX_HOME=$(mktemp -d) "$CODEX" -C "$PWD" mcp list` after
  writing a trust entry for this folder in that temporary home.
