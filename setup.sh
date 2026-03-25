#!/usr/bin/env bash
# ============================================================================
# Dotfiles Setup — Interactive personalization
#
# Configures user-specific settings (name, email, GPG key, usernames)
# so the dotfiles repo can be shared without hardcoded personal data.
#
# Uses gum (charmbracelet) for pretty UI when available, falls back to
# standard bash prompts.
#
# Safe to re-run — overwrites generated files, skips secrets if they exist.
# ============================================================================
# shellcheck disable=SC2059  # Variables in printf format strings are intentional (ANSI colors)
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# ----------------------------------------------------------------------------
# Ensure Homebrew binaries are in PATH (critical after fresh brew install)
# ----------------------------------------------------------------------------
if [[ -x /opt/homebrew/bin/brew ]]; then
    eval "$(/opt/homebrew/bin/brew shellenv)"
elif [[ -x /usr/local/bin/brew ]]; then
    eval "$(/usr/local/bin/brew shellenv)"
fi

# ----------------------------------------------------------------------------
# Colors & UI helpers
# ----------------------------------------------------------------------------
BOLD='\033[1m'
DIM='\033[2m'
BLUE='\033[1;34m'
GREEN='\033[1;32m'
YELLOW='\033[1;33m'
CYAN='\033[1;36m'
RESET='\033[0m'

USE_GUM=false
if command -v gum &>/dev/null; then
    USE_GUM=true
fi

header() {
    echo ""
    if $USE_GUM; then
        gum style --border rounded --padding "0 2" --border-foreground 4 --bold "$1"
    else
        printf "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${RESET}\n"
        printf "${BOLD}  %s${RESET}\n" "$1"
        printf "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${RESET}\n"
    fi
}

info()  { printf "${BLUE}[info]${RESET}  %s\n" "$*"; }
ok()    { printf "${GREEN}[ok]${RESET}    %s\n" "$*"; }
warn()  { printf "${YELLOW}[warn]${RESET}  %s\n" "$*"; }

ask() {
    local prompt="$1"
    local default="${2:-}"
    local result

    if $USE_GUM; then
        if [[ -n "$default" ]]; then
            result=$(gum input --prompt "  $prompt: " --placeholder "$default" --value "$default")
        else
            result=$(gum input --prompt "  $prompt: " --placeholder "")
        fi
    else
        if [[ -n "$default" ]]; then
            printf "  ${BOLD}%s${RESET} ${DIM}[%s]${RESET}: " "$prompt" "$default" >&2
        else
            printf "  ${BOLD}%s${RESET}: " "$prompt" >&2
        fi
        read -r result
        result="${result:-$default}"
    fi

    echo "$result"
}

confirm() {
    local prompt="$1"
    if $USE_GUM; then
        gum confirm "$prompt"
    else
        printf "  ${BOLD}%s${RESET} ${DIM}[y/N]${RESET}: " "$prompt" >&2
        read -r reply
        [[ "$reply" =~ ^[Yy]$ ]]
    fi
}

# ----------------------------------------------------------------------------
# Detect existing defaults
# ----------------------------------------------------------------------------
DEFAULT_NAME="$(git config user.name 2>/dev/null || true)"
DEFAULT_EMAIL="$(git config user.email 2>/dev/null || true)"
DEFAULT_GITHUB=""
if command -v gh &>/dev/null; then
    if gh auth status &>/dev/null; then
        DEFAULT_GITHUB="$(gh api user --jq '.login' 2>/dev/null || true)"
    else
        warn "GitHub CLI is not authenticated."
        info "Run 'gh auth login' to enable auto-detection of your GitHub username."
        echo ""
        if confirm "Run 'gh auth login' now?"; then
            if gh auth login; then
                DEFAULT_GITHUB="$(gh api user --jq '.login' 2>/dev/null || true)"
            else
                warn "gh auth login was canceled or failed — you can enter your username manually."
            fi
        fi
    fi
fi

# ----------------------------------------------------------------------------
# Gather information
# ----------------------------------------------------------------------------
header "Dotfiles Setup"

echo ""
echo "  Let's personalize your dotfiles."
echo ""

ask_required() {
    local result=""
    while [[ -z "$result" ]]; do
        result=$(ask "$@")
        if [[ -z "$result" ]]; then
            printf "  ${YELLOW}⚠ This field is required.${RESET}\n" >&2
        fi
    done
    echo "$result"
}

GIT_NAME=$(ask_required "Full name (for git commits)" "$DEFAULT_NAME")
GIT_EMAIL=$(ask_required "Email (for git commits)" "$DEFAULT_EMAIL")
GITHUB_USER=$(ask_required "GitHub username" "$DEFAULT_GITHUB")
NPM_USER=$(ask "npm username" "$GITHUB_USER")

echo ""

# GPG key auto-detection
GPG_KEY=""
GPG_PROGRAM=""

if command -v gpg &>/dev/null; then
    # Parse keys: build parallel arrays of key IDs and UIDs
    GPG_KEYS=()
    GPG_UIDS=()
    while IFS= read -r line; do
        if [[ "$line" == sec:* ]]; then
            current_key=$(echo "$line" | cut -d: -f5)
        elif [[ "$line" == uid:* && -n "${current_key:-}" ]]; then
            current_uid=$(echo "$line" | cut -d: -f10)
            GPG_KEYS+=("$current_key")
            GPG_UIDS+=("$current_uid")
            current_key=""
        fi
    done < <(gpg --list-secret-keys --with-colons --keyid-format long 2>/dev/null)

    if [[ ${#GPG_KEYS[@]} -gt 0 ]]; then
        printf "  ${DIM}Found %d GPG key(s) on this system:${RESET}\n" "${#GPG_KEYS[@]}" >&2
        echo "" >&2
        for i in "${!GPG_KEYS[@]}"; do
            printf "    ${BOLD}%d)${RESET} %s  ${DIM}%s${RESET}\n" "$((i + 1))" "${GPG_KEYS[$i]}" "${GPG_UIDS[$i]}" >&2
        done
        printf "    ${BOLD}0)${RESET} ${DIM}No signing (skip)${RESET}\n" >&2
        echo "" >&2

        if $USE_GUM; then
            # Build choices for gum
            choices=()
            for i in "${!GPG_KEYS[@]}"; do
                choices+=("${GPG_KEYS[$i]}  ${GPG_UIDS[$i]}")
            done
            choices+=("Skip — no commit signing")
            selected=$(gum choose --header "Select GPG signing key:" "${choices[@]}")
            if [[ "$selected" != "Skip"* ]]; then
                GPG_KEY=$(echo "$selected" | awk '{print $1}')
            fi
        else
            printf "  ${BOLD}Select key${RESET} ${DIM}[1-%d, 0 to skip]${RESET}: " "${#GPG_KEYS[@]}" >&2
            read -r choice
            if [[ "$choice" =~ ^[1-9][0-9]*$ ]] && [[ "$choice" -le ${#GPG_KEYS[@]} ]]; then
                GPG_KEY="${GPG_KEYS[$((choice - 1))]}"
            fi
        fi
    else
        printf "  ${DIM}No GPG keys found. Commit signing disabled.${RESET}\n" >&2
    fi
else
    printf "  ${DIM}GPG not installed. Commit signing disabled.${RESET}\n" >&2
fi

if [[ -n "$GPG_KEY" ]]; then
    # Detect GPG program location
    if [[ -x /opt/homebrew/bin/gpg ]]; then
        GPG_PROGRAM="/opt/homebrew/bin/gpg"
    elif [[ -x /usr/local/bin/gpg ]]; then
        GPG_PROGRAM="/usr/local/bin/gpg"
    else
        GPG_PROGRAM="$(command -v gpg)"
    fi
fi

# ----------------------------------------------------------------------------
# Summary & confirmation
# ----------------------------------------------------------------------------
header "Review"

echo ""
printf "  ${BOLD}Name:${RESET}        %s\n" "$GIT_NAME"
printf "  ${BOLD}Email:${RESET}       %s\n" "$GIT_EMAIL"
printf "  ${BOLD}GitHub:${RESET}      %s\n" "$GITHUB_USER"
printf "  ${BOLD}npm:${RESET}         %s\n" "$NPM_USER"
if [[ -n "$GPG_KEY" ]]; then
    printf "  ${BOLD}GPG Key:${RESET}     %s\n" "$GPG_KEY"
    printf "  ${BOLD}GPG Program:${RESET} %s\n" "$GPG_PROGRAM"
else
    printf "  ${BOLD}GPG:${RESET}         ${DIM}disabled${RESET}\n"
fi
printf "  ${BOLD}Dotfiles:${RESET}    %s\n" "$SCRIPT_DIR"
echo ""

if ! confirm "Proceed with setup?"; then
    echo "  Aborted."
    exit 0
fi

# ============================================================================
# 1. Generate ~/.gitconfig.local
# ============================================================================
header "Git Configuration"

GITCONFIG_LOCAL="$HOME/.gitconfig.local"

write_gitconfig_local() {
    {
        echo "[user]"
        echo "	name = $GIT_NAME"
        echo "	email = $GIT_EMAIL"
        if [[ -n "$GPG_KEY" ]]; then
            echo "	signingkey = $GPG_KEY"
            echo "[commit]"
            echo "	gpgsign = true"
            echo "[gpg]"
            echo "	program = $GPG_PROGRAM"
        fi
    } > "$GITCONFIG_LOCAL"
    ok "Generated $GITCONFIG_LOCAL"
}

if [[ -f "$GITCONFIG_LOCAL" ]]; then
    warn "$GITCONFIG_LOCAL already exists"
    if confirm "Overwrite?"; then
        write_gitconfig_local
    else
        ok "Kept existing $GITCONFIG_LOCAL"
    fi
else
    write_gitconfig_local
fi

# ============================================================================
# 2. Generate CLAUDE.md from template
# ============================================================================
header "Claude Code Configuration"

CLAUDE_TEMPLATE="$SCRIPT_DIR/claude/.claude/CLAUDE.md.template"
CLAUDE_OUTPUT="$SCRIPT_DIR/claude/.claude/CLAUDE.md"

generate_from_template() {
    local template="$1"
    local output="$2"
    local label="$3"

    if [[ ! -f "$template" ]]; then
        warn "Template not found: $template — skipping"
        return
    fi

    local should_write=true
    if [[ -f "$output" ]]; then
        # Check if the existing file was generated from template (has same structure)
        # If it differs significantly, it may have custom edits — ask before overwriting
        local new_content
        new_content=$(sed -e "s/{{GITHUB_USERNAME}}/$GITHUB_USER/g" \
                          -e "s/{{NPM_USERNAME}}/$NPM_USER/g" "$template")
        if [[ "$(cat "$output")" == "$new_content" ]]; then
            ok "$label already up to date — skipping"
            return
        else
            warn "$label exists with different content"
            if ! confirm "Overwrite $label?"; then
                ok "Kept existing $label"
                return
            fi
        fi
    fi

    if $should_write; then
        sed -e "s/{{GITHUB_USERNAME}}/$GITHUB_USER/g" \
            -e "s/{{NPM_USERNAME}}/$NPM_USER/g" \
            "$template" > "$output"
        ok "Generated $label (GitHub: $GITHUB_USER, npm: $NPM_USER)"
    fi
}

generate_from_template "$CLAUDE_TEMPLATE" "$CLAUDE_OUTPUT" "CLAUDE.md"

# ============================================================================
# 3. Generate AGENTS.md from template
# ============================================================================
AGENTS_TEMPLATE="$SCRIPT_DIR/codex/.codex/AGENTS.md.template"
AGENTS_OUTPUT="$SCRIPT_DIR/codex/.codex/AGENTS.md"

generate_from_template "$AGENTS_TEMPLATE" "$AGENTS_OUTPUT" "AGENTS.md"

# Copy Codex config.toml from template (no substitution needed)
CODEX_CONFIG_TEMPLATE="$SCRIPT_DIR/codex/.codex/config.toml.template"
CODEX_CONFIG_OUTPUT="$SCRIPT_DIR/codex/.codex/config.toml"

if [[ ! -f "$CODEX_CONFIG_TEMPLATE" ]]; then
    warn "Codex config template not found — skipping"
elif [[ -f "$CODEX_CONFIG_OUTPUT" ]]; then
    ok "Codex config.toml already exists — skipping (may contain project trust entries)"
else
    cp "$CODEX_CONFIG_TEMPLATE" "$CODEX_CONFIG_OUTPUT"
    ok "Generated Codex config.toml"
fi

# ============================================================================
# 4. npm global packages
# ============================================================================
header "npm Global Packages"

if command -v npm &>/dev/null; then
    NPM_GLOBALS=(ccstatusline typescript typescript-language-server npm-check-updates lighthouse)
    for pkg in "${NPM_GLOBALS[@]}"; do
        if npm list -g "$pkg" &>/dev/null; then
            ok "$pkg already installed"
        else
            info "Installing $pkg ..."
            npm install -g "$pkg"
            ok "Installed $pkg"
        fi
    done
else
    warn "npm not found — skipping global package installation"
    printf "  ${DIM}Install Node.js first (brew install node), then re-run setup${RESET}\n"
fi

# ============================================================================
# 5. Secrets file
# ============================================================================
header "Secrets"

SECRETS_FILE="$HOME/.config/fish/secrets.fish"
SECRETS_TEMPLATE="$SCRIPT_DIR/fish/.config/fish/secrets.fish.example"

if [[ -f "$SECRETS_FILE" ]]; then
    ok "secrets.fish already exists — skipping"
    printf "  ${DIM}Location: %s${RESET}\n" "$SECRETS_FILE"
else
    if [[ -f "$SECRETS_TEMPLATE" ]]; then
        mkdir -p "$(dirname "$SECRETS_FILE")"
        cp "$SECRETS_TEMPLATE" "$SECRETS_FILE"
        ok "Created secrets.fish from template"
        printf "  ${YELLOW}→ Edit %s to add your API tokens${RESET}\n" "$SECRETS_FILE"
    else
        warn "Template not found: $SECRETS_TEMPLATE"
    fi
fi

# ============================================================================
# 6. SSH Keychain integration (macOS only)
# ============================================================================
if [[ "$(uname -s)" == "Darwin" ]]; then
    header "SSH Keychain"
    SSH_CONFIG="$HOME/.ssh/config"

    # Append a fallback Host * block at the end of ~/.ssh/config.
    # OpenSSH uses first-match: if the user already sets UseKeychain or
    # AddKeysToAgent in an earlier block, those values win and ours are
    # ignored. This is safe for all existing configs.
    MARKER="# Added by dotfiles setup.sh"
    if [[ -f "$SSH_CONFIG" ]] && grep -qF "$MARKER" "$SSH_CONFIG"; then
        ok "SSH Keychain defaults already added by setup.sh"
    else
        info "Adding Keychain integration to ~/.ssh/config"
        mkdir -p "$HOME/.ssh"
        chmod 700 "$HOME/.ssh"
        {
            echo ""
            echo "$MARKER"
            echo "Host *"
            echo "    IgnoreUnknown UseKeychain"
            echo "    UseKeychain yes"
            echo "    AddKeysToAgent yes"
        } >> "$SSH_CONFIG"
        chmod 600 "$SSH_CONFIG"
        ok "Appended Keychain defaults to ~/.ssh/config"
    fi
fi

# ============================================================================
# 7. Summary
# ============================================================================
header "Done"

echo ""
ok "Setup complete!"
echo ""
echo "  Generated files:"
printf "    ${CYAN}%s${RESET}  (git user config)\n" "$GITCONFIG_LOCAL"
[[ -f "$CLAUDE_OUTPUT" ]] && printf "    ${CYAN}%s${RESET}  (Claude Code prompt)\n" "$CLAUDE_OUTPUT"
[[ -f "$AGENTS_OUTPUT" ]] && printf "    ${CYAN}%s${RESET}  (Codex agent prompt)\n" "$AGENTS_OUTPUT"
echo ""
printf "  Next steps:\n"
printf "    1. Run ${BOLD}make install${RESET} to stow all packages\n"
printf "    2. Edit ${BOLD}~/.config/fish/secrets.fish${RESET} to add API tokens\n"
if [[ -n "$GPG_KEY" ]]; then
    printf "    3. Verify GPG: ${BOLD}gpg --list-keys %s${RESET}\n" "$GPG_KEY"
fi
echo ""
