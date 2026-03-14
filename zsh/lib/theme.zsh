if [[ "$(defaults read -g AppleInterfaceStyle 2>/dev/null)" == "Dark" ]]; then
  # ── NordicPine (dark) ────────────────────────────────────────────
  typeset -A FAST_HIGHLIGHT_STYLES
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
  FAST_HIGHLIGHT_STYLES[path_prefix]='fg=#4ea6b8,underline'    # brightened from #33859d
  FAST_HIGHLIGHT_STYLES[globbing]='fg=#ffd2f8'
  FAST_HIGHLIGHT_STYLES[single-quoted-argument]='fg=#e6cc6f'
  FAST_HIGHLIGHT_STYLES[double-quoted-argument]='fg=#e6cc6f'
  FAST_HIGHLIGHT_STYLES[dollar-quoted-argument]='fg=#ddbc44'
  FAST_HIGHLIGHT_STYLES[assign]='fg=#c6e0df'
  FAST_HIGHLIGHT_STYLES[comment]='fg=#343b51,italic'
  ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=#555e7a'
  sed -i '' "s|^color_theme = .*|color_theme = \"${HOME}/.config/btop/themes/rose-pine-moon.theme\"|" "${HOME}/.config/btop/btop.conf" 2>/dev/null
  export STARSHIP_CONFIG="${HOME}/.config/starship.toml"
else
  # ── AlpineDawn (light) ───────────────────────────────────────────
  typeset -A FAST_HIGHLIGHT_STYLES
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
  FAST_HIGHLIGHT_STYLES[path_prefix]='fg=#286983,underline'    # darker than path for distinction
  FAST_HIGHLIGHT_STYLES[globbing]='fg=#d7827e'
  FAST_HIGHLIGHT_STYLES[single-quoted-argument]='fg=#ea9d34'
  FAST_HIGHLIGHT_STYLES[double-quoted-argument]='fg=#ea9d34'
  FAST_HIGHLIGHT_STYLES[dollar-quoted-argument]='fg=#ea9d34'
  FAST_HIGHLIGHT_STYLES[assign]='fg=#575279'
  FAST_HIGHLIGHT_STYLES[comment]='fg=#9893a5,italic'
  ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=#9893a5'
  sed -i '' "s|^color_theme = .*|color_theme = \"${HOME}/.config/btop/themes/rose-pine-dawn.theme\"|" "${HOME}/.config/btop/btop.conf" 2>/dev/null
  export STARSHIP_CONFIG="${HOME}/.config/starship-light.toml"
fi
