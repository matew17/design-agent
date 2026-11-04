---
name: design-brief-from-ticket
description: Turn a GitHub issue (ticket) into a structured design brief using the team template. Use when the designer shares a ticket number or link and wants to start design work, understand scope, or prepare for a kickoff. Do not use for writing code or for tickets without a design component.
---

# Design brief from a ticket

This is the first team workflow and a template for the ones that follow. It
is intentionally generic until the team's real process is documented in
`docs/workflows/`.

## Inputs

- A ticket reference: `owner/repo#123`, a full issue URL, or a number plus the
  repository named in `context/team.md`.

## Steps

1. Read the ticket with the GitHub MCP: title, body, labels, linked issues and
   every comment. Note the author and the latest status.
2. Read `context/design-principles.md` and `context/glossary.md`. Use the
   team's vocabulary in the brief.
3. If the ticket references existing screens or components, locate them with
   the Figma MCP (read only) and list the file and frame names.
4. Fill `templates/design-brief.md` completely. Write "N/A" where a section
   does not apply instead of removing it. Keep each section short.
5. List open questions for the product owner as a numbered list the designer
   can paste into the ticket.
6. Save the brief to `docs/briefs/<ticket-id>-<slug>.md` and show the designer
   the file path and the open questions.

## QA checklist

- [ ] Every section of the template is present.
- [ ] Acceptance criteria from the ticket are copied, not paraphrased.
- [ ] Components mentioned exist in the shared library, or are flagged as new.
- [ ] No client names or personal data appear in the brief.

## Do not

- Write anything to Figma. This workflow is read only.
- Comment on the ticket unless the designer asks for it.
