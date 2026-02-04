# ============================================================================
# Bash Shell Configuration
# ~/.bashrc
# ============================================================================

# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

# ----------------------------------------------------------------------------
# History Configuration
# ----------------------------------------------------------------------------
HISTCONTROL=ignoreboth:erasedups
HISTSIZE=50000
HISTFILESIZE=100000
HISTTIMEFORMAT="%F %T "
shopt -s histappend

# ----------------------------------------------------------------------------
# Shell Options
# ----------------------------------------------------------------------------
shopt -s checkwinsize   # Update LINES/COLUMNS after each command
shopt -s globstar       # ** matches recursively
shopt -s cdspell        # Autocorrect minor cd typos
shopt -s dirspell       # Autocorrect directory name typos in completion
shopt -s autocd         # Type directory name to cd into it
shopt -s nocaseglob     # Case-insensitive globbing

# ----------------------------------------------------------------------------
# Environment Variables
# ----------------------------------------------------------------------------
export TERM=xterm-256color
export COLORTERM=truecolor
export EDITOR=vim

# Local binaries
export PATH="$HOME/.local/bin:$HOME/bin:$HOME/.cargo/bin:$PATH"

# GPG
export GPG_TTY=$(tty)

# ----------------------------------------------------------------------------
# Aliases
# ----------------------------------------------------------------------------
alias ls='ls --color=auto'
alias grep='grep --color=auto'
alias lsla='ls -la'

# bat (Debian ships it as batcat)
if command -v batcat &>/dev/null && ! command -v bat &>/dev/null; then
    alias bat='batcat'
fi

# ----------------------------------------------------------------------------
# Utility Functions
# ----------------------------------------------------------------------------

# mkcd - Create directory and cd into it
mkcd() { mkdir -p "$1" && cd "$1"; }

# backup - Create timestamped backup of a file
backup() { cp "$1" "$1.bak-$(date +%Y%m%d-%H%M%S)"; }

# sizeof - Show size of file or directory
sizeof() { du -sh "$@"; }

# ----------------------------------------------------------------------------
# Completions
# ----------------------------------------------------------------------------
if ! shopt -oq posix; then
    if [ -f /usr/share/bash-completion/bash_completion ]; then
        . /usr/share/bash-completion/bash_completion
    elif [ -f /etc/bash_completion ]; then
        . /etc/bash_completion
    fi
fi

# ----------------------------------------------------------------------------
# Tool Integrations
# ----------------------------------------------------------------------------

# fzf keybindings and completion (Ctrl+R, Ctrl+T, Alt+C)
if command -v fzf &>/dev/null; then
    eval "$(fzf --bash)"
fi

# Starship prompt (must be last)
if command -v starship &>/dev/null; then
    eval "$(starship init bash)"
fi

# Cargo env (if present)
[ -f "$HOME/.cargo/env" ] && . "$HOME/.cargo/env"

# ----------------------------------------------------------------------------
# Auto-launch Fish Shell
# ----------------------------------------------------------------------------
# On Linux servers bash is the default login shell. This replaces the bash
# process with fish so SSH sessions land directly in fish with all its
# features (autosuggestions, syntax highlighting, etc.).
# Guard: only exec if fish exists, we're not already in fish, and this is
# an interactive session (don't break scp/rsync/scripts).
if command -v fish &>/dev/null && [ -z "$FISH_VERSION" ] && [[ $- == *i* ]]; then
    exec fish
fi
