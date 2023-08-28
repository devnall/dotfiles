# zsh-completions
#$fpath=(/usr/local/share/zsh-completions $fpath)
#if type brew &>/dev/null; then
#  FPATH="$(brew --prefix)/share/zsh/site-functions:${FPATH}"
#
#  autoload -Uz compinit
#  compinit
#fi

#if type brew &>/dev/null; then
#  FPATH=$(brew --prefix)/share/zsh-completions:$FPATH
#
#  autoload -Uz compinit
#  compinit
#fi

zstyle ':completion:*' completer _complete _ignored
zstyle :compinstall filename '$HOME/.dotfiles/zsh/lib/completions.zsh'

autoload -Uz compinit
compinit
#autoload -U +X bashcompinit
#bashcompinit

# Change text color for zsh-autosuggestions
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=242"

# AWS cli completions
if [ -f /usr/local/share/zsh/site-functions/aws_zsh_completer.sh ]; then
  source /usr/local/share/zsh/site-functions/aws_zsh_completer.sh
fi

# kubectl completions
if [ -f /usr/local/bin/kubectl ]; then
  source <(kubectl completion zsh)
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
