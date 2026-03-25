#!/usr/bin/env bash
# ============================================================================
# macOS Defaults — Developer-friendly system preferences
#
# Sets trackpad, Finder, Dock, Safari, and TextEdit preferences.
# Safe to re-run. Some changes require a logout or restart to take effect.
#
# Usage:
#   bash macos/defaults.sh
# ============================================================================
# shellcheck disable=SC2059  # Variables in printf format strings are intentional (ANSI colors)
set -euo pipefail

BOLD='\033[1m'
GREEN='\033[1;32m'
BLUE='\033[1;34m'
RESET='\033[0m'

info()  { printf "${BLUE}[info]${RESET}  %s\n" "$*"; }
ok()    { printf "${GREEN}[ok]${RESET}    %s\n" "$*"; }

echo ""
printf "${BOLD}Setting macOS defaults ...${RESET}\n"
echo ""

# ── Trackpad ───────────────────────────────────────────────────────
info "Trackpad"
defaults write NSGlobalDomain com.apple.trackpad.scaling -float 2.5
defaults write com.apple.AppleMultitouchTrackpad Clicking -bool true
defaults write NSGlobalDomain com.apple.mouse.tapBehavior -int 1
ok "Tracking speed 2.5, tap to click enabled"

# ── Finder ─────────────────────────────────────────────────────────
info "Finder"
defaults write com.apple.finder ShowPathbar -bool true
defaults write com.apple.finder AppleShowAllFiles -bool true
defaults write NSGlobalDomain AppleShowAllExtensions -bool true
defaults write com.apple.finder NewWindowTarget -string "PfAF"
ok "PathBar, hidden files, all extensions, new windows → Recents"

# ── Dock ───────────────────────────────────────────────────────────
info "Dock"
defaults write com.apple.dock tilesize -int 62
defaults write com.apple.dock magnification -bool true
defaults write com.apple.dock largesize -int 128
defaults write com.apple.dock show-recents -bool false
ok "Icon size 62, magnification 128, no recent apps"

# ── Safari ─────────────────────────────────────────────────────────
info "Safari"
defaults write com.apple.Safari IncludeDevelopMenu -bool true
ok "Develop menu enabled"

# ── TextEdit ───────────────────────────────────────────────────────
info "TextEdit"
defaults write com.apple.TextEdit RichText -bool false
ok "Default to plain text"

# ── Restart affected apps ──────────────────────────────────────────
echo ""
info "Restarting Finder and Dock to apply changes ..."
killall Finder 2>/dev/null || true
killall Dock 2>/dev/null || true
ok "Done. Some changes may require a logout to take full effect."
echo ""
