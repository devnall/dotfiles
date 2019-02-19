# zsh-completions
#fpath=(/Users/dnall/homebrew/share/zsh-completions $fpath)
fpath=(/usr/local/share/zsh-completions $fpath)
zstyle ':completion:*' completer _complete _ignored
zstyle :compinstall filename '/Users/dnall/.dotfiles/zsh/lib/completions.zsh'

autoload -Uz compinit
compinit
autoload -U +X bashcompinit
bashcompinit

# AWS cli completions
if [ -f /usr/local/share/zsh/site-functions/aws_zsh_completer.sh ]; then
  source /usr/local/share/zsh/site-functions/aws_zsh_completer.sh
fi

# kubectl completions
if [ -f /usr/local/bin/kubectl ]; then
  source <(kubectl completion zsh)
fi

# TODO: Re-do this so that it doesn't have to be edited each time tf upgrades
#complete -o nospace -C /usr/local/Cellar/terraform/0.11.11/bin/terraform terraform
# should be able to just run `terraform -install-autocomplete` once and not need this anymore?
