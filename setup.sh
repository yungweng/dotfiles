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
    DEFAULT_GITHUB="$(gh api user --jq '.login' 2>/dev/null || true)"
fi
if [[ -z "$DEFAULT_GITHUB" ]]; then
    DEFAULT_GITHUB="$(git remote get-url origin 2>/dev/null | sed -nE 's#.*[:/]([^/]+)/dotfiles.*#\1#p' || true)"
fi

# ----------------------------------------------------------------------------
# Gather information
# ----------------------------------------------------------------------------
header "Dotfiles Setup"

echo ""
echo "  Let's personalize your dotfiles."
echo ""

GIT_NAME=$(ask "Full name (for git commits)" "$DEFAULT_NAME")
GIT_EMAIL=$(ask "Email (for git commits)" "$DEFAULT_EMAIL")
GITHUB_USER=$(ask "GitHub username" "$DEFAULT_GITHUB")
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

# ============================================================================
# 2. Generate CLAUDE.md from template
# ============================================================================
header "Claude Code Configuration"

CLAUDE_TEMPLATE="$SCRIPT_DIR/claude/.claude/CLAUDE.md.template"
CLAUDE_OUTPUT="$SCRIPT_DIR/claude/.claude/CLAUDE.md"

if [[ -f "$CLAUDE_TEMPLATE" ]]; then
    sed \
        -e "s/{{GITHUB_USERNAME}}/$GITHUB_USER/g" \
        -e "s/{{NPM_USERNAME}}/$NPM_USER/g" \
        "$CLAUDE_TEMPLATE" > "$CLAUDE_OUTPUT"
    ok "Generated CLAUDE.md (GitHub: $GITHUB_USER, npm: $NPM_USER)"
else
    warn "Template not found: $CLAUDE_TEMPLATE — skipping"
fi

# ============================================================================
# 3. Generate AGENTS.md from template
# ============================================================================
AGENTS_TEMPLATE="$SCRIPT_DIR/codex/.codex/AGENTS.md.template"
AGENTS_OUTPUT="$SCRIPT_DIR/codex/.codex/AGENTS.md"

if [[ -f "$AGENTS_TEMPLATE" ]]; then
    sed \
        -e "s/{{GITHUB_USERNAME}}/$GITHUB_USER/g" \
        -e "s/{{NPM_USERNAME}}/$NPM_USER/g" \
        "$AGENTS_TEMPLATE" > "$AGENTS_OUTPUT"
    ok "Generated AGENTS.md (GitHub: $GITHUB_USER, npm: $NPM_USER)"
else
    warn "Template not found: $AGENTS_TEMPLATE — skipping"
fi

# ============================================================================
# 4. Secrets file
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
# 5. Summary
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
