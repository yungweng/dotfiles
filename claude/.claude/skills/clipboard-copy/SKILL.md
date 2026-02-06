---
name: clipboard-copy
description: Copy text to the system clipboard. Use when user asks to copy something to clipboard, copy to pasteboard, or wants to paste something.
---

# Copy to Clipboard

When copying text to the clipboard on macOS, always use a heredoc with `pbcopy`. Never use `printf` or `echo` with escaped quotes as they break on apostrophes and special characters.

## Correct Method

```bash
cat << 'EOF' | pbcopy
Your text here with apostrophes like it's and don't.
Special characters work fine: é, ü, ñ, quotes "like this".
Multiple lines work too.
EOF
```

## Why Not printf or echo

```bash
# BAD - breaks on apostrophes, needs escaping, fragile
printf '%s' 'today'\''s meeting' | pbcopy

# BAD - same escaping problems
echo "He said \"hello\"" | pbcopy

# GOOD - heredoc with single-quoted delimiter preserves everything literally
cat << 'EOF' | pbcopy
today's meeting, "hello", it's all fine
EOF
```

## Key Rules

1. Always use `cat << 'EOF' | pbcopy` (single quotes around EOF to prevent variable expansion)
2. Never escape apostrophes or quotes manually
3. Works for any text: emails, code, prose, unicode
