#!/usr/bin/env bash
# Claude Code status line script
# ~/.claude/statusline-command.sh

input=$(cat)

# --- Data extraction ---
cwd=$(echo "$input" | jq -r '.workspace.current_dir // .cwd // ""')
dir=$(basename "$cwd")

model=$(echo "$input" | jq -r '.model.display_name // .model.id // "unknown"')

used_pct=$(echo "$input" | jq -r '.context_window.used_percentage // empty')

# --- Git branch ---
git_branch=""
if [ -n "$cwd" ] && [ -d "$cwd/.git" ] || git -C "$cwd" rev-parse --git-dir > /dev/null 2>&1; then
  git_branch=$(git -C "$cwd" --no-optional-locks symbolic-ref --short HEAD 2>/dev/null || \
               git -C "$cwd" --no-optional-locks rev-parse --short HEAD 2>/dev/null)
fi

# --- Context bar ---
bar_segment=""
if [ -n "$used_pct" ]; then
  pct_int=${used_pct%.*}
  bar_width=20
  filled=$(( pct_int * bar_width / 100 ))
  empty=$(( bar_width - filled ))

  # Color thresholds
  if [ "$pct_int" -lt 50 ]; then
    color="\033[32m"   # green
  elif [ "$pct_int" -lt 75 ]; then
    color="\033[33m"   # yellow
  else
    color="\033[31m"   # red
  fi
  reset="\033[0m"

  bar=""
  for i in $(seq 1 $filled); do bar="${bar}█"; done
  for i in $(seq 1 $empty);  do bar="${bar}░"; done

  bar_segment="${color}[${bar}]${reset} ${pct_int}%"
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
