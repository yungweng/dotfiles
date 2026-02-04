#!/usr/bin/env bash
# ============================================================================
# Linux Dotfiles Bootstrap
# Installs fish, starship, fzf, rg to ~/.local/bin (no root required)
# then symlinks configs from this dotfiles repo.
#
# Usage:
#   git clone https://github.com/yungweng/dotfiles ~/.dotfiles
#   cd ~/.dotfiles && ./setup-linux.sh
#
# Works on x86_64 and aarch64. Re-run safely to update tools.
# ============================================================================
set -euo pipefail

# ----------------------------------------------------------------------------
# Config
# ----------------------------------------------------------------------------
LOCAL_BIN="$HOME/.local/bin"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Tool versions (bump these to update)
FISH_VERSION="4.4.0"
FZF_VERSION="0.67.0"
RG_VERSION="15.1.0"

# ----------------------------------------------------------------------------
# Helpers
# ----------------------------------------------------------------------------
info()  { printf '\033[1;34m[info]\033[0m  %s\n' "$*"; }
ok()    { printf '\033[1;32m[ok]\033[0m    %s\n' "$*"; }
warn()  { printf '\033[1;33m[warn]\033[0m  %s\n' "$*"; }
err()   { printf '\033[1;31m[err]\033[0m   %s\n' "$*" >&2; }

detect_arch() {
    local arch
    arch="$(uname -m)"
    case "$arch" in
        x86_64|amd64)  echo "x86_64" ;;
        aarch64|arm64) echo "aarch64" ;;
        *) err "Unsupported architecture: $arch"; exit 1 ;;
    esac
}

# Check if a command exists and optionally meets a minimum version
has() { command -v "$1" &>/dev/null; }

# Download to stdout
fetch() { curl -fsSL "$1"; }

# ----------------------------------------------------------------------------
# Setup
# ----------------------------------------------------------------------------
ARCH="$(detect_arch)"
mkdir -p "$LOCAL_BIN"

# Ensure ~/.local/bin is in PATH for this session
export PATH="$LOCAL_BIN:$PATH"

info "Architecture: $ARCH"
info "Install target: $LOCAL_BIN"
echo ""

# ----------------------------------------------------------------------------
# 1. Fish Shell
# ----------------------------------------------------------------------------
info "Installing fish $FISH_VERSION ..."

if [[ "$ARCH" == "x86_64" ]]; then
    FISH_ARCH="linux-x86_64"
else
    FISH_ARCH="linux-aarch64"
fi

FISH_TAR="fish-${FISH_VERSION}-${FISH_ARCH}.tar.xz"
FISH_URL="https://github.com/fish-shell/fish-shell/releases/download/${FISH_VERSION}/${FISH_TAR}"

TMP_DIR="$(mktemp -d)"
trap 'rm -rf "$TMP_DIR"' EXIT

# Fish 4.x ships as a single static binary in the tarball
fetch "$FISH_URL" | tar xJ -C "$LOCAL_BIN"
chmod +x "$LOCAL_BIN/fish"
ok "fish $(fish --version 2>/dev/null | head -1 || echo "$FISH_VERSION")"

# ----------------------------------------------------------------------------
# 2. Starship Prompt
# ----------------------------------------------------------------------------
info "Installing starship ..."

fetch https://starship.rs/install.sh | sh -s -- --bin-dir "$LOCAL_BIN" --yes

ok "starship $(starship --version 2>/dev/null | head -1 || echo 'installed')"

# ----------------------------------------------------------------------------
# 3. fzf
# ----------------------------------------------------------------------------
info "Installing fzf $FZF_VERSION ..."

if [[ "$ARCH" == "x86_64" ]]; then
    FZF_ARCH="linux_amd64"
else
    FZF_ARCH="linux_arm64"
fi

FZF_URL="https://github.com/junegunn/fzf/releases/download/v${FZF_VERSION}/fzf-${FZF_VERSION}-${FZF_ARCH}.tar.gz"
fetch "$FZF_URL" | tar xz -C "$LOCAL_BIN"

ok "fzf $(fzf --version 2>/dev/null | head -1 || echo "$FZF_VERSION")"

# ----------------------------------------------------------------------------
# 4. ripgrep
# ----------------------------------------------------------------------------
info "Installing ripgrep $RG_VERSION ..."

if [[ "$ARCH" == "x86_64" ]]; then
    RG_TRIPLE="x86_64-unknown-linux-musl"
else
    RG_TRIPLE="aarch64-unknown-linux-gnu"
fi

RG_TAR="ripgrep-${RG_VERSION}-${RG_TRIPLE}.tar.gz"
RG_URL="https://github.com/BurntSushi/ripgrep/releases/download/${RG_VERSION}/${RG_TAR}"

fetch "$RG_URL" > "$TMP_DIR/$RG_TAR"
tar xf "$TMP_DIR/$RG_TAR" -C "$TMP_DIR"
cp "$TMP_DIR/ripgrep-${RG_VERSION}-${RG_TRIPLE}/rg" "$LOCAL_BIN/"

ok "rg $(rg --version 2>/dev/null | head -1 || echo "$RG_VERSION")"

# ----------------------------------------------------------------------------
# 5. Stow configs (or manual symlinks)
# ----------------------------------------------------------------------------
echo ""
info "Linking configuration files ..."

cd "$SCRIPT_DIR"

symlink_stow_package() {
    local pkg="$1"
    local src="$SCRIPT_DIR/$pkg"

    if [[ ! -d "$src" ]]; then
        warn "Package '$pkg' not found, skipping"
        return
    fi

    # Walk the stow package and create symlinks mirroring the structure
    while IFS= read -r -d '' file; do
        local rel="${file#"$src/"}"
        local target="$HOME/$rel"
        local target_dir="$(dirname "$target")"

        mkdir -p "$target_dir"

        if [[ -L "$target" ]]; then
            rm "$target"  # Remove existing symlink (re-run safe)
        elif [[ -e "$target" ]]; then
            warn "Backing up $target -> $target.pre-dotfiles"
            mv "$target" "$target.pre-dotfiles"
        fi

        ln -s "$file" "$target"
    done < <(find "$src" -type f -print0)
}

if has stow; then
    info "Using GNU Stow"

    # Backup existing files that would conflict
    for f in ~/.bashrc ~/.inputrc; do
        if [[ -f "$f" ]] && [[ ! -L "$f" ]]; then
            warn "Backing up $f -> $f.pre-dotfiles"
            mv "$f" "$f.pre-dotfiles"
        fi
    done

    stow bash
    stow fish
    stow starship
    stow vim
else
    info "Stow not found, using manual symlinks"
    symlink_stow_package "bash"
    symlink_stow_package "fish"
    symlink_stow_package "starship"
    symlink_stow_package "vim"
fi

ok "Configs linked"

# ----------------------------------------------------------------------------
# 6. Git hooks (gitleaks pre-commit)
# ----------------------------------------------------------------------------
info "Setting up git hooks ..."
git -C "$SCRIPT_DIR" config core.hooksPath hooks
ok "Pre-commit hook active (gitleaks secret scanning)"

# ----------------------------------------------------------------------------
# Summary
# ----------------------------------------------------------------------------
echo ""
echo "============================================"
ok "Bootstrap complete!"
echo "============================================"
echo ""
echo "  Installed to: $LOCAL_BIN"
echo ""
echo "  fish     $(fish --version 2>/dev/null || echo '?')"
echo "  starship $(starship --version 2>/dev/null || echo '?')"
echo "  fzf      $(fzf --version 2>/dev/null || echo '?')"
echo "  rg       $(rg --version 2>/dev/null | head -1 || echo '?')"
echo ""
echo "  Next: start fish by running: exec fish"
echo ""
