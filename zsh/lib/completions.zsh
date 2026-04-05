if [[ -d "$HOME/.zsh/completion" ]]; then
  FPATH="$HOME/.zsh/completion:$FPATH"
fi

zstyle :compinstall filename '$HOME/.dotfiles/zsh/lib/completions.zsh'

autoload -Uz compinit
if [[ -n ~/.zcompdump(#qN.mh+24) ]]; then
  compinit
else
  compinit -C
fi

# AWS cli completions
if [ -f $HOMEBREW_PREFIX/share/zsh/site-functions/aws_zsh_completer.sh ]; then
  source $HOMEBREW_PREFIX/share/zsh/site-functions/aws_zsh_completer.sh
fi

# kubectl completions
if command -v kubectl &> /dev/null; then
  source <(kubectl completion zsh)
fi

# Docker completions
if command -v docker &> /dev/null; then
  source <(docker completion zsh)
fi

# 1Password CLI completions — cached to avoid triggering macOS TCC prompts on
# every shell launch. Run `op-refresh-completions` to regenerate after upgrades.
if command -v op > /dev/null; then
  _op_comp_cache="${XDG_CACHE_HOME:-$HOME/.cache}/op/completion.zsh"
  if [[ -f "$_op_comp_cache" ]]; then
    source "$_op_comp_cache"
    compdef _op op
  fi
  function op-refresh-completions() {
    local cache="${XDG_CACHE_HOME:-$HOME/.cache}/op/completion.zsh"
    mkdir -p "${cache:h}"
    op completion zsh > "$cache"
    source "$cache"
    compdef _op op
    echo "1Password completions refreshed."
  }
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
