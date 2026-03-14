# fast-syntax-highlighting — NordicPine palette
typeset -A FAST_HIGHLIGHT_STYLES
FAST_HIGHLIGHT_STYLES[default]='fg=#c6e0df'
FAST_HIGHLIGHT_STYLES[unknown-token]='fg=#e16c58'          # bright red
FAST_HIGHLIGHT_STYLES[reserved-word]='fg=#087fab,bold'     # bright blue
FAST_HIGHLIGHT_STYLES[alias]='fg=#38c9a7,bold'             # bright green
FAST_HIGHLIGHT_STYLES[builtin]='fg=#6ab4c2'                # bright cyan
FAST_HIGHLIGHT_STYLES[function]='fg=#38c9a7'               # bright green
FAST_HIGHLIGHT_STYLES[command]='fg=#38c9a7,bold'           # bright green bold
FAST_HIGHLIGHT_STYLES[precommand]='fg=#26a98b,italic'      # green italic
FAST_HIGHLIGHT_STYLES[commandseparator]='fg=#cca2c0'       # magenta
FAST_HIGHLIGHT_STYLES[path]='fg=#6ab4c2,underline'         # bright cyan underline
FAST_HIGHLIGHT_STYLES[path_prefix]='fg=#33859d,underline'  # cyan underline
FAST_HIGHLIGHT_STYLES[globbing]='fg=#ffd2f8'               # bright magenta
FAST_HIGHLIGHT_STYLES[single-quoted-argument]='fg=#e6cc6f' # bright yellow
FAST_HIGHLIGHT_STYLES[double-quoted-argument]='fg=#e6cc6f' # bright yellow
FAST_HIGHLIGHT_STYLES[dollar-quoted-argument]='fg=#ddbc44' # yellow
FAST_HIGHLIGHT_STYLES[assign]='fg=#c6e0df'
FAST_HIGHLIGHT_STYLES[comment]='fg=#343b51,italic'         # dim

# zsh-autosuggestions — muted fg
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=#343b51'               # bright black (dim)
