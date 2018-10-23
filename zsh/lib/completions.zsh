# AWS cli completions
if [ -f /Users/dnall/homebrew/bin/aws_zsh_completer.sh ]
then
  source /Users/dnall/homebrew/bin/aws_zsh_completer.sh
fi

# kubectl completions
if [ -f /Users/dnall/homebrew/bin/kubectl ]
then
  source <(kubectl completion zsh)
fi

# zsh-completions
fpath=(${brew_path}/share/zsh-completions $fpath)

# TODO: some terraform stuff I'm not sure about; still need?
complete -o nospace -C /Users/dnall/homebrew/Cellar/terraform/0.11.8/bin/terraform terraform
