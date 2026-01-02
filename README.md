# dotfiles

Personal configuration files managed with [GNU Stow](https://www.gnu.org/software/stow/).

## Contents

| Package | Description |
|---------|-------------|
| `fish/` | Fish shell configuration |
| `ghostty/` | Ghostty terminal config |
| `starship/` | Starship prompt config |
| `git/` | Git configuration with aliases |
| `macos/` | macOS-specific setup scripts |
| `claude/` | Claude Code CLI configuration |
| `codex/` | Codex CLI configuration |
| `tmux/` | tmux terminal multiplexer config |
| `vim/` | Vim editor config |
| `npm/` | npm global prefix setting |
| `topgrade/` | Topgrade system updater config |
| `btop/` | btop system monitor config |
| `htop/` | htop process viewer config |
| `gh/` | GitHub CLI preferences |
| `zed/` | Zed editor keymap and settings |

## Installation

### Prerequisites

```bash
brew install stow
```

### Clone and Stow

```bash
git clone git@github.com:yungweng/dotfiles.git ~/repos/dotfiles
cd ~/repos/dotfiles

# Install all packages
stow fish ghostty starship git claude codex tmux vim npm topgrade btop htop gh zed
```

### Install Individual Packages

```bash
cd ~/repos/dotfiles

stow fish      # Fish shell config
stow ghostty   # Ghostty terminal
stow starship  # Starship prompt
stow git       # Git config
stow claude    # Claude Code CLI
stow codex     # Codex CLI
stow tmux      # tmux
stow vim       # Vim
stow npm       # npm
stow topgrade  # Topgrade
stow btop      # btop
stow htop      # htop
stow gh        # GitHub CLI
stow zed       # Zed editor
```

> **Note:** Use `stow --adopt <package>` if the target files already exist. This moves existing files into the repo and creates symlinks. Run `git diff` afterward to review changes.

## Usage

### Add a new config to an existing package

Just add the file to the package with the correct path structure:

```bash
# Example: add a new fish function
# File goes in: ~/repos/dotfiles/fish/.config/fish/functions/myfunction.fish
# Stow creates: ~/.config/fish/functions/myfunction.fish
```

### Re-stow after adding files

```bash
stow -R fish  # Restow (re-creates symlinks)
```

### Remove symlinks

```bash
stow -D fish  # Delete symlinks for fish package
```

### Add a new package

1. Create the package directory with the target path structure:
   ```bash
   mkdir -p ~/repos/dotfiles/newapp/.config/newapp
   ```

2. Add your config file:
   ```bash
   cp ~/.config/newapp/config ~/repos/dotfiles/newapp/.config/newapp/
   ```

3. Remove the original and stow:
   ```bash
   rm ~/.config/newapp/config
   stow newapp
   ```

## Directory Structure

Stow mirrors the directory structure relative to `~`. The `.stowrc` file sets the target to home (`~`).

```
~/repos/dotfiles/
├── .stowrc                      # Sets --target=~
├── fish/
│   └── .config/fish/            → ~/.config/fish/
├── ghostty/
│   └── .config/ghostty/         → ~/.config/ghostty/
├── starship/
│   └── .config/starship.toml    → ~/.config/starship.toml
├── git/
│   └── .gitconfig               → ~/.gitconfig
├── claude/
│   └── .claude/                 → ~/.claude/
├── codex/
│   └── .codex/                  → ~/.codex/
├── tmux/
│   └── .tmux.conf               → ~/.tmux.conf
├── vim/
│   └── .vimrc                   → ~/.vimrc
├── npm/
│   └── .npmrc                   → ~/.npmrc
├── topgrade/
│   └── .config/topgrade.toml    → ~/.config/topgrade.toml
├── btop/
│   └── .config/btop/btop.conf   → ~/.config/btop/btop.conf
├── htop/
│   └── .config/htop/htoprc      → ~/.config/htop/htoprc
├── gh/
│   └── .config/gh/config.yml    → ~/.config/gh/config.yml
├── zed/
│   └── .config/zed/             → ~/.config/zed/ (keymap.json, settings-shared.json)
└── macos/
    └── setup-touchid-sudo.sh    (not stowed, run manually)
```

## Secrets

API tokens and credentials are stored in `~/.config/fish/secrets.fish` (not tracked by git):

```fish
# ~/.config/fish/secrets.fish
set -gx CR_PAT "your-github-pat"
set -gx SONAR_TOKEN "your-sonar-token"
```

This file is sourced automatically by `config.fish`.

## Git Aliases

| Alias | Description |
|-------|-------------|
| `prune-local` | Remove local branches whose remote tracking branch is gone |

## Fish Abbreviations

| Abbr | Expands to |
|------|------------|
| `cy` | `claude --dangerously-skip-permissions` |
| `claudeyolo` | `claude --dangerously-skip-permissions` |

## macOS Setup

```bash
# Enable Touch ID for sudo (persists across system updates)
./macos/setup-touchid-sudo.sh
```
