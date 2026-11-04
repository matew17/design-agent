# Design Agent

A shared Codex setup for the design team: one set of instructions, skills,
rules and connections so every designer gets the same workflow and the same
kind of result. Works in the ChatGPT desktop app (Codex), the Codex CLI and the
IDE extension, because all three read the same project files.

## Install (first time, about five minutes)

1. Open **Terminal** (press Cmd+Space, type Terminal) and paste:

   ```bash
   git clone https://github.com/<owner>/design-agent.git ~/design-agent && bash ~/design-agent/scripts/install.sh
   ```

   The script installs the GitHub command line tool if needed, signs you in to
   GitHub in the browser, and marks the folder as trusted for Codex.
2. Open the **ChatGPT app**, go to **Codex**, create a project and attach the
   `design-agent` folder as its **primary** folder.
3. In **Settings > MCP servers** press **Authenticate** next to `github` and
   `figma`.
4. In **Settings > Hooks** review and trust the design agent hooks.
5. Start a chat and type `@update-tool`. If it answers "already up to date",
   you are done.

## Daily use

- Type `@` in the chat to see the team skills. Each one is a workflow:
  - `@design-brief-from-ticket` turns a GitHub ticket into a brief.
  - `@update-tool` installs the latest version of this setup.
  - `@share-changes` sends your improvements to the team as a pull request.
  - `@add-skill` captures a repeatable process as a new skill.
- When a chat opens, the agent checks whether the tool has updates or you have
  unshared edits and tells you.

## For the people maintaining this

- `AGENTS.md` is the agent's standing instructions. Keep it under two screens.
- `context/` holds team conventions. Edit freely, keep it anonymised.
- `.agents/skills/<name>/SKILL.md` one folder per workflow. See
  `templates/skill-template/`.
- `.codex/config.toml` MCP servers, sandbox and approval policy for this project.
- `.codex/hooks.json` session start update check.
- `.codex/rules/` which shell commands run without asking, which prompt, and
  which are forbidden.
- `scripts/` install, doctor, update, share, check-updates.
- Bump `VERSION` and add a `CHANGELOG.md` entry with every change; the update
  check shows both to the team.

See `docs/CONTRIBUTING.md` for the review flow and `docs/workflows/` for the
written versions of each team process.

## Known limits

- GitHub's remote MCP server supports OAuth in some hosts only. If
  **Authenticate** fails in Codex, use a fine-grained personal access token
  and the commented `bearer_token_env_var` line in `.codex/config.toml`.
- The component library MCP is not configured yet. Add it to
  `.codex/config.toml` once its command and sign-in are known.
- Project settings load only after the folder is trusted and hooks are
  trusted. `bash scripts/doctor.sh` reports both.
