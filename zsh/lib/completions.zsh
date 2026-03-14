# zsh-completions
#$fpath=(/usr/local/share/zsh-completions $fpath)
#if type brew &>/dev/null; then
#  FPATH="$(brew --prefix)/share/zsh/site-functions:${FPATH}"
#
#  autoload -Uz compinit
#  compinit
#fi

#if type brew &>/dev/null; then
#  FPATH="$(brew --prefix)/share/zsh-completions:$FPATH"
#fi

FPATH="$HOME/.zsh/completion:$FPATH"

zstyle ':completion:*' completer _complete _ignored
zstyle :compinstall filename '$HOME/.dotfiles/zsh/lib/completions.zsh'

autoload -Uz compinit
compinit
#autoload -U +X bashcompinit
#bashcompinit

# Change text color for zsh-autosuggestions
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=242"

# AWS cli completions
if [ -f $HOMEBREW_PREFIX/share/zsh/site-functions/aws_zsh_completer.sh ]; then
  source $HOMEBREW_PREFIX/share/zsh/site-functions/aws_zsh_completer.sh
fi

# kubectl completions
if command -v kubectl &> /dev/null; then
  source <(kubectl completion zsh)
fi

# 1Password CLI completions
if [ -f $HOMEBREW_PREFIX/bin/op ]; then
  eval "$(op completion zsh)"; compdef _op op
fi

# Some functions, like _apt and _dpkg, are very slow. 
# You can use a cache in order to proxy the list of results (like the list of available debian packages) 
# Use a cache:
zstyle ':completion:*' use-cache on
zstyle ':completion:*' cache-path ~/.zsh/cache

# Fuzzy matching of completions for when you mistype them:
zstyle ':completion:*' completer _complete _match _approximate
zstyle ':completion:*:match:*' original only
zstyle ':completion:*:approximate:*' max-errors 1 numeric

# Ignore completion functions for commands you don’t have:
zstyle ':completion:*:functions' ignored-patterns '_*'
