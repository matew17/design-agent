---
name: add-skill
description: Create a new team skill (workflow) for the design agent from the template, or improve an existing one. Use when the designer describes a repeatable process they want the team to follow, or asks to turn what they just did into a skill. Do not use for one-off tasks.
---

# Add or improve a skill

Capture a repeatable design workflow so every designer runs it the same way.

## Steps

1. Agree with the designer on: a short kebab-case name, when the skill should
   trigger, its inputs, its steps, its outputs and a QA checklist. Ask one
   question at a time; designers are the experts, you are the scribe.
2. Copy `templates/skill-template/` to `.agents/skills/<name>/` and fill
   `SKILL.md`. The `description` must say when to use it and when not to.
3. Put anything deterministic (file naming, data lookups, format conversion)
   in a script under `.agents/skills/<name>/scripts/` and call it from the
   steps. Keep reasoning steps as instructions.
4. Add a changelog entry and bump `VERSION` (minor version for a new skill).
5. Offer to run `@share-changes` so the team gets it.

## Quality bar

- The skill must work for a designer who did not write it.
- Steps reference the team's context files rather than repeating them.
- Every skill ends with a QA checklist and a summary the designer can paste
  into the ticket.
