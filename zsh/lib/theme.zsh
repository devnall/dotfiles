# Theme — detect appearance and set syntax highlighting + autosuggestion colors
# State file is written by bin/theme-switch (called by dark-notify LaunchAgent)
# precmd hook re-checks the state file so mid-session appearance changes take effect

_appearance_state_file="$HOME/.local/state/appearance"

_detect_appearance() {
  if [[ -f "$_appearance_state_file" ]]; then
    <"$_appearance_state_file"
  elif [[ "$(defaults read -g AppleInterfaceStyle 2>/dev/null)" == "Dark" ]]; then
    echo dark
  else
    echo light
  fi
}

_apply_theme() {
  local mode="$1"
  if [[ "$mode" == "dark" ]]; then
    # ── NordicPine (dark) ────────────────────────────────────────────
    typeset -gA FAST_HIGHLIGHT_STYLES
    FAST_HIGHLIGHT_STYLES[default]='fg=#c6e0df'
    FAST_HIGHLIGHT_STYLES[unknown-token]='fg=#e16c58'
    FAST_HIGHLIGHT_STYLES[reserved-word]='fg=#087fab,bold'
    FAST_HIGHLIGHT_STYLES[alias]='fg=#38c9a7,bold'
    FAST_HIGHLIGHT_STYLES[builtin]='fg=#6ab4c2'
    FAST_HIGHLIGHT_STYLES[function]='fg=#38c9a7'
    FAST_HIGHLIGHT_STYLES[command]='fg=#38c9a7,bold'
    FAST_HIGHLIGHT_STYLES[precommand]='fg=#26a98b,italic'
    FAST_HIGHLIGHT_STYLES[commandseparator]='fg=#cca2c0'
    FAST_HIGHLIGHT_STYLES[path]='fg=#6ab4c2,underline'
    FAST_HIGHLIGHT_STYLES[path_prefix]='fg=#4ea6b8,underline'
    FAST_HIGHLIGHT_STYLES[globbing]='fg=#ffd2f8'
    FAST_HIGHLIGHT_STYLES[single-quoted-argument]='fg=#e6cc6f'
    FAST_HIGHLIGHT_STYLES[double-quoted-argument]='fg=#e6cc6f'
    FAST_HIGHLIGHT_STYLES[dollar-quoted-argument]='fg=#ddbc44'
    FAST_HIGHLIGHT_STYLES[assign]='fg=#c6e0df'
    FAST_HIGHLIGHT_STYLES[comment]='fg=#343b51,italic'
    ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=#555e7a'
  else
    # ── AlpineDawn (light) ───────────────────────────────────────────
    typeset -gA FAST_HIGHLIGHT_STYLES
    FAST_HIGHLIGHT_STYLES[default]='fg=#575279'
    FAST_HIGHLIGHT_STYLES[unknown-token]='fg=#b4637a'
    FAST_HIGHLIGHT_STYLES[reserved-word]='fg=#286983,bold'
    FAST_HIGHLIGHT_STYLES[alias]='fg=#286983,bold'
    FAST_HIGHLIGHT_STYLES[builtin]='fg=#56949f'
    FAST_HIGHLIGHT_STYLES[function]='fg=#286983'
    FAST_HIGHLIGHT_STYLES[command]='fg=#286983,bold'
    FAST_HIGHLIGHT_STYLES[precommand]='fg=#286983,italic'
    FAST_HIGHLIGHT_STYLES[commandseparator]='fg=#907aa9'
    FAST_HIGHLIGHT_STYLES[path]='fg=#56949f,underline'
    FAST_HIGHLIGHT_STYLES[path_prefix]='fg=#286983,underline'
    FAST_HIGHLIGHT_STYLES[globbing]='fg=#d7827e'
    FAST_HIGHLIGHT_STYLES[single-quoted-argument]='fg=#ea9d34'
    FAST_HIGHLIGHT_STYLES[double-quoted-argument]='fg=#ea9d34'
    FAST_HIGHLIGHT_STYLES[dollar-quoted-argument]='fg=#ea9d34'
    FAST_HIGHLIGHT_STYLES[assign]='fg=#575279'
    FAST_HIGHLIGHT_STYLES[comment]='fg=#9893a5,italic'
    ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=#9893a5'
  fi
}

# Initial application at shell startup
_current_appearance="$(_detect_appearance)"
_apply_theme "$_current_appearance"

# precmd hook — re-check state file and re-apply if appearance changed
_theme_precmd_hook() {
  local new_appearance
  if [[ -f "$_appearance_state_file" ]]; then
    new_appearance="$(<"$_appearance_state_file")"
  else
    return
  fi
  if [[ "$new_appearance" != "$_current_appearance" ]]; then
    _current_appearance="$new_appearance"
    _apply_theme "$_current_appearance"
  fi
}

[[ $- == *i* ]] && autoload -Uz add-zsh-hook && add-zsh-hook precmd _theme_precmd_hook
