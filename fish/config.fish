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

# Terminal
set -gx TERM xterm-256color

# GPG (for git commit signing)
set -gx GPG_TTY (tty)

# API Tokens & Credentials
# NOTE: Store sensitive tokens in ~/.config/fish/secrets.fish (not tracked)
# source ~/.config/fish/secrets.fish

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
abbr --add codexyolo 'codex --enable web_search_request --dangerously-bypass-approvals-and-sandbox'

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

# copy - Copy to clipboard (args or stdin)
function copy
    if test (count $argv) -gt 0
        echo $argv | pbcopy
    else
        pbcopy
    end
end

# ----------------------------------------------------------------------------
# Project-specific Configuration (commented out)
# ----------------------------------------------------------------------------

# CURATE project - Ollama remote host
#set -gx OLLAMA_HOST 10.67.142.34:11434


# Added by LM Studio CLI (lms)
set -gx PATH $PATH /Users/yonnock/.lmstudio/bin
# End of LM Studio CLI section


# bun
set --export BUN_INSTALL "$HOME/.bun"
set --export PATH $BUN_INSTALL/bin $PATH

# pnpm
set -gx PNPM_HOME "/Users/yonnock/Library/pnpm"
if not string match -q -- $PNPM_HOME $PATH
  set -gx PATH "$PNPM_HOME" $PATH
end
# pnpm end
