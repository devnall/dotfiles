#!/usr/bin/env bash
#
# defaults.sh — idempotent macOS system preferences for new machines
#
# Run manually after bootstrap + install:
#   bash config/macos/defaults.sh
#
# Most settings take effect immediately (after killall at the end).
# Input settings (key repeat, trackpad) may require logout or restart.

set -euo pipefail

# --- macOS gate ---

if [[ "$(uname)" != "Darwin" ]]; then
  echo "This script is macOS-only. Exiting."
  exit 0
fi

# --- Output helpers (match bootstrap.sh style) ---

tput_available() { command -v tput >/dev/null 2>&1; }

if tput_available; then
  BOLD=$(tput bold)
  GREEN=$(tput setaf 2)
  YELLOW=$(tput setaf 3)
  RED=$(tput setaf 1)
  RESET=$(tput sgr0)
else
  BOLD="" GREEN="" YELLOW="" RED="" RESET=""
fi

info()    { printf '%s[→]%s %s\n' "$BOLD"   "$RESET" "$1"; }
success() { printf '%s[✓]%s %s\n' "$GREEN"  "$RESET" "$1"; }
warn()    { printf '%s[!]%s %s\n' "$YELLOW"  "$RESET" "$1"; }
error()   { printf '%s[✗]%s %s\n' "$RED"    "$RESET" "$1"; }
setting() { printf '    %s\n' "$1"; }

# --- Confirmation prompt ---

printf '\n%s=== macOS defaults ===%s\n\n' "$BOLD" "$RESET"
info "This will apply system preferences for: Dock, Finder, Input, Screenshots, Mission Control, System UI"
printf '\n'
read -rp "Apply macOS defaults? [y/N] " confirm
if [[ "$confirm" != [yY] ]]; then
  info "Aborted."
  exit 0
fi
printf '\n'

# --- Close System Settings to prevent it from overriding changes ---

osascript -e 'tell application "System Settings" to quit' 2>/dev/null || true

# =============================================================================
# Dock
# =============================================================================

info "Configuring Dock…"

defaults write com.apple.dock autohide -bool true
setting "Auto-hide the Dock"

defaults write com.apple.dock tilesize -int 36
setting "Set icon size to 36px"

defaults write com.apple.dock mineffect -string "genie"
setting "Use genie minimize animation"

defaults write com.apple.dock show-recents -bool false
setting "Hide recent apps section"

printf '\n'
read -rp "  Remove all default Dock icons? (You can re-add apps later) [y/N] " wipe_dock
if [[ "$wipe_dock" == [yY] ]]; then
  defaults write com.apple.dock persistent-apps -array
  setting "Cleared all Dock icons"
else
  setting "Dock icons left as-is"
fi

success "Dock configured"

# =============================================================================
# Finder
# =============================================================================

info "Configuring Finder…"

defaults write NSGlobalDomain AppleShowAllExtensions -bool true
setting "Show all file extensions"

defaults write com.apple.finder AppleShowAllFiles -bool true
setting "Show hidden files"

defaults write com.apple.finder ShowPathbar -bool true
setting "Show path bar"

defaults write com.apple.finder ShowStatusBar -bool true
setting "Show status bar"

defaults write com.apple.finder FXPreferredViewStyle -string "Nlsv"
setting "Default to list view"

defaults write com.apple.finder FXDefaultSearchScope -string "SCcf"
setting "Search current folder by default"

defaults write com.apple.finder FXEnableExtensionChangeWarning -bool false
setting "Disable extension change warning"

success "Finder configured"

# =============================================================================
# Input (keyboard + trackpad)
# =============================================================================

info "Configuring Input…"

setting "Keyboard:"
defaults write NSGlobalDomain KeyRepeat -int 2
setting "  Fast key repeat rate"

defaults write NSGlobalDomain InitialKeyRepeat -int 15
setting "  Short delay before repeat (~225ms)"

setting "Trackpad:"
defaults write com.apple.AppleMultitouchTrackpad Clicking -bool true
setting "  Enable tap-to-click"

defaults write NSGlobalDomain com.apple.mouse.tapBehavior -int 1
setting "  Enable tap-to-click at login screen"

defaults write com.apple.AppleMultitouchTrackpad TrackpadThreeFingerDrag -bool true
setting "  Enable three-finger drag"

defaults write com.apple.accessibility ReduceMotionEnabled -int 0 2>/dev/null || true

success "Input configured (logout/restart may be needed)"

# =============================================================================
# Screenshots
# =============================================================================

info "Configuring Screenshots…"

mkdir -p "${HOME}/Pictures/Screenshots"

defaults write com.apple.screencapture location -string "${HOME}/Pictures/Screenshots"
setting "Save to ~/Pictures/Screenshots"

defaults write com.apple.screencapture type -string "png"
setting "Use PNG format"

defaults write com.apple.screencapture disable-shadow -bool true
setting "Disable window capture drop shadow"

success "Screenshots configured"

# =============================================================================
# Mission Control
# =============================================================================

info "Configuring Mission Control…"

defaults write com.apple.dock mru-spaces -bool false
setting "Don't auto-rearrange Spaces based on recent use"

defaults write com.apple.dock wvous-tl-corner -int 0
defaults write com.apple.dock wvous-tl-modifier -int 0
defaults write com.apple.dock wvous-tr-corner -int 0
defaults write com.apple.dock wvous-tr-modifier -int 0
defaults write com.apple.dock wvous-bl-corner -int 0
defaults write com.apple.dock wvous-bl-modifier -int 0
defaults write com.apple.dock wvous-br-corner -int 0
defaults write com.apple.dock wvous-br-modifier -int 0
setting "Disable all hot corners"

success "Mission Control configured"

# =============================================================================
# System UI (menu bar clock, battery)
# =============================================================================

info "Configuring System UI…"

setting "Battery:"
defaults write com.apple.controlcenter BatteryShowPercentage -bool false
setting "  Hide battery percentage in menu bar"

setting "Clock:"
defaults write com.apple.menuextra.clock Show24Hour -int 1
setting "  Use 24-hour clock"

defaults write com.apple.menuextra.clock ShowDate -int 2
setting "  Hide date"

defaults write com.apple.menuextra.clock ShowDayOfWeek -int 0
setting "  Hide day of week"

defaults write com.apple.menuextra.clock FlashDateSeparators -int 0
setting "  Don't flash colon separators"

defaults write com.apple.menuextra.clock ShowSeconds -int 0
setting "  Don't show seconds"

success "System UI configured"

# =============================================================================
# Apply changes
# =============================================================================

printf '\n'
info "Restarting affected services…"

killall Dock Finder SystemUIServer 2>/dev/null || true

printf '\n'
success "macOS defaults applied!"
warn "Some input settings (key repeat, trackpad) may require logout or restart."
