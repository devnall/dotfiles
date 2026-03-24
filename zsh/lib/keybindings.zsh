# Up/Down: search history matching what's already typed (built-in, zero overhead)
autoload -Uz up-line-or-beginning-search down-line-or-beginning-search
zle -N up-line-or-beginning-search
zle -N down-line-or-beginning-search
bindkey '^[[A' up-line-or-beginning-search
bindkey '^[[B' down-line-or-beginning-search

# Restore default clear-screen (forgit can override this with git-log)
bindkey '^L' clear-screen
