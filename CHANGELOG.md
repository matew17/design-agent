# Changelog

All notable changes to the design agent tool. Bump `VERSION` with every entry.

## 0.1.1 - 2026-11-04

- Default to "Approve for me" (`approvals_reviewer = "auto_review"`).
- Session-start hook writes a line to `.local/hooks.log` so it is easy to see it ran.
- Added `docs/what-is-this.md`, a plain-language overview for designers.

## 0.1.0 - 2026-11-04

- Initial foundation: AGENTS.md, project config, GitHub and Figma MCP entries,
  session-start update check, command rules, and the `update-tool`,
  `share-changes`, `design-brief-from-ticket` and `add-skill` skills.
