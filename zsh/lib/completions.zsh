if [[ -d "$HOME/.zsh/completion" ]]; then
  FPATH="$HOME/.zsh/completion:$FPATH"
fi

zstyle :compinstall filename '$HOME/.dotfiles/zsh/lib/completions.zsh'

autoload -Uz compinit
compinit

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

# Cache completions for slow sources (e.g. apt, dpkg)
zstyle ':completion:*' use-cache on
zstyle ':completion:*' cache-path ~/.zsh/cache

# Fuzzy matching of completions for when you mistype them
zstyle ':completion:*' completer _complete _match _approximate
zstyle ':completion:*:match:*' original only
zstyle ':completion:*:approximate:*' max-errors 1 numeric

# Ignore completion functions for commands you don't have
zstyle ':completion:*:functions' ignored-patterns '_*'
