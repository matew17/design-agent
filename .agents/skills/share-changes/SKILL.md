---
name: share-changes
description: Share edits made to the design agent tool (skills, context, templates, docs) with the rest of the team by opening a pull request. Use when the designer says they want to share, publish, contribute or submit their changes to the tool. Do not use for sharing designs or Figma files.
---

# Share changes with the team

Turn the designer's local edits into a pull request on the team repository.

## Steps

1. Run `git status --short` and summarise in one sentence which files changed.
   If nothing changed, say so and stop.
2. Ask for, or derive from the conversation, a one-line description of the
   change (what it adds or fixes, from a designer's point of view).
3. If the change adds or edits a skill, check that `CHANGELOG.md` has an entry
   under a new version heading and that `VERSION` was bumped (patch for fixes,
   minor for new skills). Make those edits if missing.
4. Run `bash scripts/share.sh "<description>"`. This creates a branch, commits,
   pushes and opens the pull request. The designer will be asked to approve the
   command; explain in one sentence what it does.
5. Report the pull request link and who should review it (see
   `docs/CONTRIBUTING.md`). If the script printed a browser link instead,
   tell the designer to press "Create pull request" in the page that opened.

## Do not

- Commit secrets, client names, or exported customer data. Scan the diff for
  them before running the script and ask the designer to remove them.
- Push to the main branch or use any git command beyond `git status` and
  `git diff`.
