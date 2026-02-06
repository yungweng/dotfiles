# dotfiles

Personal configuration files managed with [GNU Stow](https://www.gnu.org/software/stow/).

## Contents

| Package | Description |
|---------|-------------|
| `bash/` | Bash shell config (`.bashrc`, `.inputrc`) |
| `fish/` | Fish shell configuration, functions, and scripts |
| `ghostty/` | Ghostty terminal config |
| `starship/` | Starship prompt config |
| `git/` | Git configuration with aliases |
| `claude/` | Claude Code CLI — config, custom agents, slash commands, skills, and hooks |
| `codex/` | Codex CLI — config, prompts, and skills |
| `tmux/` | tmux terminal multiplexer config ([cheat sheet](tmux/TMUX-CHEATSHEET.md)) |
| `vim/` | Vim editor config |
| `npm/` | npm global prefix setting |
| `topgrade/` | Topgrade system updater config |
| `btop/` | btop system monitor config |
| `htop/` | htop process viewer config |
| `gh/` | GitHub CLI preferences |
| `zed/` | Zed editor keymap and settings |

| Non-stow | Description |
|----------|-------------|
| `Makefile` | Task runner — install, uninstall, brew, hooks, and more (`make help`) |
| `Brewfile` | Homebrew package manifest (formulae, casks, VS Code extensions, Go/Cargo packages) |
| `hooks/` | Git pre-commit hook (gitleaks secret scanning) |
| `macos/` | macOS-specific setup scripts |
| `setup-linux.sh` | Linux bootstrap — installs fish, starship, fzf, ripgrep (no root required) |

## Installation

### macOS (Full Setup)

```bash
# Install Homebrew if needed: https://brew.sh
brew install stow

git clone git@github.com:yungweng/dotfiles.git ~/repos/dotfiles
cd ~/repos/dotfiles

make macos   # Installs Brewfile packages, stows all configs, enables git hooks
```

### macOS (Stow Only)

```bash
cd ~/repos/dotfiles
make install   # Stow all packages
make hooks     # Enable gitleaks pre-commit hook
```

### Linux (No Root Required)

For headless servers or environments without `brew`:

```bash
git clone https://github.com/yungweng/dotfiles.git ~/.dotfiles
cd ~/.dotfiles && make linux
```

This installs fish, starship, fzf, and ripgrep to `~/.local/bin` and symlinks configs. Works on x86_64 and aarch64.

### Individual Packages

```bash
stow fish      # Stow a single package
stow -D fish   # Remove symlinks for a package
stow -R fish   # Re-stow (fix stale symlinks)
```

> **Note:** Use `stow --adopt <package>` if the target files already exist. This moves existing files into the repo and creates symlinks. Run `git diff` afterward to review changes.

### Makefile Targets

| Target | Description |
|--------|-------------|
| `make install` | Stow all packages into `~` |
| `make uninstall` | Unstow all packages |
| `make restow` | Re-stow all packages (fix stale symlinks) |
| `make brew` | Install Homebrew packages from Brewfile |
| `make brew-dump` | Update Brewfile from currently installed packages |
| `make hooks` | Enable gitleaks pre-commit hook |
| `make macos` | Full macOS setup (brew + stow + hooks) |
| `make linux` | Linux bootstrap (no root required) |
| `make clean` | Find broken symlinks pointing to this repo |
| `make list` | List all stow packages |
| `make help` | Show all available targets |

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
├── bash/
│   ├── .bashrc                         → ~/.bashrc
│   └── .inputrc                        → ~/.inputrc
├── fish/
│   ├── .config/fish/                   → ~/.config/fish/
│   │   ├── config.fish
│   │   ├── conf.d/rustup.fish
│   │   ├── secrets.fish.example        (template — copy to secrets.fish)
│   │   └── functions/                  (cloud, coy-review, key bindings)
│   └── bin/claude-cleanup              → ~/bin/claude-cleanup
├── ghostty/
│   └── .config/ghostty/                → ~/.config/ghostty/
├── starship/
│   └── .config/starship.toml           → ~/.config/starship.toml
├── git/
│   └── .gitconfig                      → ~/.gitconfig
├── claude/
│   └── .claude/                        → ~/.claude/
│       ├── CLAUDE.md                   (system prompt)
│       ├── settings.json
│       ├── agents/                     (deep-dive-investigator, research-thinker)
│       ├── commands/                   (slash commands: most-used, seminar, workflow, ...)
│       ├── hooks/                      (skill evaluation hooks)
│       └── skills/                     (12 skills: browser, audio, gh-cli, react, ...)
├── codex/
│   └── .codex/                         → ~/.codex/
│       ├── AGENTS.md
│       ├── config.toml
│       ├── prompts/                    (review, investigation, openspec prompts)
│       └── skills/                     (react, web-design-guidelines)
├── tmux/
│   ├── .tmux.conf                      → ~/.tmux.conf
│   └── TMUX-CHEATSHEET.md             (reference, not stowed)
├── vim/
│   └── .vimrc                          → ~/.vimrc
├── npm/
│   └── .npmrc                          → ~/.npmrc
├── topgrade/
│   └── .config/topgrade.toml           → ~/.config/topgrade.toml
├── btop/
│   └── .config/btop/btop.conf          → ~/.config/btop/btop.conf
├── htop/
│   └── .config/htop/htoprc             → ~/.config/htop/htoprc
├── gh/
│   └── .config/gh/config.yml           → ~/.config/gh/config.yml
├── zed/
│   └── .config/zed/                    → ~/.config/zed/ (keymap.json, settings-shared.json)
├── hooks/
│   └── pre-commit                      (gitleaks — activated via git config core.hooksPath)
├── macos/
│   └── setup-touchid-sudo.sh           (run manually)
├── Makefile                            (task runner: make help)
├── Brewfile                            (Homebrew package manifest)
├── .stowrc                             (sets --target=~)
├── .gitignore
├── setup-linux.sh                      (Linux bootstrap, no root)
└── README.md
```

## Secrets

API tokens and credentials are stored in `~/.config/fish/secrets.fish` (not tracked by git). A template is provided:

```bash
cp ~/.config/fish/secrets.fish.example ~/.config/fish/secrets.fish
# Edit secrets.fish and fill in your tokens
```

Required variables:

| Variable | Purpose | Generate at |
|----------|---------|-------------|
| `CR_PAT` | GitHub Container Registry PAT | [GitHub Tokens](https://github.com/settings/tokens) |
| `SONAR_TOKEN` | SonarQube/SonarCloud API token | [SonarCloud Security](https://sonarcloud.io/account/security) |
| `NPM_TOKEN` | npm publish token (used by `~/.npmrc`) | [npm Tokens](https://www.npmjs.com/settings/~/tokens) |

This file is sourced automatically by `config.fish`.

## Git Hooks

The `hooks/` directory contains a gitleaks pre-commit hook that scans staged changes for secrets before each commit.

```bash
# Activate (already done by setup scripts)
git config core.hooksPath hooks

# Requires gitleaks
brew install gitleaks  # macOS
```

## Git Aliases

| Alias | Description |
|-------|-------------|
| `prune-local` | Remove local branches whose remote tracking branch is gone |

## Fish Aliases

| Alias | Expands to |
|-------|------------|
| `docker-compose` | `docker compose` (v2 compatibility) |
| `lsla` | `ls -la` |

## Fish Abbreviations

| Abbr | Expands to |
|------|------------|
| `cy` | `claude --dangerously-skip-permissions` |
| `claudeyolo` | `claude --dangerously-skip-permissions` |
| `coy` | `codex --dangerously-bypass-approvals-and-sandbox` |
| `codexyolo` | `codex --dangerously-bypass-approvals-and-sandbox` |

## Fish Utility Functions

| Function | Description |
|----------|-------------|
| `mkcd <dir>` | Create directory and cd into it |
| `backup <file>` | Create timestamped backup (`file.bak-20250206-183000`) |
| `sizeof <path>` | Show size of file or directory |
| `copy [text]` | Copy args or stdin to clipboard (cross-platform) |
| `cloud` | cd to iCloud Drive |
| `coy-review` | Run parallel Codex code reviews (`-n` count, `-b` branch, `-t` thinking) |
| `claude-cleanup` | Kill detached Claude background processes, show freed memory |

## macOS Setup

```bash
# Enable Touch ID for sudo (persists across system updates)
./macos/setup-touchid-sudo.sh
```
