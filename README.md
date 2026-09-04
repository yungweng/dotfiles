# dotfiles

Personal configuration files managed with [GNU Stow](https://www.gnu.org/software/stow/).

## Installation

### macOS (Full Setup)

```bash
git clone git@github.com:yungweng/dotfiles.git ~/repos/dotfiles
cd ~/repos/dotfiles

make macos   # Runs: preflight → brew → setup → stow → hooks → shell switch
```

`make macos` handles everything automatically:
1. **Preflight** — installs Xcode CLI Tools and Homebrew if missing
2. **Brew** — interactive package install (or essentials-only on fresh macOS with bash 3)
3. **Setup** — git identity, GPG key, GitHub CLI auth, npm globals, SSH Keychain
4. **Install** — stows all packages (backs up conflicting files automatically)
5. **Hooks** — enables gitleaks pre-commit hook
6. **Shell** — offers to switch default shell to fish

### macOS (Step by Step)

```bash
cd ~/repos/dotfiles
make preflight  # Check/install prerequisites
make brew       # Install Homebrew packages (interactive)
make setup      # Interactive setup (name, email, GPG, usernames)
make install    # Stow all packages
make hooks      # Enable gitleaks pre-commit hook
```

### Linux (No Root Required)

For headless servers or environments without `brew`:

```bash
git clone https://github.com/yungweng/dotfiles.git ~/.dotfiles
cd ~/.dotfiles
./setup-linux.sh   # Installs tools, runs setup, stows configs
```

This installs fish, starship, fzf, and ripgrep to `~/.local/bin`, runs interactive setup, and symlinks configs. Works on x86_64 and aarch64.

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
| `make help` | Show all available targets |
| `make preflight` | Check/install prerequisites (Xcode CLI Tools, Homebrew, Git) |
| `make setup` | Interactive setup (name, email, GPG, usernames, gh auth, SSH Keychain) |
| `make install` | Stow all packages into `~` (with conflict backup) |
| `make uninstall` | Unstow all packages |
| `make restow` | Re-stow all packages (fix stale symlinks) |
| `make brew` | Install Homebrew packages interactively (skips installed; falls back to essentials on bash < 4) |
| `make brew-essentials` | Install only essential dev packages (~30: terminal, shell, editor, git, languages) |
| `make brew-all` | Install ALL Homebrew packages non-interactively (120+) |
| `make brew-dump` | Update Brewfile from currently installed packages |
| `make hooks` | Enable pre-commit and pre-push privacy checks |
| `make skills` | Install optional upstream skills for Claude and Codex (requires npm) |
| `make check-private` | Check staged files and locally reachable Git history |
| `make check-history` | Scan history, including deleted secrets |
| `make test-private` | Run privacy regression tests in temporary repositories |
| `make macos` | Full macOS setup (preflight + brew + setup + stow + hooks) |
| `make linux` | Linux bootstrap (no root required) |
| `make lint` | Run shellcheck and fish syntax checks locally |
| `make clean` | Find broken symlinks pointing to this repo |
| `make list` | List all stow packages |

## Contents

| Package | Description |
|---------|-------------|
| `bash/` | Bash shell config (`.bashrc`, `.inputrc`) |
| `fish/` | Fish shell configuration, functions, and scripts |
| `ghostty/` | Ghostty terminal config |
| `starship/` | Starship prompt config |
| `git/` | Git configuration with aliases |
| `gitmux/` | Git status in tmux status bar |
| `claude/` | Claude Code CLI — config, custom agents, slash commands, skills, and hooks |
| `codex/` | Codex CLI — config, prompts, and skills |
| `tmux/` | tmux terminal multiplexer config ([cheat sheet](tmux/TMUX-CHEATSHEET.md)) |
| `vim/` | Vim editor config |
| `npm/` | npm global prefix setting |
| `topgrade/` | Topgrade system updater config |
| `btop/` | btop system monitor config |
| `htop/` | htop process viewer config |
| `gh/` | GitHub CLI preferences |
| `direnv/` | direnv environment manager config |
| `zed/` | Zed editor keymap and settings |

| Non-stow | Description |
|----------|-------------|
| `setup.sh` | Interactive setup — name, email, GPG, gh auth, npm globals, SSH Keychain |
| `setup-linux.sh` | Linux bootstrap — installs tools, runs setup, stows configs (no root required) |
| `brew-interactive.sh` | Interactive Homebrew installer — skips already-installed packages |
| `Makefile` | Task runner — install, uninstall, brew, hooks, and more (`make help`) |
| `Brewfile` | Homebrew package manifest — full (120+ packages) |
| `Brewfile.essentials` | Homebrew essentials — terminal, shell, editor, git, languages (~30 packages) |
| `hooks/` | Git pre-commit hook (shellcheck, fish syntax, gitleaks) |
| `macos/` | macOS-specific scripts (defaults, Touch ID for sudo) |
| `.github/workflows/` | CI — shellcheck, fish syntax linting, stow install tests on macOS + Linux |

## Usage

### Add a new config to an existing package

Just add the file to the package with the correct path structure:

```bash
# Example: add a new fish function
# File goes in: <dotfiles>/fish/.config/fish/functions/myfunction.fish
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
   mkdir -p <dotfiles>/newapp/.config/newapp
   ```

2. Add your config file:
   ```bash
   cp ~/.config/newapp/config <dotfiles>/newapp/.config/newapp/
   ```

3. Remove the original and stow:
   ```bash
   rm ~/.config/newapp/config
   stow newapp
   ```

## Directory Structure

Stow mirrors the directory structure relative to `~`. The `.stowrc` file sets the target to home (`~`).

```
<dotfiles>/
├── bash/
│   ├── .bashrc                         → ~/.bashrc
│   └── .inputrc                        → ~/.inputrc
├── fish/
│   ├── .config/fish/                   → ~/.config/fish/
│   │   ├── config.fish
│   │   ├── conf.d/rustup.fish
│   │   ├── secrets.fish.example        (template — copy to secrets.fish)
│   │   └── functions/                  (brew, cloud, coy-review, key bindings)
│   └── bin/claude-cleanup              → ~/bin/claude-cleanup
├── ghostty/
│   └── .config/ghostty/                → ~/.config/ghostty/
├── starship/
│   └── .config/starship.toml           → ~/.config/starship.toml
├── git/
│   └── .gitconfig                      → ~/.gitconfig
├── gitmux/
│   └── .gitmux.conf                    → ~/.gitmux.conf
├── claude/
│   └── .claude/                        → ~/.claude/
│       ├── CLAUDE.md.template           (template — generated by setup.sh)
│       ├── settings.json
│       ├── agents/                     (deep-dive-investigator, research-thinker)
│       ├── commands/                   (slash commands: most-used, seminar, workflow, ...)
│       ├── hooks/                      (skill evaluation hooks)
│       └── skills/                     (12 skills: browser, audio, gh-cli, react, ...)
├── codex/
│   └── .codex/                         → ~/.codex/
│       ├── AGENTS.md.template           (template — generated by setup.sh)
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
├── direnv/
│   └── .config/direnv/direnv.toml      → ~/.config/direnv/direnv.toml
├── zed/
│   └── .config/zed/                    → ~/.config/zed/ (keymap.json, settings.json)
├── .github/
│   └── workflows/
│       ├── lint.yml                    (CI: shellcheck + fish syntax)
│       └── test-install.yml            (CI: stow install test on macOS + Linux)
├── hooks/
│   └── pre-commit                      (shellcheck + fish syntax + gitleaks)
├── macos/
│   ├── defaults.sh                     (Trackpad, Finder, Dock, Safari, TextEdit preferences)
│   └── setup-touchid-sudo.sh           (Touch ID for sudo)
├── Makefile                            (task runner: make help)
├── Brewfile                            (Homebrew package manifest)
├── brew-interactive.sh                 (interactive Homebrew installer)
├── .stowrc                             (sets --target=~)
├── .gitignore
├── setup.sh                            (interactive personalization)
├── setup-linux.sh                      (Linux bootstrap, no root)
└── README.md
```

## Secrets

API tokens and credentials are stored in `~/.config/fish/secrets.fish` (not tracked by git). `setup.sh` creates this file automatically from the template. To set up manually:

```bash
cp <dotfiles>/fish/.config/fish/secrets.fish.example ~/.config/fish/secrets.fish
# Edit secrets.fish and fill in your tokens
```

Required variables:

| Variable | Purpose | Generate at |
|----------|---------|-------------|
| `CR_PAT` | GitHub Container Registry PAT | [GitHub Tokens](https://github.com/settings/tokens) |
| `SONAR_TOKEN` | SonarQube/SonarCloud API token | [SonarCloud Security](https://sonarcloud.io/account/security) |
| `NPM_TOKEN` | npm publish token (used by `~/.npmrc`) | [npm Tokens](https://www.npmjs.com/settings/~/tokens) |

This file is sourced automatically by `config.fish`.

## Sharing and private configuration

Commit reusable defaults and templates, not the personalized files produced by
`setup.sh`. Existing generated agent files are preserved unless you approve an
overwrite when rerunning setup.

| Commit | Keep local |
|--------|------------|
| `CLAUDE.md.template`, `AGENTS.md.template` with username placeholders | Generated `CLAUDE.md`, `AGENTS.md` and personal instructions |
| Git aliases and shared preferences | `~/.gitconfig.local` with identity and signing settings |
| Zed theme, keymap, and editor preferences | Server connections in `~/.config/zed/global_settings.json`; SSH hosts and keys in `~/.ssh/` |
| Environment variable references and example files | Tokens, passwords, `.env` files, credentials, and private keys |
| Explicitly shared custom skills | Installer-managed skills, `.system/`, and private project instructions |
| Shared Topgrade defaults | Machine-specific commands and container names in `~/.config/topgrade.d/*.toml` |

Usernames and public service URLs are not credentials, but private hostnames,
server aliases, IP addresses, internal URLs, and project paths can expose your
infrastructure. Keep them out of public configs. Personal style preferences can
be shared if intentional; replace account-specific values with template fields.

Zed can write new server connections into the stowed `settings.json`. Move the
connection entries to the machine-local `global_settings.json` before committing.
The shared file must not contain `ssh_connections` or `remote` settings. Do not
replace local settings or SSH files wholesale: preserve their existing entries.

Gitignore prevents normal additions; it does not remove files from existing
commits. Stow symlinks also mean edits made by an app can change tracked files.

### Skills: shared versus installed

Custom skills already in Git are installed by Stow. New skill directories are
ignored by default: review their contents, then add an exception to the shared
skills section of `.gitignore` before staging. Private skills remain available
locally without being published. Codex manages `.system/` itself.

After Stow, run `make skills` to install the optional upstream collections listed
in the Makefile. It downloads their current versions using the
[Skills CLI](https://github.com/vercel-labs/skills#readme); it is not a pinned snapshot
and may replace local edits to those upstream skills. Custom skills with different
names are left alone. Review upstream updates before use.

The target uses `--copy`: installer-generated relative symlinks can break when
`~/.claude/skills` points into a Stow checkout. Installed copies stay ignored, so
updates do not flood `git status`. To share an installed skill as a maintained
copy instead, review it, include its license, and add a `.gitignore` exception.

### Local Topgrade settings

Put machine-specific settings in `~/.config/topgrade.d/local.toml`, outside the
checkout. [Topgrade loads these fragments](https://github.com/topgrade-rs/topgrade/blob/main/config.example.toml)
before the shared file; list settings such as `misc.disable` are combined.
Keep private container names and machine-only commands there. A fresh installation
works without a local fragment; back it up separately if you need those settings
on another machine.

## Git Hooks

```bash
make hooks                         # Once per clone; also run by make macos
# Stage only the changes you intend to share:
git add -- path/to/public-config
make check-private                 # Staged checks + locally reachable history
git diff --cached                 # Review the exact content to be committed
```

The **pre-commit hook** blocks force-added ignored files, runs ShellCheck and Fish
syntax checks on staged scripts when those tools are installed, and requires
Gitleaks. Gitleaks uses its default token/key rules plus the repository's IPv4 and
Zed server-settings rules. Findings are redacted in command output.

The **pre-push hook** requires Gitleaks and scans all commits reachable from local
refs, including remote-tracking refs and values removed in later commits. It is
intentionally conservative: a finding on another local branch also blocks a push.
It does not fetch remote refs or inspect unreachable objects, hosted caches, or
other people's clones. `make check-private` does not scan unstaged/untracked files.

```bash
brew install shellcheck gitleaks    # macOS; Fish is installed by the dotfiles setup
make test-private                  # Requires Python 3 and Gitleaks
```

The lint workflow checks shell scripts; it does not provide secret scanning.
Local hooks can be bypassed, and pattern matching cannot recognize every private
hostname or personal detail. Review the staged diff as well. A green scan is not
a guarantee that content is safe to publish.

If history scanning finds real private data, stop before pushing. Deleting the
current file is not enough. Inspect affected commits and refs, then plan history
cleanup separately; rewriting shared history changes commit IDs. Revoke or rotate
any exposed credentials before relying on cleanup.

## macOS Setup

```bash
# Set system preferences (Trackpad, Finder, Dock, Safari, TextEdit)
bash macos/defaults.sh

# Enable Touch ID for sudo (persists across system updates)
sudo bash macos/setup-touchid-sudo.sh
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

## Ghostty Shortcuts

| Shortcut | Action |
|----------|--------|
| `Cmd+Shift+P` | Command palette |
| `Cmd+D` | Split pane right |
| `Cmd+Shift+D` | Split pane down |
| `Cmd+Option+P` | Quick terminal (global — works from any app) |
| `Cmd+Shift+S` | Toggle secure input |
| `Cmd+Plus` / `Cmd+-` / `Cmd+0` | Font size: increase / decrease / reset |
