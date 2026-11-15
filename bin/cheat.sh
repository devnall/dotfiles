#!/usr/bin/env bash
# cheat.sh — fzf-powered cheatsheet browser for docs/*.cheatsheet.md
#
# Usage:
#   cheat.sh            Browse cheatsheets via fzf topic picker
#   cheat.sh <query>    Search across all cheatsheets for a string

set -euo pipefail

# Resolve cheatsheet directory
if [[ -n "${DOTFILES:-}" ]]; then
  DOCS_DIR="$DOTFILES/docs"
else
  SCRIPT_DIR="$(cd "$(dirname "$(readlink -f "$0" 2>/dev/null || realpath "$0" 2>/dev/null || echo "$0")")" && pwd)"
  DOCS_DIR="$(cd "$SCRIPT_DIR/../docs" && pwd)"
fi

CHEATSHEET_GLOB="$DOCS_DIR/*.cheatsheet.md"

# Check that at least one cheatsheet exists
mapfile -t files < <(compgen -G "$CHEATSHEET_GLOB")
if [[ ${#files[@]} -eq 0 ]]; then
  echo "No cheatsheets found in $DOCS_DIR" >&2
  exit 1
fi

# Viewer: bat if available, else cat
viewer() {
  if command -v bat > /dev/null; then
    bat --language=markdown --style=plain --paging=always "$@"
  else
    cat "$@"
  fi
}

# Mode 1: no args — topic picker
if [[ $# -eq 0 ]]; then
  if command -v fzf > /dev/null; then
    selected=$(printf '%s\n' "${files[@]}" \
      | while read -r f; do
          basename "$f" .cheatsheet.md
        done \
      | fzf --prompt="cheatsheet> " \
            --preview="bat --language=markdown --style=plain --color=always '$DOCS_DIR/{}.cheatsheet.md' 2>/dev/null || cat '$DOCS_DIR/{}.cheatsheet.md'" \
            --preview-window=right:70%)
    [[ -n "$selected" ]] && viewer "$DOCS_DIR/$selected.cheatsheet.md"
  else
    echo "Available cheatsheets:" >&2
    for f in "${files[@]}"; do
      echo "  $(basename "$f" .cheatsheet.md)"
    done
    echo "Install fzf for interactive browsing, or pass a topic name as argument." >&2
  fi
  exit 0
fi

# Mode 2: with args — content search
query="$*"
if command -v rg > /dev/null; then
  search_cmd=(rg --line-number --no-heading --color=never "$query" "${files[@]}")
else
  search_cmd=(grep -rn "$query" "${files[@]}")
fi

results=$("${search_cmd[@]}" 2>/dev/null || true)
if [[ -z "$results" ]]; then
  echo "No matches for '$query' in cheatsheets." >&2
  exit 1
fi

if command -v fzf > /dev/null; then
  # Strip DOCS_DIR prefix so fzf shows "git.cheatsheet.md:105:..." not the full path
  export DOCS_DIR
  selected=$(echo "$results" \
    | sed "s|^${DOCS_DIR}/||" \
    | fzf --prompt="match> " \
          --delimiter=: \
          --preview="
            line=\$(echo {} | cut -d: -f2)
            name=\$(echo {} | cut -d: -f1)
            file=\"$DOCS_DIR/\$name\"
            start=\$((line > 5 ? line - 5 : 1))
            end=\$((line + 20))
            bat --language=markdown --style=plain --color=always --highlight-line \"\$line\" --line-range \"\$start:\$end\" \"\$file\" 2>/dev/null || sed -n \"\${start},\${end}p\" \"\$file\"
          " \
          --preview-window=right:70%)
  if [[ -n "$selected" ]]; then
    file="$DOCS_DIR/$(echo "$selected" | cut -d: -f1)"
    line=$(echo "$selected" | cut -d: -f2)
    if command -v bat > /dev/null; then
      bat --language=markdown --style=plain --paging=always --highlight-line "$line" "$file"
    else
      cat "$file"
    fi
  fi
else
  echo "$results"
fi
