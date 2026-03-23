#!/usr/bin/env bash
# brew-audit.sh — Brewfile drift detection report
#
# Compares what's installed on this machine against what's tracked in
# Brewfiles. Outputs a report grouped by category. Does not modify anything.
#
# Usage:
#   brew-audit        # run via ~/bin symlink
#   bin/brew-audit.sh # run directly

set -uo pipefail

# --- Resolve dotfiles directory ---

if [[ -n "${DOTFILES:-}" ]]; then
  DOTFILES_DIR="$DOTFILES"
else
  SCRIPT_DIR="$(cd "$(dirname "$(readlink -f "$0" 2>/dev/null || realpath "$0" 2>/dev/null || echo "$0")")" && pwd)"
  DOTFILES_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"
fi

PACKAGES_DIR="$DOTFILES_DIR/packages"

# --- Output helpers ---

tput_available() { command -v tput >/dev/null 2>&1; }

if tput_available; then
  BOLD=$(tput bold)
  GREEN=$(tput setaf 2)
  YELLOW=$(tput setaf 3)
  RED=$(tput setaf 1)
  DIM=$(tput dim)
  RESET=$(tput sgr0)
else
  BOLD="" GREEN="" YELLOW="" RED="" DIM="" RESET=""
fi

header()  { printf '\n%s=== %s ===%s\n' "$BOLD" "$1" "$RESET"; }
ok()      { printf '  %s✓%s %s\n' "$GREEN" "$RESET" "$1"; }
finding() { printf '  %s•%s %s\n' "$YELLOW" "$RESET" "$1"; }
info()    { printf '  %s%s%s\n' "$DIM" "$1" "$RESET"; }

# --- Detect machine type ---

machine_type="unknown"
if [[ -f "$HOME/.work" ]]; then
  machine_type="work"
elif [[ -f "$HOME/.personal" ]]; then
  machine_type="personal"
elif [[ -f "$HOME/.remote-full" ]]; then
  machine_type="remote-full"
elif [[ -f "$HOME/.remote" ]]; then
  machine_type="remote"
fi

printf '%sBrew Audit Report%s — %s (%s)\n' "$BOLD" "$RESET" "$(hostname -s)" "$machine_type"
printf '%s\n' "$(date '+%Y-%m-%d %H:%M')"

# --- Check prerequisites ---

if ! command -v brew &>/dev/null; then
  printf '%sError:%s Homebrew not found\n' "$RED" "$RESET" >&2
  exit 1
fi

# --- Build list of applicable Brewfiles ---

brewfiles=()
[[ -f "$PACKAGES_DIR/Brewfile.universal" ]] && brewfiles+=("$PACKAGES_DIR/Brewfile.universal")
if [[ "$machine_type" == "work" ]] && [[ -f "$PACKAGES_DIR/Brewfile.work" ]]; then
  brewfiles+=("$PACKAGES_DIR/Brewfile.work")
fi
if [[ "$machine_type" == "personal" ]] && [[ -f "$PACKAGES_DIR/Brewfile.personal" ]]; then
  brewfiles+=("$PACKAGES_DIR/Brewfile.personal")
fi
[[ -f "$PACKAGES_DIR/Brewfile.local" ]] && brewfiles+=("$PACKAGES_DIR/Brewfile.local")

info "Brewfiles: ${brewfiles[*]##*/}"

# --- Parse active (non-commented) entries from Brewfiles ---

parse_brewfile_entries() {
  local entry_type="$1"
  shift
  for bf in "$@"; do
    grep -E "^${entry_type} " "$bf" 2>/dev/null | \
      sed -E "s/^${entry_type} \"([^\"]+)\".*/\1/" || true
  done | sort -u
}

tracked_formulae=$(parse_brewfile_entries "brew" "${brewfiles[@]}")
tracked_casks=$(parse_brewfile_entries "cask" "${brewfiles[@]}")
tracked_mas=$(for bf in "${brewfiles[@]}"; do
  grep -E '^mas ' "$bf" 2>/dev/null | sed -E 's/.*id: ([0-9]+).*/\1/' || true
done | sort -u)

# --- Get installed state ---

installed_leaves=$(brew leaves 2>/dev/null | sort)
installed_casks=$(brew list --cask 2>/dev/null | sort)
installed_mas=""
if command -v mas &>/dev/null; then
  installed_mas=$(mas list 2>/dev/null | awk '{print $1}' | sort)
fi

# --- 1. Installed formulae not in any Brewfile ---

header "Installed formulae (leaves) not in any Brewfile"
count=0
while IFS= read -r formula; do
  [[ -z "$formula" ]] && continue
  if ! echo "$tracked_formulae" | grep -qxF "$formula"; then
    finding "$formula"
    ((count++)) || true
  fi
done <<< "$installed_leaves"
[[ $count -eq 0 ]] && ok "All installed formulae are tracked"

# --- 2. Installed casks not in any Brewfile ---

header "Installed casks not in any Brewfile"
count=0
while IFS= read -r cask_name; do
  [[ -z "$cask_name" ]] && continue
  if ! echo "$tracked_casks" | grep -qxF "$cask_name"; then
    finding "$cask_name"
    ((count++)) || true
  fi
done <<< "$installed_casks"
[[ $count -eq 0 ]] && ok "All installed casks are tracked"

# --- 3. Installed MAS apps not in any Brewfile ---

header "Installed MAS apps not in any Brewfile"
count=0
if [[ -n "$installed_mas" ]]; then
  while IFS= read -r mas_id; do
    [[ -z "$mas_id" ]] && continue
    if ! echo "$tracked_mas" | grep -qxF "$mas_id"; then
      # Look up the name from mas list
      mas_name=$(mas list 2>/dev/null | grep " *${mas_id} " | sed "s/^ *[0-9]* *//" | sed 's/ *(.*//')
      finding "$mas_name ($mas_id)"
      ((count++)) || true
    fi
  done <<< "$installed_mas"
fi
[[ $count -eq 0 ]] && ok "All MAS apps are tracked"

# --- 4. Brewfile entries not installed ---

header "Brewfile entries not installed on this machine"
count=0

# Use pre-fetched lists instead of per-entry brew list calls (much faster)
installed_all_formulae=$(brew list --formula 2>/dev/null | sort)

while IFS= read -r formula; do
  [[ -z "$formula" ]] && continue
  # Strip tap prefix for matching (e.g. "cormacrelf/tap/dark-notify" -> "dark-notify")
  short_name="${formula##*/}"
  if ! echo "$installed_all_formulae" | grep -qxF "$short_name"; then
    finding "formula: $formula"
    ((count++)) || true
  fi
done <<< "$tracked_formulae"

while IFS= read -r cask_name; do
  [[ -z "$cask_name" ]] && continue
  if ! echo "$installed_casks" | grep -qxF "$cask_name"; then
    finding "cask: $cask_name"
    ((count++)) || true
  fi
done <<< "$tracked_casks"

if command -v mas &>/dev/null && [[ -n "$tracked_mas" ]]; then
  while IFS= read -r mas_id; do
    [[ -z "$mas_id" ]] && continue
    if ! echo "$installed_mas" | grep -qxF "$mas_id"; then
      # Look up name from Brewfile
      mas_name=""
      for bf in "${brewfiles[@]}"; do
        mas_name=$(grep -E "id: ${mas_id}" "$bf" 2>/dev/null | sed -E 's/^mas "([^"]+)".*/\1/' || true)
        [[ -n "$mas_name" ]] && break
      done
      finding "mas: ${mas_name:-$mas_id} ($mas_id)"
      ((count++)) || true
    fi
  done <<< "$tracked_mas"
fi

[[ $count -eq 0 ]] && ok "All Brewfile entries are installed"

# --- 5. Apps in /Applications not managed by Homebrew or MAS ---

header "Apps in /Applications not managed by Homebrew or MAS"
count=0

# Build lookup of managed app names (lowercase, no .app suffix)
# Use Homebrew's caskroom receipts (fast, no network) + MAS names
managed_apps=$(
  {
    # Cask apps: read app names from caskroom receipts
    for cask_dir in "$(brew --prefix)"/Caskroom/*/; do
      [[ -d "$cask_dir" ]] || continue
      # Find .app artifacts in the latest version directory
      latest=$(find "$cask_dir" -maxdepth 1 -mindepth 1 -type d -print 2>/dev/null | sort | tail -1)
      latest="${latest##*/}"
      [[ -z "$latest" ]] && continue
      if [[ -f "$cask_dir/$latest/.metadata" ]]; then
        # Fall back to cask name (hyphen to space, capitalize)
        basename "$cask_dir"
      else
        basename "$cask_dir"
      fi
    done

    # MAS apps: names from mas list
    if [[ -n "$installed_mas" ]]; then
      mas list 2>/dev/null | sed 's/^[0-9]* *//' | sed 's/ *(.*//'
    fi
  } | tr '[:upper:]' '[:lower:]' | sort -u
)

# System/Apple apps and non-app directories to skip
skip_apps="garageband|imovie|safari|utilities|xcode|include|lib"

for app_dir in /Applications ~/Applications; do
  [[ -d "$app_dir" ]] || continue
  while IFS= read -r app; do
    # Strip path and .app suffix
    name="${app##*/}"
    name="${name%.app}"
    name_lower=$(echo "$name" | tr '[:upper:]' '[:lower:]')

    # Skip non-.app entries, system apps, and localized dirs
    [[ "$app" != *.app ]] && continue
    echo "$name_lower" | grep -qiE "^($skip_apps)$" && continue

    # Normalize for matching: "Docker Desktop" matches cask "docker-desktop"
    name_hyphenated="${name_lower// /-}"

    # Check if managed by cask name or app name
    if ! echo "$managed_apps" | grep -qixF "$name_lower" && \
       ! echo "$managed_apps" | grep -qixF "$name_hyphenated" && \
       ! echo "$installed_casks" | grep -qixF "$name_hyphenated"; then
      finding "$name ($app_dir/)"
      ((count++)) || true
    fi
  done < <(ls "$app_dir" 2>/dev/null)
done

[[ $count -eq 0 ]] && ok "All applications are tracked"

# --- Summary ---

printf '\n%sDone.%s Run this after Brewfile changes or on new machines.\n' "$BOLD" "$RESET"
printf 'Decision framework: add to Brewfile / quarantine / uninstall / leave as manual\n'
printf 'See docs/RUNBOOK.md for details.\n\n'
