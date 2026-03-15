---
name: slack-workspace-rules
description: Ganztagshelden Slack workspace communication rules. Use when composing or sending Slack messages to ensure proper thread structure, title formatting, reactions, and channel etiquette. Apply before sending any message via the Slack MCP.
---

# Ganztagshelden Slack Workspace Rules

These rules govern how messages are structured in the Ganztagshelden Slack workspace. Apply them **every time** you compose or send a Slack message.

## Thread Structure

Every new topic gets its own thread. Never post follow-up messages as separate top-level messages.

### Thread Header Format

The thread header (top-level message) MUST follow this pattern:

```
:emoji: *[Title of the Topic]*
```

- Wrap the title in `*[...]*` (bold + square brackets)
- Prefix with a relevant emoji
- Keep the title short and descriptive

**Examples from the workspace:**

```
:clock8: *[Die Zeit drangt: Status Quo Multitenant]*
:burrito: *[Burbach in Altenberge - Actions]*
:slack: *[Slack Communication Design Guidelines]*
:screwdriver: *Status Quo: Multi-Tenant*
```

### Thread Replies

- All discussion about a topic stays in the thread
- Start with a TL;DR if the reply is long
- Include links to docs, PRs, or tickets when relevant

## Channel Etiquette

### Prefer Public Channels Over DMs

Keep discussions in public channels to avoid information silos. Only use DMs for truly private matters.

### Reactions for Quick Communication

Use reactions instead of writing short reply messages:

| Reaction | Meaning |
|----------|---------|
| :+1: | Seen / understood |
| :white_check_mark: | Done |
| :fast_forward: | I'll handle it later |
| :heavy_plus_sign: | I agree |

## When Composing Messages

1. **New topic?** Create a new top-level message with `*[Title]*` format
2. **Replying to existing topic?** Use the thread, never a new top-level message
3. **Long message?** Add a TL;DR at the top of the reply
4. **Referencing code/PRs?** Include the link
5. **Quick acknowledgment?** Use a reaction, don't write a message

## Documentation Rule

Slack is for discussions, NOT for long-term documentation. Use GitHub, Excalidraw, or other tools for:
- Specifications
- Larger documents
- Processes

## Useful Search Operators

When searching Slack:
- `in:#channel` — search within a channel
- `from:@person` — messages from a specific person
- `has:link` — messages containing links
- `before:2025-09-01` / `after:2025-08-01` — date ranges
