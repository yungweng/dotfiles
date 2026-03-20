#!/bin/sh
# Remove a session from the tmux-resurrect save file so continuum won't revive it.
# Usage: kill-session-clean.sh <session-name>

SESSION="$1"
SAVE_FILE="$HOME/.local/share/tmux/resurrect/last"

if [ -z "$SESSION" ]; then
  echo "Usage: kill-session-clean.sh <session-name>" >&2
  exit 1
fi

if [ -f "$SAVE_FILE" ]; then
  awk -F'\t' -v s="$SESSION" '$2 != s' "$SAVE_FILE" > "$SAVE_FILE.tmp" && mv "$SAVE_FILE.tmp" "$SAVE_FILE"
fi
