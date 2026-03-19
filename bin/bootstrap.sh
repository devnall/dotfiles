#!/usr/bin/env bash
#
# bootstrap — interactive first-time setup wizard for dotfiles
#
# Run this once before ./install on a new machine:
#   git clone --recursive ~/.dotfiles && cd ~/.dotfiles && ./bin/bootstrap && ./install
#
# Idempotent: already-completed steps are skipped silently.

# shellcheck disable=SC2088  # tilde in quoted labels is intentional display text
set -euo pipefail

DOTFILES_DIR="$(cd "$(dirname "$0")/.." && pwd)"

# --- Output helpers (match dotbot style) ---

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
skip()    { printf '%s[✓]%s %s (already done)\n' "$GREEN" "$RESET" "$1"; }

# --- Banner ---

printf '\n%s=== dotfiles bootstrap ===%s\n\n' "$BOLD" "$RESET"

# --- 1. Xcode CLT check (macOS only) ---

if [[ "$(uname)" == "Darwin" ]]; then
  if xcode-select -p &>/dev/null; then
    skip "Xcode Command Line Tools"
  else
    warn "Xcode Command Line Tools not found"
    info "Run: xcode-select --install"
  fi
fi

# --- 2. Submodule check ---

if [[ -d "$DOTFILES_DIR/dotbot" ]] && [[ -z "$(ls -A "$DOTFILES_DIR/dotbot" 2>/dev/null)" ]]; then
  info "Initializing submodules..."
  git -C "$DOTFILES_DIR" submodule update --init --recursive
  success "Submodules initialized"
else
  skip "Submodules"
fi

# --- 3. Marker file chooser ---

MARKERS=("$HOME/.work" "$HOME/.personal" "$HOME/.remote-full" "$HOME/.remote")
MARKER_NAMES=("work" "personal" "remote-full" "remote")
MARKER_DESCRIPTIONS=(
  "Work machine (full macOS setup)"
  "Personal machine (full macOS setup)"
  "Linux server with Homebrew + full tool suite"
  "Minimal Linux server (no Homebrew)"
)

existing_marker=""
for i in "${!MARKERS[@]}"; do
  if [[ -f "${MARKERS[$i]}" ]]; then
    existing_marker="${MARKER_NAMES[$i]}"
    break
  fi
done

if [[ -n "$existing_marker" ]]; then
  skip "Machine type: $existing_marker"
else
  info "Select machine type:"
  for i in "${!MARKER_NAMES[@]}"; do
    printf '  %d) %s — %s\n' "$((i + 1))" "${MARKER_NAMES[$i]}" "${MARKER_DESCRIPTIONS[$i]}"
  done
  printf '\n'
  while true; do
    read -rp "Choice [1-4]: " choice
    if [[ "$choice" =~ ^[1-4]$ ]]; then
      break
    fi
    error "Invalid choice. Enter 1-4."
  done
  idx=$((choice - 1))
  chosen="${MARKER_NAMES[$idx]}"

  # OS-mismatch warnings
  os="$(uname)"
  if [[ "$os" == "Darwin" ]] && [[ "$chosen" == "remote" || "$chosen" == "remote-full" ]]; then
    warn "You chose '$chosen' on macOS — this is typically for Linux servers"
  elif [[ "$os" != "Darwin" ]] && [[ "$chosen" == "work" || "$chosen" == "personal" ]]; then
    warn "You chose '$chosen' on Linux — this is typically for macOS machines"
  fi

  touch "${MARKERS[$idx]}"
  success "Machine type set: $chosen"
fi

# --- 4. Homebrew install ---

if [[ "$(uname)" == "Darwin" ]] || [[ -f "$HOME/.remote-full" ]]; then
  if command -v brew &>/dev/null; then
    skip "Homebrew"
  else
    read -rp "[→] Install Homebrew? [y/n]: " yn
    if [[ "$yn" =~ ^[Yy]$ ]]; then
      info "Installing Homebrew..."
      /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
      success "Homebrew installed"
    else
      warn "Skipped Homebrew install — you can install it later"
    fi
  fi
fi

# --- 5. Git identity template ---

GITCONFIG_USER="$DOTFILES_DIR/config/git/.gitconfig-user"
GITCONFIG_EXAMPLE="$DOTFILES_DIR/config/git/.gitconfig-user.example"

if [[ -f "$GITCONFIG_USER" ]]; then
  skip "Git identity (config/git/.gitconfig-user)"
  info "Verify your name, email, and signingkey are current"
else
  if [[ -f "$GITCONFIG_EXAMPLE" ]]; then
    cp "$GITCONFIG_EXAMPLE" "$GITCONFIG_USER"
    success "Created config/git/.gitconfig-user from template"
    warn "Edit config/git/.gitconfig-user with your name, email, and signingkey"
  else
    error "Template not found: config/git/.gitconfig-user.example"
  fi
fi

# --- 6. Stub files ---

create_stub() {
  local filepath="$1"
  local content="$2"
  local label="$3"

  if [[ -f "$filepath" ]]; then
    skip "$label"
  else
    mkdir -p "$(dirname "$filepath")"
    printf '%s\n' "$content" > "$filepath"
    success "Created $label"
  fi
}

create_stub "$HOME/.env.local" \
"# ~/.env.local — machine-specific PATH, exports, non-secret config
# Sourced at the end of every shell session. Gitignored.
#
# Examples:
#   export PATH=\"\$PATH:\$HOME/.cache/lm-studio/bin\"
#   export AWS_DEFAULT_REGION=us-east-1" \
"~/.env.local"

create_stub "$HOME/.secrets.local" \
"# ~/.secrets.local — API keys, tokens, credentials
# Sourced at the end of every shell session. Gitignored.
# WARNING: Never commit this file.
#
# Examples:
#   export OPENAI_API_KEY=\"sk-...\"
#   export GITHUB_TOKEN=\"ghp_...\"" \
"~/.secrets.local"

create_stub "$HOME/.ssh/config.local" \
"# ~/.ssh/config.local — host entries for this machine
# Included by ~/.ssh/config. Not tracked by dotfiles.
#
# Example:
#   Host myalias
#     HostName example.internal
#     User myuser
#     ForwardAgent yes" \
"~/.ssh/config.local"

# --- 7. Mise runtimes ---

if command -v mise &>/dev/null; then
  read -rp "[→] Run mise install to provision runtimes? [Y/n]: " yn
  if [[ "$yn" =~ ^[Nn]$ ]]; then
    info "Skipped — run 'mise install' later to provision runtimes"
  else
    info "Installing runtimes via mise..."
    mise install
    success "Runtimes installed"
  fi
fi

# --- 8. Summary ---

printf '\n%s=== Bootstrap complete ===%s\n\n' "$BOLD" "$RESET"

# Collect outstanding TODOs
todos=()
todos+=("Run ./install to complete setup")
if ! command -v mise &>/dev/null; then
  todos+=("Run mise install to provision runtimes (go, node, python, etc.)")
fi
if [[ -f "$GITCONFIG_USER" ]] && grep -q 'Your Name' "$GITCONFIG_USER" 2>/dev/null; then
  todos+=("Edit config/git/.gitconfig-user with your name, email, and signingkey")
fi
if [[ -f "$HOME/.env.local" ]] && ! grep -qv '^#' "$HOME/.env.local" 2>/dev/null; then
  todos+=("Add machine-specific config to ~/.env.local")
fi
if [[ -f "$HOME/.secrets.local" ]] && ! grep -qv '^#' "$HOME/.secrets.local" 2>/dev/null; then
  todos+=("Add credentials to ~/.secrets.local")
fi
if [[ -f "$HOME/.ssh/config.local" ]] && ! grep -qv '^#' "$HOME/.ssh/config.local" 2>/dev/null; then
  todos+=("Add host entries to ~/.ssh/config.local")
fi

if [[ ${#todos[@]} -gt 0 ]]; then
  info "TODO:"
  for todo in "${todos[@]}"; do
    printf '  → %s\n' "$todo"
  done
fi
printf '\n'
