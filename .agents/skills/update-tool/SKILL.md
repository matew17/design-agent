---
name: update-tool
description: Update the shared design agent tool to the latest version from the team repository. Use when the session notice says an update is available, when the designer asks to update or refresh the tool, or after their pull request was merged. Do not use for updating design files or tickets.
---

# Update the design agent

Run the update script and report the result in plain language.

## Steps

1. Run `bash scripts/update.sh` from the repository root.
2. If it reports local edits that are not shared, stop and ask the designer
   whether to share them first (`@share-changes`) or keep working on them.
   Never discard their edits.
3. If it succeeds, tell the designer the old and new version and the
   highlights from the changelog it printed.
4. Remind them to start a new chat so new skills and configuration load.

## Do not

- Run any git command other than the script.
- Retry on a failed network call more than once; point them to
  `bash scripts/doctor.sh` instead.
