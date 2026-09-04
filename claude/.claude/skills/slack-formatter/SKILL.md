---
name: slack-formatter
description: Format text for Slack messages. Use when a user wants to share content in Slack, send it through a Slack API or MCP tool, or copy it to the clipboard for manual pasting. Distinguish Slack API mrkdwn from text pasted into Slack's message editor, especially for links.
---

# Slack Message Formatter

Choose the output format from the delivery path before formatting:

- **Manual paste into Slack's message editor:** use paste-safe text. Write links as `Label (https://example.com)` or as bare URLs so Slack auto-links them.
- **Slack API, webhook, MCP, or Block Kit:** use Slack `mrkdwn`. Labeled links may use `<https://example.com|Label>`.

Never put `<URL|label>` links on the clipboard for manual pasting. That is API syntax and can appear as raw text in Slack's editor.

## Quick Reference

### Slack API `mrkdwn` Syntax

| Format | Slack Syntax | Example |
|--------|--------------|---------|
| Bold | `*text*` | `*important*` |
| Italic | `_text_` | `_emphasis_` |
| Strikethrough | `~text~` | `~deleted~` |
| Inline code | `` `text` `` | `` `code` `` |
| Code block | ` ``` ` (triple backticks) | See below |
| Link | `<URL\|text>` | `<https://example.com\|Click here>` |
| Bullet list | `• item` or `* item` | `• First item` |
| Numbered list | `1. item` | `1. First item` |
| Quote | `> text` | `> quoted text` |
| User mention | `<@USERID>` | `<@U123ABC>` |
| Channel | `<#CHANNELID>` | `<#C123ABC>` |
| Emoji | `:emoji_name:` | `:rocket:` |

### Manual-Paste Link Syntax

| Input | Paste-safe Slack output |
|-------|-------------------------|
| `[Issue #123](https://github.com/acme/repo/issues/123)` | `Issue #123 (https://github.com/acme/repo/issues/123)` |
| `<https://example.com\|Docs>` | `Docs (https://example.com)` |

The visible URL is intentional: Slack recognizes and makes it clickable after pasting. Do not rely on Markdown links or API-only angle-bracket syntax in the interactive editor.

### What Slack Does NOT Support

- `**bold**` (use `*bold*` instead)
- `## Headers` (use `*Bold Text*` instead)
- Tables with `| |` syntax (not supported at all)
- Horizontal rules `---` (not rendered)
- Complex ASCII art (gets mangled)
- Syntax highlighting in code blocks
- Nested formatting
- Images via markdown

## Conversion Rules

When converting content for Slack:

1. **Headers**: Replace `## Header` with `*Header*` (bold)
2. **Bold**: Replace `**text**` with `*text*`
3. **Tables**: Convert to bullet lists or simple text
4. **Diagrams**: Simplify to basic ASCII in code blocks, or describe in text
5. **Links**:
   - For manual paste, convert `[text](url)` to `text (url)`.
   - For API/MCP delivery, convert `[text](url)` to `<url|text>`.
6. **Lists**: Use `•` for bullets, `1.` for numbered

## Code Block Example

```
This is a code block in Slack.
No syntax highlighting available.
Keep it simple and readable.
```

## Workflow

When user asks to format for Slack:

1. **Determine delivery**: manual paste or API/MCP send.
2. **Convert** with the matching link syntax.
3. **Simplify** tables and complex diagrams.
4. **Copy** only paste-safe text when the user will paste it manually; follow the `clipboard-copy` skill when available.
5. **Confirm** the delivery format and whether the text was copied or sent.

### Copy to Clipboard Command

```bash
# macOS
cat << 'EOF' | pbcopy
Your formatted content here
EOF

# Linux
cat << 'EOF' | xclip -selection clipboard
Your formatted content here
EOF
```

## Example Conversion

### Input (Standard Markdown)

```markdown
## Important Update

**Key changes:**
- Feature A added
- Bug B fixed

| Status | Count |
|--------|-------|
| Done   | 5     |
| Pending| 3     |

Check the [documentation](https://docs.example.com).
```

### Output for Manual Paste

```
*Important Update*

*Key changes:*
• Feature A added
• Bug B fixed

*Status:*
• Done: 5
• Pending: 3

Check the documentation (https://docs.example.com).
```

### Output for Slack API/MCP

Use the same text, but write the final sentence as:

```text
Check the <https://docs.example.com|documentation>.
```

## Tips for Good Slack Messages

1. **Keep it short** - Slack is for quick communication
2. **Use emoji sparingly** - They work but don't overdo it
3. **Code blocks for anything monospace** - Diagrams, logs, code
4. **Bold for emphasis** - `*key point*`
5. **Bullet points** - Easier to scan than paragraphs
6. **Break up long messages** - Use line breaks liberally

## Reference Links

For more details on Slack formatting:
- Official: https://slack.com/help/articles/202288908-Format-your-messages-in-Slack
- API Reference: https://api.slack.com/reference/surfaces/formatting
- Markdown Guide: https://www.markdownguide.org/tools/slack/

## Common Emoji Shortcodes

| Emoji | Code |
|-------|------|
| ✅ | `:white_check_mark:` |
| ❌ | `:x:` |
| 🚀 | `:rocket:` |
| 💡 | `:bulb:` |
| ⚠️ | `:warning:` |
| 🎉 | `:tada:` |
| 👍 | `:+1:` |
| 🔥 | `:fire:` |
| 📝 | `:memo:` |
| 🐛 | `:bug:` |
