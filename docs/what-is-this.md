# What is the Design Agent?

The Design Agent is our team's shared setup for Codex. Think of it as a
briefing pack for an assistant: it tells Codex who we are, how we work, which
tools it can use, and what it must never do. Everyone on the team uses the same
pack, so we all get the same kind of help and the same kind of results.

## What it does for you

- **Knows our way of working.** Our principles, vocabulary and component
  library rules are built in. You do not have to explain them in every chat.
- **Runs our workflows.** Type `@` in a chat to pick one, for example
  `@design-brief-from-ticket` to turn a ticket into a brief. Each workflow
  follows the same steps and ends with the same checklist for everyone.
- **Connects to our tools.** It reads tickets from GitHub and reads from, or
  writes to, Figma, after you sign in once.
- **Keeps itself up to date.** When you open a chat it checks whether the team
  has improved the pack and tells you. `@update-tool` installs the update.
- **Lets you improve it.** Found a better way? Change it and type
  `@share-changes`. The design lead reviews it and everyone gets it.

## What it will not do

- It will not change files outside its own folder, delete work, or publish
  anything without the safety rules we set.
- It will not write to Figma outside your drafts unless a workflow says so.
- It never stores client names, credentials or customer data.

## Getting started

1. Run the one-time install your tech contact sends you (five minutes).
2. In the ChatGPT app, open Codex and add the `design-agent` folder as a project.
3. Sign in to GitHub and Figma when the app asks.
4. Start a chat and type `@update-tool`. If it says you are up to date, you are
   ready.
