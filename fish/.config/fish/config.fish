# ============================================================================
# Fish Shell Configuration
# ~/.config/fish/config.fish
# ============================================================================

# ----------------------------------------------------------------------------
# Interactive Session Setup
# ----------------------------------------------------------------------------
if status is-interactive
    # Commands to run in interactive sessions can go here
end

# ----------------------------------------------------------------------------
# PATH Configuration
# ----------------------------------------------------------------------------
# Using fish_add_path: idempotent (no duplicates), persistent, prepends to PATH
# Order matters: later entries have higher priority (added to front)

# System tools
fish_add_path /opt/homebrew/bin          # Homebrew (Apple Silicon)

# Language-specific
fish_add_path $HOME/go/bin               # Go binaries

# Package managers
fish_add_path $HOME/.npm-global/bin      # npm global packages

# Local binaries (highest priority)
fish_add_path $HOME/.lmstudio/bin        # LM Studio CLI
fish_add_path $HOME/.local/bin           # User-local binaries (Claude Code, etc.)
fish_add_path $HOME/bin                  # Personal scripts

# ----------------------------------------------------------------------------
# Environment Variables
# ----------------------------------------------------------------------------
# set -gx = global + exported (available to child processes)

# Suppress verbose direnv output (keep only errors)
set -gx DIRENV_LOG_FORMAT ""

# GPG (for git commit signing)
set -gx GPG_TTY (tty)

# Claude Code LSP (enable when Anthropic fixes plugin loading)
set -gx ENABLE_LSP_TOOL 1

# API Tokens & Credentials
# Load secrets from separate file (not tracked in git)
test -f ~/.config/fish/secrets.fish && source ~/.config/fish/secrets.fish

# ----------------------------------------------------------------------------
# Aliases
# ----------------------------------------------------------------------------
# For simple command replacements

alias docker-compose="docker compose"    # Docker Compose v2 compatibility
alias lsla="ls -la"                      # Quick directory listing

# ----------------------------------------------------------------------------
# Abbreviations
# ----------------------------------------------------------------------------
# Unlike aliases, abbreviations expand in-place (visible in history)
# Use for commands you want to see expanded

abbr --add claudeyolo 'claude --dangerously-skip-permissions'
abbr --add cy 'claude --dangerously-skip-permissions'
abbr --add codexyolo 'codex --dangerously-bypass-approvals-and-sandbox'
abbr --add coy 'codex --dangerously-bypass-approvals-and-sandbox'

# ----------------------------------------------------------------------------
# Utility Functions
# ----------------------------------------------------------------------------

# mkcd - Create directory and cd into it
function mkcd
    mkdir -p $argv[1] && cd $argv[1]
end

# backup - Create timestamped backup of a file
function backup
    cp $argv[1] $argv[1].bak-(date +%Y%m%d-%H%M%S)
end

# sizeof - Show size of file or directory
function sizeof
    du -sh $argv
end

# copy - Copy to clipboard (args or stdin) — works on macOS + Linux
function copy
    # Pick the right clipboard command
    set -l clip
    if command -q pbcopy
        set clip pbcopy                          # macOS
    else if test -n "$WAYLAND_DISPLAY"; and command -q wl-copy
        set clip wl-copy                         # Linux Wayland
    else if command -q xclip
        set clip xclip -selection clipboard       # Linux X11
    else if command -q xsel
        set clip xsel --clipboard --input         # Linux X11 (alt)
    else
        echo "copy: no clipboard tool found" >&2
        return 1
    end

    if test (count $argv) -gt 0
        echo $argv | $clip
    else
        $clip
    end
end

# ----------------------------------------------------------------------------
# Project-specific Configuration (commented out)
# ----------------------------------------------------------------------------

# CURATE project - Ollama remote host
#set -gx OLLAMA_HOST 10.67.142.34:11434


# bun
set --export BUN_INSTALL "$HOME/.bun"
set --export PATH $BUN_INSTALL/bin $PATH

# pnpm
if test (uname) = Darwin
    set -gx PNPM_HOME "$HOME/Library/pnpm"
else
    set -gx PNPM_HOME "$HOME/.local/share/pnpm"
end
if not string match -q -- $PNPM_HOME $PATH
    set -gx PATH "$PNPM_HOME" $PATH
end

# direnv (must come before starship to avoid prompt flicker)
if command -q direnv
    direnv hook fish | source
end

starship init fish | source
