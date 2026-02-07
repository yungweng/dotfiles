# Tmux Cheat Sheet

> Based on custom `~/.tmux.conf` — Prefix: **Ctrl-a**

---

## Prefix Key

| Key | Action |
|-----|--------|
| `Ctrl-a` | Prefix (replaces default `Ctrl-b`) |
| `Ctrl-a Ctrl-a` | Send literal `Ctrl-a` to terminal |

---

## Session Management

| Key | Action |
|-----|--------|
| `Ctrl-a f` | Fuzzy session switcher (fzf popup) |
| `Ctrl-a $` | Rename current session |
| `Ctrl-a d` | Detach from tmux |
| `Ctrl-a L` | Toggle last session |
| `Alt-Up` | Switch to previous session |
| `Alt-Down` | Switch to next session |

### From Outside tmux

```bash
tmux                        # New session
tmux new -s name            # New named session
tmux attach / tmux a        # Attach to last session
tmux attach -t name         # Attach to named session
tmux ls                     # List all sessions
tmux kill-session -t name   # Kill a session
```

---

## Window Management (Tabs)

| Key | Action |
|-----|--------|
| `Ctrl-a c` | New window (inherits current path) |
| `Ctrl-a ,` | Rename current window |
| `Ctrl-a 1-9` | Jump to window N |
| `Alt-Left` | Previous window |
| `Alt-Right` | Next window |
| `Ctrl-Shift-Left` | Swap window left |
| `Ctrl-Shift-Right` | Swap window right |
| `Ctrl-a p` | Floating popup terminal (80% x 60%) |
| `Ctrl-a P` | Previous window |
| `Ctrl-a Tab` | Toggle last window |

---

## Pane Management (Splits)

### Creating Panes

| Key | Action |
|-----|--------|
| `Ctrl-a \|` | Split horizontally (side by side) |
| `Ctrl-a -` | Split vertically (top/bottom) |
| `Ctrl-a x` | Kill pane (with confirmation) |
| `Ctrl-a z` | Toggle pane zoom (fullscreen) |

### Navigating Panes

| Key | Action | Note |
|-----|--------|------|
| `Alt-h/j/k/l` | Move between panes | Always works, no prefix |
| `Ctrl-h/j/k/l` | Smart pane/vim navigation | Works across tmux panes AND vim splits |

### Resizing Panes

| Key | Action |
|-----|--------|
| `Ctrl-a h` | Resize left (5 cells) |
| `Ctrl-a j` | Resize down (5 cells) |
| `Ctrl-a k` | Resize up (5 cells) |
| `Ctrl-a l` | Resize right (5 cells) |

> Resize keys are repeatable — hold `Ctrl-a` once, then tap `h/j/k/l` multiple times.

### Moving Panes Between Windows

| Key | Action |
|-----|--------|
| `Ctrl-a J` | Join pane from another window (prompts for source) |
| `Ctrl-a S` | Send current pane to another window (prompts for target) |

### Pane Synchronization

| Key | Action |
|-----|--------|
| `Ctrl-a y` | Toggle pane sync (type in all panes simultaneously) |

---

## Copy Mode (Vi Keys)

Enter copy mode: `Ctrl-a Enter` or scroll up with mouse.

| Key | Action |
|-----|--------|
| `v` | Begin selection |
| `Ctrl-v` | Toggle rectangle selection |
| `y` | Copy to system clipboard (OSC 52) |
| `Escape` | Exit copy mode |

> Clipboard uses OSC 52 (`set-clipboard external`) — copies go directly to system clipboard via the terminal.

---

## Utilities

| Key | Action |
|-----|--------|
| `Ctrl-a Space` | Thumbs — vimium-like text copy (see Plugins) |
| `Ctrl-a r` | Reload tmux config |
| `Ctrl-a :` | Command prompt |
| `Ctrl-a Ctrl+L` | Clear pane history |

---

## Mouse

Mouse support is **enabled**:
- Click to select pane
- Drag to resize panes
- Scroll to enter copy mode

---

## Plugins (via TPM)

| Plugin | Purpose |
|--------|---------|
| `catppuccin/tmux` | Catppuccin Mocha theme (prefix indicator turns session icon red) |
| `tmux-resurrect` | Persist sessions across restarts (`Ctrl-a Ctrl-s` save / `Ctrl-a Ctrl-r` restore) |
| `tmux-continuum` | Auto-save every 5 min, auto-restore on start |
| `vim-tmux-navigator` | Seamless `Ctrl-h/j/k/l` between tmux and vim |
| `tmux-battery` | Battery percentage in status bar |
| `tmux-thumbs` | Vimium-like text copying (`Ctrl-a Space`) — highlights text, pick a hint to copy |
| `tmux-sessionx` | Fuzzy session manager (`Ctrl-a f`) |
| `gitmux` | Git branch/status in status bar (requires `~/.gitmux.conf`) |

### Plugin Management (TPM)

```bash
# Install TPM (first time only)
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
```

| Key | Action |
|-----|--------|
| `Ctrl-a I` | Install new plugins |
| `Ctrl-a U` | Update plugins |
| `Ctrl-a Alt-u` | Remove unused plugins |

---

## Quick Reference: Navigation Summary

```
Sessions:  Alt-Up/Down     (prev/next)     Ctrl-a f (fuzzy pick)  Ctrl-a L (toggle last)
Windows:   Alt-Left/Right  (prev/next)     Ctrl-a 1-9 (jump)     Ctrl-a Tab (toggle last)
Panes:     Alt-h/j/k/l    (move)          Ctrl-a h/j/k/l (resize)
           Ctrl-h/j/k/l   (vim-aware)     Ctrl-a z (zoom)
```

---

## Terminal-Specific Notes

- Optimized for **Ghostty** terminal (true color, extended keys)
- `escape-time` set to 0 for instant vim mode switching
- Scrollback buffer: 500,000 lines
- Windows and panes start at index **1** (not 0)
