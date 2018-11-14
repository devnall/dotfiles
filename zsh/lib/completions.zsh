# zsh-completions
fpath=(/Users/dnall/homebrew/share/zsh-completions $fpath)

# AWS cli completions
if [ -f /Users/dnall/homebrew/bin/aws_zsh_completer.sh ]; then
  source /Users/dnall/homebrew/bin/aws_zsh_completer.sh
fi

# kubectl completions
if [ -f /Users/dnall/homebrew/bin/kubectl ]; then
  source <(kubectl completion zsh)
fi

# TODO: Re-do this so that it doesn't have to be edited each time tf upgrades
complete -o nospace -C /Users/dnall/homebrew/Cellar/terraform/0.11.10/bin/terraform terraform
