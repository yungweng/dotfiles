# dotfiles

Personal configuration files.

## Contents

- `.gitconfig` - Git configuration with aliases
- `macos/` - macOS-specific setup scripts
- `fish/` - Fish shell configuration
  - `config.fish` - Main config (PATH, aliases, functions)
  - `functions/` - Custom fish functions
  - `conf.d/` - Auto-sourced configuration snippets

## Git Aliases

| Alias | Description |
|-------|-------------|
| `prune-local` | Remove local branches whose remote tracking branch is gone |

## Fish Abbreviations

| Abbr | Expands to |
|------|------------|
| `cy` | `claude --dangerously-skip-permissions` |
| `claudeyolo` | `claude --dangerously-skip-permissions` |

## Installation

```bash
git clone git@github.com:yungweng/dotfiles.git ~/repos/dotfiles

# Git
ln -sf ~/repos/dotfiles/.gitconfig ~/.gitconfig

# Fish
ln -sf ~/repos/dotfiles/fish/config.fish ~/.config/fish/config.fish
ln -sf ~/repos/dotfiles/fish/functions/* ~/.config/fish/functions/
ln -sf ~/repos/dotfiles/fish/conf.d/* ~/.config/fish/conf.d/
```

## macOS Setup

```bash
# Enable Touch ID for sudo (persists across system updates)
./macos/setup-touchid-sudo.sh
```

## Secrets

API tokens and credentials should be stored in `~/.config/fish/secrets.fish` (not tracked):

```fish
# ~/.config/fish/secrets.fish
set -gx CR_PAT "your-github-pat"
set -gx SONAR_TOKEN "your-sonar-token"
```

Then source it from `config.fish`:
```fish
source ~/.config/fish/secrets.fish
```
