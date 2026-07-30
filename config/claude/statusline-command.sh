#!/usr/bin/env bash
# Claude Code status line script
# ~/.claude/statusline-command.sh

input=$(cat)

# --- Data extraction ---
cwd=$(echo "$input" | jq -r '.workspace.current_dir // .cwd // ""')
dir=$(basename "$cwd")

model=$(echo "$input" | jq -r '.model.display_name // .model.id // "unknown"')

used_pct=$(echo "$input" | jq -r '.context_window.used_percentage // empty')
used_tokens=$(echo "$input" | jq -r '
  (.context_window.total_input_tokens // 0) + (.context_window.total_output_tokens // 0)
  | select(. > 0)')

# --- Git branch ---
git_branch=""
if [ -n "$cwd" ] && [ -d "$cwd/.git" ] || git -C "$cwd" rev-parse --git-dir > /dev/null 2>&1; then
  git_branch=$(git -C "$cwd" --no-optional-locks symbolic-ref --short HEAD 2>/dev/null || \
               git -C "$cwd" --no-optional-locks rev-parse --short HEAD 2>/dev/null)
fi

# --- Context bar ---
bar_segment=""
if [ -n "$used_tokens" ]; then
  # Color thresholds, by absolute token count
  if [ "$used_tokens" -lt 100000 ]; then
    color="\033[32m"          # green
  elif [ "$used_tokens" -le 120000 ]; then
    color="\033[38;5;208m"    # orange
  else
    color="\033[31m"          # red
  fi
  reset="\033[0m"

  # Human-readable count: 1234 -> 1.2k, 112499 -> 112.4k.
  # Truncate rather than round, so a count below a color threshold never
  # displays as if it had crossed it (99999 -> 99.9k, not 100.0k).
  tokens_fmt=$(awk -v t="$used_tokens" 'BEGIN {
    if (t < 1000)         printf "%d", t
    else if (t < 1000000) printf "%.1fk", int(t / 100) / 10
    else                  printf "%.2fM", int(t / 10000) / 100
  }')

  # Bar still tracks how full the window is
  bar=""
  if [ -n "$used_pct" ]; then
    pct_int=${used_pct%.*}
    bar_width=20
    filled=$(( pct_int * bar_width / 100 ))
    [ "$filled" -gt "$bar_width" ] && filled=$bar_width
    empty=$(( bar_width - filled ))

    # Built with printf padding, not seq: macOS `seq 1 0` counts *down* and
    # emits "1 0", which would add two stray blocks whenever a side is empty.
    bar=$(printf "%${filled}s" | tr ' ' '█')$(printf "%${empty}s" | tr ' ' '░')
    bar="[${bar}] "
  fi

  bar_segment="${color}${bar}${tokens_fmt}${reset}"
fi

# --- Assemble ---
line=""

# directory
line="${line}$(printf '\033[1m%s\033[0m' "$dir")"

# git branch
if [ -n "$git_branch" ]; then
  line="${line} $(printf '\033[36m(%s)\033[0m' "$git_branch")"
fi

# model
line="${line} $(printf '\033[35m%s\033[0m' "$model")"

# context bar
if [ -n "$bar_segment" ]; then
  line="${line} $(printf "${bar_segment}")"
fi

printf "%b" "$line"
